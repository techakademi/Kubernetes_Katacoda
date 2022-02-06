
## 1.Senaryo Secret oluşturma & kullanımı.

Bu uygulamada, kalıcı bir değer ile ortam değişkeni olarak kullanılacak şekilde bir Secret oluşturalım.
Kalıcı değer kullanarak oluşturacağımız bu Secretin türü **"generic"** olacaktır.

1. Adım Kullanıcı adı parola barındıran bir secret oluşturalım:

`kubectl create secret generic deneme-secret --from-literal=kullanici=yonetici --from-literal=parola=12345`{{execute}}

Secretin oluşturulduğunun teyit eden komut aşağıda ki gibi olacaktır:

```bash
secret/deneme-secret created
```

2.Adım, secretin içeriğini inceleyelim:

`kubectl describe secrets deneme-secret`{{execute}}

```bash
Name:         deneme-secret
Namespace:    default
Labels:       <none>
Annotations:  <none>

Type:  Opaque

Data
====
kullanici:  8 bytes
parola:     5 bytes
```

3.Adım, oluşturduğumuz bu Secret değerlerini ortam değişkeni halinde kullanabileceğimiz bir pod oluşturalım.

Secret Pod oluşturmak için  [20-Secret-Env-Pod.yml](./assets/20-Secret-Env-Pod.yml) belgesinde konteynerin ortam değişkeni olarak kullanacağı değerleri içeren manifest hazır durumdadır.

`kubectl apply -f 20-Secret-Env-Pod.yml`{{execute}}

```bash
pod/deneme-secret-podu created
```

Pod'un ortam değişkenlerini okumak için interaktif shell ile konteynere erişip değerleri görelim.

`kubectl exec -it deneme-secret-podu -- env`{{execute}}

```bash
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
HOSTNAME=deneme-secret-podu
KULLANICI=yonetici
PAROLA=12345
KUBERNETES_SERVICE_PORT=443
KUBERNETES_SERVICE_PORT_HTTPS=443
KUBERNETES_PORT=tcp://10.96.0.1:443
KUBERNETES_PORT_443_TCP=tcp://10.96.0.1:443
KUBERNETES_PORT_443_TCP_PROTO=tcp
KUBERNETES_PORT_443_TCP_PORT=443
KUBERNETES_PORT_443_TCP_ADDR=10.96.0.1
KUBERNETES_SERVICE_HOST=10.96.0.1
TERM=xterm
HOME=/root
```

Deneme Secret'inde oluşturduğumuz kullanıcı ve parola bilgilerinin konteynerimiz tarafından okunarak aktarımı bu şekilde gerçekleşmekte.

Secret değerlerini, ortam değişkeni olarak kullanmak her ne kadar mümkün isede, çok hatta neredeyse hiç tavsiye edilmemektedir. Örneğin, uygulamanın hata oluşturması halinde ortam değişkenlerini içeren bir logunu tuttuğumuzu varsayalım, loga erişimi olan herkes ilgili hassas veriyi görebilir hale gelecektir.

Secretleri, env olarak kullanmak yerine, veribirimi (volume) şeklinde kullanarak pod'a monte etmek daha iyi olacaktır.
