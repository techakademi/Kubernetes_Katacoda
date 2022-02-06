
## 3.Senaryo Manifest belgesi kullanarak secret oluşturmak.

Secret'lar kubectl komutu kullanılarak oluşturulabildiği gibi, bir yaml manifesti oluşturarak da kullanılabilir. Bu senaryoda önce base64 ile kullanıcı adı ve parola kodlayıp sonrasında, o değerler ile bir manifset hazırlayıp, Kubernetes'de yeni bir secret oluşturacağız.

1. Adım, base64 ile veri oluşturmak, bu değerleri bir not defterine kopyalayalım.

`echo -n 'ustakullanici' | base64`{{execute T1}}

```bash
dXN0YWt1bGxhbmljaQ==
```

`echo -n 'muhtesemparola' | base64`{{execute T1}}

```bash
bXVodGVzZW1wYXJvbGE=
```

2.Adım, kodlanmış değerler ile aşağıda ki örnekte olduğu gibi bir manifest oluşturalım.

Yeni bir manifest oluşturmak için nano editörünü kullanalım.

`sudo nano 22-Secret-kod1.yml`{{execute T1}}


##### 1. Adım, Aşğıdaki manifesti kopyalayıp nano editörüne Shift+Insert ile yapıştıralım.
##### 2. Adım, ctr+o belgeyi kayıt edelim.
##### 3. Adım, ctr+x ile nano'dan çıkalım.

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: secret-manifest
type: Opaque
data:
  kullaniciadi: dXN0YWt1bGxhbmljaQ==
  parola: bXVodGVzZW1wYXJvbGE=
```

3.Adım, oluşturduğumuz Manifest ile yeni bir secret oluşturalım:

`kubectl apply -f 22-Secret-kod1.yml`{{execute T1}}

```bash
secret/secret-manifest created
```

4.Adım, Manifest ile oluşturduğumuz secret'i bir pod'a volume olarak ekleyerek erişelim.


`kubectl apply -f 23-Secret-Vol-Kod-Pod.yml`{{execute T1}}

5.Adım, Secret'i kullanan podumuzdan verileri okuyup içeriklerini görüntüleyelim.

**Pod'a erişmek için Status'un "running" olduğundan emin ol.**

5.1 Veribirimi klasörü içeriğini görüntüleyelim.

`kubectl exec secret-manifest-podu -- ls vars/gizli-kod`{{execute T1}}

```bash
kullaniciadi
parola
```

5.2 Kullanıcı adını görüntüleyelim.

`kubectl exec secret-manifest-podu -- cat vars/gizli-kod/kullaniciadi`{{execute T1}}

```bash
ustakullanici
```

5.3 Parolayı görüntüleyelim.

`kubectl exec secret-manifest-podu -- cat vars/gizli-kod/parola`{{execute T1}}

```bash
muhtesemparola
```

Secret'leri bir volume şeklinde kullanarak uygulamalarımızın kullanıcı adı parolalara erişebilmelerini sağlarız.

Ancak malumdur ki, kullanıcı adları çoğunlukla sabit olurlar fakat parolalar düzenli bir şekilde değişirler. Hali hazırda kullandığımız bir parola değişirse ne yaparız?.

6.Adım, yeni bir parola oluşturalım.

`echo -n 'muhtesemp@r0la' | base64`{{execute T1}}

```bash
bXVodGVzZW1wQHIwbGE=
```

7.Adım, oluşturduğumuz bu parolayı için yeni manifest oluşturup güncelleme uygulamasını yapalım.

`sudo nano 22-Secret-kod2.yml`{{execute T1}}

##### 1. Adım, Aşğıdaki manifesti kopyalayıp nano editörüne Shift+Insert ile yapıştıralım.
##### 2. Adım, ctr+o belgeyi kayıt edelim.
##### 3. Adım, ctr+x ile nano'dan çıkalım.

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: secret-manifest
type: Opaque
data:
  kullaniciadi: dXN0YWt1bGxhbmljaQ==
  parola: bXVodGVzZW1wQHIwbGE=
```

`kubectl apply -f 22-Secret-kod2.yml`{{execute T1}}

```sh
secret/secret-manifest configured
```

Bu manifest'de dikkat ederseniz değiştirdiğimiz anahtar değer, yalnızca parolanın ki oldu, diğer tüm değerler aynı şekilde kaldı. Eğer ***"secret-manifest"*** adını değiştirecek olsaydık, o zaman bu Kubernetes için yeni bir nesne olacak idi, ancak sadece ***"parola"*** anahtarını değiştirdiğimiz için, bu durum Kubernetes için ilgili secret'i güncelleme işlemi olmaktadır.

Parola değişikliğini gözlemleyelim.

---Not:
Scheduler'in ETCD'de ki değişikliği okuyup pod'a yansıtması biraz zaman alabilir, aşağıda komutu bir kaç sefer denemeniz gerekebilir.

`kubectl exec secret-manifest-podu -- cat vars/gizli-kod/parola`{{execute T1}}

```sh
muhtesemp@r0la
```

Bu şekilde, parolalar veya anahtarlar her ne tür bir hassas veri barındıran nesne kullanıyorsak, güncellemelerini gerçekleştirebiliriz.

Bir sonraki bölüme geçebiliriz.
