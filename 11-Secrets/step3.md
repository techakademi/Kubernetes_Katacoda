## 2.Senaryo Secret'i bir veribirimi şeklinde kullanmak.

Secret'lar aynı anda birden fazla pod tarafından kullanılabilir, aynı secreti kullanarak, Yeni bir pod oluşturalım, bu sefer pod'umuza ***deneme-secret***'i bir veri birimi şeklinde monteleyerek kullanalım.

Secret Pod oluşturmak için  [21-Secret-Vol-Pod.yml](./assets/21-Secret-Vol-Pod.yml) belgesinde konteynerin secret'i veri birimi monte edilecek şekilde değerleri içeren manifest hazır durumdadır.

1.Adım, pod'umuzu çalıştıralım:

`kubectl apply -f 21-Secret-Vol-Pod.yml`{{execute}}

```bash
pod/deneme-secret-volpodu created
```

2.Adım, oluşturduğumuz Pod'un arayüzüne erişip monte ettiğimiz veribirimi dizinine gidip hassas verilerimizi inceleyelim.

`kubectl exec -it deneme-secret-volpodu -- sh`{{execute}}

`ls vars/gizli/`{{execute}}

```bash
kullanici  parola
```

3.Adım, kullanıcı ve parola değerlerini okumak için "cat" komutunu kulllanalım:

`cat vars/gizli/kullanici`{{execute}}

```bash
yonetici
```

`cat vars/gizli/parola`{{execute}}

```bash
12345
```
