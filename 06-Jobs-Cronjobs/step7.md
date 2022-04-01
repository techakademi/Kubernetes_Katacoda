
**Bu bölümde, Job'un yedinci bölümünü işliyoruz.**

___
***Şu an Kubernetes 1.18 sürümü çalışıyor bu platformda, o nedenden bu bölüm amacına yönelik sonucu üretmeyecektir. Yinede bölümü uygulamak istersiniz diye ekledim***
___

Tamamlanan görevlere genellikle, sistemde artık ihtiyaç duyulmaz. Kubernetes'de tamamlanmış görevleri tutmak, API sunucusunu gereksiz yere meşgul edeceğinden çok tercih edilmezler. Her görevi takip ederek elle temizlemek de neredeyse mümkün olmadığından, temizleme işlemini autoClean mekanizması kullanarak temizlemek gerekecektir. Kubernetes'de tamamlanmış veya tamamlanmamış görevleri temizlemenin yolu TTL kontrolü tarafından sunulan ttl mekanizmasını kullanmaktır, TTL, Time to Live, yaşama süresi diyebileceğimiz, bir sayaç veya zaman damgası kullanılarak öngörülen süre geçtikten sonra işlemin sonlandırılmasıdır. 

Bu özellik, 1.21 sürümünde beta halinde idi, 1.23'de stable olarak kullanılmaya başlandı, 
Kubernetes TTL kontrolörü, bir görevi kademeli olarak görev ile birlikte, o göreve ait pod'ları ve bağımlı diğer nesneleri de temizler.

Job7 [08-Job7.yml](./assets/08-Job7.yml) belgesinde görevin çalışması tamamlandıktan otuz saniye sonra silinmesi şekilde yapılandırılımş haldedir. 

Görev spesifikasyonuna,  ttlSecondsAfterFinished alanı eklenerek görev bitiminden sonra beklenecek süre ile birlikte tanımlanarak işlem gerçekleştirilir.
 
`kubectl apply -f 08-Job7.yml`{{execute T1}}

```
NAME                    READY   STATUS    RESTARTS   AGE   IP              NODE          NOMINATED NODE   READINESS GATES
pod/dns-kontrol-hdf8l   1/1     Running   0          5s    172.16.225.40   kubeworker2   <none>           <none>
```

`kubectl describe job dns-kontrol | grep 'job-controller'`{{execute T1}}

```
Normal  SuccessfulCreate  75s   job-controller  Created pod: dns-kontrol-tjxx7
Normal  Completed         8s    job-controller  Job completed
```
Bu görev için ***ttlSecondsAfterFinished: 30*** otuz saniye olarak tanımlamış idim, görev başarıklı bir şekilde tamamlanınca tanımlanan süre geçtikten sonra kendiliğinden silinmiş oldu.

Görevi elle silmek istediğimizde, aşağıda ki hata ile karşılaşacağız.

`kubectl delete -f 08-Job5-1.yml`{{execute T1}}

```
Error from server (NotFound): error when deleting "08-Job5-1.yml": jobs.batch "dns-kontrol" not found
```
Job'un yedinci bölümünü burada tamamladık, bir sonraki adıma geçebiliriz.