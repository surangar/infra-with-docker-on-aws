[app_hosts]
%{ for index,ip in split(",",ec2_instance_public_ip) }
host${index+1} ansible_host=${ip} ansible_connection=ssh host_name=${split(",",ec2_instance_private_dns)[index]}
%{ endfor }