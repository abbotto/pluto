#!/bin/bash
# Pluto: Pentesting Suite for Ubuntu/Raspbian Distributions
# Created by Jared Abbott: @o0110o

echo "-------------------------------------------------------------"
echo "  ________   ___        ___  ___   _________   ________      "
echo " |\   __  \ |\  \      |\  \|\  \ |\___   ___\|\   __  \     "
echo " \ \  \|\  \\ \  \     \ \  \\\  \\|___ \  \_|\ \  \|\  \    "
echo "  \ \   ____\\ \  \     \ \  \\\  \    \ \  \  \ \  \\\  \   "
echo "   \ \  \___| \ \  \____ \ \  \\\  \    \ \  \  \ \  \\\  \  "
echo "    \ \__\     \ \_______\\ \_______\    \ \__\  \ \_______\ "
echo "     \|__|      \|_______| \|_______|     \|__|   \|_______| "
echo ""
echo "-------------------------------------------------------------"
echo ""
echo " === Release 0.1.0 === "
echo " === Jared Abbott | @o0110o === "
echo " === A comprehensive security pentesting suite for Ubuntu/Raspbian ==="
echo " === See README.md for more information ==="
echo ""
echo "-------------------------------------------------------------"
echo ""
echo "Press CTRL+C to abort."
echo ""
echo "-------------------------------------------------------------"
echo ""

echo "Setting Owner: $1"
echo "Creating the Pentest Directory..."
mkdir /opt/pentest
mkdir /opt/pentest/tmp

echo "Updating the Repository..."
apt-get update

echo "Installing Applications From the Repository..."
echo "Now Installing: lsb-release perl python libpcap-dev libpq-dev libsqlite3-dev dnstracer hostapd btscanner dsniff python-twisted-web python-pymssql tcpdump hping3 nbtscan ptunnel ngrep tcpflow proxychains proxytunnel siege netcat iodine smbclient sslsniff tcptraceroute netdiscover udptunnel ssldump xprobe python-scapy w3af subversion ettercap-text-only nikto nbtscan medusa ratproxy sslscan netwox darkstat reaver ipcalc rsync xrdp fping ike-scan darkstat netdiscover iw avahi-daemon netmask dnswalk hydra openjdk-7-jre openjdk-7-jdk lynis libssl-dev libnl1 libnl-3-200 libnl-genl-3-200 libcurl4-gnutls-dev python-lxml libxml2 libncurses-dev libxml2-dev libxslt1-dev ruby-dev skipfish wapiti nmap macchanger wireshark kismet libnl-dev sqlite3..."
apt-get -y install lsb-release perl python libpcap-dev libpq-dev libsqlite3-dev dnstracer hostapd btscanner dsniff python-twisted-web python-pymssql tcpdump hping3 nbtscan ptunnel ngrep tcpflow proxychains proxytunnel siege netcat iodine smbclient sslsniff tcptraceroute netdiscover udptunnel ssldump xprobe python-scapy w3af subversion ettercap-text-only nikto nbtscan medusa ratproxy sslscan netwox darkstat reaver ipcalc rsync xrdp fping ike-scan darkstat netdiscover iw avahi-daemon netmask dnswalk hydra openjdk-7-jre openjdk-7-jdk lynis libssl-dev libnl1 libnl-3-200 libnl-genl-3-200 libcurl4-gnutls-dev python-lxml libxml2 libncurses-dev libxml2-dev libxslt1-dev ruby-dev skipfish wapiti nmap macchanger wireshark kismet libnl-dev sqlite3

if grep --quiet "Raspbian" /etc/issue; then
	echo "Installing Raspbian Dependencies..."
	echo "Now Installing: rpi-update libruby libnl-genl-3-dev..."
	apt-get -y install rpi-update libruby libnl-genl-3-dev
	echo "Updating the R-Pi Firmware..."
	rpi-update
fi

echo "Installing Ruby Application Dependencies..."
gem install --no-ri --no-rdoc bundler

# BUNDLE SHOULD BE RUN AS A NON-ROOT USER
wget https://raw.githubusercontent.com/o0110o/pluto/master/Gemfile
touch Gemfile.lock
chown $1:$1 Gemfile
chown $1:$1 Gemfile.lock
su -c 'bundle update' $1
su -c 'bundle install' $1
rm Gemfile
rm Gemfile.lock

echo "Installing Applications From Source..."
echo "Now Installing: Aircrack..."
svn co http://svn.aircrack-ng.org/trunk/ /opt/pentest/aircrack-ng
cd /opt/pentest/aircrack-ng
make
make install
airodump-ng-oui-update
cd scripts
chmod +x airmon-ng
cp airmon-ng /usr/bin/airmon-ng
cd /opt/pentest

echo "Now Installing: Airoscript..."
svn co http://svn.aircrack-ng.org/branch/airoscript-ng/ /opt/pentest/airoscript-ng
cd airoscript-ng
make
cd /opt/pentest

echo "Now Installing: RobotsRider..."
cd /opt/pentest
git clone https://github.com/felmoltor/RobotsRider
cd RobotsRider
ruby install.3rd.party.rb
cd /opt/pentest

echo "Now Installing: TheHarvester..."
cd /opt/pentest/RobotsRider/ThirdParty
rm -rf theharvester
git clone https://github.com/MarioVilas/theHarvester
mv theHarvester theharvester
cd /opt/pentest

echo "Now Installing: Metasploit Framework..."
wget http://downloads.metasploit.com/data/releases/framework-latest.tar.bz2
tar jxpf framework-latest.tar.bz2
rm -rf framework-latest.tar.bz2
cd /opt/pentest

echo "Now Installing: Social Engineer Toolkit..."
git clone https://github.com/trustedsec/social-engineer-toolkit/
cd /opt/pentest/social-engineer-toolkit/
python setup.py install
cd /opt/pentest

echo "Now Installing: Offensive Security Expliot Database..."
git clone https://github.com/offensive-security/exploit-database
cd

echo "Now Installing: Rootkit Hunter Installer..."
touch /opt/pentest/get-rkhunter.sh
echo 'wget --content-disposition http://sourceforge.net/projects/rkhunter/files/latest/download?source=files' >> /opt/pentest/get-rkhunter.sh
echo 'tar -xvf rkhunter-*.tar.gz' >> /opt/pentest/get-rkhunter.sh
echo 'rm -rf rkhunter-*.tar.gz' >> /opt/pentest/get-rkhunter.sh
echo 'mv rkhunter-* rootkit-hunter' >> /opt/pentest/get-rkhunter.sh
echo 'cd rootkit-hunter' >> /opt/pentest/get-rkhunter.sh
echo 'sudo ./installer.sh --layout default --install' >> /opt/pentest/get-rkhunter.sh
echo 'sudo chown $1:$1 rootkit-hunter' >> /opt/pentest/get-rkhunter.sh
echo 'cd ..' >> /opt/pentest/get-rkhunter.sh

echo "Setting the Correct Application Permissions..."
chmod +x /opt/pentest/RobotsRider/robotsrider.rb
chmod +x /opt/pentest/RobotsRider/ThirdParty/wpscan/wpscan.rb
chmod +x /opt/pentest/RobotsRider/ThirdParty/plown/plown.py
chmod +x /opt/pentest/RobotsRider/ThirdParty/DPScan/DPScan.py
chmod +x /opt/pentest/RobotsRider/ThirdParty/joomscan/joomscan.pl
chmod +x /opt/pentest/RobotsRider/ThirdParty/theharvester/theHarvester.py
chmod +x /opt/pentest/get-rkhunter.sh

echo "Creating the Configuration Files..."
find /opt/pentest/RobotsRider/config -type f -exec sed -i 's/\/home\/harvester\/Tools/\/opt\/pentest\/RobotsRider\/ThirdParty/g' {} \;
find /opt/pentest/RobotsRider/config -type f -exec sed -i 's/\/opt\/pentest\/RobotsRider\/ThirdParty\/RobotsRider/\/opt\/pentest\/RobotsRider/g' {} \;
find /opt/pentest/RobotsRider/config -type f -exec sed -i 's/\/home\/felmoltor\/Tools/\/opt\/pentest/g' {} \;
find /opt/pentest/RobotsRider/config -type f -exec sed -i 's/\/theHarvester-2.2a//g' {} \;
find /opt/pentest/RobotsRider/config -type f -exec sed -i 's/\/opt\/pentest\/RobotsRider\/ThirdParty\/theHarvester.py/\/opt\/pentest\/RobotsRider\/ThirdParty\/theharvester\/theHarvester.py/g' {} \;
find /opt/pentest/RobotsRider/classes -type f -exec sed -i 's/\/tmp/\/opt\/pentest\/tmp/g' {} \;
find /opt/pentest/RobotsRider/classes -type f -exec sed -i 's/-f #{thtmpfile}/-o H #{thtmpfile}/g' {} \;
find /opt/pentest/RobotsRider/classes -type f -exec sed -i 's/h.include?/("" || h).include?/g' {} \;

echo 'Creating Aliases...'
touch /opt/pentest/RobotsRider/run.sh
chmod +x /opt/pentest/RobotsRider/run.sh
echo '#!/bin/bash' >> /opt/pentest/RobotsRider/run.sh          
echo 'DIR=$(pwd -P)' >> /opt/pentest/RobotsRider/run.sh
echo 'cd /opt/pentest/RobotsRider' >> /opt/pentest/RobotsRider/run.sh
echo 'ruby robotsrider.rb "$@"' >> /opt/pentest/RobotsRider/run.sh
echo 'cd $DIR' >> /opt/pentest/RobotsRider/run.sh
touch /home/$1/.bash_aliases
echo 'alias webscan=/opt/pentest/RobotsRider/run.sh' >> /home/$1/.bash_aliases
echo 'alias harvest=/opt/pentest/RobotsRider/ThirdParty/theharvester/theHarvester.py' >> /home/$1/.bash_aliases
echo 'alias wfuzz=/opt/pentest/RobotsRider/ThirdParty/wfuzz/wfuzz.py' >> /home/$1/.bash_aliases
echo 'alias plown=/opt/pentest/RobotsRider/ThirdParty/plown/plown.py' >> /home/$1/.bash_aliases
echo 'alias metasploit=/opt/pentest/msf3/msfconsole' >> /home/$1/.bash_aliases
echo 'alias set=setoolkit' >> /home/$1/.bash_aliases

echo 'Setting the Correct Permissions for the Current User'
chown $1:$1 /home/$1/.bash_aliases
chown -R $1:$1 /opt/pentest

echo 'Setup completed. Have Fun...'
