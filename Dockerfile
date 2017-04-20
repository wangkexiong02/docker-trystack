FROM wangkexiong/openstackcli
MAINTAINER wangkexiong<wangkexiong@gmail.com>

COPY trystack /root/trystack
COPY crontab /etc/crontabs/root
COPY startup.sh /root/

RUN apk add --no-cache wget && chmod +x /root/trystack/setup.sh && chmod +x /root/startup.sh
EXPOSE 80

CMD ["/bin/sh", "-c", "/root/startup.sh"]
