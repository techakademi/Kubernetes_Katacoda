
**Bu bölümde, CronJob'un ikinci bölümünü işliyoruz.**

Kubernetes, cronjob'ların son üç başarılı görev ile birlikte son bir başarısız görevi tutar, kalanını ise siler. Başarısız olan görevlerin başarısızlık nedenini tespitini loglarına erişerek kontrol etmek için tutmaktadır.
Ayrıca, göreve spec.successfulJobsHistoryLimit, spec.failedJobsHistoryLimit alanları ekleyerek her görev için ayrı limit belirleyebiliriz.

Limitleri tanımlanmış olan cronjob'umuzu çalıştıralım:

`kubectl apply -f 09-CronJob1.yml`{{execute T1}}

```
cronjob.batch/hiz-test created
```

```
NAME                     SCHEDULE      SUSPEND   ACTIVE   LAST SCHEDULE   AGE   CONTAINERS   IMAGES                  SELECTOR
cronjob.batch/hiz-test   */1 * * * *   False     0        <none>          6s    hiz-test     techakademi/hiztest:1   <none>
```

Bazen bir cronjob'u durdurma veya bekletmeye ihtiyacımız olacaktır. Bekletme işlemini cronjob'u silmeden gerçekleştirmek istediğimizi varsayacak olursak, mevcut çalışan cronjob'un talimatını güncelleyerek gerçekleştirebiliriz.

```
spec:
  schedule: "*/1 * * * *"
  suspend: true
```

Hali hazırda çalışan görevin zamanlama spec'ine suspend hanesini ekleyip etkinleştirdikten sonra aynı görevi apply etmemiz yeterli olacaktır.

`kubectl apply -f 09-CronJob2.yml`{{execute T1}}

```
cronjob.batch/hiz-test configured
```

```
NAME                     SCHEDULE    SUSPEND   ACTIVE   LAST SCHEDULE   AGE   CONTAINERS   IMAGES                  SELECTOR
cronjob.batch/hiz-test   */ * * * *   True      0        36s             42m   hiz-test     techakademi/hiztest:1   <none>
```

Hız-testi görevimiz, bekletmeyi kaldırmadığımız sürece bu şekilde bekleyerek yeni podlar oluşturmayacaktır. 
Görevin devam etmesini sağlamak için suspend hanesini silebilir veya false'a çekip cronjob'u tekrar apply edebiliriz.

Bir diğer yöntem ise, kubectl'in patch komutu ile Cronjob'u çalışma anında güncelleyebiliriz. Patch, json formatınını kullanarak bir kaynak alanını güncellememize olanak tanımaktadır.

Çalışan CronJob'umuzu patch kullanarak ***"suspend"*** alanını false olarak güncelleyelim.

-p uygulanacak patch'in json dosyasına uygulanacağını belirtmek için kullanıyoruz, -f ile file olduğunu belirttiğimiz gibi.

`kubectl patch cronjob hiz-test -p '{"spec":{"suspend":false}}'`{{execute T1}}

```
cronjob.batch/hiz-test patched
```

```
NAME                     SCHEDULE    SUSPEND   ACTIVE   LAST SCHEDULE   AGE     CONTAINERS   IMAGES                  SELECTOR
cronjob.batch/hiz-test   */1 * * * *   False     1        56s             7m38s   hiz-test     techakademi/hiztest:1   <none>
```

Cronjob'a zamanlanmış görevlerin çakışması dururumu sözkonusu olacaktır, örneğin bir görev çalışmaya başladığında görevini tammalamadan, zamanlanmış bir diğer görev çalışmaya başlayacaktır.
Bu durumda, ya aynı iş mükerrer olacaktır veya henüz diğer görev kaynakları kullanaya devam ettiğinden, eksik olacaktır. Bu çakışmayı engellemek için kubernetes CronJob'lara ***_concurrencyPolicy_***
ekleyerek önlem alabiliriz, concurrencyPolicy'nin üç potlitikası vardır, birincisi ***_"Allow"_*** bu  varsayılan değer olup görevlerin aynı anda çalışmalarına izin vermesidir.
ikincisi ***_"Forbid"_*** dir eşzamanlı çalışmaya izin vermez, mevcut görev çalışıyor ise yeni görev çalıştırmaz, sonuncusu ise ***_"Replace"_*** dir, mevcut çalışan görev ile tekrarlayan zamanı gelimiş olan görev çakıştığında, çalışanı iptal edip zamanı gelimiş olan görevi çalıştırır.

___
Job & Cronjob bölümümüzü burada tamamlamış olduk arkadaşlar, umarım faydalı olmuştur. Bir diğer bölümde görüşmek üzere hoşçakalın.