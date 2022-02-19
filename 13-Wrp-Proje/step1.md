##### Kubernetes'de MySQL ile Wordpress Sitesi oluşturmak.

Bu bölüme kadar işlediğimiz konuların uygulamasını gerçekleştireceğiz.
Uygulama projesi için ihtiyacımız olan adımları aşağıda listeleyelim:

* Uygulamaların ihtiyaçları olan ortam değişkenleri için configmap'lar oluşturacağız

* Uygulamaların diğer bir ihtiyaçları olan secret'lar oluşturacağız

* Wordpress'in de MySQL'inde verilerinin kalıcı halde saklanabilmeleri için Persistent Volume & Clime olşuturacağız.

* Son olarak uygulamalar için deploymentler ile yayına alıp, servislerini de oluşturup dış dünyaya açarak projemizi sonlandıracağız.

Projeye başlamadan önce, mümkünse kullandığınız terminali yatay şeklinde ikiye bölerek anlık gözlemleme olanağına sahip oluruz.
Ekranlardan birinde, watch komutunu çalıştırarak kendimize bir gözlem terminali oluşturmuş olalım.

Volume Gözlem ekranı:

`Yeni terminal ekranı aç.`{{execute T2}}

Terminalde aşağıda ki komutu çalıştır:
`watch kubectl get pv,pvc -o wide` {{execute T2}}

Podlar Gözlem ekranı:

`Yeni terminal ekranı aç.`{{execute T3}}

Terminalde aşağıda ki komutu çalıştır:
`watch kubectl get pod,svc,deploy -o wide` {{execute T3}}

Bir sonraki bölüme geçerek ilk senaryomuz ile Kubernetes ile Wordpres & MySQL konumuzu işlemeye başlayalım.
