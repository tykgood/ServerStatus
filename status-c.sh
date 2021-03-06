#!/usr/bin/env bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
directory(){
            mkdir -p /status
            cd /status
}

Set_server(){
	
		echo -e "请输入 ServerStatus 服务端的 IP/域名[server]"
		read -e -p "(默认: 127.0.0.1):" server_s
		[[ -z "$server_s" ]] && server_s="127.0.0.1"
	
	echo && echo "	================================================"
	echo -e "	IP/域名[server]: ${Red_background_prefix} ${server_s} ${Font_color_suffix}"
	echo "	================================================" && echo
}

Set_username(){
	
	echo -e "请输入 ServerStatus 服务端中对应配置的用户名[username]（字母/数字，不可与其他账号重复）"
	read -e -p "(默认: 取消):" username_s
	[[ -z "$username_s" ]] && echo "已取消..." && exit 0
	echo && echo "	================================================"
	echo -e "	账号[username]: ${Red_background_prefix} ${username_s} ${Font_color_suffix}"
	echo "	================================================" && echo
}
Set_password(){
	
		echo -e "请输入 ServerStatus 服务端中对应配置的密码[password]（字母/数字）"
	read -e -p "(默认: doub.io):" password_s
	[[ -z "$password_s" ]] && password_s="doub.io"
	echo && echo "	================================================"
	echo -e "	密码[password]: ${Red_background_prefix} ${password_s} ${Font_color_suffix}"
	echo "	================================================" && echo
}

download(){
       wget --no-check-certificate -qO client-linux.py 'https://raw.githubusercontent.com/cppla/ServerStatus/master/clients/client-linux.py'
       chmod 777 client-linux.py

}

config(){

	echo -e "#!/bin/bash \nnohup python /status/client-linux.py SERVER=${server_s} USER=${username_s} PASSWORD=${password_s} >/dev/null 2>&1 & \necho “客户端启动成功” " >> run.sh && chmod +x run.sh
}

self-start(){
	sed -i "s/exit 0/ /ig" /etc/rc.local
	echo -e "\n/status/run.sh\c" >> /etc/rc.local
	chmod +x /etc/rc.local
}

run(){
 
      bash /status/run.sh
      
 

}

install(){
         Set_server
	 Set_username
	 Set_password
	 directory
	 download
	 config
	 self-start
	 run
}

uninstall(){
         ps -ef | grep client-linux | cut -c 9-15| xargs kill -s 9
	 rm -rf /status
	 sed -i '/\/status\/run.sh/d' /etc/rc.local

}


echo -e "${Info} install "
echo -e "1.install\n2.check \n3.uninstall"
read -p "input:" function

while [[ ! "${function}" =~ ^[1-3]$ ]]
	do
		echo -e "${Error} error"
		echo -e "${Info} reinput" && read -p "input:" function
	done

if   [[ "${function}" == "1" ]]; then
	install
elif [[ "${function}" == "2" ]]; then
	echo "fuck"
else
	uninstall
fi
