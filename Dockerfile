FROM wangkexiong/openstackcli
MAINTAINER wangkexiong<wangkexiong@gmail.com>

COPY trystack /root/trystack
COPY keystone_trystack* /root/
COPY crontab /etc/crontabs/root

RUN apk add --no-cache wget && chmod +x /root/trystack/setup.sh

CMD ["crond", "-f", "-d", "8"]
