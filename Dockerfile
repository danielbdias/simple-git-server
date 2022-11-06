FROM ubuntu:latest

# Image based on https://linuxhint.com/setup_git_http_server_docker/

RUN apt update 2>/dev/null && \
    apt install -y git apache2 apache2-utils 2>/dev/null

RUN a2enmod env cgi alias rewrite

RUN mkdir /var/www/git
RUN chown -Rfv www-data:www-data /var/www/git

COPY ./etc/git.conf /etc/apache2/sites-available/git.conf
COPY ./etc/git-create-repo.sh /usr/bin/mkrepo

RUN chmod +x /usr/bin/mkrepo
RUN a2dissite 000-default.conf
RUN a2ensite git.conf

RUN git config --system http.receivepack true
RUN git config --system http.uploadpack true

ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_LOCK_DIR /var/lock/apache2
ENV APACHE_PID_FILE /var/run/apache2.pid

CMD /usr/sbin/apache2ctl -D FOREGROUND
EXPOSE 80/tcp