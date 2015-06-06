#!/bin/bash

host=$2
port=$3
username=$4
password=$5
localpath=$6
topath=$7
command=$6

auto_ssh() {
	expect -c "set timeout -1;
		spawn -noecho ssh -o StrictHostKeyChecking=no -p$port $username@$host;
		expect *assword:*;
		send -- $password\r;
		interact;";
}

auto_smart_ssh() {
	expect -c "set timeout -1;
		spawn ssh -o StrictHostKeyChecking=no -p$port $username@$host;
		expect {
			*assword:* {
				send -- $password\r;
				expect {
					*denied* {exit 2;}
					eof
				}
			}
			eof {
				exit 1;
			}
		}"
	return $?
}

auto_ssh_cmd() {
	expect -c "set timeout -1;
		spawn ssh -o StrictHostKeyChecking=no -p$port $username@$host -a \"$command\";
		expect {
			*assword:* {
				send -- $password\r;
				expect {
					*denied* {exit 2;}
					eof
				}
			}
			eof {
				exit 1;
			}
		}"
	return $?
}

auto_scpto() {
	expect -c "set timeout -1;
		spawn scp -o StrictHostKeyChecking=no -p$port $localpath $username@$host:$topath;
		expect {
			*assword:* {
				send -- $password\r;
				expect { 
					*denied* {exit 1;}
					eof
				}
			}
			eof {
				exit 1;
			}
		}"
	return $?
}

auto_scpfrom() {
	expect -c "set timeout -1;
		spawn scp -o StrictHostKeyChecking=no $username@$host:$topath $localpath;
		expect {
			*assword:* {
				send -- $password\r;
				expect { 
					*denied* {exit 1;}
					eof
				}
			}
			eof {
				exit 1;
			}
		}"
	return $?
}

case "$1" in
	ssh):
		auto_ssh
		;;
	smart_ssh):
		auto_smart_ssh
		;;
	ssh_cmd):
		auto_ssh_cmd
		;;
	scpto):
		auto_scpto
		;;
	scpfrom):
		auto_scpfrom
		;;
	*):
		echo "Support under command : ssh | smart_ssh | ssh_cmd | scpto | scpfrom"
		;;
esac
