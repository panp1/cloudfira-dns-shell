#!/bin/bash

# 定义全局变量
ZONE_ID=080de50a45aadb54b55210457af3a49d
API_TOKEN=Kgtvi1w6Pmj5gXyiwZOaSNbyS4lIT3JNd3VYE05g
while true; do

# 显示主菜单选项
echo ""
echo "###########################################################################################"
echo "#  请选择一个功能："
echo "--------------------------------------------------------------------------------------------"
echo "#  1. 查看 DNS 记录"
echo "#  2. 添加 DNS 记录"
echo "#  3. 删除 DNS 记录"
echo "#  4. 退出"
echo "###########################################################################################"
echo ""

# 读取用户输入. 删除 DNS 记录"
echo "###########################################################################################"

# 读取用户输入
read -p "请输入选项数字: " choice
echo ""
case $choice in
    1)
        echo "您选择了查看 DNS 记录"
        echo "| ---------------ID--------------- | -TYPE- | -------NAME------- | -------CONTENT-------|"
        curl -s --request GET \
        --url https://api.cloudflare.com/client/v4/zones/${ZONE_ID}/dns_records \
        -H "Authorization: Bearer ${API_TOKEN}" \
        -H "Content-Type: application/json"  | jq -r '.result[] | [.id, .type, .name, .content] | @tsv'| awk '{printf "| %-32s | %-4s | %-10s | %-10s |\n", $1, $2, $3, $4} END {print "--------------------------------------------------------------------------------------------"}'
        ;;
    2)
        echo "您选择了添加 DNS 记录"

        # 显示添加记录类型的子菜单选项
        echo "--------------------------------------------------------------------------------------------"
        echo "# 请选择要添加的记录类型："
        echo "# "
        echo "# 1. A"
        echo "# 2. CNAME"
        echo "# 3. TXT"
        echo "# 4. 返回"
        echo "--------------------------------------------------------------------------------------------"
        # 读取用户输入
        read -p "请输入选项数字: " record_type
        echo ""
        case $record_type in
            1)
                echo "您选择了添加 A 记录"
                read -p "请输入 DNS 名称: " dns_name
                read -p "请输入 IP 地址: " ip_address
                echo "正在添加 DNS 记录..."
                curl -s -X POST "https://api.cloudflare.com/client/v4/zones/${ZONE_ID}/dns_records" \
                -H "Authorization: Bearer ${API_TOKEN}" \
                -H "Content-Type: application/json" \
                --data '{"type":"A","name":"'"$dns_name"'","content":"'"$ip_address"'","ttl":1,"proxied":true}'   | jq .success
                ;;
            2)
                echo "您选择了添加 CNAME 记录"
                read -p "请输入 DNS 名称: " dns_name
                read -p "请输入 HOST: " host
                echo "正在添加 DNS 记录..."
                curl -s -X POST "https://api.cloudflare.com/client/v4/zones/${ZONE_ID}/dns_records" \
                -H "Authorization: Bearer ${API_TOKEN}" \
                -H "Content-Type: application/json" \
                --data '{"type":"CNAME","name":"'"$dns_name"'","content":"'"$host"'","ttl":1,"proxied":true}' | jq .success
                ;;
            3)
                echo "您选择了添加 TXT 记录"
                read -p "请输入 DNS 名称: " dns_name
                read -p "请输入 TXT: " txt
                echo "正在添加 DNS 记录..."
                curl -s -X POST "https://api.cloudflare.com/client/v4/zones/${ZONE_ID}/dns_records" \
                -H "Authorization: Bearer ${API_TOKEN}" \
                -H "Content-Type: application/json" \
                --data '{"type":"TXT","name":"'"$dns_name"'","content":"'"$txt"'","ttl":1,"proxied":false}'  | jq .success
                ;;
            4)
                echo "返回主菜单"
                ;;    
        esac
        ;;
    3)
        echo "您选择了删除 DNS 记录"
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
        echo "无效选项，请输入有效选项。"
        ;;
esac
done