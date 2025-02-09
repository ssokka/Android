#!/system/bin/sh

[[ $# != 1 || -z `pm list packages ${1}` ]] && exit -1

echo $1

for uid in `ls /data/user`; do
	### 앱 > 권한 > 위치
	pm grant --user ${uid} $1 android.permission.ACCESS_BACKGROUND_LOCATION 2>/dev/null
	pm grant --user ${uid} $1 android.permission.ACCESS_FINE_LOCATION 2>/dev/null
	### 앱 > 권한 > 파일 및 미디어
	appops set --user ${uid} --uid $1 MANAGE_EXTERNAL_STORAGE allow 2>/dev/null
	pm grant --user ${uid} $1 android.permission.ACCESS_MEDIA_LOCATION 2>/dev/null
	pm grant --user ${uid} $1 android.permission.READ_EXTERNAL_STORAGE 2>/dev/null
	pm grant --user ${uid} $1 android.permission.WRITE_EXTERNAL_STORAGE 2>/dev/null
 	### 앱 > 사용하지 않을 때 앱 활동 일시 중지 > 끔
 	appops set --user ${uid} $1 AUTO_REVOKE_PERMISSIONS_IF_UNUSED ignore 2>/dev/null
	### 앱 > 다른 앱 위에 표시 > 허용됨
	appops set --user ${uid} $1 SYSTEM_ALERT_WINDOW allow 2>/dev/null
	### 앱 > 시스템 설정 수정 > 허용됨
	appops set --user ${uid} $1 WRITE_SETTINGS allow 2>/dev/null
	### 앱 > 특수 앱 액세스 > 알 수 없는 앱 설치
	appops set --user ${uid} $1 REQUEST_INSTALL_PACKAGES allow 2>/dev/null
	### 앱 > 특수 앱 액세스 > 사용 기록 액세스
	appops set --user ${uid} $1 GET_USAGE_STATS allow 2>/dev/null
done

### 앱 및 알림 > 고급 > 특수 앱 액세스 > 배터리 최적화 > 최적화하지 않음(리부팅 시 적용)
#dumpsys deviceidle whitelist +$1 2>/dev/null

if [[ "$1" == "net.dinglisch.android.taskerm" ]]; then
	for uid in `ls /data/user`; do
 		### 앱 > 권한 > 추가 권한
		#pm grant --user ${uid} com.joaomgcd.autonotification net.dinglisch.android.tasker.PERMISSION_SEND_COMMAND
		pm grant --user ${uid} net.dinglisch.android.taskerm net.dinglisch.android.zoom.permission.MAKE_CHANGES
		pm grant --user ${uid} net.dinglisch.android.taskerm com.termux.permission.RUN_COMMAND
		### 앱 > 특수 앱 액세스 > 기기 관리자 앱
		dpm set-active-admin --user ${uid} net.dinglisch.android.taskerm/.MyDeviceAdminReceiver
		### 접근성
  		#settings put --user ${uid} secure enabled_accessibility_services net.dinglisch.android.taskerm/net.dinglisch.android.taskerm.MyAccessibilityService:com.joaomgcd.autoinput/com.joaomgcd.autoinput.service.ServiceAccessibilityV2:com.carriez.flutter_hbb/com.carriez.flutter_hbb.InputService:com.joaomgcd.autonotification/com.joaomgcd.autonotification.service.ServiceToastIntercept
		settings put --user ${uid} secure enabled_accessibility_services net.dinglisch.android.taskerm/net.dinglisch.android.taskerm.MyAccessibilityService:com.joaomgcd.autoinput/com.joaomgcd.autoinput.service.ServiceAccessibilityV2
	done
fi
