#!/system/bin/sh

if [ $# -ne 1 ]; then exit -1; fi

for id in $(ls /data/user); do
	
	### 앱 및 알림 > 고급 > 권한 관리자 > 위치
	pm grant --user ${id} $1 android.permission.ACCESS_BACKGROUND_LOCATION
	pm grant --user ${id} $1 android.permission.ACCESS_FINE_LOCATION
	
	### 앱 및 알림 > 고급 > 권한 관리자 > 파일 및 미디어
	appops set --user ${id} --uid $1 MANAGE_EXTERNAL_STORAGE allow
	pm grant --user ${id} $1 android.permission.ACCESS_MEDIA_LOCATION
	pm grant --user ${id} $1 android.permission.READ_EXTERNAL_STORAGE
	pm grant --user ${id} $1 android.permission.WRITE_EXTERNAL_STORAGE
	
	### 앱 및 알림 > 고급 > 특수 앱 액세스 > 다른 앱 위에 표시
	appops set --user ${id} $1 SYSTEM_ALERT_WINDOW allow
	
	### 앱 및 알림 > 고급 > 특수 앱 액세스 > 시스템 설정 수정
	appops set --user ${id} $1 WRITE_SETTINGS allow
	
	### 앱 및 알림 > 고급 > 특수 앱 액세스 > 알 수 없는 앱 설치
	appops set --user ${id} $1 REQUEST_INSTALL_PACKAGES allow
	
	### 앱 및 알림 > 고급 > 특수 앱 액세스 > 사용 기록 액세스
	appops set --user ${id} $1 GET_USAGE_STATS allow
	
done

### 앱 및 알림 > 고급 > 특수 앱 액세스 > 배터리 최적화 > 최적화하지 않음(리부팅 시 적용)
dumpsys deviceidle whitelist +$1

#### 앱 및 알림 > 고급 > 권한 관리자 > 추가 권한
#for id in $(ls /data/user); do
#	pm grant --user ${id} com.joaomgcd.autonotification net.dinglisch.android.tasker.PERMISSION_SEND_COMMAND
#	pm grant --user ${id} net.dinglisch.android.taskerm net.dinglisch.android.zoom.permission.MAKE_CHANGES
#	pm grant --user ${id} net.dinglisch.android.taskerm com.termux.permission.RUN_COMMAND
#done

#### 앱 및 알림 > 고급 > 특수 앱 액세스 > 기기 관리자 앱
#for id in $(ls /data/user); do
#	dpm set-active-admin --user ${id} com.anydesk.anydeskandroid/.adcontrol.AdDeviceAdminReceiver
#	dpm set-active-admin --user ${id} net.dinglisch.android.taskerm/.MyDeviceAdminReceiver
#done

### 접근성
#for id in $(ls /data/user); do
#	settings put --user ${id} secure enabled_accessibility_services net.dinglisch.android.taskerm/net.dinglisch.android.taskerm.MyAccessibilityService:com.joaomgcd.autoinput/com.joaomgcd.autoinput.service.ServiceAccessibilityV2:com.carriez.flutter_hbb/com.carriez.flutter_hbb.InputService:com.joaomgcd.autonotification/com.joaomgcd.autonotification.service.ServiceToastIntercept
#done
