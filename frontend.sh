source common.sh


print_head "Installing nginx"
yum install nginx -y &>>${log_file}
status_check.sh $?


print_head "Removing Old Content"
rm -rf /usr/share/nginx/html/* &>>${log_file}

print_head "Downloading Frontend Content"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip &>>${log_file}

print_head "Extracting Downloaded Frontend"
cd /usr/share/nginx/html
unzip /tmp/frontend.zip &>>${log_file}

print_head "Copying Nginx Config for RoboShop"
cp ${code_dir}/configs/nginx-roboshop.conf /etc/nginx/default.d/roboshop.conf &>>${log_file}

print_head "Enabling nginx"
systemctl enable nginx &>>${log_file}

print_head "Starting nginx"
systemctl restart nginx &>>${log_file}


echo -e "\e[35mEnabling nginx\e[0m"
systemctl enable nginx &>>${log_file}

echo -e "\e[35mStarting nginx\e[0m"
systemctl restart nginx &>>${log_file}


## If any command is errored or failed, we need to stop the script
#status of a command need to be printed

