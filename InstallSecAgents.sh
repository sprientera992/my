#!/bin/bash
#fire_eye
sudo mkdir /tmp/xagt
sudo cd /tmp/xagt
sudo wget -O IMAGE_HX_AGENT_LINUX_33.46.0.tgz "https://sah3esrchdevtest01.blob.core.windows.net/fire-eye/IMAGE_HX_AGENT_LINUX_33.46.0.tgz?sp=r&st=2021-10-15T12:38:13Z&se=2022-04-01T20:38:13Z&spr=https&sv=2020-08-04&sr=b&sig=s2r5OKefZhfw7T4e5Zk8BYtkQD7RLSveDzeY73NgD2A%3D"
sudo tar zxvf IMAGE_HX_AGENT_LINUX_33.46.0.tgz
# Install the HX agent
echo Install Fire Eye agent
sudo yum localinstall -y xagt-33.46.0-1.el7.x86_64.rpm
# Run agent_config from Parameter Store param
echo Set config file
sudo /opt/fireeye/bin/xagt -i agent_config.json
# Start HX service
echo Start Xagt agent
sudo systemctl start xagt
sudo sleep 20

#bigfix
sudo mkdir /tmp/bestmp
sudo cd /tmp/bestmp
sudo curl --output bigfix_client_linux.zip "https://emirelay.blob.core.windows.net/agent/bigfix_client_linux.zip?si=ReadOnlyforBUs&sv=2019-10-10&sr=c&sig=VJGSM%2FM5zR8OcLFzGomHB0KqxHBp6syEGkxvcd%2BKtdE%3D"
sudo unzip bigfix_client_linux.zip
sudo chmod a+x install_azure.sh
sudo ./install_azure.sh $FQDN
sudo sleep 20s



ACTIVATIONURL='dsm://trend-dsm-hb.secops.aws.thomsonreuters.com:443/'
MANAGERURL='https://trend-dsm.secops.aws.thomsonreuters.com:443'
CURLOPTIONS='--silent --tlsv1.2'
linuxPlatform='';
isRPM='';

if [[ $(/usr/bin/id -u) -ne 0 ]]; then
echo You are not running as the root user. Please try again with root privileges.;
logger -t You are not running as the root user. Please try again with root privileges.;
exit 1;
fi;

rm -f /tmp/PlatformDetection
rm -f /tmp/agent.*

if ! type curl >/dev/null 2>&1; then
echo "Please install CURL before running this script."
logger -t Please install CURL before running this script
exit 1
fi

curl $MANAGERURL/software/deploymentscript/platform/linuxdetectscriptv1/ -o /tmp/PlatformDetection $CURLOPTIONS --insecure
curlRet=$?

if [[ $curlRet == 0 && -s /tmp/PlatformDetection ]]; then
. /tmp/PlatformDetection
elif [[ $curlRet -eq 60 ]]; then
echo "TLS certificate validation for the agent package download has failed. Please check that your Deep Security Manager TLS certificate is signed by a trusted root certificate authority. For more information, search for \"deployment scripts\" in the Deep Security Help Center."
logger -t TLS certificate validation for the agent package download has failed. Please check that your Deep Security Manager TLS certificate is signed by a trusted root certificate authority. For more information, search for \"deployment scripts\" in the Deep Security Help Center.
exit 1;
else
echo "Failed to download the agent installation support script."
logger -t Failed to download the Deep Security Agent installation support script
exit 1
fi

platform_detect
if [[ -z "${linuxPlatform}" ]] || [[ -z "${isRPM}" ]]; then
echo Unsupported platform is detected
logger -t Unsupported platform is detected
exit 1
fi

echo Downloading agent package...
if [[ $isRPM == 1 ]]; then package='agent.rpm'
else package='agent.deb'
fi
curl -H "Agent-Version-Control: on" $MANAGERURL/software/agent/${runningPlatform}${majorVersion}/${archType}/$package?tenantID= -o /tmp/$package $CURLOPTIONS --insecure
curlRet=$?
isPackageDownloaded='No'
if [ $curlRet -eq 0 ];then
if [[ $isRPM == 1 && -s /tmp/agent.rpm ]]; then
file /tmp/agent.rpm | grep "RPM";
if [ $? -eq 0 ]; then
isPackageDownloaded='RPM'
fi
elif [[ -s /tmp/agent.deb ]]; then
file /tmp/agent.deb | grep "Debian";
if [ $? -eq 0 ]; then
isPackageDownloaded='DEB'
fi
fi
fi

echo Installing agent package...
rc=1
if [[ ${isPackageDownloaded} = 'RPM' ]]; then
rpm -ihv /tmp/agent.rpm
rc=$?
elif [[ ${isPackageDownloaded} = 'DEB' ]]; then
dpkg -i /tmp/agent.deb
rc=$?
else
echo Failed to download the agent package. Please make sure the package is imported in the Deep Security Manager
logger -t Failed to download the agent package. Please make sure the package is imported in the Deep Security Manager
exit 1
fi
if [[ ${rc} != 0 ]]; then
echo Failed to install the agent package
logger -t Failed to install the agent package
exit 1
fi

echo Install the agent package successfully

sleep 15
/opt/ds_agent/dsa_control -r
/opt/ds_agent/dsa_control -a $ACTIVATIONURL
# /opt/ds_agent/dsa_control -a dsm://trend-dsm-hb.secops.aws.thomsonreuters.com:443/
