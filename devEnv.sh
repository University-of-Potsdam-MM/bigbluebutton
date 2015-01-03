#!/usr/bin/env bash

sudo apt-get install --fix-missing -y ant openjdk-6-jdk 

mkdir -p /vagrant/tools
cd /vagrant/tools

wget http://bigbluebutton.googlecode.com/files/gradle-0.8.tar.gz
tar xvfz gradle-0.8.tar.gz

wget http://bigbluebutton.googlecode.com/files/groovy-1.6.5.tar.gz
tar xvfz groovy-1.6.5.tar.gz

wget https://bigbluebutton.googlecode.com/files/grails-1.3.9.tar.gz
tar xvfz grails-1.3.9.tar.gz

wget http://fpdownload.adobe.com/pub/flex/sdk/builds/flex4.5/flex_sdk_4.5.0.20967_mpl.zip

mkdir -p /vagrant/tools/flex-4.5.0.20967
unzip flex_sdk_4.5.0.20967_mpl.zip -d flex-4.5.0.20967

sudo find /vagrant/tools/flex-4.5.0.20967 -type d -exec chmod o+rx '{}' \;
chmod 755 /vagrant/tools/flex-4.5.0.20967/bin/*
sudo chmod -R +r /vagrant/tools/flex-4.5.0.20967

mv /vagrant/tools/flex-4.5.0.20967 /vagrant/tools/flex

mkdir -p flex-4.5.0.20967/frameworks/libs/player/11.2
cd flex-4.5.0.20967/frameworks/libs/player/11.2
wget http://download.macromedia.com/get/flashplayer/updaters/11/playerglobal11_2.swc
mv -f playerglobal11_2.swc playerglobal.swc

echo "export GROOVY_HOME=/vagrant/tools/groovy-1.6.5
export GRAILS_HOME=/vagrant/tools/grails-1.3.9
export FLEX_HOME=/vagrant/tools/flex
export GRADLE_HOME=/vagrant/tools/gradle-0.8
export PATH=$PATH:${GRADLE_HOME}/bin:${GROOVY_HOME}/bin:${FLEX_HOME}/bin:${GRAILS_HOME}/bin
export JAVA_HOME=/usr/lib/jvm/java-6-openjdk-amd64
export ANT_OPTS='-Xmx512m -XX:MaxPermSize=512m'" >> ~/.profile

source ~/.profile

cd /vagrant/
cp bigbluebutton-client/resources/config.xml.template bigbluebutton-client/src/conf/config.xml

current_ip=$(ip addr | grep 'state UP' -A2 | tail -n1 | awk '{print $2}' | cut -f1  -d'/')

# Update config.xml (replace the 192.168.1.145 with !BigBlueButton hostname/ip address)
sed -i s/HOST/${current_ip}/g bigbluebutton-client/src/conf/config.xml

echo "
location /client/BigBlueButton.html {
root /vagrant/bigbluebutton-client;
index index.html index.htm;
expires 1m;
}

# BigBlueButton Flash client.
location /client {
root /vagrant/bigbluebutton-client;
index index.html index.htm;
}
" | sudo tee /etc/bigbluebutton/nginx/client_dev 

sudo ln -f -s /etc/bigbluebutton/nginx/client_dev /etc/bigbluebutton/nginx/client.nginx

sudo service nginx restart