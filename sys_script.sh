#!/bin/bash
yum update -y
yum install epel-release -y
yum install httpd -y
setenforce 0
echo -e 'OPTIONS="-f /etc/httpd/conf/httpd-sample1.conf"
LANG=C' > /etc/sysconfig/httpd-sample1
echo -e 'OPTIONS="-f /etc/httpd/conf/httpd-sample2.conf"
LANG=C' > /etc/sysconfig/httpd-sample2

echo -e '[Unit]
Description=My Apache HTTP Server
After=network.target remote-fs.target nss-lookup.target
Documentation=man:httpd(8)
Documentation=man:apachectl(8)

[Service]
Type=notify
PIDFile=/var/run/httpd/httpd-%i.pid
EnvironmentFile=/etc/sysconfig/httpd-%i
ExecStart=/usr/sbin/httpd $OPTIONS -DFOREGROUND
ExecReload=/usr/sbin/httpd $OPTIONS -k graceful
ExecStop=/bin/kill -WINCH ${MAINPID}
KillSignal=SIGCONT
PrivateTmp=true

[Install]
WantedBy=multi-user.target' > /etc/systemd/system/httpd@.service


echo -e 'ServerRoot "/etc/httpd"
Listen 8101
Include conf.modules.d/*.conf
User apache
Group apache
ServerAdmin root@localhost
ServerName localhost:8101
<Directory />
    AllowOverride none
    Require all denied
</Directory>
DocumentRoot "/var/www/html"
<Directory "/var/www">
    AllowOverride None
    # Allow open access:
    Require all granted
</Directory>

<Directory "/var/www/html">
   Options Indexes FollowSymLinks
   AllowOverride None
   Require all granted
</Directory>
<IfModule dir_module>
    DirectoryIndex index.html
</IfModule>
<Files ".ht*">
    Require all denied
</Files>
ErrorLog "logs/error_log"

LogLevel warn

<IfModule log_config_module>

    LogFormat "%h %l %u %t \"%r\" %>s %b \"%{Referer}i\" \"%{User-Agent}i\"" combined
    LogFormat "%h %l %u %t \"%r\" %>s %b" common

    <IfModule logio_module>
      
      LogFormat "%h %l %u %t \"%r\" %>s %b \"%{Referer}i\" \"%{User-Agent}i\" %I %O" combinedio
    </IfModule>

    CustomLog "logs/access_log" combined
</IfModule>

<IfModule alias_module>

   ScriptAlias /cgi-bin/ "/var/www/cgi-bin/"

</IfModule>

<Directory "/var/www/cgi-bin">
    AllowOverride None
    Options None
    Require all granted
</Directory>

<IfModule mime_module>
   TypesConfig /etc/mime.types
   
    AddType application/x-compress .Z
    AddType application/x-gzip .gz .tgz

    AddType text/html .shtml
    AddOutputFilter INCLUDES .shtml
</IfModule>


AddDefaultCharset UTF-8

<IfModule mime_magic_module>

    MIMEMagicFile conf/magic
</IfModule>


EnableSendfile on' > /etc/httpd/conf/httpd-sample1.conf

echo -e 'ServerRoot "/etc/httpd"
Listen 8102
Include conf.modules.d/*.conf
User apache
Group apache
ServerAdmin root@localhost
ServerName localhost:8102
<Directory />
    AllowOverride none
    Require all denied
</Directory>
DocumentRoot "/var/www/html"
<Directory "/var/www">
    AllowOverride None
    # Allow open access:
    Require all granted
</Directory>

<Directory "/var/www/html">
   Options Indexes FollowSymLinks
   AllowOverride None
   Require all granted
</Directory>
<IfModule dir_module>
    DirectoryIndex index.html
</IfModule>
<Files ".ht*">
    Require all denied
</Files>
ErrorLog "logs/error_log"

LogLevel warn

<IfModule log_config_module>

    LogFormat "%h %l %u %t \"%r\" %>s %b \"%{Referer}i\" \"%{User-Agent}i\"" combined
    LogFormat "%h %l %u %t \"%r\" %>s %b" common

    <IfModule logio_module>
      
      LogFormat "%h %l %u %t \"%r\" %>s %b \"%{Referer}i\" \"%{User-Agent}i\" %I %O" combinedio
    </IfModule>

    CustomLog "logs/access_log" combined
</IfModule>

<IfModule alias_module>

   ScriptAlias /cgi-bin/ "/var/www/cgi-bin/"

</IfModule>

<Directory "/var/www/cgi-bin">
    AllowOverride None
    Options None
    Require all granted
</Directory>

<IfModule mime_module>
   TypesConfig /etc/mime.types
   
    AddType application/x-compress .Z
    AddType application/x-gzip .gz .tgz

    AddType text/html .shtml
    AddOutputFilter INCLUDES .shtml
</IfModule>


AddDefaultCharset UTF-8

<IfModule mime_magic_module>

    MIMEMagicFile conf/magic
</IfModule>


EnableSendfile on' > /etc/httpd/conf/httpd-sample2.conf

systemctl daemon-reload

systemctl start httpd@sample1.service
systemctl start httpd@sample2.service
