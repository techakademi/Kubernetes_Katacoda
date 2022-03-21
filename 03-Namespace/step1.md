### Bu bölümde, Namespace konusunu işleyeceğiz.
___
Kubernetes'de aynı adı kullanarak, pod, deployment, servis oluşturamayız. Her bir elemanın farklı adı olmak zorundadır.

Cluster'i Namespace'lere bölerek aynı adlar ile pod, deployment, service elemanlarını farklı namespace'lerde aynı adlar ile kullanabilmekteyiz.

Namespace, Cluster için sanal clusterlar oluşturmamızı sağlamaktadır.

Bu bölümde, sırasıya aşağıda ki listelenmiş olan konuları uygulayacağız.

___
#### <u>___1. Cluster bilgilerini görüntüleme:___</u>

Halihazırda çalışan cluster'ımız hakkında bilgi edinmek için ***kubectl cluster-info*** komutunu kullanarak görüntüleyebiliriz.

`kubectl cluster-info`{{execute}}

```
Kubernetes control plane is running at https://192.168.1.73:6443
CoreDNS is running at https://192.168.1.73:6443/api/v1/namespaces/kube-system/services/kube-dns:dns/proxy

To further debug and diagnose cluster problems, use 'kubectl cluster-info dump'.
```

#### <u>___Node'larımız hakkında bilgi edinme:___</u>

`kubectl get nodes`{{execute}}

```
NAME          STATUS   ROLES                  AGE     VERSION
kubemaster    Ready    control-plane,master   4d18h   v1.23.1
kubeworker1   Ready    <none>                 4d18h   v1.23.1
kubeworker2   Ready    <none>                 4d18h   v1.23.1
```

Namespace, cluster işlevlerine dahil olan bir işlemdir, bu sebeple önce cluster hakkında snora da node'lar hakkında bilgi edinerek cluster'ımızın ve Node'larımızın çalışır durumda olduklarını belirlemiş olduk.

#### <u>___2. Cluster'da var olan namespace'leri listeleme:___</u>

Kubernetes'de varsayılan namespace'leri listelemek için ***kubectl get namespaces*** veya "ns" şeklinde kısa ad komutunu kullanarak listeleyebiliriz.

`kubectl get namespaces`{{execute}}

```
NAME              STATUS   AGE
default           Active   4d16h
kube-node-lease   Active   4d16h
kube-public       Active   4d16h
kube-system       Active   4d16h
```
Default namespace, kubernetes'in varsayılan namespace olup, tüm oluşturulan kaynaklar bu namespace içinde var edilirler.

Kube-system namespace'i cluster kaynaklarının var edildiği namespace'dir.

kube-node-lease namespace:
Bu namespace, her node’a ilişkin lease’leri tutar. Bilişim kavramı olarak Lease, belirli kaynakların sınırlı bir süre ile belirli hakların verildiği bir sözleşme gibidir, DHCP’yi buna örnek alabiliriz, ilgili sunucu IP havuzunda ki her IP’yi kiraya verir ta ki, o IP’yi kullanan cihazın genellikle restart edilmesi halinde o ip’yi bırakması veya kiraya verme süresi bittiğinde tekrar sürenin uzatılması gibi.
Node’ leaseleri, kubelet’in nodelar’ın durumlarını kontrol etmek için hearthbeat sinyalleri göndererek olası arızalarını algılamasını sağlar.

kube-public:
Bu namespace, belirli kaynakların tüm clusterda genel olarak görünür ve okunabilir olması için tasarlanmıştır ve çoğunlukla cluster kullanımı için ayrılmıştır.

cluster'da henüz herhangi bir obje oluşturmadığımız için  ***kubectl get pods*** ile podları listelemek istediğimizde, varsayılan namespace'de herhangi bir kaynak bulunamadı mesajını döndürecektir.

`kubectl get pods`{{execute}}

```
No resources found in default namespace.
```

Varsayılan namespace haricinde system namespace'ini ***kubectl -n kube-system get pods*** ile kontrol ettiğimizde ise

`kubectl -n kube-system get pods`{{execute}}

```
NAME                                       READY   STATUS    RESTARTS      AGE
calico-kube-controllers-647d84984b-pwrr8   1/1     Running   7 (36m ago)   4d16h
calico-node-brrdj                          1/1     Running   4 (38m ago)   4d16h
calico-node-q6dpl                          1/1     Running   7 (42m ago)   4d16h
calico-node-vm6f2                          1/1     Running   4 (38m ago)   4d16h
coredns-64897985d-2hsd6                    1/1     Running   4 (42m ago)   4d16h
coredns-64897985d-cbxsn                    1/1     Running   4 (42m ago)   4d16h
etcd-kubemaster                            1/1     Running   4 (42m ago)   4d16h
kube-apiserver-kubemaster                  1/1     Running   4 (42m ago)   4d16h
kube-controller-manager-kubemaster         1/1     Running   8 (42m ago)   4d16h
kube-proxy-7jq9v                           1/1     Running   4 (38m ago)   4d16h
kube-proxy-jb9xt                           1/1     Running   4 (38m ago)   4d16h
kube-proxy-tj7sm                           1/1     Running   4 (42m ago)   4d16h
kube-scheduler-kubemaster                  1/1     Running   8 (42m ago)   4d16h
```

Cluster'in yaşaması için gerekli olan podların çalıştığını görüntüleyebiliriz.

___
#### <u>___3. Yeni bir namespace oluşturma:___</u>

İhtiyacımız doğrultusunda yeni bir namespace oluşturalım, adını da **"nsders"** koyalım.

`kubectl create namespace nsders`{{execute}}

```
namespace/nsders created
```

Namespace'leri listeleyerek kontrolümüzü gerçekleştirelim.

`kubectl get ns`{{execute}}

```
default           Active   42s
kube-node-lease   Active   44s
kube-public       Active   44s
kube-system       Active   44s
nsders            Active   36s
```
Namespace'imizi oluşturmuş olmamıza rağmen, henüz kubernetes'de oluşturacağımız herhangi bir pod halen daha varsayılan namespace'de oluşturulacaktır.nsders namespace'imizde bir obje oluşturmak için önce o namespace'e geçiş yapmamız gerekecektir. Herhangi bir namespace geçiş yapmadan önce de o namespace'de obje oluşturabiliriz.

Nsders namespace'imizde çalışacak yeni bir pod oluşturalım.

`kubectl run merhaba --image=techakademi/merhabadunya:1  -n nsders`{{execute}}

```
pod/merhaba created
```

Nsders Namespace'indeki podları listeleyelim.

`kubectl get pods -n nsders`{{execute}}
```
NAME      READY   STATUS    RESTARTS   AGE
merhaba   1/1     Running   0          7s
```

Diyelim ki aynı cluster'da birden fazla ekip ve birden fazla proje çalıştırıyoruz, böyle bir yapıda her proje için bir namespace, o namespace altında çalışabilecek kullanıcılar oluşturabiliriz.
Tüm kullanıcıların hangi namespace altına çalışabileceklerine dair kurallar atayabiliriz, veya diyebilriz ki her kullanıcı her proje namespace'ine erişebilsin. Bu stratejiler tamamen proje ve o proje için ne kadar insan kaynağının olduğuyla ilişkili olacaktır.

Şimdilik nsders'de bulunan pod'umuzu silelim:

`kubectl delete pod merhaba -n nsders`{{execute}}

___
#### <u>___4. Mevcut context'leri listeleyeceğiz:___</u>
Namespace değiştirme işlemimize geçmeden önce, kubernetes'in cluster bilgilerine bir göz atalım. Kubernetes cluster konfigurasyon bilgilerini .kube klasörü altına bulunan "***~/.kube/config*** belgesinin içerisinde bulundurmaktadır.

Mevcut konfigurasyonu görüntülemek için ***kubectl config view*** komutunun kullanarak görüntüleyebiliriz.

`kubectl config view`{{execute}}

---
```
apiVersion: v1                                  
clusters:										 							
- cluster:	                                     
    certificate-authority-data: DATA+OMITTED    
    server: https://172.17.0.34:6443             
  name: kubernetes								 		
contexts:										 		
- context:										 		
    cluster: kubernetes                          
    user: kubernetes-admin								
  name: kubernetes-admin@kubernetes						
current-context: kubernetes-admin@kubernetes   
kind: Config                                   
preferences: {}                                
users:													
- name: kubernetes-admin                         
  user:                                        
    client-certificate-data: REDACTED              
    client-key-data: REDACTED                  
```

Konfigurasyon belgesi kaç adet cluster olduğunu, cluster'ların adlarını, o cluster'a bağlı context'leri hangi kullanıcıların var olduğunu, varsayılan context'in hangisi olduğu bilgilerini bardındıran kubernetes'in config belgesidir.

Clusterda aktif kullanılan context'i görüntülemek için:

`kubectl config get-contexts`{{execute}}

CURRENT   NAME                          CLUSTER      AUTHINFO           NAMESPACE
*         kubernetes-admin@kubernetes   kubernetes   kubernetes-admin

Şu an bir adet konfigurasyonumuzun olduğunu görebilmekteyiz, **"nsders"** namespace'imizi bir context'e bağlayıp kullanmak için yeni bir context oluşturacağız.

Yeni context oluşturma komutunu şu şekilde kullanacağız:

`kubectl config set-context kubensders --namespace=nsders --user=kubernetes-admin --cluster=kubernetes`{{execute}}

```
Context "kubensders" created.
```

Context'lerimizi tekrar listelemek için:

`kubectl config get-contexts`{{execute}}

CURRENT   NAME                          CLUSTER      AUTHINFO           NAMESPACE
          kubensders                    kubernetes   kubernetes-admin   nsders
*         kubernetes-admin@kubernetes   kubernetes   kubernetes-admin

Yeni oluşturduğumuz context'imiz mevcut config belgesine eklenmiş durumda olacaktır. Tekrar bir kontrol edip sonucunu gözlemleyelim.


`kubectl config view`{{execute}}

```
apiVersion: v1
clusters:
- cluster:
    certificate-authority-data: DATA+OMITTED
    server: https://172.17.0.67:6443
  name: kubernetes
contexts:
- context:
    cluster: kubernetes
    namespace: nsders
    user: kubernetes-admin
  name: kubensders
- context:
    cluster: kubernetes
    user: kubernetes-admin
  name: kubernetes-admin@kubernetes
current-context: kubernetes-admin@kubernetes
kind: Config                                   
preferences: {}                                
users:													
- name: kubernetes-admin                         
  user:                                        
    client-certificate-data: REDACTED              
    client-key-data: REDACTED
```

kubensders context'imiz başarılı bir şekilde oluşmuş durumda, ***kubectl config use-context*** komutu ile kubensders contextimizi kullanmaya başlayabiliriz.

`kubectl config use-context kubensders`{{execute}}

```
Switched to context "kubensders".
```

Nsders namespace'inde çalışan podları listeleyelim.

`kubectl get pods`{{execute}}

```
NAME      READY   STATUS    RESTARTS   AGE
merhaba   1/1     Running   0          2m36s
```

Nsders namespace'imizde podumuz çalışırken, varsayılan namespace'i tekrar kontrol edelim.

`kubectl config use-context kubernetes-admin@kubernetes`{{execute}}

```
Context "kubernetes-admin@kubernetes" modified.
```
`kubectl get pods`{{execute}}

```
No resources found in default namespace.
```
Tekrar nsders'de bulunan pod'umuzu silelim:

`kubectl delete pod merhaba -n nsders`{{execute}}

___
#### <u>___5. Farklı namespace'lerde aynı uygulamayı aynı ad ile çalıştırma.:___</u>

Her seferinde, ***kubectl config use-context*** komutunu uzun uzun yazmak yerine bir alias oluşturup kısa kod kullanarak uygulayabiliriz.

1. Uygulamada olan context'i görüntülemek için **"mevcutcont"** adında bir alias oluşturalım.

`alias mevcutcont='kubectl config current-context'`{{execute}}

2. Kullanmak istediğimiz context'i değiştirmek için **"contdegistir"** adında bir alias oluşturalım.

`alias contdegistir='kubectl config use-context'`{{execute}}

`mevcutcont`{{execute}}

`contdegistir kubensders`{{execute}}

`kubectl run merhaba --image=techakademi/merhabadunya:1 `{{execute}}

`contdegistir kubernetes-admin@kubernetes`{{execute}}

`kubectl run merhaba --image=techakademi/merhabadunya:1 `{{execute}}

Şu an her iki namespace'de aynı isimle aynı uygulamayı çalıştırmış durumdayız, her iki namespace'de çalışan podları listeleyip kontrol edelim.

Varsayılan namespace'de çalışan podları listeleyelim.

`kubectl get pods `{{execute}}

```
NAME      READY   STATUS    RESTARTS   AGE
merhaba   1/1     Running   0          6m32s
```

Nsders namespace'inde çalışan podları listeleyelim.

`kubectl -n nsders get pods `{{execute}}

```
NAME      READY   STATUS    RESTARTS   AGE
merhaba   1/1     Running   0          6m32s
```
___
Namespace'ler uyguladığımızdan daha farklı olarak, oluşturulan namespace'lere kaynak kullanımlarının tanımlanarak farklı amaçlar için kullanılabilmektedir.Namespace bölümünüde burada tamamlamış olduk arkadaşlar.
