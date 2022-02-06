#!/bin/bash
clear
echo -------------------------------
echo "Hazirlik yapiyorum, lütfen biraz bekleyiniz."
sleep 2
echo -------------------------------
etcdctl rm POD1 --recursive && etcdctl rm POD2 --recursive && etcdctl rm POD3 --recursive && etcdctl rm POD4 --recursive && etcdctl rm POD5 --recursive
echo -------------------------------
echo "Gerekli hazirligi tamamladim, baslayabilirsiniz."
sleep 2
echo -------------------------------
echo "Kolay gelsin :)"
sleep 2
clear
echo