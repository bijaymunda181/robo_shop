echo "<<<<<<<< install nginux >>>>>>>>>>>>"
yum install nginx -y

echo "<<<<<<< copy nginx-roboshop.conf file"
cp nginx-roboshop.conf /etc/nginx/default.d/roboshop.conf

echo "<<<<<<<<<<<<<<  remove all inside the /usr/share/nginx/html/* file >>>>>>>>>>>>"
rm -rf /usr/share/nginx/html/*

echo " <<<<<<<<<<<<<<<<<<<<    install unzip command   >>>>>>>>>>>>>>>>>>>"
yum install unzip -y

echo "<<<<<<<<<<<<     download the zip file    >>>>>>>>>>>>>>>>"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip

echo "<<<<<<<<<<<<<<<<<<<<   go to html directory     >>>>>>>>>>>>>>>>"
cd /usr/share/nginx/html

echo " <<<<<<<<<<<<<<<<<<<<<<     unzip frontend.zip file    >>>>>>>>>>>>>>>>>>>>>>>>>>>"
unzip /tmp/frontend.zip

echo " <<<<<<<<<<<<<<<<<<<<<<<<     start and enable the nginx service     >>>>>>>>>>>>>>>>>>>>>>>"
systemctl enable nginx
systemctl restart nginx