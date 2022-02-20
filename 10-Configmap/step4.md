## 4.Senaryo

Dns kontrolünü gerçekleştiren uygulamamız başarılı bir şekilde çalışıyor, ancak yazılımıza yen bir ip eklemek istediğimizde, sırasıyla önce configMap'ı sonra da Pod'un spec'ine yeni bir satır ekleyip sonrasında ise Pod'u tekrar çalıştırmamız gerekecek. Bu uygulanabilecek bir yöntem olmakla birlikte, kullanacağımız parametrelerin değişmesi halinde uygulamaya yansımasını ve yeni parametreleri kullanarak çalışmasını sağlayabiliriz.

Bu bölüm için hazırlamış olduğum **"techakademi/pinger:1"** adında bir uygulamam var, uygulama bir öneki sürümde olduğu gibi DNS kontrolünü gerçekleştiriyor, aslında özellikle DNS değil herhangi bir ip adresini pingleme işlemini gerçekleştiriyor, ancak bir fark var ki pingleyeceği ip adreslerini ***"/pinger/adres.cfg"*** klasörü altında bulunan adres.cfg belgesinden okuyarak ipleri pingliyior.

Pinger uygulamasının çalışması için ihtiyacı olan parametreleri, bir veribirimi kullanarak ekleyeceğiz, böylece konteyner çalıştığında ***adres.cfg*** belgesinde var olan ip adreslerini ***/pinger*** klasörüne montelemiş olacağımızdan ip'leri pingleme işlemini yerine getirebilecektir.

1.Adım, Uygulama değişkenimizi içeren parametreleri barındıran manifest'imizi oluşturalım.

`sudo nano asres.cfg`{{execute T1}}

### Aşağıdaki IP adreslerini ekleyip kayıt edip kapatalım

```cfg
208.67.222.222
185.228.168.9
76.76.19.19
94.140.14.14
```

2.Adım, ConfigMap'ımızı oluşturalım:

`kubectl create configmap adres-map-belge --from-file=./adres.cfg`{{execute T1}}

```bash
configmap/adres-map-belge created
```

ConfigMap'ı kullanacak Pod oluşturmak için  [28-Pinger-Conf-Vol-Belge.yml](./assets/28-Pinger-Conf-Vol-Belge.yml) belgesinde konteynerin ilgili değişekneleri okuyacak şekilde değerleri içeren manifest hazır durumdadır.

3.Adım, Dns kontrolünü gerçekleştirecek Podumuzu çalıştıralım.

`kubectl apply -f 28-Pinger-Conf-Vol-Belge.yml`{{execute T1}}

```bash
pod/adres-test-pod created
```

4.Adım, adres-test-pod-belge Pdo'umuzun arayüzüne erişelim.

`kubectl exec -it adres-test-pod-belge -- sh`{{execute T1}}

```bash
/ #
```

5.Adım, home dizininin altında bulunan pinger.sh scriptimizi çalıştıralım.

`./home/pinger.sh`{{execute T1}}

```bash
dns.umbrella.com is alive
Pinglenen IP 208.67.222.222 : Durumu Basarili
customfilter9-dns.cleanbrowsing.org is alive
Pinglenen IP 185.228.168.9 : Durumu Basarili
dns.alternate-dns.com is alive
Pinglenen IP 76.76.19.19 : Durumu Basarili
dns.adguard.com is alive
Pinglenen IP 94.140.14.14 : Durumu Basarili
```

Arayüzden çıkıp, ConfigMap'ımızı silelim, adres.cfg belgemize yeni IP adresi ekleyip configMap'ımızı tekrar oluşturup uygulamayı çalıştıralım.

1.Adım, Çıkış yapalım.
`exit`{{execute T1}}

2.Adım, adres-map-belge isimli ConfigMap'ımızı silelim.

`kubectl delete configmap adres-map-belge`{{execute T1}}

2.Adım, adres-map-belge isimli ConfigMap'ımızı silelim.

`kubectl delete configmap adres-map-belge`{{execute T1}}

```bash
configmap "adres-map-belge" deleted
```

3.Adım, adres.cfg belgemizi editleyip yeni IP adresi eklyelim.

`sudo nano asres.cfg`{{execute T1}}

### Aşağıdaki yeni IP adreslerini ekleyip kayıt edip kapatalım

```cfg
208.67.222.222
185.228.168.9
76.76.19.19
94.140.14.14
8.8.8.8
9.9.9.9
1.1.1.1
94.140.15.15
76.223.122.150

```

4.Adım, adres-map-belge ConfigMap'ımızı tekrar oluşturalım.

`kubectl create configmap adres-map-belge --from-file=./adres.cfg`{{execute T1}}

5.Adım, adres-test-pod-belge Pod'umuzun arayüzüne erişip scriptimizi tekrar çalıştıralım.

** Kubelet senkronizasyon süresi varsayılan olarak 1 dakikadır, bu süreden önce ConfigMap'ın yeni değerleri yansımaya bilir.**

5.1
`kubectl exec -it adres-test-pod-belge -- sh`{{execute T1}}

5.2
`./home/pinger.sh`{{execute T1}}

Sonuç:

```bash
dns.umbrella.com is alive
Pinglenen IP 208.67.222.222 : Durumu Basarili
customfilter9-dns.cleanbrowsing.org is alive
Pinglenen IP 185.228.168.9 : Durumu Basarili
dns.alternate-dns.com is alive
Pinglenen IP 76.76.19.19 : Durumu Basarili
dns.adguard.com is alive
Pinglenen IP 94.140.14.14 : Durumu Basarili
dns.google is alive
Pinglenen IP 8.8.8.8 : Durumu Basarili
dns9.quad9.net is alive
Pinglenen IP 9.9.9.9 : Durumu Basarili
one.one.one.one is alive
Pinglenen IP 1.1.1.1 : Durumu Basarili
dns.adguard.com is alive
Pinglenen IP 94.140.15.15 : Durumu Basarili
76.223.122.150 is alive
Pinglenen IP 76.223.122.150 : Durumu Basarili
```

Uygulamamız yeni parametreleri kullanarak eklenen IP adreslerini başarılı bir şekilde tamamını pinglemeyi başardı.

Pod'umuzdan çıkış yapalım.
`exit`{{execute T1}}

`kubectl delete pod adres-test-pod-belge`{{execute T1}}
pod "adres-test-pod-belge" deleted

`kubectl delete configmaps merhaba-map`{{execute T1}}
configmap "merhaba-map" deleted

`kubectl delete configmaps dns-map`{{execute T1}}
configmap "dns-map" deleted

`kubectl delete configmaps adres-map-belge`{{execute T1}}
configmap "adres-map-belge" deleted

`kubectl delete configmaps adres-map`{{execute T1}}
configmap "adres-map" deleted

Kubernetes'de secret kullanımı temel olarak bu yöntemler ile gerçekleştirilmektedir.Bu bölümüde burada tamamalamış olduk arkadaşlar, bir sonra ki bölümde görüşmek üzere hoşçakalın.

___

### Bu Bölümün Menüsüne çık [12-ConfigMap'a Geri Dön](https://github.com/techakademi/KubernetesDersler/tree/master/12-ConfigMap)

## Ana Bölüm [Kubernetes Derlser'e geri dön](https://github.com/techakademi/KubernetesDersler)

**Referanslar:**

**[ConfigMap](https://kubernetes.io/docs/tasks/configure-pod-container/configure-pod-configmap/)**

**[Environment Variable](https://en.wikipedia.org/wiki/Environment_variable)**
