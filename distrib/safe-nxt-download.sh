#!/bin/bash
if [[ -z "$1" ]]; then
  echo "Pass version number as first parameter"
  exit 1
fi
export PATH=$PATH:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin;
gpg --recv-keys 0xB88DC0A62ECDDDD1643A28FDCEF1F4A9FF2A19FA 0x263A9EB029CFC77A3D06FD13811D6940E1E4240C > /dev/null 2>&1 || { echo "Could not recieve public key for file verification. Exiting."; exit 1; }
rm -f nxt-client-$1.* nxt.zip
wget -nv https://bitbucket.org/JeanLucPicard/nxt/downloads/nxt-client-$1.{zip,sh,zip.asc,sh.asc,changelog.txt.asc} > /dev/null 2>&1
zip_sig=$(gpg --verify nxt-client-$1.zip.asc > /dev/null 2>&1; echo $?)
sh_sig=$(gpg --verify nxt-client-$1.sh.asc > /dev/null 2>&1; echo $?)
chg_sig=$(gpg --verify nxt-client-$1.changelog.txt.asc > /dev/null 2>&1; echo $?)
sha_sum=$(sha256sum -c nxt-client-$1.changelog.txt.asc > /dev/null 2>&1; echo $?)
if [[ sha_sum -ne 0 || sh_sig -ne 0 || zip_sig -ne 0 || chg_sig -ne 0 ]]; then
	rm -f nxt-client-$1.*
	echo "ERROR: Signature mismatch."
	exit 1
else
	ln -sf nxt-client-$1.zip nxt.zip
	echo "OK"
	exit 0
fi
