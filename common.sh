log=/tmp.roboshop.log


func_exit_status() {
  if [ $? -eq 0 ]; then
    echo -e "\e[32m SUCCESS \e[0m"
    else
      echo -e "\e[31m FALURE \e[0m"

     fi
}
func_appreq(){
 echo -e "\e[36m>>>>>>>>>>>>>>>>>>   Create ${component}   <<<<<<<<<<<<<<<<\e[0m"
cp ${component}.service /etc/systemd/system/${component}.service &>>${log}
func_exit_status

echo -e "\e[36m>>>>>>>>>>>>>>>>>>   creating application user   <<<<<<<<<<<<<<<<\e[0m"
id roboshop &>>${log}
if [ $? -ne 0 ]; then
useradd roboshop &>>${log}
fi
func_exit_status

echo -e "\e[36m>>>>>>>>>>>>>>>>>>   cleanup existing Application content    <<<<<<<<<<<<<<<<<\e[0m"
rm -rf /app &>>${log}
func_exit_status

echo -e "\e[36m>>>>>>>>>>>>>>>>>>   create Application directory   <<<<<<<<<<<<<<<<\e[0m"
mkdir /app &>>${log}
func_exit_status
echo -e "\e[36m>>>>>>>>>>>>>>>>>>   Download Application Content   <<<<<<<<<<<<<<<<\e[0m"
curl -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip &>>${log}
func_exit_status

echo -e "\e[36m>>>>>>>>>>>>>>>>>>   Extract Application content   <<<<<<<<<<<<<<<<\e[0m"
cd /app
unzip /tmp/${component}.zip &>>${log}
func_exit_status

cd /app
}

func_systemd(){
  echo -e "\e[36m>>>>>>>>>>>>>>>>>>   start ${component} service   <<<<<<<<<<<<<<<<\e[0m"
  systemctl daemon-reload &>>${log}
  systemctl enable ${component} &>>${log}
  systemctl restart ${component} &>>${log}
func_exit_status
}

func_schema_setup(){
  if [ "${schema_type}" == "mongodb" ]; then
    echo -e "\e[36m>>>>>>>>>>  Install Mongo Client  <<<<<<<<<<\e[0m" | tee -a /tmp/roboshop.log
    yum install mongodb-org-shell -y &>>${log}
func_exit_status

    echo -e "\e[36m>>>>>>>>>>  Load User Schema  <<<<<<<<<<\e[0m" | tee -a /tmp/roboshop.log
    mongo --host mongodb.rdevopsb72.online </app/schema/${component}.js &>>${log}
func_exit_status
  fi

if [ "${schema_type}" == "mysql" ]; then
  echo -e "\e[36m>>>>>>>>>>  Install MySQL Client  <<<<<<<<<<\e[0m"
  yum install mysql -y &>>${log}
func_exit_status

  echo -e "\e[36m>>>>>>>>>>  Load Schema  <<<<<<<<<<\e[0m"
  mysql -h mysql.rdevopsb72.online -uroot -pRoboShop@1 < /app/schema/${component}.sql &>>${log}
  func_exit_status
fi


}

func_nodejs() {
    log=/tmp/roboshop.log

echo -e "\e[36m>>>>>>>>>>>>>>>>>>   create mongodb repo   <<<<<<<<<<<<<<<<\e[0m"
cp mongo.repo /etc/yum.repos.d/mongo.repo &>>${log}
func_exit_status

echo -e "\e[36m>>>>>>>>>>>>>>>>>>   installing unzip command   <<<<<<<<<<<<<<<<\e[0m"
yum intsall unzip -y &>>${log}
func_exit_status

echo -e "\e[36m>>>>>>>>>>>>>>>>>>   install  NodeJS Repos   <<<<<<<<<<<<<<<<\e[0m"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${log}
func_exit_status

echo -e "\e[36m>>>>>>>>>>>>>>>>>>   install NodeJS   <<<<<<<<<<<<<<<<\e[0m"
yum install nodejs -y &>>${log}
func_exit_status

func_appreq

echo -e "\e[36m>>>>>>>>>>>>>>>>>>   Download NodeJS Dependencies   <<<<<<<<<<<<<<<<\e[0m"
npm install &>>${log}
func_exit_status

func_schema_setup

func_systemd
}

func_java() {
 echo -e "\e[36m>>>>>>>>>>>>>>>>>>   Install mongo client   <<<<<<<<<<<<<<<<\e[0m"
yum install unzip -y &>>${log}
func_exit_status

echo -e "\e[36m>>>>>>>>>>>>>>>>>>   Install Maven    <<<<<<<<<<<<<<<<\e[0m"
yum install maven -y &>>${log}
func_exit_status

func_appreq
echo -e "\e[36m>>>>>>>>>>>>>>>>>>   Build ${component} service    <<<<<<<<<<<<<<<<\e[0m"
mvn clean package &>>${log}
mv target/${component}s-1.0.jar ${component}.jsr &>>${log}
func_exit_status
func_schema_setup

func_systemd
}

func_python() {
echo -e "\e[36m>>>>>>>>>>>>>>>>>>  Installing unzip command   <<<<<<<<<<<<<<<<\e[0m"
  yum install unzip -y &>>${log}
func_exit_status

echo -e "\e[36m>>>>>>>>>>>>>>>>>>   Build ${component}    <<<<<<<<<<<<<<<<\e[0m"
  yum install python36 gcc python3-devel -y &>>${log}
func_exit_status

func_appreq

echo -e "\e[36m>>>>>>>>>>>>>>>>>>   Build ${component}     <<<<<<<<<<<<<<<<\e[0m"
  pip3.6 install -r requirements.txt &>>${log}
func_exit_status

func_systemd

}