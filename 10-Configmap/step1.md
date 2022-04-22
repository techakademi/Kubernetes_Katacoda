ConfigMap, gizli olmayan verileri anahtar/değer çiftlerinde depolamak için kullanılan bir API nesnesidir. Pod'lar, ConfigMaps'i ortam değişkenleri, komut satırı değişkenleri veya bir veribirimi yapılandırma dosyaları olarak kullanabilirler.

Bir ConfigMap ile, uygulamanın ihtiyaç duyduğu ortam değişkenlerini konteyner imajına kodlamaka yerine, dışında barındırmayı sağlar.

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

`Yeni Terminal aç.`{{execute T2}}

`watch kubectl get cm,pods`{{execute T2}}

***kubectl get cm,pods*** tüm cluster'da oluşan pod ve secret nesnelerini getir anlamındadır.

Bir sonraki bölüme geçelim.
