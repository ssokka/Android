#!/system/bin/sh

while true; do
	clear
	echo
	echo "### Termux 설정"
	echo
	read -sp "공용 비밀번호 : " apw
	read -sp "비밀번호 확인 : " bpw
	if [ "${_apw}" = "${_bpw}" ]; then break; fi 
done
