code_dir=$(pwd)
log_file=/tmp/roboshop.log
rm -f ${log_file}

print_head(){
  echo -e "\e[36m$1\e[0m"
}

status_check(){
  if [ $1 -eq 0 ]
     then
       echo successfull
       else
         echo failure
         echo "Read the log file ${log_file} for more information about error"
         exit 1
         fi
}

nodejs(){
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

print_head "Downloading ${component} repository"
curl -L -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip &>>${log_file}
status_check $?
cd /app

print_head "Extracting ${component} content"
unzip /tmp/${component}.zip &>>${log_file}
status_check $?

print_head "installing nodejs dependices"
npm install &>>${log_file}
status_check $?

print_head "Copy SystemD Service File"
cp ${code_dir}/configs/${component}.service /etc/systemd/system/${component}.service &>>${log_file}
status_check $?

print_head "Reload deamon"
systemctl daemon-reload &>>${log_file}
status_check $?

print_head "Enabling ${component} service"
systemctl enable ${component} &>>${log_file}
status_check $?

print_head "Restart ${component} service"
systemctl restart ${component} &>>${log_file}
status_check $?


print_head "Copying mongodb.repo"
cp ${code_dir}/configs/mongodb.repo /etc/yum.repos.d/mongodb.repo &>>${log_file}
status_check $?

print_head "installing mongodb"
yum install mongodb-org-shell -y &>>${log_file}
status_check $?

print_head "load schema"
mongo --host mongodb.devopsb72.online </app/schema/${component}.js &>>${log_file}
status_check $?
}
