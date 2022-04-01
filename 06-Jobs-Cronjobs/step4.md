
**Bu bölümde, Job'un dördüncü bölümünü işliyoruz.**

Paralelism, bir görevin eş zamanlı kaç adet çalışmasını istendiğinin belirtilmesidir, tekil görev çalıştırıldığında aksi belirtilmediği sürece, hangi node üzerinde çalışacağına kubernetes karar verecektir. Diyelim ki, tüm cluster'daki node'lar üzerinde aynı anda çalışmasına ihtiyacımız olan bir görevimiz var, bu durumda paralelizm kullanılması ile görev aynı anda eş zamanlı olarak tüm node'larda çalışacaktır.

Job4 [08-Job4.yml](./assets/08-Job4.yml) belgesinde aynı görevi paralel çalıştıracak şekilde yapılandırılımş haldedir. 

`kubectl apply -f 08-Job4.yml`{{execute T1}}

```
NAME                    READY   STATUS              RESTARTS   AGE   IP       NODE          NOMINATED NODE   READINESS GATES
pod/dns-kontrol-8pxvn   0/1     ContainerCreating   0          2s    <none>   kubeworker1   <none>           <none>
pod/dns-kontrol-t4sbx   0/1     ContainerCreating   0          3s    <none>   kubeworker2   <none>           <none>
```
Görevi çalıştırmak için farklı node'lar üzerinde iki adet pod oluşturup, çalıştımasını tamamladı.

Job'un dördüncü bölümünü burada tamamladık, bir sonraki adıma geçebiliriz.