#!/bin/sh

DEST_DIR=/config/openvpn

case ${VPN_PROV} in
  pia)
    SRC_DIR="/openvpn/pia"
    FILES="openvpn.ovpn crl.rsa.2048.pem ca.rsa.2048.crt"
    ;;
  torguard)
    SRC_DIR="/openvpn/tg"
    FILES="openvpn.ovpn"
    ;;
  *)
    echo "VPN provider ${VPN_PROV} not supported"
    exit 1
    ;;
esac

[ ! -d /config/openvpn ] && mkdir --mode=0775 /config/openvpn

for f in $FILES; do
  if [ ! -f "${DEST_DIR}${f}" ]; then
    cp $SRC_DIR/${f} $DEST_DIR/
  fi
done

sed -i -e "s/^remote .*$/remote $VPN_REMOTE $VPN_REMOTE_PORT/" /config/openvpn/openvpn.ovpn
sed -i -e 's/^auth-user-pass.*$/auth-user-pass \/config\/openvpn\/login.conf/' /config/openvpn/openvpn.ovpn

cat <<EOF > /config/openvpn/login.conf
${VPN_USERNAME}
${VPN_PASSWORD}
EOF
