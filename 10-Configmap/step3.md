## 2.Senaryo

ConfigMap'lar, Çalışan uygulamanın komut argümanı şeklinde kullanımını uygulayacağız bu bölümde, DNS sunucu kontrolünü yapan uygulamamız sunucu ip'lerini Pod'un spec'ine tanımlayarak kullanmıştık ***"Jobs_Cronjobs"*** bölümünde. Bu senaryoda, yine aynı uygulama için ip adresini bir ortam değişkeni şeklinde kullanacağız.
Ancak bu sefer ConfigMap'ımızı kubectl komutu yerine bir manifest ile oluşturacağız, uygulayacağımız adımlar aşağıda ki gibi olacaktır:

1.Adım, Uygulama değişkenimizi içeren parametreleri barındıran manifest'imizi oluşturalım.

`sudo nano 26-1-Dns-Config.yml`{{execute T1}}

### Manifestimiz aşağıdaki gibi olmalı

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: dns-map
  namespace: default
data:
  dns1: 1.1.1.1
  dns2: 8.8.8.8
```

2.Adım, ConfigMap'ımızı oluşturalım:

`kubectl apply -f 26-1-Dns-Config.yml`{{execute T1}}

```bash
configmap/dns-map created
```

ConfigMap'ı kullanacak Pod'u oluşturmak için  [26-Conf-Dns-Env.yml](./assets/26-Conf-Dns-Env.yml) belgesinde konteynerin ilgili değişekneleri okuyacak şekilde değerleri içeren manifest hazır durumdadır.

3.Adım, Dns kontrolünü gerçekleştirecek Podumuzu çalıştıralım.

`kubectl apply -f 26-Conf-Dns-Env.yml`{{execute T1}}

```bash
pod/dns-kontrol-conf created
```

Gözlem ekrarnından dns-kontrol-conf podumuzun görevini tamamlamış olduğunu kontrol edelim.

NAME                     READY   STATUS      RESTARTS   AGE
pod/dns-kontrol-conf     0/1     Completed   0          37s
pod/merhabamap-env-pod   1/1     Running     0          2m40s


4.Adım, dns-kontrol-conf Pdo'umuzun görevini tamamlamış olduğunu teyit ettikten sonra, loglarını kontrol ederek sonucunu öğrenelim.

`kubectl logs dns-kontrol-conf`{{execute T1}}

```bash
dns.google is alive
one.one.one.one is alive
```

ConfigMap'de tanımladığımız ip adreslerinin kontrollerini başarılı bir şekilde yerine getirmiş olduğunu görebilmekteyiz.
