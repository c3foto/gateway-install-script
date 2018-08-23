﻿#!/bin/bash




EntryPoint()
{
# Default Variables
blank=""
gwNameDefault="vg01"
gwVersionDefault="2.1.65"
gwPortDefault="9001"
gwModeDefault="encrypt-everything"
gwTopologyDefault="outbound"
gwInboundRelayDefault=""
gwFqdnDefault="gw.example.com"
gwDomainDefault="example.com"
gwDkimSelectorDefault="gw"
gwOutboundRelayDefault=""
gwAmplitudeTokenDefault="0000000000"
gwHmacNameDefault="0000000000"
gwHmacSecretDefault="0000000000"




# Final Variables
gwName=""
gwVersion=""
gwPort=""
gwMode=""
gwTopology=""
gwInboundRelay=""
gwFqdn=""
gwDkimSelector=""
gwOutboundRelay=""
gwAmplitudeToken=""
gwHmacName=""
gwHmacSecret=""




# Working Variables
tlsPath=""
tlsKeyFile=""
tlsKeyFull=""
tlsPemFile=""
tlsPemFull=""
dkimPath=""
dkimPrivateFull=""
dkimPublicFull=""
scriptFile=""




# Actions
ShowLogo
GetGwName $gwNameDefault
GetGwVersion $gwVersionDefault
GetGwPort $gwPortDefault
GetGwMode $gwModeDefault
GetGwTopology $gwTopologyDefault
GetGwInboundRelay $gwInboundRelayDefault
GetGwFqdn $gwFqdnDefault
GetGwDomain $gwDomainDefault
GetGwDkimSelecotr $gwDkimSelectorDefault
GetGwOutboundRelay $gwOutboundRelayDefault
GetGwAmplitudeToken $gwAmplitudeTokenDefault
GetGwHmacName $gwHmacNameDefault
GetGwHmacSecret $gwHmacSecretDefault




MakeTlsPathVariables
MakeDkimPathVariables
MakeDirectories
MakeTlsCert
MakeDkimCert
WriteEnv
WriteScript
clear
ShowLogo
ShowNextSteps


}






## Functions
GetGwName() {
 local input=""
 read -p "Gateway Name [$1]: " input


 case "$input" in
   $blank )
     gwName=$1
   ;;
   * )
     gwName=$input
   ;;
 esac
 echo " "
}


GetGwVersion() {
 local input=""
 read -p "Gateway Version [$1]: " input


 case "$input" in
   $blank )
     gwVersion=$1
   ;;
   * )
     gwVersion=$input
   ;;
 esac
 echo " "
}


GetGwPort() {
local input=""
 read -p "Gateway Port [$1]: " input


 case "$input" in
   $blank )
     gwPort=$1
   ;;
   * )
     gwPort=$input
   ;;
 esac
 echo " "
}


GetGwMode() {
 local input=""
 echo "Gateway Mode"
 echo "  Options"
 echo "  1 - encrypt-everything"
 echo "  2 - decrypt-everything"
 echo "  3 - dlp"
 echo " "
 read -p "Enter 1-3 [$1]: " input


 case "$input" in
   $blank )
     gwMode=$1
   ;;
   1 )
     gwMode="encrypt-everything"
   ;;
   2 )
     gwMode="decrypt-everything"
   ;;
   3 )
     gwMode="dlp"
   ;;
   * )
     gwMode=$1
   ;;
 esac
 echo " "
}


GetGwTopology() {
 local input=""
 echo "Gateway Topology"
 echo "  Options"
 echo "  1 - inbound"
 echo "  2 - outbound"
 echo " "
 read -p "Enter 1-2 [$1]: " input


 case "$input" in
   $blank )
     gwTopology=$1
   ;;
   1 )
     gwTopology="inbound"
   ;;
   2 )
     gwTopology="outbound"
   ;;
   * )
     gwTopology=$1
   ;;
 esac
 echo " "
}


GetGwInboundRelay() {
 local input=""
 echo "Inbound Relay Addresses"
 echo "Options"
 echo " 1 - G Suite"
 echo " 2 - O365"
 echo " 3 - All"
 echo " 4 - None"
 read -p  "Enter (1-4) [$1]: " input


 case "$input" in
   $blank )
     gwInboundRelay=$1
   ;;
   1 )
    gwInboundRelay="GATEWAY_RELAY_ADDRESSES=64.18.0.0/20,64.233.160.0/19,66.102.0.0/20,66.249.80.0/20,72.14.192.0/18,74.125.0.0/16,108.177.8.0/21,173.194.0.0/16,207.126.144.0/20,209.85.128.0/17,216.58.192.0/19,216.239.32.0/19,172.217.0.0/19,108.177.96.0/19"
   ;;
   2 )
     gwInboundRelay="GATEWAY_RELAY_ADDRESSES=23.103.132.0/22,23.103.136.0/21,23.103.144.0/20,23.103.198.0/23,23.103.200.0/22,23.103.212.0/22,40.92.0.0/14,40.107.0.0/17,40.107.128.0/18,52.100.0.0/14,65.55.88.0/24,65.55.169.0/24,94.245.120.64/26,104.47.0.0/17,104.212.58.0/23,134.170.132.0/24,134.170.140.0/24,157.55.234.0/24,157.56.110.0/23,157.56.112.0/24,207.46.51.64/26,207.46.100.0/24,207.46.163.0/24,213.199.154.0/24,213.199.180.128/26,216.32.180.0/23"
   ;;
   3 )
     gwInboundRelay="GATEWAY_RELAY_ADDRESSES=0.0.0.0/0"
   ;;
   4 )
     gwInboundRelay="GATEWAY_RELAY_ADDRESSES="
   ;;
   * )
     gwInboundRelay="GATEWAY_RELAY_ADDRESSES=$1"
   ;;
 esac
 echo " "
}


GetGwFqdn() {
 local input=""
 read -p "Gateway FQDN [$1]: " input


 case "$input" in
   $blank )
     gwFqdn=$1
   ;;
   * )
     gwFqdn=$input
   ;;
 esac
 echo " "
}


GetGwDomain() {
 local input=""
 read -p "Gateway Domain [$1]: " input


 case "$input" in
   $blank )
     gwDomain=$1
   ;;
   * )
     gwDomain=$input
   ;;
 esac
 echo " "
}


GetGwOutboundRelay() {
 local input=""
 echo "Outbound Relay"
 echo "  Blank (Gateway performs final delivery)"
 echo "  [smtp-relay.example.com]:587 (Gateway sends all mail to relay for delivery)"
 read -p "Enter Relay Address []: " input


 case "$input" in
   $blank )
     gwOutboundRelay="# GATEWAY_TRANSPORT_MAPS=*=>$1"
   ;;
   * )
     gwOutboundRelay="GATEWAY_TRANSPORT_MAPS=*=>$input"
   ;;
 esac
 echo " "
}


GetGwDkimSelecotr() {
 local input=""
 read -p "Gateway DKIM Selector [$1]: " input


 case "$input" in
   $blank )
     gwDkimSelector=$1
   ;;
   * )
     gwDkimSelector=$input
   ;;
 esac
 echo " "
}


GetGwAmplitudeToken() {
 local input=""
 read -p "Amplitude Token (Provided by Virtru) [$1]: " input


 case "$input" in
   $blank )
     gwAmplitudeToken=$1
   ;;
   * )
     gwAmplitudeToken=$input
   ;;
 esac
 echo " "
}


GetGwHmacName() {
 local input=""
 read -p "HMAC Name (Provided by Virtru) [$1]: " input


 case "$input" in
   $blank )
     gwHmacName=$1
   ;;
   * )
     gwHmacName=$input
   ;;
 esac
 echo " "
}


GetGwHmacSecret() {
 local input=""
 read -p "HMAC Secret (Provided by Virtru) [$1]: " input


 case "$input" in
   $blank )
     gwHmacSecret=$1
   ;;
   * )
     gwHmacSecret=$input
   ;;
 esac
 echo " "
}




MakeTlsPathVariables() {
  tlsPath="/var/virtru/vg/tls/$gwFqdn"
  tlsKeyFile="client.key"
  tlsKeyFull="$tlsPath/$tlsKeyFile"
  tlsPemFile="client.pem"
  tlsPemFull="$tlsPath/$tlsPemFile"
}


MakeDkimPathVariables() {
  dkimPath="/var/virtru/vg/dkim"
  dkimPrivateFull="$dkimPath/$gwDkimSelector"
  dkimPrivateFull="$dkimPrivateFull._domainkey.$gwDomain.pem"
  dkimPublicFull="$dkimPath/$gwDkimSelector._domainkey.$gwDomain-public.pem"
}


MakeDirectories(){
  mkdir -p /var/virtru/vg/
  mkdir -p /var/virtru/vg/env
  mkdir -p /var/virtru/vg/scripts
  mkdir -p /var/virtru/vg/test
  mkdir -p /var/virtru/vg/tls
  mkdir -p $tlsPath
  mkdir -p /var/virtru/vg/dkim
}


MakeTlsCert(){
## Make TLS Certs
openssl genrsa -out $tlsKeyFull 2048
openssl req -new -key $tlsKeyFull -x509 -subj /CN=$gwFqdn -days 3650 -out $tlsPemFull


}


MakeDkimCert(){
openssl genrsa -out $dkimPrivateFull 1024 -outform PEM
openssl rsa -in $dkimPrivateFull -out $dkimPublicFull -pubout -outform PEM
}


ShowLogo() {
echo " "
echo "                      +++                '++."
echo "                      +++                ++++"
echo "                                         ++++"
echo "     ,:::      +++    +++     :+++++++   +++++++    .+++++++   .++     '++"
echo "     ++++     .+++.  '+++    ++++++++++  ++++++++  ++++++++++  ++++    ++++"
echo "     ++++     ++++   ++++    +++++''++   +++++++   +++++++++   ++++    ++++"
echo "     ++++   .++++    ++++    ++++        ++++      ++++        ++++    ++++"
echo "     ++++  .++++     ++++    ++++        ++++      ++++        ++++    ++++"
echo "     ++++ ++++       ++++    ++++        ++++      ++++        ++++    ++++"
echo "     ++++++          ;+++    ++++        ++++      ++++          ++++++++"
echo "     ++++             +++     ++'         ++        ++'           .++++"
echo " "
echo "   S   i   m   p   l   e      E   m   a   i   l      P   r   i   v   a   c   y"
echo " "
echo " "




}
WriteEnv() {
  envFile=/var/virtru/vg/env/$gwName.env




/bin/cat <<EOM >$envFile
# Enable verbose logging in Gateway. 
# Values
#   Enable: 1
#   Disable: 0
# Default: 0
# Required: No
# Note: Set this to 0 unless you are debugging something.
#
GATEWAY_VERBOSE_LOGGING=0




# Domain name of organization
# Values
#   Domain
# Required: Yes
#
GATEWAY_ORGANIZATION_DOMAIN=$gwDomain




# Comma delimited list of trusted networks in CIDR formate.
# Inbound addresses allowed to connect to the gateway
# Values (examples)
#   All IP: 0.0.0.0/0
#   2 IP: 2.2.2.2/32,2.2.2.3/32
# Required: Yes
#
$gwInboundRelay




# Enable Proxy Protocol for SMTP.
# For use behind a load balancer.
# Values
#   Enable: 1
#   Disable: 0
# Default: 1
# Required: No
#
GATEWAY_PROXY_PROTOCOL=0




# Comma delimited set of domains and next-hop destinations and optional ports
# Values
#   Not defined/Commented out - Final delivery by MX
#   GATEWAY_TRANSPORT_MAPS=*=>[Next hop FQDN]:port
# Default: Not defined/Commented out - Final delivery by MX
# Required: No
#
# Examples:
# GATEWAY_TRANSPORT_MAPS=*=>[smtp-relay.gmail.com]:587
# GATEWAY_TRANSPORT_MAPS=*=>[MX Record]:25
# GATEWAY_TRANSPORT_MAPS=*=>[1.1.1.]:25
#
$gwOutboundRelay




# The mode for the Gateway.
# Values
#    decrypt-everything
#    encrypt-everything
#    dlp - Use rules defined on Virtru Dashboard (https://secure.virtru.com/dashboard)
# Default: encrypt-everything
# Required: Yes
#
GATEWAY_MODE=$gwMode




# Topology of the gateway.
# Values
#   outbound
#   inbound
# Default: outbound
# Required: Yes
GATEWAY_TOPOLOGY=$gwTopology




# URL to Virtru's ACM service.
# Required: Yes
# Note: Do not change this.
#
GATEWAY_ACM_URL=https://acm.virtru.com




# URL to Virtru's Accounts service.
# Required: Yes
# Note: Do not change this.
#
GATEWAY_ACCOUNTS_URL=https://accounts.virtru.com




# The base URL for remote content.
# Required: Yes
# Note: Do not change this.
#
GATEWAY_REMOTE_CONTENT_BASE_URL=https://secure.virtru.com/start




# DKIM certificate information
# Values
#   Not defined/Commented out - Gateway will not perform any DKIM signing
#   Complete record for DKIM signing
# Required: No
# Example:
# GATEWAY_DKIM_DOMAINS=gw._domainkey.example.com
#
# GATEWAY_DKIM_DOMAINS=$gwDkimSelector._domainkey.$gwDomain




# HMAC Token Name to connect to Virtru services such as Accounts and ACM.
# Values
#   Value provided by Virtru
# Required: Yes
# Note:Contact Virtru Support for getting your token Name.
#
GATEWAY_API_TOKEN_NAME=$gwHmacName




# HMAC Token Secret to connect to Virtru services such as Accounts and ACM.
# Values
#   Value provided by Virtru
# Required: Yes
# Note:Contact Virtru Support for getting your Token Secret.
#
GATEWAY_API_TOKEN_SECRET=$gwHmacSecret




# Amplitude Token to connect to the Virtru Events platform
# Values
#   Value provided by Virtru
# Required: Yes
# Note:Contact Virtru Support for getting your Token.
#
GATEWAY_AMPLITUDE_API_KEY=$gwAmplitudeToken




# Consider a message as undeliverable, when delivery fails with a temporary error, and the time in the queue
# has reached the maximal_queue_lifetime limit.
# Time units: s (seconds), m (minutes), h (hours), d (days), w (weeks). The default time unit is d (days).
# Postfix default is '5d'. Set this ENV variable if default does not work.
# Values
#   NumberUnits
# Default: 5d
# Required: No
# Note: Specify 0 when mail delivery should be tried only once.
#
MAX_QUEUE_LIFETIME=5m




# The maximal time between attempts to deliver a deferred message.
# Values
#   NumberUnits
# Default: 4000s
# Required: No
# Note: Set to a value greater than or equal to MIN_BACKOFF_TIME
#
MAX_BACKOFF_TIME=45s




# The minimal time between attempts to deliver a deferred message
# Values
#   NumberUnits
# Default: 300s
# Required: No
# Note: Set to a value greater than or equal to MIN_BACKOFF_TIME
#
MIN_BACKOFF_TIME=30s




# The time between deferred queue scans by the queue manager
# Values
#   NumberUnits
# Default: 300s
# Required: No
#
QUEUE_RUN_DELAY=30s




# Gateway Inbound
# Enable Inbound TLS to the Gateway.
# Values
#   1 Enabled
#   0 Disabled
# Default: 1
# Require: No
#
GATEWAY_SMTPD_USE_TLS=1




# Gateway Inbound
# TLS level for inbound connections
# Values
#   1 Enabled
#   0 Disabled
# Default: 1
# Require: No
#
GATEWAY_SMTPD_SECURITY_LEVEL=opportunistic




# Gateway Outbound
# Enable TLS at the Gateway.
# Values
#   1 Enabled
#   0 Disabled
# Default: 1
# Require: No
#
GATEWAY_SMTP_USE_TLS=1




# Gateway Outbound
# TLS level for outbound connections
# Values
#   none
#   madatory
#   opportunistic
# Require: No
#
GATEWAY_SMTP_SECURITY_LEVEL=opportunistic




# Gateway Outbound
# Outbound TLS requirements for a domain.  Comma separated list.
# Example
#   example.com=>none
#   example.net=>maybe
#   example.org=>encrypt
# GATEWAY_SMTP_TLS_POLICY_MAPS=example.com=>none,example.net=>maybe
#
# GATEWAY_SMTP_TLS_POLICY_MAPS=




# New Relic Key
# Customer provided key to log events in customer's New Relic Tenant
# Values
#   Provided by New Relic
# Required: No
# GATEWAY_NEWRELIC_CRED=








EOM




}


WriteScript() {
echo $gwVersion
  echo "script"
  scriptFile=/var/virtru/vg/scripts/setup-$gwName.sh


  /bin/cat <<EOM >$scriptFile
docker run \\
--env-file /var/virtru/vg/env/$gwName.env \\
-v /var/virtru/vg/tls/:/etc/postfix/tls \\
-v /var/virtru/vg/dkim/:/etc/opendkim/keys \\
--hostname $gwFqdn \\
--publish $gwPort:25 \\
--interactive --tty --detach \\
--restart unless-stopped \\
--log-opt max-size=10m \\
--log-opt max-file=100 \\
virtru/gateway:$gwVersion
EOM




chmod +x $scriptFile




}
ShowNextSteps() {
  echo "next steps"
  echo "-----------------------"
  echo " Deploy Successful!"
  echo " Next Steps:"
  echo " "
  echo " run: docker login"
  echo " run: sh $scriptFile"
  echo "-----------------------"
}












# Entry Point




clear
EntryPoint