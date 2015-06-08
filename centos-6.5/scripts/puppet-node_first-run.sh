#!/bin/bash
####### PUPPET NODE ##################################################
# Spark Digital Ventures
# Greg Duraj greg@sparkventures.co.nz 
########### BACIS SYSTEM ENV VARIABLES AND SETTINGS ###################
echo "# file modified for puppet-master compabitility " >>/etc/hosts 
echo "10.100.161.202 puppet.corp.qrious.co.nz puppet">>/etc/hosts 
#
# clearing the IPTABLES... stuff will break if we won't, seriously...
/sbin/iptables -F
#
yum -y install epel-release | tee -a /tmp/install.log
yum -y install perl nano openssh-clients  | tee -a /tmp/install.log
#
echo -n "thou shalt install puppet..."
yum -y install http://yum.puppetlabs.com/puppetlabs-release-el-6.noarch.rpm  | tee -a /tmp/install.log
yum -y install puppet  | tee -a /tmp/install.log
#----------------
#
echo -e " YOU CAN TRY RUING THE AGENT NOW \n"
puppet agent -t -d | tee -a /tmp/install.log
echo -e	"and again!"
puppet agent -t -d | tee -a /tmp/install.log
echo -e "3rd time's the charm"
puppet agent -t -d | tee -a /tmp/install.log
########### EOF  #############


