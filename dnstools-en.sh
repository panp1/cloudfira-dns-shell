#!/bin/bash

while true; do

echo ""
echo "###########################################################################################"
echo "#  Select an option:"
echo "--------------------------------------------------------------------------------------------"
echo "#  1. List DNS records"
echo "#  2. Add DNS record"
echo "#  3. Delete DNS records"
echo "#  4. exit"
echo "###########################################################################################"
echo ""
echo "###########################################################################################"

read -p "Input option: " choice
echo ""
case $choice in
    1)
        echo "List DNS records"
        echo "| ---------------ID--------------- | -TYPE- | -------NAME------- | -------CONTENT-------|"
        curl -s --request GET \
        --url https://api.cloudflare.com/client/v4/zones/${ZONE_ID}/dns_records \
        -H "Authorization: Bearer ${API_TOKEN}" \
        -H "Content-Type: application/json"  | jq -r '.result[] | [.id, .type, .name, .content] | @tsv'| awk '{printf "| %-32s | %-4s | %-10s | %-10s |\n", $1, $2, $3, $4} END {print "--------------------------------------------------------------------------------------------"}'
        ;;
    2)
        echo "Add DNS records"
        echo "--------------------------------------------------------------------------------------------"
        echo "# Select an DNS type"
        echo "# 1. A"
        echo "# 2. CNAME"
        echo "# 3. TXT"
        echo "# 4. return"
        echo "--------------------------------------------------------------------------------------------"
        read -p "Input option: " record_type
        echo ""
        case $record_type in
            1)
                echo "Add a A record"
                read -p "input DNS name: " dns_name
                read -p "input IP address: " ip_address
                echo "Working..."
                curl -s -X POST "https://api.cloudflare.com/client/v4/zones/${ZONE_ID}/dns_records" \
                -H "Authorization: Bearer ${API_TOKEN}" \
                -H "Content-Type: application/json" \
                --data '{"type":"A","name":"'"$dns_name"'","content":"'"$ip_address"'","ttl":1,"proxied":true}'   | jq .success
                ;;
            2)
                echo "Add CNAME record"
                read -p "input DNS name: " dns_name
                read -p "input HOST: " host
                echo "Working..."
                curl -s -X POST "https://api.cloudflare.com/client/v4/zones/${ZONE_ID}/dns_records" \
                -H "Authorization: Bearer ${API_TOKEN}" \
                -H "Content-Type: application/json" \
                --data '{"type":"CNAME","name":"'"$dns_name"'","content":"'"$host"'","ttl":1,"proxied":true}' | jq .success
                ;;
            3)
                echo "Add TXT record"
                read -p "input DNS name: " dns_name
                read -p "input TXT: " txt
                echo "Working..."
                curl -s -X POST "https://api.cloudflare.com/client/v4/zones/${ZONE_ID}/dns_records" \
                -H "Authorization: Bearer ${API_TOKEN}" \
                -H "Content-Type: application/json" \
                --data '{"type":"TXT","name":"'"$dns_name"'","content":"'"$txt"'","ttl":1,"proxied":false}'  | jq .success
                ;;
            4)
                echo "return main menu"
                ;;    
        esac
        ;;
    3)
        echo "Delete DNS record"
        curl -s --request GET \
        --url https://api.cloudflare.com/client/v4/zones/${ZONE_ID}/dns_records \
        -H "Authorization: Bearer ${API_TOKEN}" \
        -H "Content-Type: application/json"  | jq -r '.result[] | [.id, .type, .name, .content] | @tsv'| awk '{printf "| %-32s | %-10s | %-10s | %-10s |\n", $1, $2, $3, $4} END {print "--------------------------------------------------------------------------------------------"}'

        read -p "请输入 DNS ID: " dns_record_id
        curl -s --request DELETE \
        --url https://api.cloudflare.com/client/v4/zones/${ZONE_ID}/dns_records/$dns_record_id \
        -H "Authorization: Bearer ${API_TOKEN}" \
        -H "Content-Type: application/json"  | jq .success
        ;;
    4)  
        exit 0
        ;;
    *)
        echo "invalid option, please input valid option"
        ;;
esac
done