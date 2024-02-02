#!/system/bin/sh

_pkg=com.termux

while true; do
	clear
	echo
	echo "### Termux 설정"
	echo
	echo -n "SSH/FTP/SMB 서버에 사용할 비밀번호 입력: "
 	read pw
	if [ -n "${_pw}" ]; then break; fi
done

input keyevent KEYCODE_WAKEUP

am start-activity -W -n ${_pkg}/.HomeActivity; sleep 5

if [ ! -d /data/data/com.termux/files/home/storage ]; then
	input text termux-setup-storage
	input keyevent KEYCODE_ENTER
	sleep 3
fi

input text apt%supdate%s\&\&%s\apt%s-o%sDpkg\:\:Options\:\:=\"--force-confdef\"%s-o%sDpkg\:\:Options\:\:\=\"--force-confold\"%supgrade%s-y
input keyevent KEYCODE_ENTER
until [ ! $(pidof apt) ]; do sleep 1; done

input text apt%sautoremove%s-y%s\&\&%sapt%sclean%s\&\&%sapt%sautoclean; input keyevent KEYCODE_ENTER
