
log=/tmp.roboshop.log

func_appreq(){
 echo -e "\e[36m>>>>>>>>>>>>>>>>>>   Create ${component}   <<<<<<<<<<<<<<<<\e[0m"
cp ${component}.service /etc/systemd/system/${component}.service &>>${log}
echo $?

echo -e "\e[36m>>>>>>>>>>>>>>>>>>   creating application user   <<<<<<<<<<<<<<<<\e[0m"
useradd roboshop &>>${log}
echo $?

echo -e "\e[36m>>>>>>>>>>>>>>>>>>   cleanup existing Application content    <<<<<<<<<<<<<<<<<\e[0m"
rm -rf /app &>>${log}
echo $?

echo -e "\e[36m>>>>>>>>>>>>>>>>>>   create Application directory   <<<<<<<<<<<<<<<<\e[0m"
mkdir /app &>>${log}
echo $?

echo -e "\e[36m>>>>>>>>>>>>>>>>>>   Download Application Content   <<<<<<<<<<<<<<<<\e[0m"
curl -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip &>>${log}
echo $?

echo -e "\e[36m>>>>>>>>>>>>>>>>>>   Extract Application content   <<<<<<<<<<<<<<<<\e[0m"
cd /app
unzip /tmp/${component}.zip &>>${log}
echo $?
cd /app
}

func_systemd(){
  echo -e "\e[36m>>>>>>>>>>>>>>>>>>   start ${component} service   <<<<<<<<<<<<<<<<\e[0m"
  systemctl daemon-reload &>>${log}
  echo $?
  systemctl enable ${component} &>>${log}
  echo $?
  systemctl restart ${component} &>>${log}
echo $?
}

func_schema_setup(){
  if [ "${schema_type}" == "mongodb" ]; then
    echo -e "\e[36m>>>>>>>>>>  Install Mongo Client  <<<<<<<<<<\e[0m" | tee -a /tmp/roboshop.log
    yum install mongodb-org-shell -y &>>${log}
echo $?

    echo -e "\e[36m>>>>>>>>>>  Load User Schema  <<<<<<<<<<\e[0m" | tee -a /tmp/roboshop.log
    mongo --host mongodb.rdevopsb72.online </app/schema/${component}.js &>>${log}
echo $?
  fi

if [ "${schema_type}" == "mysql" ]; then
  echo -e "\e[36m>>>>>>>>>>  Install MySQL Client  <<<<<<<<<<\e[0m"
  yum install mysql -y &>>${log}
echo $?

  echo -e "\e[36m>>>>>>>>>>  Load Schema  <<<<<<<<<<\e[0m"
  mysql -h mysql.rdevopsb72.online -uroot -pRoboShop@1 < /app/schema/${component}.sql &>>${log}
echo $?
fi


}

func_nodejs() {
    log=/tmp/roboshop.log

echo -e "\e[36m>>>>>>>>>>>>>>>>>>   create mongodb repo   <<<<<<<<<<<<<<<<\e[0m"
cp mongo.repo /etc/yum.repos.d/mongo.repo &>>${log}
echo $?

echo -e "\e[36m>>>>>>>>>>>>>>>>>>   installing unzip command   <<<<<<<<<<<<<<<<\e[0m"
yum intsall unzip -y &>>${log}
echo $?

echo -e "\e[36m>>>>>>>>>>>>>>>>>>   install  NodeJS Repos   <<<<<<<<<<<<<<<<\e[0m"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${log}
echo $?

echo -e "\e[36m>>>>>>>>>>>>>>>>>>   install NodeJS   <<<<<<<<<<<<<<<<\e[0m"
yum install nodejs -y &>>${log}
echo $?

func_appreq

echo -e "\e[36m>>>>>>>>>>>>>>>>>>   Download NodeJS Dependencies   <<<<<<<<<<<<<<<<\e[0m"
npm install &>>${log}
echo $?

func_schema_setup

func_systemd
}

func_java() {
 echo -e "\e[36m>>>>>>>>>>>>>>>>>>   Install mongo client   <<<<<<<<<<<<<<<<\e[0m"
yum install unzip -y &>>${log}
echo $?

echo -e "\e[36m>>>>>>>>>>>>>>>>>>   Install Maven    <<<<<<<<<<<<<<<<\e[0m"
yum install maven -y &>>${log}
echo $?

func_appreq
echo -e "\e[36m>>>>>>>>>>>>>>>>>>   Build ${component} service    <<<<<<<<<<<<<<<<\e[0m"
mvn clean package &>>${log}
echo $?
mv target/${component}s-1.0.jar ${component}.jsr &>>${log}
echo $?
func_schema_setup

func_systemd
}

func_python() {
echo -e "\e[36m>>>>>>>>>>>>>>>>>>  Installing unzip command   <<<<<<<<<<<<<<<<\e[0m"
  yum install unzip -y &>>${log}
echo $?

echo -e "\e[36m>>>>>>>>>>>>>>>>>>   Build ${component}    <<<<<<<<<<<<<<<<\e[0m"
  yum install python36 gcc python3-devel -y &>>${log}
echo $?

func_appreq

echo -e "\e[36m>>>>>>>>>>>>>>>>>>   Build ${component}     <<<<<<<<<<<<<<<<\e[0m"
  pip3.6 install -r requirements.txt &>>${log}
echo $?

func_systemd

}