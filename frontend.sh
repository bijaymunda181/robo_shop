 echo -e "\e[31m<<<<<<<< install nginux >>>>>>>>>>>\e[0m"
yum install nginx -y

 echo -e "\e[31m<<<<<<< copy nginx-roboshop.conf file\e[0m"
cp nginx-roboshop.conf /etc/nginx/default.d/roboshop.conf

 echo -e "\e[31m<<<<<<<<<<<<<<  remove all inside the /usr/share/nginx/html/* file >>>>>>>>>>>\e[0m"
rm -rf /usr/share/nginx/html/*

 echo -e "\e[31m <<<<<<<<<<<<<<<<<<<<    install unzip command   >>>>>>>>>>>>>>>>>>\e[0m"
yum install unzip -y

 echo -e "\e[31m<<<<<<<<<<<<     download the zip file    >>>>>>>>>>>>>>>\e[0m"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip

 echo -e "\e[31m<<<<<<<<<<<<<<<<<<<<   go to html directory     >>>>>>>>>>>>>>>\e[0m"
cd /usr/share/nginx/html

 echo -e "\e[31m <<<<<<<<<<<<<<<<<<<<<<     unzip frontend.zip file    >>>>>>>>>>>>>>>>>>>>>>>>>>\e[0m"
unzip /tmp/frontend.zip

 echo -e "\e[31m <<<<<<<<<<<<<<<<<<<<<<<<     start and enable the nginx service     >>>>>>>>>>>>>>>>>>>>>>\e[0m"
systemctl enable nginx
systemctl restart nginx