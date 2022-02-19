## MySQL Uygulama adımları

MySQL'i çalışabilir hale getirmek için ihtiyacımız olan  üç aşama var:

1.Adım, Secret oluşturmak.

1.1 MySQL root parolası kodlamak  

`echo -n '!P@ssw0rd01!' | base64`{{execute T1}}

```bash
IVBAc3N3MHJkMDEh
```

1.2 MySQL Wordrpess site parolası kodlamak:

`echo -n '!DBP@r0la01!' | base64`{{execute T1}}

```bash
IURCUEByMGxhMDEh
```

1.3 MySQL, secret manifest'ini oluşturmak.

## 1.Adım, Aşğıdaki manifesti kopyalayıp nano editörüne Shift+Insert ile yapıştıralım

### 2. Adım, ctr+o belgeyi kayıt edelim

#### 3. Adım, ctr+x ile nano'dan çıkalım

`sudo nano 00-Mysql-Secret.yml`{{execute T1}}

```yaml
apiVersion: v1
kind: Secret
metadata:
    name: wrprss-mysql
data:
    mysql-root-password: IVBAc3N3MHJkMDEh
    mysql-password: IURCUEByMGxhMDEh
stringData:
    mysql-username: dbroot
```

1.4 Secret'i kullanılmak üzere uygulayalım.

`kubectl apply -f 00-Mysql-Secret.yml`{{execute T1}}

```bash
secret/wrprss-mysql created
```

1.5 MySQL için configmap oluşturmak, MySQL 8.x sürümüne kadar varsayılan kimlik doğrulama eklentisi olarak  ***"mysql_native_password"*** eklentisini kullanıyordu. MySQL 8.0 ile birlikte, bu eklentiyi  ***"caching_sha2_password"*** ile varsayılan olarak değiştirdiler. Bu değişiklik ile daha güvenli parola şifrelemesi çözümünü sağladıklarını, bununla kalmayıp parola şifreleme yönteminde hatırı sayılır performans sağladıklarını ayrıca beyan ettiler.  Bu şu anlama geliyor, MySQL sunucusuna bağlanacak tüm client'ların hangi kimlik doğrulama eklentisini kullanacaklarını bildirmesi gerekmekte, aksi takdirde sunucu varsayılan olarak ***"caching_sha2_password"*** eklentisini kullanacağını varsaymakta. Bu durumda ne yazık ki bir çok istemcinin bağlantı sorunununa neden oluyor. MySQL çözüm olarak varsayılan kimlik doğrulama eklentisini MySQL konfigurasyonunda tanımlanması ile bağlantı sorununu çözebileceğimizi yazmakta. Şimdi biz de, bu sorunu gidermek için bir configmap oluşturup onun içerisinie varsayılan değeri ekleyip kullanacağız.

## 1. Adım, Aşğıdaki manifesti kopyalayıp nano editörüne Shift+Insert ile yapıştıralım

### 2. Adım, ctrl+o belgeyi kayıt edelim

#### 3. Adım, ctrl+x ile nano'dan çıkalım

`sudo nano 01-Mysql-Configmap.yml`{{execute T1}}

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: mysql-config
  labels:
    app: mysql
data:
  default_auth.cnf: |
    [mysqld]
    default_authentication_plugin=mysql_native_password
```

1.6 Configmap'i kullanılmak üzere uygulayalım.

`kubectl apply -f 01-Mysql-Configmap.yml`{{execute T1}}

```bash
configmap/mysql-config created
```

1.7 Persistent Volume & Clime'ını oluşturmak

Mysql'in kullanacağı veribirimi için [02-Mysql-Pv-Pvc.yml](./assets/02-Mysql-Pv-Pvc.yml) belgesinde veribirimi ile birlikte clime'ın birlikte kullanılabilecek şekilde manifestimiz hazır.

Veribirimini oluşturacak Manifestimizi çalıştıralım.

`kubectl apply -f 02-Mysql-Pv-Pvc.yml`{{execute T1}}

```bash
persistentvolume/mysql-pv created
persistentvolumeclaim/mysql-pv-claim created
```

1.8 MySQL Deploymentini yayınlama

Mysql Deployment'i için [03-Mysql-Deployment.yml](./assets/03-Mysql-Deployment.yml) belgesinde kullanılabilecek şekilde manifestimiz hazır.

MySQL Podumuzu oluşturacak Manifestimizi çalıştıralım.

`kubectl apply -f 03-Mysql-Deployment.yml`{{execute T1}}

```bash
deployment.apps/mysql created
```

1.9 MySQL Servisini oluşturmak

Mysql Servisini [04-Mysql-Service.yml](./assets/04-Mysql-Service.yml) belgesinde kullanılabilecek şekilde manifestimiz hazır.

MySQL Servisimizi oluşturacak Manifestimizi çalıştıralım.

`kubectl apply -f 04-Mysql-Service.yml`{{execute T1}}

```bash
service/mysql-service created
```

1.10 MySQL sunucunun sağlıklı çalıştığını kontrol etmek için, mysql-client podu oluşturup kontrol yapalım.

Mysql Sunucusuna bağlanmak için kullanacağımız client [05-Mysql-Client.yml](./assets/05-Mysql-Client.yml) belgesinde  şekilde kullanılmak üzere manifestimiz hazır.

MySQL Client Podunu oluşturacak Manifestimizi çalıştıralım.

`kubectl apply -f 05-Mysql-Client.yml`{{execute T1}}

```bash
pod/mysql-client created
```

1.11 Mysql Sunucuuna erişmek için ***kubectl exec*** komutu ile mysql-client podumuza erişelim.

`kubectl exec -it mysql-client -- ash`{{execute T1}}

```ash
/ #
```

Mysql-client podumuzun terminal arayüzünden mysql ile mysql-service üzerinden suncumuza erişmek için aşağıda ki komutu kullanalım.

`mysql -h mysql-service -u root -p`{{execute T1}}

Parola ekranında, **"mysql-root-password"** için oluşturduğumuz parolayı girelim. **Not: ***"Parola"*** parola oluşturma bölümünde :)**

```bash
Enter password:
```

Parolayı doğru girmiş iseniz aşağıdaki gibi mysql ekranı karşılayacaktır sizi.

```bash
Welcome to the MariaDB monitor.  Commands end with ; or \g.
Your MySQL connection id is 9
Server version: 8.0.28 MySQL Community Server - GPL

Copyright (c) 2000, 2018, Oracle, MariaDB Corporation Ab and others.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

MySQL [(none)]>
```

Mysql terminalinde, mevcut veritabanlarını listelemek için ***show databases*** komutunu kullanarak listeleyelim.

`show databases;`{{execute T1}}

```bash
+--------------------+
| Database           |
+--------------------+
| information_schema |
| mysql              |
| performance_schema |
| sys                |
| kubeblog          |
+--------------------+
5 rows in set (0.002 sec)
```

Mysql sunucumuzda bulunan tüm veritabanlarını listelyecektir.
Kontrol işlemimizi bu şekilde tamamalayalım, önce mysql'den çıkalım. Sonrasında ise pod'dan çıkış yapalım.

Mysql'den çıkış için kullanacağımız komutumuz:

`exit;`{{execute T1}}

Mysql Pod'umuzdan çıkış için kullanacağımız komutumuz:

`exit;`{{execute T1}}

MySQL Client Podunu imha ederek gereksiz kaynak kullanımının önüne geçelim.

`kubectl delete -f 05-Mysql-Client.yml`{{execute T1}}

```bash
pod "mysql-client" deleted
```

Bir sonraki bölüme geçerek Wordpress işlemlerimize başlayalım.
