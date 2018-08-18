FROM alpine:edge
MAINTAINER James Eckersall <james.eckersall@gmail.com>

RUN \
  apk update && \
  apk add bash bind-tools curl grep openvpn privoxy rsync sed strongswan supervisor ppp xl2tpd && \
  chmod -R 0777 /var/log /run && \
  mkdir -p /var/run/xl2tpd && \
  touch /var/run/xl2tpd/l2tp-control && \
  rm -rf /var/cache/apk/*

COPY files /

RUN \
  chmod -R 0777 /var/log /run && \
  chmod -R 0755 /hooks/ && \
  chmod -R 0644 /etc/supervisord.conf /etc/supervisord.d/*.ini

ENV \
  LOGLEVEL=info \
  VPN_PSK='torguard' \
  LAN_NETWORK=192.168.0.0/16 \
  NAME_SERVERS=8.8.8.8,9.9.9.9 \
  VPN_CONFIG=/config/openvpn/openvpn.ovpn \
  VPN_DEVICE_TYPE=tun \
  VPN_PROV=torguard \
  VPN_REMOTE=88.150.157.14 \
  VPN_REMOTE_PORT=1912 \
  VPN_PROTOCOL=udp \
  VPN_USERNAME=bob \
  VPN_PASSWORD=pass

ENTRYPOINT ["/bin/bash", "-e", "/init/entrypoint"]
CMD ["run"]
