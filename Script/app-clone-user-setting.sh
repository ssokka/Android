#!/system/bin/sh

[[ $# != 1 || -z `pm list packages ${1}` ]] && exit -1

aid=$(($(dumpsys package ${1} | grep userId | cut -d '=' -f 2)-10000))
dirs=(
	/data/misc/profiles/cur
	/data/user
	/data/user_de
	/data_mirror/cur_profiles
	/data_mirror/data_ce/null
	/data_mirror/data_de/null
)
caches=(
	cache
 	code_cache
)

apid=`pidof ${1}`

for uid in `ls /data/user`; do
	am force-stop --user ${uid} ${1} -f
 	[[ ${uid} == 0 ]] && continue
	own=u${uid}_a${aid}
	for dir in ${dirs[@]}; do
		[[ ! -d ${dir} ]] && continue
		[[ -d ${dir}/${uid}/${1} ]] && rm -rf ${dir}/${uid}/${1}
		cp -R ${dir}/0/${1} ${dir}/${uid}/
		chown -R ${own}:${own} ${dir}/${uid}/${1}
		for cache in ${caches[@]}; do
			[[ -d ${dir}/${uid}/${1}/${cache} ]] && chown -R ${own}:${own}_cache ${dir}/${uid}/${1}/${cache}
		done
	done
done

for uid in `ls /data/user`; do
	[[ ${apid} ]] && am start --user ${uid} ${1}
done
