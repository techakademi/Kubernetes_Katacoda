##### Kubernetes Secrets'a giriş.

Kubernetes Secret'lar, onları kullanacak olan Pod'larda bağımsız bir şekilde oluşturulurlar, böylece onları kullanan Pod'ların oluşum, görüntüleme ve düzenleme aşamalarında barındırdığı gizli verilerin açığa çıkma riski azalır.

| ⚠ Dikkat: Kubernetes Secret'lar, varsayılan olarak API sunucusunun veri deposu olan "etcd" şifrelenmemiş olarak depolanır. Bu, API erişimi olan herkesin ilgili secret'i alabileceği, değiştirebileceği anlamına gelmektedir. Secret'ları encrypt edilmiş şekilde saklamak için, Kubernetes API serveri Secret verilerini encrypt edilmiş şekilde etcd'de saklaması için yapılandırılabilir .⚠|
| --- |  

Bir diğer seçenek ise, Bir VAULT sistemi kullanarak tüm hassas şifreleri orada muhafaza etmek daha mantıklı olur.

Kubernetes'de bir Secret'i kullanmak için, ilgili Pod'a kullanacağı Secret'i tanımlanması gerklidir.

Herhangi bir secretin Pod ile kullanımı üç şekilde olmakta:

1. Bir pod'un içindeki konteynere monte edilmiş veri birimi şeklinde
2. Konteyner ortam değişkeni şeklinde
3. Pod içinde çalışacak uygulamanın imajını indirmek için kubelet'in kullanacağı şekilde olmaktadır.

**Secret Türleri:**

Kubernetes, bazı yaygın kullanım senaryoları için çeşitli yerleşik türler sağlar. Bu türler, gerçekleştirilen doğrulamalar ve Kubernetes'in onlara dayattığı kısıtlamalar açısından farklılık gösterir.

| Secret türü | Açıklama | Örnek |
| ----------- | ----------- | ------- |
| generic     |Bir dosyadan, dizinden veya değerden oluşturulabilen Secret | **kubectl create secret generic deneme-secret  --from-literal=kullaniciadi=deneme --from-literal=parola=12345** |
| tls         | public ve private anahtarlarını barındıran Secret türü |**kubectl create secret tls tls-secret --cert=sertifikadizin/tls.cert --key=sertifikadizin/tls.key** |
| docker-registry | Özel Docker registry kullanımı için oluşturulan secret türüdür. | **kubectl create secret docker-registry docker-registry-adı --docker-server=<https://index.docker.io/v1/> --docker-username=kullanıcıadı --docker-password=kullanıcıparolası** |

Secret'lerimizi oluşturmadan önce, mümkünse ikinci bir terminal açarak, watch komutunu çalıştırarak kendimize bir gözlem terminali oluşturmuş olalım.

İkinci terminal ekranı açmak için aşağıdaki komutu kullanalım.

`Yeni terminal ekranı aç.`{{execute T2}}

Terminalde aşağıda ki komutu çalıştır.

`watch kubectl get pods,secrets`{{execute T2}}

***kubectl get pods,secrets*** tüm cluster'da oluşan pod ve secret nesnelerini getir anlamındadır.

Bir sonraki bölüme geçerek ilk senaryomuz ile Kubernetes Secrets konumuzu işlemeye başlayalım.
