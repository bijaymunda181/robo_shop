func_appreq(){
echo -e "\e[36m>>>>>>>>>>>>>>>>>>   creating application user   <<<<<<<<<<<<<<<<\e[0m"
useradd roboshop &>>${log}

echo -e "\e[36m>>>>>>>>>>>>>>>>>>   cleanup existing Application content    <<<<<<<<<<<<<<<<<\e[0m"
rm -rf /app &>>${log}

echo -e "\e[36m>>>>>>>>>>>>>>>>>>   create Application directory   <<<<<<<<<<<<<<<<\e[0m"
mkdir /app &>>${log}

echo -e "\e[36m>>>>>>>>>>>>>>>>>>   Download Application Content   <<<<<<<<<<<<<<<<\e[0m"
curl -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip &>>${log}

echo -e "\e[36m>>>>>>>>>>>>>>>>>>   Extract Application content   <<<<<<<<<<<<<<<<\e[0m"
cd /app
unzip /tmp/${component}.zip &>>${log}
cd /app
}

func_systemd(){
  echo -e "\e[36m>>>>>>>>>>>>>>>>>>   start ${component} service   <<<<<<<<<<<<<<<<\e[0m"
  systemctl daemon-reload &>>${log}
  systemctl enable ${component} &>>${log}
  systemctl restart ${component} &>>${log}
}

func_nodejs() {
    log=/tmp/roboshop.log


echo -e "\e[36m>>>>>>>>>>>>>>>>>>   create ${component} service file   <<<<<<<<<<<<<<<<\e[0m"
cp ${component}.service /etc/systemd/system/${component}.service &>>${log}

echo -e "\e[36m>>>>>>>>>>>>>>>>>>   create mongodb repo   <<<<<<<<<<<<<<<<\e[0m"
cp mongo.repo /etc/yum.repos.d/mongo.repo &>>${log}

echo -e "\e[36m>>>>>>>>>>>>>>>>>>   installing unzip command   <<<<<<<<<<<<<<<<\e[0m"
yum intsall unzip -y &>>${log}

echo -e "\e[36m>>>>>>>>>>>>>>>>>>   install  NodeJS Repos   <<<<<<<<<<<<<<<<\e[0m"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${log}

echo -e "\e[36m>>>>>>>>>>>>>>>>>>   install NodeJS   <<<<<<<<<<<<<<<<\e[0m"
yum install nodejs -y &>>${log}

func_appreq

echo -e "\e[36m>>>>>>>>>>>>>>>>>>   Download NodeJS Dependencies   <<<<<<<<<<<<<<<<\e[0m"
npm install &>>${log}

echo -e "\e[36m>>>>>>>>>>>>>>>>>>   Install mongo client   <<<<<<<<<<<<<<<<\e[0m"
yum install mongodb-org-shell -y &>>${log}

echo -e "\e[36m>>>>>>>>>>>>>>>>>>   Load user schema   <<<<<<<<<<<<<<<<\e[0m"
mongo --host MONGODB-SERVER-IPADDRESS </app/schema/${component}.js &>>${log}

func_systemd
}

func_java() {
  echo -e "\e[36m>>>>>>>>>>>>>>>>>>   Create ${component}   <<<<<<<<<<<<<<<<\e[0m"
cp ${component}.service /etc/systemd/system/${component}.service

echo -e "\e[36m>>>>>>>>>>>>>>>>>>   Install mongo client   <<<<<<<<<<<<<<<<\e[0m"
yum install unzip -y

echo -e "\e[36m>>>>>>>>>>>>>>>>>>   Install Maven    <<<<<<<<<<<<<<<<\e[0m"
yum install maven -y

func_appreq
echo -e "\e[36m>>>>>>>>>>>>>>>>>>   Build ${component} service    <<<<<<<<<<<<<<<<\e[0m"
mvn clean package
mv target/${component}s-1.0.jar ${component}.jsr

echo -e "\e[36m>>>>>>>>>>>>>>>>>>  Install MySQl client    <<<<<<<<<<<<<<<<\e[0m"
yum install mysql -y
echo -e "\e[36m>>>>>>>>>>>>>>>>>>   Load schema    <<<<<<<<<<<<<<<<\e[0m"
mysql -h <MYSQL-SERVER-IPADDRESS> -uroot -pRoboShop@1 < /app/schema/${component}.sql

func_systemd
}
