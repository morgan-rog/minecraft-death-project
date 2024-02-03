#!/bin/bash

# create minecraft directory
mkdir /opt/minecraft/
mkdir /opt/minecraft/server/
cd /opt/minecraft/server

# install Java
rpm -Uvh https://packages.microsoft.com/config/centos/7/packages-microsoft-prod.rpm
yum install -y msopenjdk-17

# install Git
yum install -y git

# running BuildTools
curl -o BuildTools.jar https://hub.spigotmc.org/jenkins/job/BuildTools/lastSuccessfulBuild/artifact/target/BuildTools.jar
java -jar BuildTools.jar

# initialize server
java -Xms1G -Xmx1G -XX:+UseG1GC -jar spigot-1.20.4.jar nogui
sleep 5
# eula agreement
sed -i 's/false/true/p' eula.txt

# start server
#screen -d -m -S "minecraft-screen" java Xms1G -Xmx1G -XX:+UseG1GC -jar spigot-1.20.4.jar nogui
java -Xms1G -Xmx1G -XX:+UseG1GC -jar spigot-1.20.4.jar nogui