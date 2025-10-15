log=/tmp/roboshop.log

echo -e "\e[36m>>>>>>>>>>>>>>>>>>   create catalogue service file   <<<<<<<<<<<<<<<<\e[0m"
cp catalogue.service /etc/systemd/system/catalogue.service &>>${log}

echo -e "\e[36m>>>>>>>>>>>>>>>>>>   create mongodb repo   <<<<<<<<<<<<<<<<\e[0m"
cp mongo.repo /etc/yum.repos.d/mongo.repo &>>${log}

echo -e "\e[36m>>>>>>>>>>>>>>>>>>   installing unzip command   <<<<<<<<<<<<<<<<\e[0m"
yum intsall unzip -y &>>${log}

echo -e "\e[36m>>>>>>>>>>>>>>>>>>   install  NodeJS Repos   <<<<<<<<<<<<<<<<\e[0m"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${log}

echo -e "\e[36m>>>>>>>>>>>>>>>>>>   install NodeJS   <<<<<<<<<<<<<<<<\e[0m"
yum install nodejs -y &>>${log}

echo -e "\e[36m>>>>>>>>>>>>>>>>>>   creating application user   <<<<<<<<<<<<<<<<\e[0m"
useradd roboshop &>>${log}

echo ">>>>>>>>>>>>>>>>>>   create catalogue service file   <<<<<<<<<<<<<<<<<"
rm -rf /app &>>${log}

echo -e "\e[36m>>>>>>>>>>>>>>>>>>   create Application directory   <<<<<<<<<<<<<<<<\e[0m"
mkdir /app &>>${log}

echo -e "\e[36m>>>>>>>>>>>>>>>>>>   Download Application Content   <<<<<<<<<<<<<<<<\e[0m"
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip &>>${log}

echo -e "\e[36m>>>>>>>>>>>>>>>>>>   Extract Application content   <<<<<<<<<<<<<<<<\e[0m"
cd /app
unzip /tmp/catalogue.zip &>>${log}
cd /app

echo -e "\e[36m>>>>>>>>>>>>>>>>>>   Download NodeJS Dependencies   <<<<<<<<<<<<<<<<\e[0m"
npm install &>>${log}

echo -e "\e[36m>>>>>>>>>>>>>>>>>>   Install mongo client   <<<<<<<<<<<<<<<<\e[0m"
yum install mongodb-org-shell -y &>>${log}

echo -e "\e[36m>>>>>>>>>>>>>>>>>>   Load catalogue schema   <<<<<<<<<<<<<<<<\e[0m"
mongo --host MONGODB-SERVER-IPADDRESS </app/schema/catalogue.js &>>${log}

echo -e "\e[36m>>>>>>>>>>>>>>>>>>   start catalogue service   <<<<<<<<<<<<<<<<\e[0m"
systemctl daemon-reload &>>${log}
systemctl enable catalogue &>>${log}
systemctl restart catalogue &>>${log}
