source common.sh
source status_check.sh

print_head "installing redis repository file"
yum install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y &>>${log_file}
status_check $?

print_head "Enable the version"
dnf module enable redis:remi-6.2 -y &>>${log_file}
status_check $?

print_head "installing redis"
yum install redis -y
status_check $?

print_head "updating listening address"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/redis.conf /etc/redis/redis.conf
status_check $?

print_head "enable redis"
systemctl enable redis
status_check $?

print_head "Restart redis"
systemctl restart redis
status_check $?