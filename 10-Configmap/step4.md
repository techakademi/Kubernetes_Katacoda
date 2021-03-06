## 3.Senaryo

Dns kontrolünü gerçekleştiren uygulamamız başarılı bir şekilde çalışıyor, ancak yazılıma yeni bir ip eklemek istediğimizde, sırasıyla önce configMap'ı sonra da Pod'un spec'ine yeni bir satır ekleyip sonrasında ise Pod'u tekrar çalıştırmamız gerekecek.

Bu bölüm için hazırlamış olduğum **"techakademi/pinger:1"** adında bir uygulamam var, uygulama bir öneki sürümde olduğu gibi DNS kontrolünü gerçekleştiriyor, aslında özellikle DNS değil herhangi bir ip adresini pingleme işlemini gerçekleştiriyor, ancak bir fark var ki pingleyeceği ip adreslerini ***"/pinger/adres.cfg"*** klasörü altında bulunan adres.cfg belgesinden okuyarak ipleri pingliyior.

Pinger uygulamasının çalışması için ihtiyacı olan parametreleri, bir veribirimi kullanarak ekleyeceğiz, böylece konteyner çalıştığında ***adres.cfg*** belgesinde var olan ip adreslerini ***/pinger*** klasörüne montelemiş olacağımızdan ip'leri pingleme işlemini yerine getirebilecektir.

1.Adım, Uygulama değişkenimizi içeren parametreleri barındıran manifest'imizi oluşturalım.

`sudo nano 27-1-Pinger-Config.yml`{{execute T1}}

### İlk manifestimiz aşağıdaki gibi olmalı

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: adres-map
  namespace: default
data:
  adres.cfg: |
      1.0.0.1
      8.8.4.4
```

2.Adım, ConfigMap'ımızı oluşturalım:

`kubectl apply -f 27-1-Pinger-Config.yml`{{execute T1}}

```bash
configmap/adres-map created
```

ConfigMap'ı kullanacak Pod oluşturmak için  [27-Pinger-Conf-Vol.yml](./assets/27-Pinger-Conf-Vol.yml) belgesinde konteynerin ilgili değişekneleri okuyacak şekilde değerleri içeren manifest hazır durumdadır.

3.Adım, Dns kontrolünü gerçekleştirecek Podumuzu çalıştıralım.

`kubectl apply -f 27-Pinger-Conf-Vol.yml`{{execute T1}}

```bash
pod/adres-test-pod created
```

Bir önceki Pod'umuzda olduğu gibi adres-test-pod'umuzun da görevini tamamlamış olduğunu gözlem ekranımızdan teyit edelim.

```bash
NAME                     READY   STATUS      RESTARTS   AGE
pod/adres-test-pod       0/1     Completed   0          23s
pod/dns-kontrol-conf     0/1     Completed   0          4m11s
pod/merhabamap-env-pod   1/1     Running     0          6m14s
```

4.Adım, adres-test-pod Pdo'umuzun loglarını kontrol ederek sonucunu öğrenelim.

`kubectl logs adres-test-pod`{{execute T1}}

```bash
one.one.one.one is alive
Pinglenen IP 1.0.0.1 : Durumu Basarili
dns.google is alive
Pinglenen IP 8.8.4.4 : Durumu Basarili
```

Sonuç beklendiği gibi başarılı, ancak diyelim ki pinglemek istediğimiz adresleri güncellemek veya yenilerini eklemek istediğimizde ne yaparız?.

5.Adım, IP adreslerini içeren ConfigMap'ımıza yenilerini ekleyip güncelleyelim. Adres güncellemesi için aynı manfiestimizi kullanacağız, başka bir isimle kullanacak olursak bu yeni bir ConfigMap olacaktır.

`sudo nano 27-1-Pinger-Config.yml`{{execute T1}}

### Manifestimiz aşağıdaki gibi değiştirip kayıt edelim

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: adres-map
  namespace: default
data:
  adres.cfg: |
      1.0.0.1
      8.8.4.4
      9.9.9.9
```

6.Adım, ConfigMap'ımızı güncelleyelim.

`kubectl apply -f 27-1-Pinger-Config.yml`{{execute T1}}

```bash
configmap/adres-map configured
```

7.Adım, daha önce çalıştırdığımız Pod'umuz halen mevcut olduğundan onu imha ederek yeniden oluşturalım.

`kubectl delete pod adres-test-pod`{{execute T1}}

```bash
pod/adres-test-pod deleted
```

8.Adım, Podumuzu tekrar oluşturalım.

`kubectl apply -f 27-Pinger-Conf-Vol.yml`{{execute T1}}

```bash
pod/adres-test-pod created
```

9.Adım, Podumuzun log'unu tekrar kontrol ederek sonucunu görelim.

`kubectl logs adres-test-pod`{{execute T1}}

```bash
one.one.one.one is alive
Pinglenen IP 1.0.0.1 : Durumu Basarili
dns.google is alive
Pinglenen IP 8.8.4.4 : Durumu Basarili
dns9.quad9.net is alive
Pinglenen IP 9.9.9.9 : Durumu Basarili
```

Uygulama parametrelerini ConfigMap'i veribirimi olaraka kullandığımızda, parametre değişiklikleri uygulama içine dışarıdan enjekte edilmek yerine bu yöntem ile uygulanabilir.
