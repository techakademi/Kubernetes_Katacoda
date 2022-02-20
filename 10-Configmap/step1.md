Uygulamalar özellikle geliştirme aşamalarında sıklıkla yapılandırma değişimine ihtiyaç duyarlar, yapılandırma parametrelerini uygulamanın içine kodlamak, her değişimde uygulama imajının tekrar hazırlanmasını gerektirecektir. Yenilenen imajın tüm ekip tarafından tekrar kullanılmasını sağlamak, imajı ilgili registry'ye push etmek gibi bir çok sürecin işlemesini gerektiren zaman ve kaynak israfı anlamına gelmektedir.

Bu şekilde yürütmek yerine, uygulamanın yapılandırma parametrelerini dışarıda barındırarak, her seferinde sadece ilgili uygulama imajını gerekli yeni hali ile yayınalamaya odaklanmak daha doğru olur.

Konfigurasyon nedir?, bir uygulamanın çalışmaya başlaması ve devam edebilmesi için ihtiyaç duyduğu herşey.

Örneklemek gerekirse:

* Veritabanı bağlantı stringleri
* Kullanıcı adı parolalar
* Port numaraları
* Servis adları
* Servis adresleri

şeklinde sıralayabilriz.

Bu yapılandırma parametreleri hassas veri ile hassas olmayan veri olarak ikiye ayırabiliriz, parola, anahtar, API anahtarı gibi hassas verileri içeren parametreleri bir önceki bölümde işlediğimiz gibi **"Secret"** kullanarak uygulama içerisine alınmalı.Bunun haricinde bağlantı portları, bağlantı adresleri gibi hassas ver içermeyen parametreler için **"ConfigMaps"** kullanabiliriz.

| ⚠ Dikkat: ConfigMap gizlilik veya şifreleme sağlamaz. Saklamak istediğiniz veriler gizliyse, ConfigMap yerine bir Secret kullanın veya verilerinizi gizli tutmak için ek (üçüncü taraf) araçlar kullanın. ⚠|
| --- |  

Herhangi bir ConfigMap'ı Pod ile kullanımı dört şekilde olmakta:

1. Bir konteyner içinde komut argümanı
2. Konteyner ortam değişkeni
3. Veribiriminde salt-okunur bir belge
4. Kubernetes API üzerinden bir ConfigMap'ı okuayabilecek Pod içinde çalışan uygulama ile gerçekleştirilebilir.

ConfigMap'lerimizi oluşturmadan önce, mümkünse kullandığınız terminali yatay şeklinde ikiye bölerek anlık gözlemleme olanağına sahip oluruz.
Ekranlardan birinde, watch komutunu çalıştırarak kendimize bir gözlem terminali oluşturmuş olalım.

`Yeni terminal ekranı aç.`{{execute T2}}

`watch kubectl get cm,pods`{{execute T2}}

***kubectl get cm,pods*** tüm cluster'da oluşan pod ve secret nesnelerini getir anlamındadır.

Sırası ile ConfigMap üretip kullanalım:

## 1.Senaryo

Bu uygulamada, **"kubcetl create configmap"** komut aracı ile bir ortam değişkeni olarak kullanılacak şekilde ConfigMap oluşturalım.

1. Adım Kullanıcı adı parola barındıran bir secret oluşturalım:

`kubectl create configmap merhaba-map --from-literal=selam=merhaba-Kubernetes-Dunyasi`{{execute T1}}

SecrConfigMap'in oluşturulduğunu teyit eden komut aşağıda ki gibi olacaktır:

```bash
configmap/merhaba-map created
```

2.Adım, secretin içeriğini inceleyelim:

`kubectl describe configmap merhaba-map`{{execute T1}}

```bash
Name:         merhaba-map
Namespace:    default
Labels:       <none>
Annotations:  <none>

Data
====
selam:
----
merhaba-Kubernetes-Dunyasi

BinaryData
====

Events:  <none>
```

3.Adım, oluşturduğumuz bu ConfigMap değerini ortam değişkeni halinde kullanabileceğimiz bir pod oluşturalım.

ConfigMap Pod oluşturmak için  [25-Conf-Merhaba-Map.yml](./assets/25-Conf-Merhaba-Map.yml) belgesinde konteynerin ortam değişkeni olarak kullanacağı değerleri içeren manifest hazır durumdadır.

`kubectl apply -f 25-Conf-Merhaba-Map.yml`{{execute T1}}

```bash
pod/merhabamap-env-pod created
```

Pod'un ortam değişkenlerini okumak için interaktif shell ile konteynere erişip değerleri görelim.

`kubectl exec -it merhabamap-env-pod -- sh`{{execute T1}}

```bash
/ #
```

Konteyner arayüzünde bulunduğumuz sırada **echo** ile ortam değişkeni olarak tanımladığımız **selam** değişkeninin değerini görüntüleyelim.

`echo $selam`{{execute T1}}

```bash
merhaba-Kubernetes-Dunyasi
/ #
```

Exit komutu ile podumuzdan çıkış yapalım.

`exit`{{execute T1}}

merhaba-map ConfigMap'ında oluşturduğumuz selam değişkeninin değeri olan ***"merhaba-Kubernetes-Dunyasi"*** konteynerimiz tarafından okunarak aktarımı bu şekilde gerçekleşmiş oldu.

ConfigMap'i ortam değişkeni olarak kullandığımızda, ilgili değişken konteynerin oluşum anında ortam değişkeni olarak kayıt edilir.Değişken değerinin yenisi ile değişmesi halinde Pod'un güncellenen değişkeni tekrar alabilmesini tek yolu restart edilerek yeni değeri almasından geçer.

Uygulama parametrelerinin sıklıkla değiştiği durumlarda, env olarak kullanmak yerine, veribirimi (volume) şeklinde kullanarak pod'a monte etmek daha iyi olacaktır.

Bir sonraki bölüme geçerek ilk senaryomuz ile Kubernetes Secrets konumuzu işlemeye başlayalım.
