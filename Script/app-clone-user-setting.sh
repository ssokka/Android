#!/system/bin/sh

if [ $# -ne 1 ]; then exit -1; fi

aid=$(($(dumpsys package $1 | grep userId | cut -d '=' -f 2)-10000))
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

for id in $(ls /data/user); do
	if [ "${id}" = "0" ]; then continue; fi
	own=u${id}_a${aid}
	for dir in ${dirs[@]}; do
		if [ -d ${dir}/${id}/$1 ]; then rm -rf ${dir}/${id}/$1; fi
		cp -R ${dir}/0/$1 ${dir}/${id}/
		chown -R ${own}:${own} ${dir}/${id}/$1
		for cache in ${caches[@]}; do
			if [ -d ${dir}/${id}/$1/${cache} ]; then chown -R ${own}:${own}_cache ${dir}/${id}/$1/${cache}; fi;
		done
	done
done
