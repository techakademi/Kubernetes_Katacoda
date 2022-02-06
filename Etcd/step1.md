----------------------------------------------------------------------
## Etcd'ye Giris
----------------------------------------------------------------------
### Bu eğitim bölümünde, version 3.2 kullanıldığından, şu anki versiyonlar ile komutlar aynı olmayabilir, bu bölümün amacı ***etcd*** egitimi olmayip, ***etcd*** hakkında kısa bir bilgilendirme den ibarettir.

---

**[etcd](https://etcd.io/)**, herhangi bir zaman noktasında clusterın  genel durumunu temsil eden, cluster yapılandırma verilerini güvenilir bir şekilde depolayan, CoreOS tarafından geliştirilmiş kalıcı, yüksek düzeyde kullanılabilir anahtar-değer ( key-value store) deposudur.

---

### 1. Bölüm Etcd Kurulumunda, Sırası ile uygulayacağımız adımlar:

Kurulum öncesi, mevcut ortamda yüklü olan ***etcd***'nin versiyonunu kontrol edelim:


`etcd --version`{{execute}}

Version kontrolü sonucu ekranda aşağıda ki gibi **'etcd'** bulunamadı yüklemek isterseniz 
**"apt install etcd-server"** komutunu kullanabilirsiniz şeklinde yazı belirecektir.

Bu komut çıktısı, şu an bu sunucuda etcd'nin yüklü olmadığını belirtmektedir. 

```
$ etcd --version

Command 'etcd' not found, but can be installed with:

apt install etcd-server
```

**etcd** kurulumunu gerçekleştirmek için aşağıdaki komutu kullanalım:

`apt install etcd -y `{{execute}}

Mevcut ekranı temizleyelim.

`clear `{{execute}}

Kurulumun tamamlanmasının ardından tekrar version kontrolünü gerçekleştirelim.

`etcd --version `{{execute}}

Kontrolün sonucu, aşağıda ki gibi ekran çıktısı oluşacaktır.
```
etcd --version
etcd Version: 3.2.26
Git SHA: Not provided (use ./build instead of go build)
Go Version: go1.13.7
Go OS/Arch: linux/amd64
```

Bu sonuç ile, **etcd** kurulumunun başarılı bir şekilde gerçekleştiğini teyit edebiliriz.

Mevcut ekranı tekrar temizleyelim.

`clear `{{execute}}