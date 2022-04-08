
**Bu bölümde, Persistent Volume oluşturmayı işliyoruz.**

Senaryolarımızı uygulamaya başlamadan önce, çalışma ortamızı hazırlayalım. Mümkünse kullandığınız terminali yatay veya dikey yada ikinci ekran şeklinde ayrıştırıp aşağıdaki watch komutunu çalıştırınız.

***Bu komut ile ikinci bir terminal açabilirsin.***

`Terminal2 Penceresi Aç`{{execute interrupt T2}}

***Terminal'de çalışması için aşağıdaki komutu kullanalım.***

`watch kubectl get pv,pvc,pod -o wide`{{execute T2}}

***kubectl get pv,pvc,pod -o wide*** tüm cluster'da oluşan pv, pvc ve pod nesnelerini getir anlamında dır.

## 1.Senaryo:

1.Adım Hostpath Persistent Volume Oluşturmak.

Persistent Volume [11-Hostpath-pv.yml](./assets/11-Hostpath-pv.yml) belgesinde Persisten Volume oluşturacak şekilde yapılandırılımş haldedir.

***Bu komutun sonucunu Terminal 2'den gözlemleyebilirisin.***

`kubectl apply -f 11-Hostpath-pv.yml`{{execute T1}}

```
persistentvolume/pv-hostpath-yerel created
```

```
NAME                CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS      CLAIM   STORAGECLASS   REASON   AGE   VOLUMEMODE
pv-hostpath-yerel   1Gi        RWO            Retain           Available           manual                  31s   Filesystem
```

2.Adım Oluşturduğumuz Pv'den alan talebinde bulunmak.

Persistent Volume Clime [12-Hostpath-pvc.yml](./assets/12-Hostpath-pvc.yml) belgesinde Persistent Volume Clime talebi oluşturacak şekilde yapılandırılımş haldedir.

`kubectl apply -f 12-Hostpath-pvc.yml`{{execute T1}}

```
persistentvolumeclaim/local-pv-claim created
```

```
NAME                CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS   CLAIM                    STORAGECLASS   REASON   AGE     VOLUMEMODE
pv-hostpath-yerel   1Gi        RWO            Retain           Bound    default/local-pv-claim   manual                  5m45s   Filesystem
```

3.Adım Oluşturduğumuz Pvc'yi kullanacak pod oluşturmak.

Persistent Volume Clime [13-Hostpath-Containeri.yml](./assets/13-Hostpath-Containeri.yml) belgesinde Persisten Volume Clime kullanacak pod oluşturacak şekilde yapılandırılımş haldedir.

`kubectl apply -f 13-Hostpath-Containeri.yml`{{execute T1}}

```
NAME                     READY   STATUS    RESTARTS   AGE   IP             NODE          NOMINATED NODE   READINESS GATES
pod/veri-olusturan-pod   1/1     Running   0          57s   172.16.90.55   kubeworker1   <none>           <none>
```

Çalışan pod'un arayüzüne erişip, oluşturduğumuz veribiriminde veri oluşturalım.

***Pod'un arayüzüne erişebilmek için Pod'un çalışıyor olması gerekir.
Terminal 2'den gözlemleyebilirisin.***
`kubectl exec -it veri-pod -- bash`{{execute T1}}

Container içinde, Merhaba.txt belgesi oluşturalım, içine de Merhaba Dünya yazalım.

`echo "Merhaba Dunya" > /veridosyam/merhaba.txt`{{execute T1}}

Merhaba.txt'in içeriğini kontrol edelim.

`cat /veridosyam/merhaba.txt`{{execute T1}}

Podun çalıştığı noda'a login olup veri dosyasını inceleyelim.

`Yeni Terminal Ekranı aç`{{execute T3}}

`ssh node01`{{execute T3}}

`ls /opt/veridosyasi/`{{execute T3}}

Container'den çıkış yapalım.

`exit`{{execute T1}}

Bu senaryonun bu aşamasına kadar olan bölümü ile işlemlerimiz tamamlandı, pod'u silerek verilerin kalıcılığını kontrol edelim.

Pod'u silerek devam edelim.

`kubectl delete -f 13-Hostpath-Containeri.yml`{{execute T1}}

Tekrar podun çalıştığı node üzerinde veribirimini kontrol edelim.

`ls /opt/veridosyasi/`{{execute T3}}

merhaba.txt belgemiz, oluşturduğumuz dosya altında varlığını korumaktadır.

---

Veri biz silmediğimiz sürece burada sürekli kalacaktır, veya aynı volume'u kullanan başka bir pod oluşturduğumuzda doğrudan bu volume içindeki veriye erişebilir olacaktır.
Fakat, diyelim ki aynı pod'u tekrar çalıştırdık. Biz "***_nodeseLector_***"  ile hangi node'a çalışacağını belirtmediğimiz sürece, Kubernetes yeni çalışan pod'u node'lardan herhangi birinde çalıştıracaktır, aynı node üzerinde çalıştırmaz ise, oluşturduğumuz volume o node'da olmayacağından pod veriye erişemeyecektir.

Bunun önüne geçmenin bir kaç yöntemi var, ya o pod spec'ine sürekli o node üzerinde çalışması için ***_nodeseLector_*** kullanacağız veya nfs ile external bir volume oluşturacağız, bunun haricinde statefulset kullanabiliriz. Her iki konuya da ayrıca değineceğiz.
___
Persistent Volume, Persistent Clime Oluşturma bölümümüzü burada tamamlamış olduk, İkinci Senaryoya geçebiliriz.
