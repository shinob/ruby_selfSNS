#!/bin/sh

libdir="selfSNS/lib"
appname="selfSNS"
wwwuser="apache"

## データベースファルの作成

sqlite3 ${libdir}/databases/${appname}.db < ${libdir}/databases/${appname}.txt

## ファイル保存フォルダの作成

mkdir ${appname}/files
chown apache ${appname}/files
cp ${appname}/lib/.htaccess ${appname}/files/

# Root権限がない場合
# chmod 777 ${appname}/files

## ファイル属性の変更

chmod 755 ${appname}/*.rb
chown ${wwwuser} ${libdir}/databases
chown ${wwwuser} ${libdir}/databases/${appname}.db

# Root権限がない場合
# chmod 777 ${libdir}/databases
# chmod 777 ${libdir}/databases/${appname}.db

## ログファイルの作成

touch ${libdir}/login.log
chown apache ${libdir}/login.log

# Root権限がない場合
# chmod 666 ${libdir}/login.log
