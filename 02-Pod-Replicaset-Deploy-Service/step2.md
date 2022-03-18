## Bu bölümde, Merhaba Dünya uygulamasının Replicaset'ini oluşturacağız.

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

Pod'larımızı, **"02-Merhaba-dunya-Replicaset.yml"** adında ki belgemizi kullanarak kuberenetes'de çalıştıralım.

`kubectl apply -f 02-Merhaba-dunya-replicaset.yml`{{execute T1}}

Replicaset oluşturma komutu sonucunda replicaset'in oluşturulduğunu teyit eden komut çıktısı görünecektir.

```
replicaset.apps/merhaba-dunya-replicaset created
```

Oluşan replicaset'i kontrol için ***kubectl get replicaset*** komutunu kullanarak görüntüleyebiliriz.

`kubectl get replicaset merhaba-dunya-replicaset`{{execute T1}}

```
NAME                       DESIRED   CURRENT   READY   AGE
merhaba-dunya-replicaset   3         3         3       29s
```

Replicaset'imiz çalışıyor, bu replicaset'inde çalışan podların hangi node'larda çalıştıkları ve hangi IP adreslerine sahip oldukları bilgisine erişmek istediğimizde ***kubectl get pods -o wide*** komutunu kullanarak görüntüleyebiliriz.

`kubectl get pods -o wide`{{execute T1}}

Replicaset'in detayını görüntülemek için ***kubectl get replicaset -o wide*** komutunu kullanrak görüntüleyebiliriz.

`kubectl get replicaset -o wide`{{execute T1}}

```
NAME                     DESIRED CURRENT READY AGE  CONTAINERS    IMAGES                     SELECTOR
merhaba-dunya-replicaset 3       3       3     3m3s merhaba-dunya techakademi/merhab
```

Oluşturduğumuz replicaset'inin işlevini kontrol etmek için, çalışan pod'larımızdan herhangi birini silerek kontrol edebiliriz.Kubernetes'de pod silme işlemi ***kubectl delete pod*** **"pod-adı"** komutu kullanılarak gerçekleştirilir.

**Bu örnek bir komuttur, pod adında bulunan ID sizin sisteminizde farklı olacaktır, lütfen kendi pod adını kullanarak bu komutu çalıştırınız**

Replicaset'e dahil olan herhangi bir pod'u silmek için öncelikle mevcut pod'ları listeleyelim.

`kubectl get pods`{{execute T1}}

```
NAME                             READY   STATUS    RESTARTS   AGE
merhaba-dunya-replicaset-9974k   1/1     Running   0          30m
merhaba-dunya-replicaset-99v2s   1/1     Running   0          30m
merhaba-dunya-replicaset-ltb4d   1/1     Running   0          30m
```
Listeden herhangi bir pod'u belirleyerek silme işlemini aşağıda ki komut örneğinde ki gibi gerçekleştirelim.
***Terminal2***'de anlık gözlem yaparak, replicaset'e dahil olan pod'ları takip edelim.


```sh
kubectl delete pod merhaba-dunya-replicaset-98x6z
```

Replicaset'e dahil olan herhangi bir pod'un imha edilmesi ile birlikte, neredeyse aynı anda kubernetes hemen yeni bir pod oluşturarak hizmet etmesini sağladı.

```
NAME                               READY STATUS  RESTARTS  AGE   IP                NODE          NOMINATED NODE   READINESS GATES
pod/merhaba-dunya-replicaset-x48pc 0/1   ContainerCreating 0     8s  <none>        kubeworker1   <none>           <none>
pod/merhaba-dunya-replicaset-98x6z 1/1   Terminating       0     52s 172.16.225.25 kubeworker2   <none>           <none>
```
Replicaset'in tamamını silmek istediğimizde, ***kubectl delete replicaset*** **"replicaset-adı"** şeklinde kullanarak silme işlemini gerçekleştirebiliriz.

Oluşturduğumuz **merhaba-dunya** replicaset'ini silelim:

`kubectl delete replicaset merhaba-dunya-replicaset`{{execute T1}}

İşlemin başarılı bir şekilde gerçekleştiğini teyit eden komut çıktısı aşağıda ki gibi olacaktır.

```
replicaset.apps "merhaba-dunya-replicaset" deleted
```
Cluster'in son durumunu kontrol etmek için, ***kubectl get all*** komutunu kullanabiliriz.

`kubectl get all`{{execute T1}}

Tebrikler, Replicaset bölümünü burada tamamlamış olduk arkadaşlar.