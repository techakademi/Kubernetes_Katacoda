
**Bu bölümde, ReclaimPolicy delete konusunu işliyoruz.**

Yeni bir pv talep manifestosu oluşturup, "persistentVolumeReclaimPolicy: Delete" anahtarı ekleyerek, pv'nin silinebileceğini belirttim. Sırasıyla önce bu yeni pv'yi sonra da ondan daha önceki kullandığımız pvc manifestosu ile talepde bulunacağız. Her ikisi soluştuktan sonra, pvc'yi silip sonucunu gözlemleyeceğiz.

## 3.Senaryo:

**1. Adım, Reclaim Policy, "Delete" belirttiğimiz manifestoyu çalıştıralım.**

Reclaim Policy [14-PV-Reclaim-Delete.yml](./assets/14-PV-Reclaim-Delete.yml) belgesinde Persistent Volume Reclaim Policy türü Delete şekilde yapılandırılımş haldedir.

`kubectl apply -f 14-PV-Reclaim-Delete.yml`{{execute T1}}

```
persistentvolume/pv-hostpath-yerel created
```

**2. Adım, Pvc manifestomuzu manifestoyu çalıştıralım.**

`kubectl apply -f 12-Hostpath-pvc.yml`{{execute T1}}

```
persistentvolumeclaim/pv-hostpath-yerel created
```
Gözlem ekranında son durmu gözlemleyelim.


Reclaim policy, Retain olarak tanımlandığında, pvc silindiğinde, pv varlığını koruyordu.
Oysa reclaim policy delete olarak belirtildiğinde, pvc silindiğinde pv ve onunla birlikte silinmeli.

**"_Bu volume'larda oluşan veriler silinmeyecektir._"**

Pvc'yi silip volume'da siliniyor mu diye bakalım.

`kubectl delete -f 12-Hostpath-pvc.yml`{{execute T1}}

```
persistentvolumeclaim "pv-hostpath-yerel" deleted
```

İşlem durumunu gözlemleyerek sonucu teyit edelim.

```
NAME                                 CAPACITY  RECLAIM POLICY   STATUS   CLAIM
persistentvolume/pv-hostpath-yerel   1Gi       Delete           Failed   default/pv-hostpath-yerel   
```
Durumunu ***"Failed"*** olarak görünüyor, detayını inceleyip neden fail olduğunu öğrenmeye çalışalım.

`kubectl describe pv pv-hostpath-yerel`{{execute T1}}

```
Message:         host_path deleter only supports /tmp/.+ but received provided /opt/veridosyasi
```

Hata mesajı diyorki, hostpath silme işlemini ancak, /tmp/klasörünün altında olursa gerçekleştirebilir, bunun haricinde ki klasörleri silemez.

Bu çok doğal, bunu aksi inanılmaz büyük bir güvenlik zafiyeti doğurur, binlerce pod'u çalıştırdığınız bir cluster düşünün, herbirinin arka tarafta ne işlemler yaptığnı bilemyeceğimiz için böyle bir önlem olması gayet iyidir.

Pv'yi silip /tmp/ klasörü altında oluşabilecek bir klasör oluşturacak şekilde yeniden yapılandıralım operasyonumuzu.

`kubectl delete pv pv-hostpath-yerel`{{execute T1}}

```
persistentvolume "pv-hostpath-yerel" deleted
```

Yeni oluşturduğum [15-PV-Hostpath-tmp.yml](./assets/15-PV-Hostpath-tmp.yml) manifestosunda dizin yolunu bu sefer tmp altında almış oldum.

```
apiVersion: v1
kind: PersistentVolume
metadata:
  name: pv-hostpath-yerel
spec:
  storageClassName: manual
  persistentVolumeReclaimPolicy: Delete
  capacity:
    storage: 1Gi
  accessModes:
    - ReadWriteOnce
  hostPath:
    path: "/tmp/veridosyasi"
```
Sırası ile, önce pv'mizi oluşturalım, sonra pvc'i ile alanımızı talep edelim, en son olarak da pod'umuzu çalıştıralım.

1.
`kubectl apply -f 15-PV-Hostpath-tmp.yml`{{execute T1}}

```
persistentvolume/pv-hostpath-yerel created
```

2.
`kubectl apply -f 12-Hostpath-pvc.yml`{{execute T1}}

```
persistentvolumeclaim/pv-hostpath-yerel created
```

3.
`kubectl apply -f 13-Hostpath-Containeri.yml`{{execute T1}}

```
pod/veri-pod created
```
Podumuzun hangi node'da çalıştığını bulalım.

`kubectl get pods -o wide`{{execute T1}}

Podumuzun node01'de oluştuğunu görüyoruz, o node'a login olup veridosyamızın kontrolünü yapalım.

`ls /tmp/ | grep veridosyasi`{{execute T3}}

Veri dosyamız, tmp klasörü altında bulunacaktır :).

Planladığımız gibi gerçekleşti işlemlerimiz, sırada pvc'yi silerek neler olacağını gözlemlemek kaldı.

PVC'imizi ve podumuzu silelim.

`kubectl delete pod veri-pod`{{execute T1}}

```
pod "veri-pod" deleted
```

`kubectl delete pvc pv-hostpath-yerel`{{execute T1}}

```
persistentvolumeclaim "pv-hostpath-yerel" deleted
```

Persistent Volume tekrar kontrol edelim.

`kubectl get pv`{{execute T!}}

```
No resources found
```
___
Tebrikler, Bu bölümüde burada tamamalamış olduk arkadaşlar, bir sonra ki bölümde görüşmek üzere hoşçakalın.
