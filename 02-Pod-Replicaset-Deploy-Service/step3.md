## Bu bölümde, Merhaba Dünya uygulamasının Deployment'ini oluşturacağız.

Çalışma ortamına yeni bir terminal ekleyip, **watch** komutunu kullanarak uyguladğımız adımların sonuçlarını gözlemleyebiliriz.

**1. Adım**
Yeni bir etrminal oluşturmak için aşağıda ki komutu kullanabilirsiniz:

`"Yeni terminal aç"`{{execute T2}} 

**2. Adım**
Terminal2'de aşağıda ki komutu uygulayarak Cluster komutlarının anlık sonuçlarını izleyebiliriz. 

`watch kubectl get all -o wide`{{execute T2}}

---

**Bundan Sonraki tüm komutlarımız Terminal1'de çalışacaktır, Terminal2 sadece gözlem için kullanılacaktır.**

---

Pod'larımızı, **"03-Merhaba-dunya-deployment.yml"** adında ki belgemizi kullanarak kuberenetes'de çalıştıralım.

`kubectl apply -f 03-Merhaba-dunya-deployment.yml`{{execute T1}}

Deployment oluşturma komutu sonucunda deployment'in oluşturulduğunu teyit eden komut çıktısı görünecektir.

```
deployment.apps/merhaba-dunya-deploy created
```

Oluşan deployment'i kontrol için ***kubectl get deployment*** komutunu kullanarak görüntüleyebiliriz.

`kubectl get deployment merhaba-dunya-deploy`{{execute T1}}

```
NAME                   READY   UP-TO-DATE   AVAILABLE   AGE
merhaba-dunya-deploy   3/3     3            3           105s
```

Deployment'imiz çalışıyor, bu deployment'da çalışan podların hangi node'larda çalıştıkları ve hangi IP adreslerine sahip oldukları bilgisine erişmek istediğimizde ***kubectl get pods -o wide*** komutunu kullanarak görüntüleyebiliriz.

`kubectl get pods -o wide`{{execute T1}}

Deployment'in detayını görüntülemek için ***kubectl get deployment -o wide*** komutunu kullanrak görüntüleyebiliriz.

`kubectl get deployment -o wide`{{execute T1}}

```
NAME                   READY   UP-TO-DATE   AVAILABLE   AGE     CONTAINERS      IMAGES                       SELECTOR
merhaba-dunya-deploy   3/3     3            3           5m55s   merhaba-dunya   techakademi/merhabadunya:1   name=Merhaba-dunya
```

Oluşturduğumuz deployment'in işlevini kontrol etmek için, çalışan pod'larımızdan herhangi birini silerek kontrol edebiliriz.Kubernetes'de pod silme işlemi ***kubectl delete pod*** **"pod-adı"** komutu kullanılarak gerçekleştirilir.

**Bu örnek bir komuttur, pod adında bulunan ID sizin sisteminizde farklı olacaktır, lütfen kendi pod adını kullanarak bu komutu çalıştırınız**

Deployment'e dahil olan herhangi bir pod'u silmek için öncelikle mevcut pod'ları listeleyelim.

`kubectl get pods`{{execute T1}}

```
NAME                                    READY   STATUS    RESTARTS   AGE
merhaba-dunya-deploy-75bfcfc8b9-82nbf   1/1     Running   0          30m
merhaba-dunya-deploy-75bfcfc8b9-82nbf   1/1     Running   0          30m
merhaba-dunya-deploy-75bfcfc8b9-82nbf   1/1     Running   0          30m
```
Listeden herhangi bir pod'u belirleyerek silme işlemini aşağıda ki komut örneğinde ki gibi gerçekleştirelim.
***Terminal2***'de anlık gözlem yaparak, deployment'e dahil olan pod'ları takip edelim.


```sh
kubectl delete pod merhaba-dunya-deploy-5b69f56cc6-8qlvz
```

Deployment'e dahil olan herhangi bir pod'un imha edilmesi ile birlikte, neredeyse aynı anda kubernetes hemen yeni bir pod oluşturarak hizmet etmesini sağladı.

```
NAME                                      READY STATUS  RESTARTS  AGE   IP                NODE          NOMINATED NODE   READINESS GATES
pod/merhaba-dunya-deploy-75bfcfc8b9-82nbf 0/1   ContainerCreating 0     8s  <none>        kubeworker1   <none>           <none>
pod/merhaba-dunya-deploy-75bfcfc8b9-dn77f 1/1   Terminating       0     52s 172.16.225.29 kubeworker2   <none>           <none>
```
Deployment'in tamamını silmek istediğimizde, ***kubectl delete deployment*** **"deployment-adı"** şeklinde kullanarak silme işlemini gerçekleştirebiliriz.

Oluşturduğumuz **merhaba-dunya** deployment'ini silelim:

`kubectl delete deployment merhaba-dunya-deploy`{{execute T1}}

İşlemin başarılı bir şekilde gerçekleştiğini teyit eden komut çıktısı aşağıda ki gibi olacaktır.

```
deployment.apps "merhaba-dunya-deploy" deleted
```
Cluster'in son durumunu kontrol etmek için, ***kubectl get all*** komutunu kullanabiliriz.

`kubectl get all`{{execute T1}}

Tebrikler, Deployment bölümünü burada tamamlamış olduk arkadaşlar.