#!/bin/sh

# CN = server サーバー側の公開鍵, 秘密鍵のセットアップ
# CN = client クライアント用の公開鍵, 秘密鍵のセットアップ

# openvpnサーバーのセットアップ
# ユーザーをルートに変更して実行すること 
dest=$(sed -n "1p" /etc/issue | awk 'BEGIN {SP = " "} {print $1}' | tr "[A-Z]" "[a-z]")

EASY_RSA="/etc/openvpn/easy-rsa"
KEYS_DIR="/etc/openvpn/keys"

case $dest in
    centos)
        EASY_RSA_DEFAULT='/usr/share/openvpn/easy-rsa/2.0/'
        ;;
    debian)
        EASY_RSA_DEFAULT='/usr/share/doc/openvpn/examples/easy-rsa/2.0'        
        ;;
    else)
        echo "unkown os"
        exit 0
esac

cp -r $EASY_RSA_DEFAULT  $EASY_RSA
mkdir /var/log/openvpn/
mkdir /etc/openvpn/ccd
useradd -r openvpn
source ./vars
$EASY_RSA/clean-all
$EASY_RSA/build-ca
ln -s $EASY_RSA/keys $KEYS_DIR
$EASY_RSA/build-key-server server
$EASY_RSA/build-key-pass client
$EASY_RSA/build-dh
openvpn --genkey --secret $KEYS_DIR/ta.key

