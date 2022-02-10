##### Kubernetes ConfigMaps'a giriş.

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

İkinci terminal ekranı açmak için aşağıdaki komutu kullanalım.

`Yeni terminal ekranı aç.`{{execute T2}}

Terminalde aşağıda ki komutu çalıştır.

`watch kubectl get cm,pods`{{execute T2}}

***kubectl get cm,pods*** tüm cluster'da oluşan pod ve ConfigMap nesnelerini getir anlamındadır.

Bir sonraki bölüme geçerek ilk senaryomuz ile Kubernetes ConfigMaps konumuzu işlemeye başlayalım.
