Sırası ile ConfigMap üretip kullanalım:

## 1.Senaryo

Bu uygulamada, **"kubcetl create configmap"** komut aracı ile bir ortam değişkeni olarak kullanılacak şekilde ConfigMap oluşturalım.

1. Adım Kullanıcı adı parola barındıran bir secret oluşturalım:

`kubectl create configmap merhaba-map --from-literal=selam=merhaba-Kubernetes-Dunyasi`{{execute}}

SecrConfigMap'in oluşturulduğunu teyit eden komut aşağıda ki gibi olacaktır:

```bash
configmap/merhaba-map created
```

2.Adım, secretin içeriğini inceleyelim:

`kubectl describe configmap merhaba-map`{{execute}}

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

`kubectl apply -f 25-Conf-Merhaba-Map.yml`{{execute}}

```bash
pod/merhabamap-env-pod created
```

Pod'un ortam değişkenlerini okumak için interaktif shell ile konteynere erişip değerleri görelim.

`kubectl exec -it merhabamap-env-pod -- sh`{{execute}}

```bash
/ #
```

Konteyner arayüzünde bulunduğumuz sırada **echo** ile ortam değişkeni olarak tanımladığımız **selam** değişkeninin değerini görüntüleyelim.

`echo $selam`{{execute}}

```bash
merhaba-Kubernetes-Dunyasi
/ #
```

merhaba-map ConfigMap'ında oluşturduğumuz selam değişkeninin değeri olan ***"merhaba-Kubernetes-Dunyasi"*** konteynerimiz tarafından okunarak aktarımı bu şekilde gerçekleşmiş oldu.

ConfigMap'i ortam değişkeni olarak kullandığımızda, ilgili değişken konteynerin oluşum anında ortam değişkeni olarak kayıt edilir.Değişken değerinin yenisi ile değişmesi halinde Pod'un güncellenen değişkeni tekrar alabilmesini tek yolu restart edilerek yeni değeri almasından geçer.

Uygulama parametrelerinin sıklıkla değiştiği durumlarda, env olarak kullanmak yerine, veribirimi (volume) şeklinde kullanarak pod'a monte etmek daha iyi olacaktır.
