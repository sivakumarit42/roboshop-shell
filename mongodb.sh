source common.sh

print_head "setup mongodb repository"
cp ${code_dir}/configs/mongodb.repo /etc/yum.repos.d/mongo.repo &>>${log_file}

print_head "installing mongodb"
yum install mongodb-org -y &>>${log_file}

print_head "enabling mongodb"
systemctl enable mongod &>>${log_file}

print_head "restart mongodb"
systemctl restart mongod &>>${log_file}

#update /etc/mongod.conf from 127.0.0.1 to 0.0.0.0