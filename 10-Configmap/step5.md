## 4.Senaryo

ConfigMap değerleri bir yapılandırma belgesinin okunması ile de uygulanabilmektedir, bir önce ki bölümde kullandığımız adres.cfg'nin barındırdığı parametreleri configMap'ın içerisinde barındırmıştık, şimdi yine aynı yapılandırma belgesini bu sefer configMap'ın içerisinde barındırmak yerine, onu dışarıda oluşturup configMap ile Pod'a veribirimi şeklinde monte ederek oluşturacağız.

1.Adım, Uygulama değişkenimizi içeren parametreleri barındıran manifest'imizi oluşturalım.

`sudo nano adres.cfg`{{execute T1}}

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

```bash
configmap "adres-map-belge" deleted
```

3.Adım, adres.cfg belgemizi editleyip yeni IP adresi eklyelim.

`sudo nano adres.cfg`{{execute T1}}

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
