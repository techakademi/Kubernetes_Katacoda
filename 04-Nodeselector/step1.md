
**Bu bölümde, Nodeselector konusunu işliyoruz.**

Nodeselector en az üç node olursa çok daha iyi anlaşılır.

___
***Dikkat, bu platform şu an en fazla biri Master olmak üzere iki node ile çalışmakta. Bu cluster'da tüm pod'lar node01'de doğal olarak çalışacaktır. Yine de deneyimlemek isterseniz diye hazırlamış oldum bu bölümü.***
___
Kubernetes'de Nodeselector herhangi bir uygulamanın, seçilen ve de istenen node üzerinde çalışmasını belirtmek için kullanılmaktadır.

Bir uygulamanın belirli bir node üzerinde çalışmasının bir kaç nedeni olabilir. Uygulamanın işlevine göre belirlenmesi gereken bir karardır, diyelim ki çalıştırılacak pod bir Machine Learning uygulaması olsun.

Neyi, nasıl öğreniyor ? hangi kaynaklara ihtiyacı olduğunu tespit etmemiz gerekiyor, diyelim ki coğrafik haritalama üzerine çalışan bir uygulama olsun. Online haritaları okuyup, kendi haritasını oluşturuyor olsun, kendi haritası üzerinede web sitelerinden online haberleri tarayıp, haberin oluştuğu coğrafik konumun harita üzerindeki yerini işaretliyor olsun. Bununla birlikte, harita üzerindeki binalarla birlikte coğrafik konumunda üç boyutlu modeli ile birlikte modellerin renderlerini'de ayrıca oluşturuyor olsun. 

Bu uygulamanın ilk ihtiyacı GPU (Grapphics Processing Unit)yüksek grafik işlemcisi olacaktır. İkinci sırada harita taramasının kayıtlarını resim olarak kaydettiğini varsayacak olursak, ssd veri deploama alanına ihtiyacı olacaktır.

___
![Datacenter Örneği](./assets/img/datacenter.jpg)

Cluster'da diyelim ki sunuculardan birisinde GPU özelliği var olsun. Bu durumda, bu uygulamayı GPU işlemcisi olan sunucuda çalıştırmak isteyeceğiz, bu isteğimizi Kubernetes'e deklare etmediğimiz sürece Kubernetes kendi kararı ile cluster'da bulunan her hangi bir node üzerinde çalıştıracaktır. Bu karar uygulama performansına yansıyacağından, istenilen sonuç elde edileemiyebilir.
Bu ve bu türev ihtiyaçlar doğrultusunda, Kubernetes cluster'ında node seçimi gerçekleştirilmektedir.

Bu bölümde, merhaba-dunya uygulamamızı node selector ile kullanarak istediğimiz node üzerinde çalışmasını sağlayacağız.

Nodeselector kullanımına başlamak için öncelikle cluster'daki nodeları belirlememiz gerekir.

___
**Node'ların çalışması biraz zaman alabilmekte, iki dk. kadar beklemeniz gerekebilir.**

`kubectl get nodes`{{execute}}

Node'larımızdan birini, örneğin kubeworker1'i GPU sunucusu olarak seçelim.
Herhangi bir Node'u nodeselector olarak kullanabilmek için öncelikle o node'u taşıdığı özellikle işkili etiketlememiz gerekir.


Node01'i **"GPU"** özelliği ile etiketlemek için ***kubectl label node*** komutu kullanarak etiketliyoruz.

`kubectl label node node01 gpu=true`{{execute}}

```
node/node01 labeled
```
Kubernetes'de herhangi bir done'un taşıdığı etiketleri görüntülemek için ***kubectl get node <node-adı> --show-labels*** komutu kullanırız.

`kubectl get node node01 --show-labels`{{execute}}

Node üzerinde ***"gpu=true"*** etiketinin eklenmiş olduğundan emin olunuz.

Node'umuz üzerinde GPU etiketi ile  etiketlernmiş olan podları artık çalıştırabilir durumda hazır haldedir.

Merhaba dünya uygulası için hazılramış olduğum deployment belgesini birlikte inceleyelim.

`cat 05-Merhaba-dunya-Nodeselector.yml`{{execute}}

```
spec:
  containers:
  - image: techakademi/merhabadunya:1
    name: merhaba-dunya
  nodeSelector:
    gpu: "true"
```

Konteyner spesifikasyonu bölümünde, **"nodeSelector"** adında bir alan ekledim, bu alanın anahtar değerinide  gpu:"ture" olarak ekledim, node'umuza vermiş olduğumuz etiketi bu anahtar ile belirterek, kubernetes api'ya gelen bu bilgiyi etcd'ye kaydettiğinde, scheduler bu anahtar değeri okuduğunda pod'u doğrudan etiket atanmış olan node'da çalıştıracaktır.

Deployment'imizi çalıştırıp sonucunu gözlemleyelim.

`kubectl create -f 05-Merhaba-dunya-Nodeselector.yml`{{execute}}

```
deployment.apps/merhaba-dunya-deploy created
```

Kısaca pod'umuzun describe opsiyonu ile içeriğine bakarak hangi değerleri almış olduğunu görelim.

`kubectl describe pod merhaba-dunya-deploy`{{execute}}

```
Node-Selectors:  gpu=true
```

Yeni bir terminal açıp podların hangi node üzerinde çalıştığını gözlemlemek için kullanabiliriz.

`Terminal aç`{{execute T2}}

`watch kubectl get pods  -o wide`{{execute T2}}


Daha önceki  Merhaba dünya deploymentin replicaset değer üç idi, şu an kullandığımız deployment'i bir adet olarak belirlemiştim, uyguladığımız senaryoda bu deploymentin sadece ilgili etiketi taşıyan node üzerinde çalışmasını hedeflediğimizden, replicaset'ini artırdığımız zaman nasıl bir sonuç elde edeceğimiz deneyimlemek için şimdi elle scale edelim.

---

***Bu komutun sonucunu Terminal 2'den gözlemleyebilirisin.***
`kubectl scale deploy merhaba-dunya-deploy --replicas=3`{{execute T1}}

---

Gördüğünüz üzere tüm pod'lar otomatik bir şekilde, node01 isimli node'umuzda çalışmaya başladılar.Eğer node selector olmasa idi, Kubernetes scheduler en uygun node'u seçerek burada pod'u o node üzerinde çalıştıracaktı.

Merhaba dünya deploymentimiz, haricinde yeni bir deploymetn daha çalıştırallım, bu deployment'de herhangi bir "nodeSelector" belirtilmiş olmadığından, doğrudan cluster'da bulunan herhangi bir node üzerinde çalışacaktır.

---

***Bu komutun sonucunu Terminal 2'den gözlemleyebilirisin.***
`kubectl create -f 06-Merhaba-dunya-deploy.yml`{{execute T1}}

---


**"nodeSelector"** en basit anlamıyla bu şekilde kullanılmaktadır, bunun haricinde daha başka gelişmiş kullanım şekilleri vardır, örneğin, herhangi bir bulut sağlayıcısının almanya frankfurt bölgesinde bulunan cluster'da çalıştırmak istediğimizde, label ötesinde başka operatörler de dahil olmaktadır.

---

### __*Bölümü burada tamamlıyoruz, çıkmadan önce son bir iki işlem daha yapalım.*__

*  Oluşturduğumuz Deployment'leri kaldıralım
*  Node'umuza eklediğimiz label'i de kaldıralım

_Deployment'leri kaldıralım:_

`kubectl delete deploy merhaba-dunya-deploy`{{execute T1}}

`kubectl delete deploy merhaba-dunya-deploy-nodsuz`{{execute T1}}

_Node etiketini kaldıralım:_

Node'umuzdan etiketimizi kaldırmak için "<etiket>-" opsiyonunu kullanmaktayız.

`kubectl label node node01 gpu-`{{execute T1}}

```
node/node01 unlabeled
```

Node'un etiketlerini kontrol edelim:

`kubectl get node node01  --show-labels`{{execute T1}}

___
NoedeSelector bölümünüde burada tamamlamış olduk arkadaşlar.

## Ana Bölüm [Kubernetes Derlser'e geri dön ](https://www.katacoda.com/techakademi)

