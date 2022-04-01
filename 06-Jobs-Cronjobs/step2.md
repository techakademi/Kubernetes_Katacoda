
**Bu bölümde, Job'un ikinci bölümünü işliyoruz.**

Job pod'ları, replicaset'de olguğu gibi, job çalıştığı sürece ona bağlı podları sürekli kontrol eder, pod'un silinmesi durumunda yerine yenisini oluşturacaktır.

Yeni [08-Job2.yml](./assets/08-Job2.yml) ile yeni job oluşturup podunu silerek bu durumu uygulayalım.

`kubectl apply -f 08-Job2.yml`{{execute T1}}

**Listede çalışan pod'unuzun adını girmeyi unutmayın lütfen** 

**Job'a bağlı pod çalışırken silinirse yerine yenisini oluşturacaktır, görevi tamamlanmış pod silindiğinde hemn yerine yenisini oluşturmayacaktır** 
```
kubectl delete pod dns-kontrol
```
***Bu komutun sonucunu Terminal 2'den gözlemleyebilirisin.***
```
NAME                    READY   STATUS              
pod/dns-kontrol-4dbjx   1/1     Terminating         
pod/dns-kontrol-4n2bf   0/1     ContainerCreating
```

Job'a bağlı pod'u silerken diğer taraftan ise aynı job'a bağlı yeni bir pod oluşturup job'un çalışabilirliğini sağlamış oluyor.

Job'un ikinci bölümünü burada tamamladık, bir sonraki adıma geçebiliriz.