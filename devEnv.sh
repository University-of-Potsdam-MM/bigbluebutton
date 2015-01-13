#!/usr/bin/env bash

sudo apt-get install --fix-missing -y ant openjdk-6-jdk 

mkdir -p /vagrant/tools
cd /vagrant/tools

if [ ! -d "/vagrant/tools/gradle-0.8" ]; then  
	wget http://bigbluebutton.googlecode.com/files/gradle-0.8.tar.gz
	tar xvfz gradle-0.8.tar.gz
	rm gradle-0.8.tar.gz
fi
if [ ! -d "/vagrant/tools/groovy-1.6.5" ]; then
	wget http://bigbluebutton.googlecode.com/files/groovy-1.6.5.tar.gz
	tar xvfz groovy-1.6.5.tar.gz
	rm groovy-1.6.5.tar.gz
fi
if [ ! -d "/vagrant/tools/grails-1.3.9" ]; then
	wget https://bigbluebutton.googlecode.com/files/grails-1.3.9.tar.gz
	tar xvfz grails-1.3.9.tar.gz
	rm grails-1.3.9.tar.gz
fi
if [ ! -d "/vagrant/tools/flex" ]; then
	wget http://fpdownload.adobe.com/pub/flex/sdk/builds/flex4.5/flex_sdk_4.5.0.20967_mpl.zip
	mkdir -p /vagrant/tools/flex
	unzip flex_sdk_4.5.0.20967_mpl.zip -d flex
	rm flex_sdk_4.5.0.20967_mpl.zip
	sudo find /vagrant/tools/flex -type d -exec chmod o+rx '{}' \;
	chmod 755 /vagrant/tools/flex/bin/*
	sudo chmod -R +r /vagrant/tools/flex
	# mv /vagrant/tools/flex-4.5.0.20967 /vagrant/tools/flex
	mkdir -p flex/frameworks/libs/player/11.2
	cd flex/frameworks/libs/player/11.2
	wget http://download.macromedia.com/get/flashplayer/updaters/11/playerglobal11_2.swc
	mv -f playerglobal11_2.swc playerglobal.swc
fi

#export PATH=$PATH:$GRADLE_HOME/bin:$GROOVY_HOME/bin:$FLEX_HOME/bin:$GRAILS_HOME/bin # would be a nicer than the hard coded Path extension..
echo "export GROOVY_HOME=/vagrant/tools/groovy-1.6.5
export GRAILS_HOME=/vagrant/tools/grails-1.3.9
export FLEX_HOME=/vagrant/tools/flex
export GRADLE_HOME=/vagrant/tools/gradle-0.8
export PATH=$PATH:/vagrant/tools/gradle-0.8/bin:/vagrant/tools/groovy-1.6.5/bin:/vagrant/tools/flex/bin:/vagrant/tools/grails-1.3.9/bin
export JAVA_HOME=/usr/lib/jvm/java-6-openjdk-amd64
export ANT_OPTS='-Xmx512m -XX:MaxPermSize=512m'" | sudo tee -a ~/.bashrc
source ~/.bashrc

# sudo touch /etc/profile.d/pathsetup.sh
# echo "export PATH=$PATH:$GRADLE_HOME/bin:$GROOVY_HOME/bin:$FLEX_HOME/bin:$GRAILS_HOME/bin" | sudo tee -a /etc/profile.d/pathsetup.sh

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