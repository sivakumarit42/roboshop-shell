code_dir=$(pwd)

echo -e "\e[35mInstalling nginx\e[0m"
yum install nginx -y

echo -e "\e[35mRemoving Old Content\e[0m"
rm -rf /usr/share/nginx/html/*

echo -e "\e[35mDownloading Frontend Content\e[0m"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip

echo -e "\e[35mExtracting Downloaded Frontend\e[0m"
cd /usr/share/nginx/html
unzip /tmp/frontend.zip

echo -e "\e[35mCopying Nginx Config for RoboShop\e[0m"
cp ${code_dir}/configs/nginx-roboshop.conf /etc/nginx/default.d/roboshop.conf

## inside  the roboshop-shell directory only the configs file is available, so we have to change the location so we used
## -the variable code-dir which is already declared


echo -e "\e[35mEnabling nginx\e[0m"
systemctl enable nginx

echo -e "\e[35mStarting nginx\e[0m"
systemctl restart nginx


## If any command is errored or failed, we need to stop the script

