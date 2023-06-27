# if docker -i, will output no thing https://medium.com/cubemail88/docker-exec-in-crontab-279f88badd33
/usr/bin/docker exec -t  ubuntu_ppp0 curl https://api.myip.com > /var/www/html/buyhouse/proxy_ip.html; echo "<br>" >> /var/www/html/buyhouse/proxy_ip.html; /bin/date >> /var/www/html/buyhouse/proxy_ip.html;
