**XMN Motion Coin Masternode Nasıl Kurulur?**

-------

### Preparation

Motion Coin geliştirdiği yazılımı sayesinde klasik Masternode kurulumu devrini geride bırakıyor. Yatırımcıları için kolaylık sağlamak 
adına özenle hazırlanmış Masternode kurulum script’i sayesinde dakikalar içerisinde hiçbir ön deneyim gerektirmeden bir Masternode 
kurulumu gerçekleştiriliyor. 
Kurulum yapılmadan önce Motion cüzdanınızda tam olarak 1000 XMN teminat olarak bulunması gerekiyor. Bu koinler cüzdanınızda bulunduğu 
sürece Masternode’unuz aktif kalıp karşılığında pasif bir getiri sağlayacak.

**Hazırlık**
-Öncelikle bir VPS server kiralamanız gerekiyor. (Yabancı  veya yerli)
-Önerilen VPS boyutu: 2GB RAM (daha az ise sorun değil swap memory yapılabilir)
-VPS işletim sistemi Ubuntu 16.04 (Xenial) olmalı (zorunlu)
-Cüzdanınıza tam 1000 XMN gönderilmiş olmalı (eğer parça parça geldiyse o zaman kendi adresinize 1000 XMN yollamanız gerekiyor)
-Lokal cüzdandaki(bilgisayarınızdaki) motion.conf dosyası boş olmalı (eğer daha önce bu dosyaya hiç dokunmadıysanız boştur)
-VPS cüzdanındaki masternode.conf dosyası boş olmalı (eğer daha önce bu dosyaya hiç dokunmadıysanız boştur)

**Önemli Notlar:** 
Her Masternode için ayrı bir IP adresinde ihtiyacınız var

Masternode Status’unda “Pre-enabled” yazması sorun değil, Lokal cüzdanınızı tekrar başlatıp birkaç dakika bekleyin

Masternode Status’unda “WATCHDOG_EXPIRED” yazması sorun değil, Lokal cüzdanın senkronize olmasını bekleyip 10-20 dakika bekleyin

Scriptin içerisinde Sentinel kendiliğinden yüklü olduğundan ek olarak yüklemenize gerek yoktur, WATCHDOG_EXPIRED durumu kendiliğinden 
geçecektir

### Lokal Cüzdan Kurulumu Bölüm 1

-Bilgisayarınızdaki Motion cüzdanını açın
-“Recieve” yazısına tıklayın, “MN1” gibi bir isim verip “Request” tuşuna basın, çıkan adresi kopyalayın
-Kopyaladığınız adrese tam olarak 1000 XMN yollayın ve 15 confirmation(onay) bekleyin
-Aşağıdaki “Tools” yazısına tıklayın
-Yukarıdaki “Console” yazısına tıklayın
-Şimdi imlecin bulunduğu yere bu kodu yazın:

`masternode outputs`

Bir satır boyunca transaction_id (tx_id) (işlem adresi) ve hemen yanında digit identifier(rakam belirteci) görmeniz gerekiyor. Bu iki
metni bir metin dosyasına kaydedin. 
Örnek:
```
{
  "6a66ad6011ee363c2d97da0b55b73584fef376dc0ef43137b478aa73b4b906b0": "0"
}
```
Tırnak içindeki ilk uzun metnin adı tx_id , tırnak içindeki tekli rakamın adı ise digit (ileride referans olarak kullanılacaktır)
Not: Eğer birden fazla satır tx_id görüyorsanız, birden fazla 1000 XMN’lik gönderiniz bulunmakta olduğundandır.

Şimdi bir metin daha yazalım:

`masternode genkey`

Metni yazdığınızda uzun bir şifre görmeniz gerekiyor: (masternodeprivkey)

Örnek: `7xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx`

Bu şifre sizin kişiye özel şifrenizdir, bunu da bir metin dosyasına kaydedin, güvende tutun, kimseyle paylaşmayın. Bu şifrenin adı 
masternodeprivkey ‘dir ve referans olarak ilerde kullanılacaktır.


Şimdi , cüzdanınızın data directory’sine (genellikle AppData’dadır) gitmelisiniz:

-Aşağıda “Settings” yazısına gidip `Open masternode configuration file` yazısına basın
-Dosyanın içinde # içerisine yazılmış(bilgisayar bu yazıları okuyamaz) iki satır metin görmeniz gerekiyor
-Metin dosyasının içine yeni bir satır ekleyin (veya içindeki iki satırı silseniz de olur) ve bunu yazın

`MN1 YOUR VPS IP:7979 masternodeprivkey tx_id digit`

-MN1 recieve adresinizde yazdığınız isim
-Your VPS IP sizin VPS serverınızın IP adresidir
-7979 port sayısıdır ve 7979 olması gerekiyor
-masternodeprivkey sizin kişisel şifreniz (masternode genkey yazarak aldığımız)
-tx_id sizin transaction_id(işlem adresi)’nizdir(masternode outputs yazarak aldığımız)
-digit sizin digit identifier(rakam belirteci)’nizdir(masternode outputs yazınca aldığımız tekli rakam)

Örnek:
`MN1 148.124.58.33:7979 7xxxxxxxxxxxxxxxxxxx 6a66ad6011ee363c2d97da0b0ef43137b478aa73b4b906b0 0`

**Not:** Her metin parçası arasında bir adet boşluk bırakılacaktır(IP:Port dışında, onlar bitişik olup aralarında “:” bulunması gerekiyor)
Verilerinizi doğru girip kaydedip dosyayı kapatın

Motion Cüzdanınıza gidin, alttan “Settings” e basın, “Show Masternodes Tab” kutucuğunu işaretleyin

Kaydedip çıkın ve Motion cüzdanınızı kapatıp tekrar başlatın

**Not:** Eğer birden fazla Masternode kurmak istiyorsanız aynı `masternode.conf` dosyasının içinde satır ekleyerek aynı adımları tekrarlayın 
(bir masternode başına bir satır)

##VPS Kurulumu Bölüm 2
Hazırlık: Windows kullanıcılarının VPS serverına SSH ile bağlanmak için puTTy adı verilen bir programa ihtiyaçları olacaktır.

**Not:** Herşeyi “root” kullanıcısı üzerinden gerçekleştireceğiz, herhangi başka bir kullanıcı ile başarısız olunur.
İşte bu evrede Motion Coin’in yaptığı script sayesinde kurulumunuz diğer klasik koinlerden çok daha az zaman alacaktır
Şimdi VPS serverınıza bazı yazılımsal güncellemeler/dosyalar indirmeniz gerekiyor. Kopyala yapıştır yapıp entera basınız
(hepsini tekte yapıştırabilirsiniz noktalı virgüllere göre ayırmanıza gerek yok)

`apt-get update;apt-get upgrade; apt-get install nano software-properties-common git wget -y;`

Bittikten sonra bu metni (bahsettiğim o script) kopyalayıp yapıştırıp enter a basın:

`wget https://raw.githubusercontent.com/motioncrypto/motion-docs/master/scripts/masternode.sh`

Şimdi sonraki metni yapıştırıp enter a basın:

`chmod +x masternode.sh`

Son olarak bu metni yapıştırıp enter a basın:

`./masternode.sh`

-Size `masternodeprivkey` sorulacaktır. (Konsola masternode genkey yazdığınızda aldığınız size özel masternode şifrenizi)
masternodeprivkey ‘i girdikten sonra size VPS IP ve port sorulacaktır.
-Aynen daha önce metin dosyasına da yazdığınız gibi IP:Port olacak şekilde VPS IP’nizi ve 7979 olan port numarasını aralarında “:” olacak 
şekilde yazıp enter a basın.
-Size VPS hakkında sorular sorulacak, hepsine “y” diyip entera basın (Kurulumda 2GB RAM’iniz yoksa sorun değil demiştim, sorulara “y” 
dediğiniz zaman sizin için script swap memory ayarlayacak ve daha düşük RAM’li VPS ile de Masternode’unuzu çalıştırabileceksiniz)

Klasik yöntemlerle kurulan Masternode’larda çok daha fazla kod koplayayıp yapıştırmanız gerekiyor olup yükleme işlemini yaklaşık 1 
saatte tamamlıyor. 
Geliştirilen script sayesinde VPS kurulumu 10 dakikadan daha kısa bir süre içersinde kurulmuş oluyor.
Scriptin içerisinde Sentinel kendiliğinden yüklü olduğundan ek olarak yüklemenize gerek yoktur

##Test Etme:
Script kurulumu bittiğinde herşeyin düzgün çalıştığını kontrol etmek için bazı testler yapın. Bu kodu girin

`motion-cli getinfo`

Eğer yanlış masternodeprivkey veya IP:Port girdiyseniz error alırsınz. Doğru bilgileri girmek için:

`nano /root/.motioncore/motion.conf`

Kaydedip çıkmak için CTRL+X ve sonra Y tuşlarına basıp Enter a basın, sonra girmiş olduğumuz doğru bilgilerle masternode’u çalıştıralım:

`motiond-daemon`

şimdi tekrar test edin:

`motion-cli getinfo`

veya

`motion-cli getblockcount`

Eğer hala error alıyorsanız Discord’da yetkililerle konuşmaktan çekinmeyin

##Masternode’unuzu Çalıştırmak

Lokal cüzdanınızda Masternodes bölümüne gidin. Masternode’unuzu başlatabilmek için 15 onay(confirmation) beklemeniz gerekmektedir. 

VPS serverınızın güncel blok sayısını kontrol etmek için bu kodu girin:

`motion-cli getblockcount`

(Güncel olabilmesi için sayının “0” dan büyük olması lazım. Ben bu metni yazarken güncel blok 18745)

**Not:** Eğer Masternodes Bölmesini göremiyorsanız Motion Cüzdanınıza gidin, alttan “Settings” e basın, “Show Masternodes Tab” kutucuğunu işaretleyin. Sonra cüzdanı kapatıp tekrar açın.

##Masternode’unuzu Kontrol Etme:

Masternode’unuzun durumunu öğrenmek için VPS serverınıza bu kodu yazın:

`motion-cli masternode status`

Eğer Masternode’unuz çalışıyorsa “Masternode successfully started” yazısını görmeniz gerekiyor

Ayrıca Masternode’unuzun durumunu Lokal cüzdanınızdan da görebilirsiniz. Aşağıda “Tools” dan “Console” a basın ve çıkan ekrana bu metni 
yazın:
```
masternode list full XXXXX
(XXXXX yerine tx_id’nizin ilk 5 karakterini yazmanız gerekiyor)
```
Tebrikler!

