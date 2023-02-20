source common.sh
source status_check.sh

print_head "Downloading nodejs repository"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${log_file}
status_check $?

print_head "installing nodejs"
yum install nodejs -y &>>${log_file}
status_check $?

print_head "Creating robshop user"
id roboshop  &>>${log_file}              # find the roboshop user is already exist or not by using command "id"..
                                          ##-it will return $? '0' if it is already available
if [ $? -ne 0 ]; then
  useradd roboshop &>>${log_file}
fi
status_check $?

print_head "Creating app directory"
if [ ! -d /app ]; then
  mkdir /app &>>${log_file}
fi
status_check $?

print_head "Removing old content"
rm -rf /app/* &>>${log_file}
status_check $?

print_head "Downloading catalogue repository"
curl -L -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip &>>${log_file}
status_check $?
cd /app

print_head "Extracting catalogue content"
unzip /tmp/catalogue.zip &>>${log_file}
status_check $?

print_head "installing nodejs dependices"
npm install &>>${log_file}
status_check $?

print_head "Copy SystemD Service File"
cp ${code_dir}/configs/catalogue.service /etc/systemd/system/catalogue.service &>>${log_file}
status_check $?

print_head "Reload deamon"
systemctl daemon-reload &>>${log_file}
status_check $?

print_head "Enabling Catalogue service"
systemctl enable catalogue &>>${log_file}
status_check $?

print_head "Restart Catalogue service"
systemctl restart catalogue &>>${log_file}
status_check $?


print_head "Copying mongodb.repo"
cp ${code_dir}/configs/mongodb.repo /etc/yum.repos.d/mongodb.repo &>>${log_file}

print_head "installing mongodb"
yum install mongodb-org-shell -y &>>${log_file}

print_head "load schema"
mongo --host mongodb.devopsb72.online </app/schema/catalogue.js &>>${log_file}


