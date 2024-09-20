# write a bash script with installs apache upon launch 

#!/bin/bash 
yum update -y
yum install httpd -y 
echo "this instanc is:${hostname} " > /var/www/html/index.html 
systemctl start http 

