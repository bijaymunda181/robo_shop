echo ">>>>>>>>>>>>>>>>>>   create catalogue service file   <<<<<<<<<<<<<<<<<"
cp catalogue.service /etc/systemd/system/catalogue.service

echo ">>>>>>>>>>>>>>>>>>   create mongodb repo   <<<<<<<<<<<<<<<<<"
cp mongo.repo /etc/yum.repos.d/mongo.repo

echo ">>>>>>>>>>>>>>>>>>   installing unzip command   <<<<<<<<<<<<<<<<<"
yum intsall unzip -y

echo ">>>>>>>>>>>>>>>>>>   install  NodeJS Repos   <<<<<<<<<<<<<<<<<"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash

echo ">>>>>>>>>>>>>>>>>>   install NodeJS   <<<<<<<<<<<<<<<<<"
yum install nodejs -y

echo ">>>>>>>>>>>>>>>>>>   creating application user   <<<<<<<<<<<<<<<<<"
useradd roboshop

echo ">>>>>>>>>>>>>>>>>>   create Application directory   <<<<<<<<<<<<<<<<<"
mkdir /app

echo ">>>>>>>>>>>>>>>>>>   Download Application Content   <<<<<<<<<<<<<<<<<"
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip

echo ">>>>>>>>>>>>>>>>>>   Extract Application content   <<<<<<<<<<<<<<<<<"
cd /app
unzip /tmp/catalogue.zip
cd /app

echo ">>>>>>>>>>>>>>>>>>   Download NodeJS Dependencies   <<<<<<<<<<<<<<<<<"
npm install

echo ">>>>>>>>>>>>>>>>>>   Install mongo client   <<<<<<<<<<<<<<<<<"
yum install mongodb-org-shell -y

echo ">>>>>>>>>>>>>>>>>>   Load catalogue schema   <<<<<<<<<<<<<<<<<"
mongo --host MONGODB-SERVER-IPADDRESS </app/schema/catalogue.js

echo ">>>>>>>>>>>>>>>>>>   start catalogue service   <<<<<<<<<<<<<<<<<"
systemctl daemon-reload
systemctl enable catalogue
systemctl restart catalogue
