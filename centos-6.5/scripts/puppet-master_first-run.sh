#!/bin/bash
####### PUPPET MASTER #################################################
# Spark Digital Ventures
# Greg Duraj greg@sparkventures.co.nz 
########### BACIS SYSTEM ENV VARIABLES AND SETTINGS ###################
LH_V4=`cat /etc/hosts | grep "127.0.0.1"` 
LH_V6=`cat /etc/hosts | grep "::1"` 
echo "# file modified for puppet-master compabitility " >/etc/hosts 
echo "$LH_V4 puppet puppetdb puppet.corp.qrious.co.nz puppetdb.corp.qrious.co.nz">>/etc/hosts 
echo "$LH_V6 puppet puppetdb puppet.corp.qrious.co.nz puppetdb.corp.qrious.co.nz">>/etc/hosts
#
# clearing the IPTABLES... stuff will break if we won't, seriously...
/sbin/iptables -F
#
yum -y install epel-release | tee -a /tmp/install.log
yum -y install perl nano openssh-clients  | tee -a /tmp/install.log
#
echo -n "thou shalt install puppet..."
yum -y install http://yum.puppetlabs.com/puppetlabs-release-el-6.noarch.rpm  | tee -a /tmp/install.log
yum -y install puppet-server  | tee -a /tmp/install.log
#----------------
echo -e "[master]
# add support for feature caching - performance improvement 
always_cache_features = true 
autosign=true
storeconfigs=true 
storeconfigs_backend = puppetdb 
dns_alt_names=puppet,puppetdb,puppet.corp.qrious.co.nz,puppetdb.corp.qrious.co.nz" >>/etc/puppet/puppet.conf
#---------------
# starting puppetmaster
service puppetmaster start  | tee -a /tmp/install.log
# puppetdb after puppetmaster has been isntalled and started(we need the keys from it)
yum -y install puppetdb puppetdb-terminus  | tee -a /tmp/install.log
service puppetdb  start  | tee -a /tmp/install.log
#
echo -e "need to wait for puppetdb to start up... this takes up to 30sec"  | tee -a /tmp/install.log
for S in {1..30} ; do echo -ne "script will continue in T $[$S-30] \r" ; netstat  -napt | grep 8081 | awk '{print $7,$6,$4}' ; sleep 1; done
puppet agent --debug --test  | tee -a /tmp/install.log 
echo "at this stage we have puppet master and puppetDB running -n NOW we run git but... since we dont' have it... we run scp from the dev box"
mkdir /root/.ssh
echo "-----BEGIN RSA PRIVATE KEY-----
MIIEoAIBAAKCAQEArv55vgQETE0jdoqTEehndnp33ACegbbOk+s+sivMfn3Vj5ba
gnVu28MlYTpLSpgv6twYGlNqZKqpEG5tqoxY7ykBuixc2BzxhGMWzluRRyubtv9y
CuIK7WRMToxY9OPG6H9t1QR+0UjSx3g9RZLj05YH9FwtydMK4ULl+DbjbPGsnYx0
1Mg8geqC9ap9v49XHcmxkQi9fzfxQdRxVbLZLvQd3rOTrlcWuF4fKlVdgUx/EK3t
Rx8/LI2aqibt1k+JnVjHdhojthYYx+B2yarrS8MYEBrKNW+FLHsmTSHXAEPiqilz
z3I6D4BQiqASFZmjVh1eAZrhkP6zxfMPxnbiFQIBIwKCAQAE//TZixYQzwEDYwuE
KzYn9N7aZmrtw2T86XbR4/6HRWyAcgY+Pd6YkIwKF5vATX22QM19GFN/OBN1f395
5sC2YEHgv3Bd8jLJRKjhUxLHhOcxHT3Fy/GvAt2b2B/Me4lXGZVsfHim5NLSf8c8
gIoqneL4Wme1TywyUl5XjIonrxYYJxqbF4MJLypoi+MBktLPxMhOLPntkT15zV/r
DLt1OSx6YfBEULv5JBi4dJq+h+K10htJRfActTzKGkjLK0FkWLDbfcNeuDDnO/Zo
XHuKvEO9kBl3hdV7rZf203NxqBgaVm7elPyB1rbmB6kl/vAzgTjk7zAwukEWnWGq
MRfrAoGBANPmygZ0KreG/qp4X6uCDGt1Nb70HypBNTm+8yFjcGR6EfeEAEs3TwNJ
avjLZY2OLEQ4CRD1kqtBPB7CqsVXi1kSVTh8GumVU/b7cn/4rEb2rtVqlsoj2T44
5LDMez6hTOhTGH8Xvy+PnGXzUxX0Pxd1vGXIG1vhAaI6/ddE0D29AoGBANNpacss
Zpq5eQwyKskGcBlArI/sw2fDJ0/bzTLPhNOuERGfT28f/mBfA8Um/qfmjDv86yFM
/L/+iixF5DS32j/S42D3zYQtk3IvO0aMWcBdVv+60IS6ShcK2q7Bvc/U+669P8xJ
VIS/iOkkQNvvf7TVtjDsy+8GhitzcN488F85AoGAZuxwwU5d5Bz/Wh01yFUb+a31
iKJ1iY1i/sp2F4gSBOrVhtm2//ZK8vfGPlQqAu1Is2usodZdLpwHQiQJzZDr6W9N
9t0xpKedz7v1ySEDOGkwWQfi1zX7zcPcyub6CHo7TEWeLxopqWMC0m7fNoyTrE8g
/jyfkwbjiU/aYT6uSd8CgYAMFKb1qsQI12YAsmjYSYK/nUuwc+3orBDf/e537png
NdUW8ykcSviXyupFx7bHxAgDbYnHY3woOm5LrDjtEdH1BLyJMrtJYbCncGnJhFzm
a7vUGU2+cQuMScNacXiPiINpEiDnGiIWNtSfm6vvT4Oj7vR30wRWzSw8/0hHNq6m
WwKBgAi2/lNivgcnqGHpdCtogCMEuB1SqHtkdwphPv1pEaSDsMbim0KidEotqqCZ
UXUw4MZS3MgikuWxTECmw4Ih0Bg1bUCiXMPAcgHlehnQE/ofJdM3kNWnavdc9zg6
PE490fRJNycXVivfwibJlwEsaA13XwvNlbBpO9T30dSGWJoY
-----END RSA PRIVATE KEY----- ">/root/.ssh/id_rsa
echo "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEArv55vgQETE0jdoqTEehndnp33ACegbbOk+s+sivMfn3Vj5bagnVu28MlYTpLSpgv6twYGlNqZKqpEG5tqoxY7ykBuixc2BzxhGMWzluRRyubtv9yCuIK7WRMToxY9OPG6H9t1QR+0UjSx3g9RZLj05YH9FwtydMK4ULl+DbjbPGsnYx01Mg8geqC9ap9v49XHcmxkQi9fzfxQdRxVbLZLvQd3rOTrlcWuF4fKlVdgUx/EK3tRx8/LI2aqibt1k+JnVjHdhojthYYx+B2yarrS8MYEBrKNW+FLHsmTSHXAEPiqilzz3I6D4BQiqASFZmjVh1eAZrhkP6zxfMPxnbiFQ== root@puppet ">/root/.ssh/id_rsa.pub
echo "10.100.161.202 ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAxFOzJm6qjllk8fNl2myR2zCLUqJhXpNb/z0HZI2Fh1ssBGYkvJaNsv84Un1rxNubOJSRcfIDvT1DDiL4/HQcRpzet2f8KIErGdoO1tVg9B4jqtfdmQsWNhcz5PZtSgOciQgi6+fIRWNrp4uFUfoRRw9SkVxUap8wonk8miM3nd4jFisGcU8YO9OyxY6Ceb7/C4WfIdFJrZMKdolyDbwCeSb8hJZCQ0jtiBj89Ht2KfpqwvO/oBH05yVdv1eND11m2fmcilKVqU61pEpKOng98Ff0S+oKvCib6ZT29cmu7ox47UtRfRsgcrYBZA/bF65OeCURuQjLqjdUKK7l9TJ8ZQ== ">/root/.ssh/known_hosts
chmod 0600 /root/.ssh/id_rsa
echo "SSH keys installed"
scp -oStrictHostKeyChecking=no -r root@10.100.161.202:/etc/puppet /etc/  | tee -a /tmp/install.log
echo -e "at this stage we would have GIT repo cloned but the secrets.pp is encrypted \n so we run some pgp or ssl cript stuff on it \ then re run the puppet agent on the puppet-master to fully describe it"
#
echo -e " YOU CAN TRY RUING THE AGENT NOW \n"
puppet agent -t -d | tee -a /tmp/install.log
echo -e	"and again!"
puppet agent -t -d | tee -a /tmp/install.log
echo -e "3rd time's the charm"
puppet agent -t -d | tee -a /tmp/install.log
#
########### EOF  #############


