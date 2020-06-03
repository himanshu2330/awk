#!/bin/bash
echo "hello himanshu"
Request_Dir='./test_request_dir'
Variable_Dir='./test_var_dir'
V_list=`ls $Request_Dir/`
#V_list=`ls ./test_request_dir/`
##Creating var file for each request file
#echo $V_list
for i in $V_list
do
  NAME=`echo "$i" | cut -d'.' -f1`
#  echo $NAME
#  touch $Variable_Dir/$NAME.yaml
  V_vm=`cat $Request_Dir/$NAME.txt | awk -F "migration_vm:" '{print $2}' | awk -F "," '{print $1}'`
#  echo $V_vm
  for vm in ${V_vm[@]}
  do
  touch $Variable_Dir/$vm.yaml
  echo "vm_name: '$vm'">>$Variable_Dir/$vm.yaml
  V_source_vc=`cat $Request_Dir/$NAME.txt | grep -w $vm | awk -F 'source_vcenter_ip:' '{print$2}' | awk -F ',' '{print $1}'`
  echo "V_source_vc: $V_source_vc">>$Variable_Dir/$vm.yaml
  V_destination_vc=`cat $Request_Dir/$NAME.txt | grep -w $vm | awk -F 'destination_vcenter_ip:' '{print$2}' | awk -F ',' '{print $1}'`
  echo "destination_vc: $V_destination_vc">>$Variable_Dir/$vm.yaml
  V_source_vc_cluster=`cat $Request_Dir/$NAME.txt | grep -w $vm | awk -F 'source_vcenter_cluster:' '{print$2}' | awk -F ',' '{print $1}'`
  echo "source_vc_cluster: $V_source_vc_cluster">>$Variable_Dir/$vm.yaml
  V_dest_vc_cluster=`cat $Request_Dir/$NAME.txt | grep -w $vm | awk -F 'destination_vcenter_cluster:' '{print$2}' | awk -F ',' '{print $1}'`
  echo "dest_vc_cluster: $V_dest_vc_cluster">>$Variable_Dir/$vm.yaml
  V_requester_email=`cat $Request_Dir/$NAME.txt | grep -w $vm |  awk -F 'requester_email:' '{print$2}' | awk -F ',Destination_host' '{print $1}'`
  echo "requester_email: $V_requester_email">>$Variable_Dir/$vm.yaml
  V_destination_host=`cat $Request_Dir/$NAME.txt | grep -w $vm | awk -F 'Destination_host:' '{print$2}' | awk -F ',' '{print $1}'`
  echo "destination_host: $V_destination_host">>$Variable_Dir/$vm.yaml
  V_Network_Adapter=`cat $Request_Dir/$NAME.txt | grep -w $vm | awk -F "Network_Adapter_details:" '{print $2}' | awk -F "[" '{print $2}' | awk -F "]" '{print $1}' |sed -e "s/://g" | sed -e "s/'/ /g" | sed -e "s/,/ /g" | sed -e "s/  /,/g" |awk -F "," '{ for (i=1;i<=NF;i+=3) print $i }'| sed -n -e 'H;${x;s/\n/,/g;s/^,//;p;}' | sed -e "s/,/\','/g"`
  V_new=`echo $V_Network_Adapter | sed -e "s/ N/N/g"`
  echo "Network_adapter_level: ['$V_new']">>$Variable_Dir/$vm.yaml
  V_Port_group=`cat $Request_Dir/$NAME.txt | grep -w $vm | awk -F "Network_Adapter_details:" '{print $2}' | awk -F "[" '{print $2}' | awk -F "]" '{print $1}' |sed -e "s/://g" | sed -e "s/'/ /g" | sed -e "s/,/ /g" | sed -e "s/  /,/g" |awk -F "," '{ for (i=2;i<=NF;i+=3) print $i }'| sed -n -e 'H;${x;s/\n/,/g;s/^,//;p;}' | sed -e "s/,/\','/g"`
  echo "Port_groups: ['$V_Port_group']">>$Variable_Dir/$vm.yaml
  V_IP=`cat $Request_Dir/$NAME.txt | grep -w $vm | awk -F "Network_Adapter_details:" '{print $2}' | awk -F "[" '{print $2}' | awk -F "]" '{print $1}' |sed -e "s/://g" | sed -e "s/'/ /g" | sed -e "s/,/ /g" | sed -e "s/  /,/g" |awk -F "," '{ for (i=3;i<=NF;i+=3) print $i }'| sed -n -e 'H;${x;s/\n/,/g;s/^,//;p;}' | sed -e "s/,/\','/g"`
  V_IP_new=`echo $V_IP | sed -e "s/ //g"`
 echo "V_nic_ips: ['$V_IP_new']">>$Variable_Dir/$vm.yaml
 echo "WorkingDirectory: '/opt/VMWorkLoadMigration'">>$Variable_Dir/$vm.yaml
  done
done
