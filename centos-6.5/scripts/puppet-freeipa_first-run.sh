#!/bin/bash
####### PUPPET NODE ##################################################
# Spark Digital Ventures
# Greg Duraj greg@sparkventures.co.nz 
########################################
#
echo -n "thou shalt install puppet..."
#
yum -y install http://yum.puppetlabs.com/puppetlabs-release-el-7.noarch.rpm  | tee -a /tmp/install.log
yum -y install puppet epel-release nano | tee -a /tmp/install.log
#
echo "and EPEL - EEEEEEEEEEPEL"
#
### freeIPA trickery - cleaning and setting up the hosts file ####
# because CentOS is AWSUM.. we need  to check what version we're running
CENTOS_VERSION=`cat /etc/centos-release | grep -e "6\.${1,2,3,4,5,6,7,8,9,0}"`
if [ -n "$CENTOS_VERSION" ] 
 then
  IP_ADDR=`ifconfig | grep "inet addr" | grep -v "127.0.0.1" | awk '{print $2}' | sed -e s/addr://g ` 
 else 
  IP_ADDR=`ifconfig | grep "broadcast" | grep -v "127.0.0.1" | awk '{print $2}' `
fi
#
LH_V4=`cat /etc/hosts | grep "127.0.0.1"`
LH_V6=`cat /etc/hosts | grep "::1"`
#
echo "# file modified for puppet-master compabitility " >/etc/hosts
echo "$LH_V4">>/etc/hosts
echo "$LH_V6">>/etc/hosts
echo "10.100.161.202 puppet.corp.qrious.co.nz puppet">>/etc/hosts
echo "$IP_ADDR ipa.corp.qrious.co.nz ipa">>/etc/hosts
#
hostname ipa.corp.qrious.co.nz
#
echo -e " YOU CAN TRY RUING THE AGENT NOW \n"
puppet agent -t -d | tee -a /tmp/install.log 
echo -e "and again!"
puppet agent -t -d | tee -a /tmp/install.log
echo -e "3rd time's the charm"
puppet agent -t -d | tee -a /tmp/install.log
########### EOF  #############


