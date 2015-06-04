#!/bin/bash
if [[ -z "$1" ]]; then
  echo "Pass version number as first parameter"
  exit 1
fi
export PATH=$PATH:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin;
gpg --recv-keys 0xFF2A19FA > /dev/null 2>&1 || { echo "Could not recieve public key for file verification. Exiting."; exit 1; }
rm -f nxt-client-$1.* nxt.zip
wget -nv https://bitbucket.org/JeanLucPicard/nxt/downloads/nxt-client-$1.{zip,jar,zip.asc,changelog.txt.asc} > /dev/null 2>&1
zip_sig=$(gpg --verify nxt-client-$1.zip.asc > /dev/null 2>&1; echo $?)
chg_sig=$(gpg --verify nxt-client-$1.changelog.txt.asc > /dev/null 2>&1; echo $?)
sha_sum=$(sha256sum -c nxt-client-$1.changelog.txt.asc > /dev/null 2>&1; echo $?)
if [[ sha_sum -ne 0 || zip_sig -ne 0 || chg_sig -ne 0 ]]; then
	rm -f nxt-client-$1.*
	echo "ERROR: Signature mismatch."
	exit 1
else
	ln -sf nxt-client-$1.zip nxt.zip
	echo "OK"
	exit 0
fi
