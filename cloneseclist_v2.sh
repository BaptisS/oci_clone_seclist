

#!/bin/bash
echo ""
echo "Please provide the SOURCE Security List OCID :" 
read srcsl_id
echo ""
echo "Please provide the DESTINATION route table OCID :"
echo "Important : Destination route table  will be overwritten with the content of the source RT" 
read dstsl_id

rm -f src_sl_egress.json
rm -f src_sl_ingress.json 

srcsl_data=$(oci network security-list get --security-list-id $srcsl_id)
echo $srcsl_data | jq '.data."egress-security-rules"'  > src_sl_egress.json 
echo $srcsl_data | jq '.data."ingress-security-rules"' > src_sl_ingress.json 

sed -i "s/destination-type/destinationType/g" src_sl_*.json 
sed -i "s/source-type/sourceType/g" src_sl_*.json 
sed -i "s/icmp-options/icmpOptions/g" src_sl_*.json 
sed -i "s/is-stateless/isStateless/g" src_sl_*.json 
sed -i "s/tcp-options/tcpOptions/g" src_sl_*.json 
sed -i "s/destination-port-range/destinationPortRange/g" src_sl_*.json
sed -i "s/source-port-range/sourcePortRange/g" src_sl_*.json
sed -i "s/udp-options/udpOptions/g" src_sl_*.json

oci network security-list update --security-list-id $dstsl_id --egress-security-rules file://src_sl_egress.json --ingress-security-rules file://src_sl_ingress.json --force
