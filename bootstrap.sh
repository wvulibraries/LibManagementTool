#!/bin/bash

## Variables
RUBY_VERSION='2.3.0'
APP_NAME="LibraryManagementTool"

## SERVER CONFIGURATION
echo "Updating OS and YUM"
echo " -------------------------------------------------------------------------- "

yum -y update

echo "Installing Developer Tools ... "
echo " -------------------------------------------------------------------------- "

yum groupinstall -y "Development Tools"
yum install -y kernel-devel kernel-headers
yum install -y openssl openssl-devel
yum install -y libcurl-devel
yum install -y gcc gcc-c++ make
yum install -y zlib-devel
yum install -y readline-devel
yum install -y ntp git vim emacs

echo "Change server time to Eastern"
ln -s /usr/share/zoneinfo/US/Eastern /etc/localtime


echo "Installing mysql ... "
echo " -------------------------------------------------------------------------- "
rpm -Uvh http://repo.mysql.com/mysql-community-release-el7-5.noarch.rpm
yum -y install mysql-community-server mysql-community-client mysql-community-devel mysql-community-common mysql-community-libs mysql-community-release

echo "Setting Up MySQL."

systemctl enable mysqld
systemctl restart mysqld

echo "Installing redis ... "
echo " -------------------------------------------------------------------------- "

yum --enablerepo=epel -y install redis

echo "Installing memcached ... "
echo " -------------------------------------------------------------------------- "

rpm -Uvh http://apt.sw.be/redhat/el5/en/x86_64/rpmforge/RPMS/rpmforge-release-0.5.2-2.el5.rf.x86_64.rpm
yum install memcached

echo "installing Ruby and RVM ... "
echo " -------------------------------------------------------------------------- "

gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
curl -sSL https://get.rvm.io | bash -s stable --ruby

echo "Installing Ruby Enviornment using the RVM ... "
echo " -------------------------------------------------------------------------- "

if [ ! -e ~/.rbenv ]; then
  git clone https://github.com/sstephenson/rbenv.git ~/.rbenv
  git clone https://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build

  echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bash_profile
  echo 'eval "$(rbenv init -)"' >> ~/.bash_profile

  source ~/.bash_profile
  echo "rbenv(`rbenv --version`) installed"
fi

source /home/vagrant/.rvm/scripts/rvm

yum -y install libffi-devel
rbenv install ${RUBY_VERSION}
rbenv global ${RUBY_VERSION}
rbenv rehash

echo "installing node"
echo " -------------------------------------------------------------------------- "

curl --silent --location https://rpm.nodesource.com/setup_4.x | bash -
yum -y install nodejs


echo " Change ownership so vagrant user can install gems and such "
sudo chown -R vagrant /usr/local/

# VIEW README AND COMMENT OUT NEW RAILS APP AFTER INITIAL APPLICATION STRUCTURE IS CREATED.
