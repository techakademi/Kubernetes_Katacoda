----------------------------------------------------------------------
## 3. Bölüm Degerleri okuma 
----------------------------------------------------------------------
Etcd'de kayıtlı anahtarların değerlerini okumak için aşağıdaki komutları kullanabiliriz.


Birinci Pod'a ait bilgileri okumak icin:

`etcdctl get POD1`{{execute}}

---

İkinci Pod'a ait bilgiler:

`etcdctl get POD2`{{execute}}

---

Üçüncü Pod'a ait bilgiler:

`etcdctl get POD3`{{execute}}

---

Dördüncü Pod'a ait bilgiler:

`etcdctl get POD4`{{execute}}

---

Besinci Pod'a ait bilgiler:

`etcdctl get POD5`{{execute}}
```
192.168.1.5:8080
```
---

Bu şekilde, oluşturduğumuz kayıt anahtarlarına ait değerleri okuyabiliriz.
Bu aşamaya kadar kullandigimiz kayıt okuma ile, o anahtara atanmış olan kaydı okuyabiliyorduk, ancak **etcd**'de tutulan kayıtlar bunlarla sınırlı değildir. 
Herhangi bir kayda ait tüm bilgilere erişmek için, -o extended operatörü kullanilarak ek meta verilene erişebiliriz.


----

Altinci Pod'a ait bilgiler:

`etcdctl -o extended get POD6`{{execute}}

```
Key: /POD6
Created-Index: 100
Modified-Index: 100
TTL: 0
Index: 100

192.168.1.5:8081
```
-o extended ile, ilgili kayda ait detayli bilgiye erisebilmekteyiz.

---

Bunun haricinde, ilgili kaydın çıktısını json olarak da almamız mümkün, 

---

`curl  -L http://127.0.0.1:2379/v2/keys/POD1`{{execute}}

```
{"action":"get","node":{"key":"/POD5","value":"192.168.1.5:8080","modifiedIndex":95,"createdIndex":95}}
```
-o extended'den tek farkı, bilgilerı json formatında vermesidir.

---

Tek bir kaydın json çıktısına ulaşabildiğimiz gibi, tüm kayıtlara ait bilgileri de ayni sekilde json olarak ulaşabilmekteyiz.


---

`curl  -L http://127.0.0.1:2379/v2/keys/`{{execute}}

```
{"action":"get","node":{"dir":true,"nodes":[{"key":"/POD4","value":"192.168.1.3:88","modifiedIndex":94,"createdIndex":94},{"key":"/POD5","value":"192.168.1.5:8080","modifiedIndex":95,"createdIndex":95},{"key":"/POD6","value":"192.168.1.5:8081","modifiedIndex":100,"createdIndex":100},{"key":"/POD1","value":"192.168.1.2:80","modifiedIndex":91,"createdIndex":91},{"key":"/POD2","value":"192.168.1.2:88","modifiedIndex":92,"createdIndex":92},{"key":"/POD3","value":"192.168.1.3:80","modifiedIndex":93,"createdIndex":93}]}}
```

---

Mevcut kayıtların tamamını listelemek icin "ls" operatörünü kullanabiliriz:

---

`etcdctl ls / --recursive`{{execute}}

---

Herhangi bir anahtari silmek icin ise "rm" operatörünü kullanabiliriz: 

---

`etcdctl rm /POD6 --recursive`{{execute}}

---

Bir sonraki bölüme geçmeden önce, tüm kayıtlarımızı listeleyelim.
Gördüğünüz gibi daha önce oluşturmuş olduğumuz **POD7** yaşama zamanını tamamlamış ve aramızdan ayrılmıştır :).

---

`etcdctl ls --recursive`{{execute}}

#### ***etcd*** ile ilgili kısa bilgilendirme eğitimini burada tamamlamış bulunmaktayız. Bir sonraki bölümde küçük bir alistirma yapacagiz.