#!/bin/bash
echo ""
echo "Please provide the SOURCE security list OCID :" 
read srcseclist_id
echo ""
echo "Please provide the DESTINATION security list OCID :"
echo "Important : Destination Security list will be overwritten with the content of the source SL" 
read dstseclist_id

rm -f src_ingress.json
rm -f src_egress.json

srcseclist_data=$(oci network security-list get --security-list-id $srcseclist_id)
#echo "[" >> src_ingress.json
echo $srcseclist_data | jq '.[] | ."ingress-security-rules"' >> src_ingress.json 
echo $srcseclist_data | jq '.[] | ."egress-security-rules"' >> src_egress.json 

oci network security-list update --security-list-id $dstseclist_id --ingress-security-rules file://src_ingress.json  --egress-security-rules file://src_egress.json --force

rm -f src_ingress.json
rm -f src_egress.json
