source common.sh

 echo -e "\e[36m<<<<<<<< install nginx >>>>>>>>>>>\e[0m"
yum install nginx -y &>>${log}
func_exit_status


 echo -e "\e[36m<<<<<<< copy nginx-roboshop.conf file\e[0m"
cp nginx-roboshop.conf /etc/nginx/default.d/roboshop.conf &>>${log}
func_exit_status

 echo -e "\e[36m<<<<<<<<<<<<<<  clean old content >>>>>>>>>>>\e[0m"
rm -rf /usr/share/nginx/html/* &>>${log}
func_exit_status


 echo -e "\e[36m <<<<<<<<<<<<<<<<<<<<    install unzip command   >>>>>>>>>>>>>>>>>>\e[0m"
yum install unzip -y &>>${log}
func_exit_status

 echo -e "\e[36m<<<<<<<<<<<<     download Application content    >>>>>>>>>>>>>>>\e[0m"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip &>>${log}
func_exit_status

 echo -e "\e[36m<<<<<<<<<<<<<<<<<<<<   go to html directory     >>>>>>>>>>>>>>>\e[0m"
cd /usr/share/nginx/html &>>${log}
func_exit_status

 echo -e "\e[36m <<<<<<<<<<<<<<<<<<<<<<     unzip frontend.zip file    >>>>>>>>>>>>>>>>>>>>>>>>>>\e[0m"
unzip /tmp/frontend.zip &>>${log}
func_exit_status

 echo -e "\e[36m <<<<<<<<<<<<<<<<<<<<<<<<     start and enable the nginx service     >>>>>>>>>>>>>>>>>>>>>>\e[0m"
systemctl enable nginx &>>${log}
systemctl restart nginx &>>${log}
func_exit_status