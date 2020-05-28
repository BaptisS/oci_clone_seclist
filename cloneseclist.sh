srcseclist_id=ocid1.securitylist.oc1.eu-frankfurt-1.aaaaaaaabd6fdwc46tblehygavo3ohgd76jw6myobarbc2d7w55v6t6ij5ma
dstseclist_id=ocid1.securitylist.oc1.eu-frankfurt-1.aaaaaaaani7redyemyyfwqnd5nt2qkwe257j2az2le4d4mddexokjgwi7ecq 

rm -f src_ingress.json
rm -f src_egress.json

srcseclist_data=$(oci network security-list get --security-list-id $srcseclist_id)
#echo "[" >> src_ingress.json
echo $srcseclist_data | jq '.[] | ."ingress-security-rules"' >> src_ingress.json 
echo $srcseclist_data | jq '.[] | ."egress-security-rules"' >> src_egress.json 

oci network security-list update --security-list-id $dstseclist_id --ingress-security-rules file://src_ingress.json  --egress-security-rules file://src_egress.json --force

