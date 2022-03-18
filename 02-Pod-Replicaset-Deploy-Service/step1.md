## Bu bölümde, tekil bir Pod oluşturacağız.

Podumuzu, **"01-Merhaba-dunya-pod.yml"** adında belgemizi kullanarak kuberenetes'de çalıştıracağız.

01-Merhaba-dunya-pod.yml belgesi şu an sunucu'ya kopyalanmış durumdadır.
**ls** ile kontrolünü gerçekleştirebiliriz.

`ls`{{execute}}

Cluster'da ilk podumuzu hazırlanmış olan belgemizi kullanarak oluşturacağız, kubectl'dan pod'umuzu ***"create"*** yerine ***"apply"*** ile oluşturmasını istiyoruz, ***create*** ile ***apply*** arasındaki fark ***create*** oluştur demektir, ***apply*** ise uygula demektir, her ne kadar birbirlerine çok benzeselerde aralırnda ki fark ***create*** daha çok yeni objeler oluşturmak için kullanılırken ***apply*** ile mevcut bir deklarasyonun hem uygulanmasını hem de güncellemesini gerçekleştirebilmekteyiz.

-----
Pod'umuzu oluşturmak için aşağıdaki komutu uygulayalım:

`kubectl apply -f 01-Merhaba-dunya-pod.yml `{{execute}}

Kubectl, podu başarılı bir şekilde oluşturduğunu aşağıdaki şekilde bildirecektir.

```
pod/merhaba-dunya-pod created
```
---
**NOT:**

Bazen, aşağıdaki şekilde hata mesajı alabilirsiniz, kısa bir süre bekleyip tekrar deneyiniz.

***Error from server (Forbidden): error when creating "01-Merhaba-dunya-pod.yml": pods "merhaba-dunya-pod" is forbidden: error looking up service account default/default: serviceaccount "default" not found***
---

Merhaba Dunya podumuzun oluşmasının ardından, ***kubectl get pods*** komutu ile mevcut podlarımızı listelyelim.

`kubectl get pods`{{execute}}

```
NAME                READY   STATUS    RESTARTS   AGE
merhaba-dunya-pod   1/1     Running   0          29s
```

Tebrikler, Kubernetes Cluster'inde ilk podumuzu başarılı bir şekilde oluşturmuş olduk.