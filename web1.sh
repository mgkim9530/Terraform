#! /bin/bash
sudo -s
yum -y update
amazon-linux-extras install nginx1
rm /usr/share/nginx/html/index.html
touch /usr/share/nginx/html/index.html

echo -e "<html> \n 
<head> \n 
<title> Hello Cloocus </title> \n
<body> apache start start (web1) </body> \n
</head> \n
</html> " > /usr/share/nginx/html/index.html

systemctl restart nginx
