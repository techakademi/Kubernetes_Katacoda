
**Bu bölümde, Job'un altıncı bölümünü işliyoruz.**


Bir görevin çalışma süresinden daha uzun süre çalışıyor olması halinde, Kubernetes görevi kendiliğinden durudurmasının talimatını tanımlamak. Diyelimki, çalıştırdığımız görev herşey yolunda giderse, bir dakika sürdüğünü biliyoruz. Eğer görev, bu süreden daha uzun bir zaman çalışıyorsa, bu durumun normal olmadığınıda biliyoruz. Bir görevin olması gerekenden daha uzun çalışması beklenmedik sonuçlar doğuracaktır. Bu sonuçlarla karşılaşmamak için aktiveDeadlineSecons tanımlamak işlerin kontrolden çıkmasının önünü alacaktır.


Job6 [08-Job5.yml](./assets/08-Job6.yml) belgesinde görevin çalışma süresinin onbeş saniye ile sınırlandırılmış şekilde yapılandırılımş haldedir. 

`kubectl apply -f 08-Job6.yml`{{execute T1}}

```
NAME                    READY   STATUS        RESTARTS   AGE   IP              NODE          NOMINATED NODE   READINESS GATES
pod/dns-kontrol-mthnt   0/1     Error         0          15s   172.16.90.60    kubeworker1   <none>           <none>
pod/dns-kontrol-pwls7   1/1     Terminating   0          7s    172.16.225.43   kubeworker2   <none>           <none>
```

Görevin detayını inceleyerek neler olduğunu görmeye çalışalım:

`kubectl describe job dns-kontrol | grep 'job-controller'`{{execute T1}}

```
Normal   SuccessfulCreate  32s   job-controller  Created pod: dns-kontrol-mthnt
Normal   SuccessfulCreate  24s   job-controller  Created pod: dns-kontrol-pwls7
Normal   SuccessfulDelete  17s   job-controller  Deleted pod: dns-kontrol-pwls7
Warning  DeadlineExceeded  17s   job-controller  Job was active longer than specified deadline
```
Görev normal bir şekilde başlayıp, pod'larını oluşturup çalışmaya başlamış, ancak tanımlanan süreden daha uzun sürdüğü için görevi durdurmuş. Görev içinde çalışmasını istediğimiz uyglumaya altmış saniye beklemesi talimatını vermiş idim, deadline bekleme süresini ise onbeş saniye ile sınırlandırmıştım, bu sebepten uygulama daha başlayıp işini yapamadan görev durdurulmuş oldu.

Job'un altıncı bölümünü burada tamamladık, bir sonraki adıma geçebiliriz.