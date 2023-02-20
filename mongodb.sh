source common.sh
source status_check.sh

print_head "setup mongodb repository"
cp ${code_dir}/configs/mongodb.repo /etc/yum.repos.d/mongo.repo &>>${log_file}
status_check $?

print_head "installing mongodb"
yum install mongodb-org -y &>>${log_file}
status_check $?

print_head "Update MongoDB lisiting Address"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf  ##update /etc/mongod.conf from 127.0.0.1 to 0.0.0.0
status_check $?

print_head "enabling mongodb"
systemctl enable mongod &>>${log_file}
status_check $?

print_head "restart mongodb"
systemctl restart mongod &>>${log_file}
status_check $?

#update /etc/mongod.conf from 127.0.0.1 to 0.0.0.0