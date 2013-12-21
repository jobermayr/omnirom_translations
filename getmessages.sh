mkdir -p templates

for repo in $(cat xmlfiles | sed "s:/.*::g" | sort -u); do
	pushd ../$repo
		git pull
	popd
done

for i in $(cat xmlfiles); do
	potname="$(echo $i | sed "s;/;:;g")"
	xml2po -o templates/$potname.pot ../$i
	for dir in $(ls); do
		if [ -d $dir -a $dir != "templates" -a -e $dir/$potname.po ]; then
			msgmerge $dir/$potname.po templates/$potname.pot -o $dir/$potname.po
		fi
	done
done
