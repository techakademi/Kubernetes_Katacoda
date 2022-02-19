## MySQL & Wordpress Yedekleme Aşaması

Her iki uygulamanın verilerinin düzenli bir şekilde yedeklenmesi gerekmektedir. MySQL'in veritabanı yedeğinin alınması ile birlikte, Wordpress'in de ayrıca yedeğinin alınmasında fayda var.

Elbette Wordpress'in kendi içinde bir takım eklentiler ile düzenli bir şekilde yedeğinin alınması sözkonsudur, ancak bizim amacımız bu işlemleri Kubernetes ile gerçekleştirmek olacaktır.

Yedekleme Süreci için, Kubernetes'in Cronjob özelliğini kullanacağız. Her iki uygulama için birer CronJob manifesti oluşturup uygulamaya alacağız.

Uygulamaların aktif olarak çalıştıkları süreç içerisinde kullandıkları veribirimlerine ilave olarak yedeklerin konulacağı ikinci veribirimleri oluşturacağız, sonrasında CronJob manifestlerimizde ilgili veribirimlerini ikinci veribirimi olarak kullanarak, yedeklerin o veribirimlerinde saklanmalarını sağlayacağız.

Uygulama adımlarına başlamadan önce, CronJOB Gözlem ekranı oluşturalım:

`Yeni terminal ekranı aç.`{{execute T4}}

Terminalde aşağıda ki komutu çalıştır:
`watch kubectl get cronjobs`{{execute T4}}

1.Adım, MySQL için Yeni veribirimi oluşturmak.

MySQL yedekleri için [10-Mysql-Backup-Pv-Pvc.yml](./assets/10-Mysql-Backup-Pv-Pvc.yml) belgesinde kullanılabilecek şekilde manifestimiz hazır.

MySQL veribirimini oluşturacak Manifestimizi çalıştıralım.

`kubectl apply -f 10-Mysql-Backup-Pv-Pvc.yml`{{execute T1}}

```bash
persistentvolume/mysql-yedek-pv created
persistentvolumeclaim/mysql-yedek-pv-claim created
```

2.Adım, MySQL yedeklerini alacak CronJOB manifestini oluşturmak.

MySQL yedeklerini düzenli bir şekilde almak için [11-Mysql-Backup.yml](./assets/11-Mysql-Backup.yml) belgesinde kullanılabilecek şekilde manifestimiz hazır.

MySQL yedeklerini alacak Podumuz için Manifestimizi çalıştıralım.

`kubectl apply -f 11-Mysql-Backup.yml`{{execute T1}}

```bash
cronjob.batch/mysql-yedekleme created
```

3.Adım, WordpressL için Yeni veribirimi oluşturmak.

Wordpress yedekleri için [12-Wrprss-Backup-Pv-Pvc.yml](./assets/12-Wrprss-Backup-Pv-Pvc.yml) belgesinde kullanılabilecek şekilde manifestimiz hazır.

Wordpress veribirimini oluşturacak Manifestimizi çalıştıralım.

`kubectl apply -f 12-Wrprss-Backup-Pv-Pvc.yml`{{execute T1}}

```bash
persistentvolume/wrprss-yedek-pv created
persistentvolumeclaim/wrprss-yedek-pv-claim created
```

4.Adım, Wordpress yedeklerini alacak CronJOB manifestini oluşturmak.

Wordpress yedeklerini düzenli bir şekilde almak için [13-Wrprss-Backup.yml](./assets/13-Wrprss-Backup.yml.yml) belgesinde kullanılabilecek şekilde manifestimiz hazır.

MySQL yedeklerini alacak Podumuz için Manifestimizi çalıştıralım.

`kubectl apply -f 13-Wrprss-Backup.yml`{{execute T1}}

```bash
cronjob.batch/wordpress-yedekleme created
```

CronJob Gözlem ekranımız kontrol ettiğimizde, her iki cronjob'umuzun oluştuğunu teyit edebiliriz.

```bash
NAME                  SCHEDULE      SUSPEND   ACTIVE   LAST SCHEDULE   AGE
mysql-yedekleme       */1 * * * *   False     1        2s              5m41s
wordpress-yedekleme   */3 * * * *   False     0        <none>          39s
```

CronJob'larımızın başarılı bir şekilde çalışmaları halinde, veribirimlerinde oluşturduğumuz dizinlerin altını kontrol ettiğimizde, yedeklerimizin orada var olduklarını gözlemleyebiliriz.

5.Adım, Yedek klasörüne gidelim.

`cd yedek`{{execute T1}}

```bash
/yedek$
```

6.Adım, Yedek klasörünün içeriğini listeleyelim.

`ls`{{execute T1}}

```bash
mysql  wrprss
```

7.Adım, MySQL klasörüne gidelim.

`cd mysql`{{execute T1}}

8.Adım, klasörünün içeriğini listeleyelim.

`ls -la`{{execute T1}}

```bash
total 16
drwxr-xr-x 2 root root 4096 Feb 19 09:04 .
drwxr-xr-x 4 root root 4096 Feb 19 09:12 ..
-rw-r--r-- 1 root root 1267 Feb 19 09:23 kubeblog_19022022.sql
-rw-r--r-- 1 root root   20 Feb 19 09:03 kubeblog_19022022.sql.gz
```

9.Adım, Wordpress klasörünün içeriğini listeleyelim.

`ls -la /yedek/wrprss/`{{execute T1}}

```bash
total 19424
drwxr-xr-x 2 root root     4096 Feb 19 09:12 .
drwxr-xr-x 4 root root     4096 Feb 19 09:12 ..
-rw-r--r-- 1 root root 19878863 Feb 19 09:24 wordpress_19-02-22.tar.gz
```

Yedekleme sitemimiz başarılı bir şekilde çalışmış, ilgili uygulamaların yedeklerini alarak veribirimleri altında konumlandırmıştır.
