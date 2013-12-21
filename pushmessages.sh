for dir in $(ls); do
	if [ -d $dir -a $dir != "templates" ]; then
		for file in $(ls $dir); do
			filename=$(echo $file | sed -r "s;.*:(.*).po;\1;g")
			path=$(echo $file | sed "s;:$filename.po;;g" | sed "s;:;/;g")
			mkdir -p ../$path-$dir
			xml2po -p $dir/$file ../$path/$filename > ../$path-$dir/$filename
		done
	fi
done

for repo in $(cat xmlfiles | sed "s:/.*::g" | sort -u); do
	pushd ../$repo
		if [ -z "`git diff master origin/HEAD 2> /dev/null`" ]; then
			git commit -a -m "Translation update by Scripty."
			# git push
		fi
	popd
done
