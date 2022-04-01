
**Bu bölümde, Job'un beşinci bölümünü işliyoruz.**

Hani dedik ya, görev başarıyla sonuçlanana kadar, kubernetes o görevi tekrar tekrar çalıştıracaktır, görevin tekrar çalıştırılmasından kast edilen, aynı görevi içeren yeni bir pod oluşturmaktır, sürekli yeni pod oluşturup kullanılamaması, cluster'da çöp yığını oluşturmak anlamına gelir. Bunun önüne geçmek için, Kubernetes'de Backofflimit kullanılmaktadır. BackoffLimit ile Kubernetes'e diyoruz ki, bu görev için hata töleransımız 2'dir, bu sayıya kadar görevi çalıştır, eğer bu sayıda hataya düşerse, artık bu görevi çalıştırma, yani yeni pod üretme demiş oluyoruz.   

İki farklı görev çalıştıracağız, birincisi backoffLimit'i olmadan hatalı çalışan bir görev olacak. ikinci görev ise, backoffLimit tanımlanmış aynı hatalı görev olacak, ikisi arasında ki farkı birlikte uygulayıp görelim.

Job5 [08-Job5.yml](./assets/08-Job5.yml) belgesinde görevin çalışmasını engelleyecek hatalı bir argüman ile çalıştıracak şekilde yapılandırılımş haldedir. 

`kubectl apply -f 08-Job5.yml`{{execute T1}}

```
NAME                    READY   STATUS              RESTARTS   AGE   IP              NODE          NOMINATED NODE   READINESS GATES
pod/dns-kontrol-4bc2m   0/1     Error               0          23s   172.16.225.21   kubeworker2   <none>           <none>
pod/dns-kontrol-f2xc4   0/1     Error               0          18s   172.16.90.27    kubeworker1   <none>           <none>
pod/dns-kontrol-g8288   0/1     Error               0          29s   172.16.90.26    kubeworker1   <none>           <none>
pod/dns-kontrol-kzc5c   0/1     ContainerCreating   0          5s    <none>          kubeworker1   <none>           <none>
pod/dns-kontrol-qwn27   0/1     Error               0          12s   172.16.90.28    kubeworker1   <none>           <none>
```
Gördüğünüz gibi, müdahale etmediğimiz sürece, Kubernetes bu görevi çalıştırmayı deneyecektir.

Bu görevi silip, yerine backoffLimit tanımlanmış olan bir görev daha çalıştırarak gözlemleyelim.

`kubectl delete jobs.batch dns-kontrol`{{execute T1}}

Job5 [08-Job5-1.yml](./assets/08-Job5-1.yml) belgesinde görevin çalışmasını engelleyecek hatalı argüman ve backoffLimit ile çalıştıracak şekilde yapılandırılımş haldedir. 

`kubectl apply -f 08-Job5-1.yml`{{execute T1}}

`kubectl describe job dns-kontrol | grep 'job-controller'`{{execute T1}}

```
Normal   SuccessfulCreate      28s   job-controller  Created pod: dns-kontrol-pgsxs
Normal   SuccessfulCreate      24s   job-controller  Created pod: dns-kontrol-8trjd
Normal   SuccessfulCreate      18s   job-controller  Created pod: dns-kontrol-928d8
Normal   SuccessfulCreate      13s   job-controller  Created pod: dns-kontrol-knfv2
Normal   SuccessfulCreate      7s    job-controller  Created pod: dns-kontrol-kdhkw
Warning  BackoffLimitExceeded  1s    job-controller  Job has reached the specified backoff limit
```

Oluşturduğumuz görevin backoffLimit'i dört idi, görev bu limite ulaşınca görevi durdurarak işlemi sonlandırdı. 

Job'un beşinci bölümünü burada tamamladık, bir sonraki adıma geçebiliriz.