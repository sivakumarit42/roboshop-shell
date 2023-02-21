source common.sh


print_head "installing redis repository file"
yum install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y &>>${log_file}
status_check $?

print_head "Enable the 6.2 version"
dnf module enable redis:remi-6.2 -y &>>${log_file}
status_check $?

print_head "installing redis"
yum install redis -y &>>${log_file}
status_check $?

print_head "updating listening address"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/redis.conf /etc/redis/redis.conf &>>${log_file}
status_check $?

print_head "enable redis"
systemctl enable redis &>>${log_file}
status_check $?

print_head "Restart redis"
systemctl restart redis &>>${log_file}
status_check $?
