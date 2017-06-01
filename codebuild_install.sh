#!/usr/bin/env bash
 
echo "~~~ Updating packages"
apt-get -qq update
 
echo "~~~ Purging maven, maven2"
apt-get -qq purge maven maven2
 
echo "~~~ Installing add-apt-repository command"
apt-get -qq install -y software-properties-common
 
echo "~~~ Adding Java 8 repository"
add-apt-repository ppa:openjdk-r/ppa
 
echo "~~~ Updating after adding repo"
apt-get -qq update
 
apt-get -qq install -y openjdk-8-jdk

export JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk-amd64
 
echo "~~~ Download Maven 3.3.9"
wget --quiet http://apache.claz.org/maven/maven-3/3.3.9/binaries/apache-maven-3.3.9-bin.tar.gz
 
echo "~~~ Unpacking Maven"
tar xzf apache-maven-3.3.9-bin.tar.gz -C /usr/bin