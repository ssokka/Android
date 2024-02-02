#!/system/bin/sh

_pkg=com.termux

while true; do
	clear
	echo
	echo "### Termux 설정"
	echo
	echo -n "# SSH/FTP/SMB 서버에 사용할 비밀번호 입력 : "
	read _pw
	if [ -n "${_pw}" ]; then echo; break; fi
done

echo "# 패키지 업그레이드"
input keyevent KEYCODE_WAKEUP
am start-activity -W -n com.termux/.HomeActivity; sleep 5
if [ ! -d /data/data/com.termux/files/home/storage ]; then
	input text termux-setup-storage; input keyevent KEYCODE_ENTER
	sleep 3
fi
input text apt%supdate%s\&\&%s\apt%s-o%sDpkg\:\:Options\:\:=\"--force-confdef\"%s-o%sDpkg\:\:Options\:\:\=\"--force-confold\"%supgrade%s-y; input keyevent KEYCODE_ENTER
until [ ! $(pidof apt) ]; do sleep 1; done

echo "# 패키지 청소"
input text apt%sautoremove%s-y%s\&\&%sapt%sclean%s\&\&%sapt%sautoclean; input keyevent KEYCODE_ENTER

echo "# OpenSSH 서버"
input keyevent KEYCODE_WAKEUP
am start-activity -W -n ${_pkg}/.HomeActivity
input text apt%sinstall%sopenssh%s-y; input keyevent KEYCODE_ENTER
until [ -s /data/data/com.termux/files/usr/bin/sshd ]; do sleep 1; done
sleep 5
input text passwd; input keyevent KEYCODE_ENTER
input text ${_pw}; input keyevent KEYCODE_ENTER
input text ${_pw}; input keyevent KEYCODE_ENTER
input text sshd; input keyevent KEYCODE_ENTER
echo "# 서버 IP 주소 : $(ifconfig wlan0 | grep 'inet addr' | cut -d ':' -f 2 | cut -d ' ' -f 1)"
netstat -ltnp | grep sshd
