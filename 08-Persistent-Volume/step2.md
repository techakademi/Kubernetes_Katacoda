
**Bu bölümde, Persistent Volume Clime tekrar kullanmayı işliyoruz.**

Hatırlarsanız demiştim ki, persistent volume'da reclaim ile tutulan bir volume başka bir persistent volume clime'ın hizmetine verilmez diye. Şimdi onun bir uygulamasını yaparak neler olduğuna bakalım.

## 2.Senaryo:

1.Adım, önce, pvc'yi silelim, Bu komutun sonuçlarını gözlem ekranından takip edelim.

***Bu komutun sonucunu Terminal 2'den gözlemleyebilirisin.***
`kubectl delete -f 12-Hostpath-pvc.yml`{{execute T1}}

Gözlem ekranından dikkat ederseniz pvc imha edilmiş durumda. Pv ise halen varlığını korumaktadır, pv nin "status" kolonuna bakarsanız, daha önce "bound" olan durumu şimdi "released" durumunda. Pvc kullanımdayken ***"bound"*** ile bağlanmış haldeydi, şimdi ise bırakılmış durumda.

Reclaim policy ***"retain"*** olarak belirttiğimiz için, kendisini silmedi, eğer reclaim policy'i "delete" olarak belirtseydik, kendisini de silerek yok edecekti.

2.Adım, 12-Hostpath-pvc.yml manifestosunu çalıştırıp talepde bulunanlım.

`kubectl apply -f 12-Hostpath-pvc.yml`{{execute T1}}

Gözlem ekranından Pvc'oluşumunu gözlemleyelim.

```
NAME                STATUS    VOLUME   CAPACITY   ACCESS MODES   STORAGECLASS   AGE
pv-hostpath-yerel   Pending                                      manual         55s
```
Durumu ***"pending"*** olarak görünüyor, detayını inceleyip neden beklemede olduğunu öğrenmeye çalışalım.

`kubectl describe pvc pv-hostpath-yerel`{{execute T1}}

```
Events:
  Type     Reason              Age               From                         Message
  ----     ------              ----              ----                         -------
  Warning  ProvisioningFailed  1s (x8 over 97s)  persistentvolume-controller  storageclass.storage.k8s.io "manual" not found
```

Events, kısmında hata mesajında diyor ki,  Kubernetes volume controller, storage sınıflandırmasında "manual" i bulamadığını söylüyor. Bu generik bir hata mesajıdır, detay bulunmuyor, ancak biraz daha incelersek, Finalizers: [kubernetes.io/pvc-protection] Bu pv'nin pvc koruması olduğunu görebiliriz.

Bu alanı tekrar kullanmanın yolu, Pvc'yi ve Pv'yi silip yeni bir pv oluşturarak işlemlerimizi gerçekleştirebiliriz.

Diğer senaryoya geçmeden önce, mevcut pv'yi ve pvc'yi silelim.

1.Adım
`kubectl delete -f 12-Hostpath-pvc.yml`{{execute T1}}

2.Adım
`kubectl delete -f 11-Hostpath-pv.yml`{{execute T1}}

Persisitent Volume ve Persisitent Volume Clime silmiş olmamız node'a oluşan veriyi silmişmidir ?, gidip kontrol edelim.

***Bu komutun sonucunu Terminal 3'den gözlemleyebilirisin.***

`ls /opt/veridosyasi/`{{execute T3}}

Merhaba.txt belgemiz yerinde duruyor olması gerekir, eğer öyleyse buraya kadar işler yolunda gitmektedir.
___
Persistent Volume Clime tekrar kullanma bölümümüzü burada tamamlamış olduk, İkinci Senaryoya geçebiliriz.
