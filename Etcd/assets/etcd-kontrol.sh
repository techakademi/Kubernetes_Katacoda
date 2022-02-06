#!/bin/bash
kayitsay=$(etcdctl ls | wc -l)
kayitlar=$(etcdctl ls --recursive)
kayitadet=5
kayiteksik=$(($kayitsay - $kayitadet))
echo -------------------------------
echo "Kayitlari okuyorum, Lütfen bekleyiniz..."
sleep 1
echo -------------------------------
echo "Toplam kayit adeti: " "$kayitsay"
echo -------------------------------
echo "Kayit listesi: " 
echo "$kayitlar"
echo -------------------------------
sleep 1
if [[ $kayitsay -eq 5 ]]
then
  echo "Tebrikler, beklenen kayit sayisi (beş) adet, okunan kayit adeti:($kayitsay)"
  echo "Bu dersi basarili bir sekilde tamamladin, bir sonraki derse gecebilirsin :)"
else
  echo "!!!!Uzgunum, beklenen kayit sayisi (beş) adet, okunan kayit adeti:($kayitsay)!!!!"
  sleep 1
  echo -------------------------------
  echo "Mevcut kayitlar: "
  echo "$kayitlar"
  echo -------------------------------
  echo "Eksik kayit adeti : " "$kayiteksik"
  echo -------------------------------
fi
echo