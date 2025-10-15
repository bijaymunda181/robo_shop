log=/tmp/roboshop.log
 echo -e "\e[33m<<<<<<<< install nginux >>>>>>>>>>>\e[0m"
yum install nginx -y &>>${log}


 echo -e "\e[33m<<<<<<< copy nginx-roboshop.conf file\e[0m"
cp nginx-roboshop.conf /etc/nginx/default.d/roboshop.conf &>>${log}


 echo -e "\e[33m<<<<<<<<<<<<<<  remove all inside the /usr/share/nginx/html/* file >>>>>>>>>>>\e[0m"
rm -rf /usr/share/nginx/html/* &>>${log}



 echo -e "\e[33m <<<<<<<<<<<<<<<<<<<<    install unzip command   >>>>>>>>>>>>>>>>>>\e[0m"
yum install unzip -y &>>${log}


 echo -e "\e[33m<<<<<<<<<<<<     download the zip file    >>>>>>>>>>>>>>>\e[0m"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip &>>${log}


 echo -e "\e[33m<<<<<<<<<<<<<<<<<<<<   go to html directory     >>>>>>>>>>>>>>>\e[0m"
cd /usr/share/nginx/html &>>${log}


 echo -e "\e[33m <<<<<<<<<<<<<<<<<<<<<<     unzip frontend.zip file    >>>>>>>>>>>>>>>>>>>>>>>>>>\e[0m"
unzip /tmp/frontend.zip &>>${log}


 echo -e "\e[33m <<<<<<<<<<<<<<<<<<<<<<<<     start and enable the nginx service     >>>>>>>>>>>>>>>>>>>>>>\e[0m"
systemctl enable nginx &>>${log}
systemctl restart nginx &>>${log}