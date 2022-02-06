
### 4.Senaryo Belge veya dosyadan secret oluşturmak.

Secret'lar, bir manifest kullanılarak veya doğrudan ***"kubectl create secret"*** komutu aracılığı ile oluşturulabildiği gibi, bir belge içerisinde oluşturulmuş olan kullanıcı adı parola, ssh anahtarı gibi hassas verilerden oluşturulabilinmektedir.
Bu senaryomuda, ssh için anahtarından secret oluşturup pod'umuza volume olarak ekleyip kullanalım.

1. Adım, ssh-keygen ile yeni bir ssh anahtarı oluşturalım.

`ssh-keygen -f ~/.ssh/deneme_rsa -t rsa -b 4096 -C "usta@example.com"`{{execute T1}}

```bash
Generating public/private rsa key pair.
Enter passphrase (empty for no passphrase):
Enter same passphrase again:
Your identification has been saved in /root/.ssh/deneme_rsa.
Your public key has been saved in /root/.ssh/deneme_rsa.pub.
The key fingerprint is:
SHA256:9Y+DgtsDpZ49gxFXfkD+BxGuSdCVdh3zErwuFrzAD5c usta@example.com
```

2.Adım, ssh public anahtarının içeriğini görmek için ***"cat"*** ile gözlemleyelim.

`cat /root/.ssh/deneme_rsa.pub`{{execute T1}}

```sh
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDelgo39wdASkV6p3ay96XUNPGcJRAdI5k6gvylb+Rhe83aS6h/Tr8XKYBg7nYjvOxIMEo+90w0v6JDJwGbXdI3srt24V8IgHEeWFUFPJaG+4LjcGMqRNhId4C2MYneuEXGPdIFn36NgMKELTPQXWjlvhQ30y8q/usta@example.com
```

3.Adım, ssh anahtarlarını barındıran secret'imizi oluşturmak için ***"kubectl create secret"*** komutunu kullanalım.

`kubectl create secret generic ssh-key-secret --from-file=ssh-privatekey=/root/.ssh/deneme_rsa --from-file=ssh-publickey=/root/.ssh/deneme_rsa.pub`{{execute T1}}

Secret oluşumunu teyit eden komuş aşağıdaki gibidir.

```sh
secret/ssh-key-secret created
```

Ssh anahtarlarını kullanacağımız Pod'u oluşturmak için  [24-Secret-Ssh-Pod.yml](./assets/24-Secret-Ssh-Pod.yml) belgesinde konteynerin secret'i veri birimi monte edilecek şekilde değerleri içeren manifest hazır durumdadır.

4.Adım, Podumuzu oluşturmak için aşağıda komutu kullanalım.

`kubectl apply -f 24-Secret-Ssh-Pod.yml`{{execute T1}}

Podun oluşum teyidi aşağıdaki gibidir.

```sh
pod/ssh-manifest-podu created
```

5.Adım, Podumuzun arayüzüne erişip, ssh anahtarlarımızı kontrol edelim.

**Pod'a erişmek için Status'un "running" olduğundan emin ol.**

`kubectl exec -it ssh-manifest-podu -- cat /.ssh/ssh-privatekey`{{execute T1}}

```sh
-----BEGIN OPENSSH PRIVATE KEY-----
b3BlbnNzaC1rZXktdjEAAAAABG5vbmUAAAAEbm9uZQAAAAAAAAABAAACFwAAAAdzc2gtcn
NhAAAAAwEAAQAAAgEA3pYKN/cHQEpFeqd2svel1DTxnCUQHSOZOoL8pW/kYXvN2kuof06/
```

`kubectl exec -it ssh-manifest-podu -- cat /.ssh/ssh-publickey`{{execute T1}}

```sh
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDelgo39wdASkV6p3ay96XUNPGcJRAdI5k6gvylb+Rhe83aS6h/Tr8XKYBg7nYjvOxIMEo+90w0v6JDJwGbXdI3srt24V8IgHEeWFUFPJaG+4LjcGMqRNhId4C2MYneuEXGP
```
---

##### Kubernetes'de secret kullanımı temel olarak bu yöntemler ile kullanılabilir, Secrets bölümümüz burada tamamlanmıştır.
