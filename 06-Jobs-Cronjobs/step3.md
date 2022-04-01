
**Bu bölümde, Job'un üçüncü bölümünü işliyoruz.**

Görev tekrarlama sayısı, bir görevin kaç sefer çalışmasını istediğimize göre, görev çalıştırma sayısını belirtebiliriz.
Bir görevin kaç sefer çalışacağını, görev spesifikasyonunda tanımlayarak belirtiyoruz. Completion, paralel olarak çalışmaz, belirtilen sayıda görevi sırası ile birbiri ardına çalıştırır, biten görevin sonrasında aynı görevi tekrar çalıştırır.

Job3 [08-Job3.yml](./assets/08-Job3.yml) belgesinde aynı görevi sırasıyla iki sefer olarak çalıştıracak şekilde yapılandırılımş haldedir. 

`kubectl apply -f 08-Job3.yml`{{execute T1}}

```
NAME                    READY   STATUS      RESTARTS   AGE   
pod/dns-kontrol-ln7ts   0/1     Completed   0          22s   
pod/dns-kontrol-ql7js   1/1     Running     0          11s   
```

Bu uygulamamızda, önce bir görev çalıştırdı, sonrasında ise aynı görevi tekrar çalıştırarak tanımlamış olduğumuz adet'de görevi yerine getirmiş oldu.

`kubectl describe job dns-kontrol | grep 'job-controller'`{{execute T1}}

Job'un üçüncü bölümünü burada tamamladık, bir sonraki adıma geçebiliriz.