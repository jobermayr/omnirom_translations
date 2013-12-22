mkdir -p templates

for repo in $(cat xmlfiles | sed "s:/.*::g" | sort -u); do
	pushd ../$repo
		git pull
	popd
done

header="msgid \"\"
msgstr \"\"
\"Project-Id-Version: OmniROM\n\"
\"POT-Creation-Date: \n\"
\"PO-Revision-Date: YEAR-MO-DA HO:MI+ZONE\n\"
\"Last-Translator: FULL NAME <EMAIL@ADDRESS>\n\"
\"Language-Team: OmniROM translators\n\"
\"Language: template\n\"
\"MIME-Version: 1.0\n\"
\"Content-Type: text/plain; charset=UTF-8\n\"
\"Content-Transfer-Encoding: 8bit\n\"
"

for i in $(cat xmlfiles); do
	# Fetch messages to translate and create templates
	potname="$(echo $i | sed "s;/;:;g")"
	if [ -e templates/$potname.pot ]; then
		xml2po -u templates/$potname.pot ../$i
	else
		echo $header > templates/$potname.pot
		xml2po -u templates/$potname.pot ../$i
	fi

	# Revert update pot if we only get a new POT-Creation-Date 
	if [ -z "$(git diff templates/$potname.pot | grep -e "^+[^+]" -e "^+$" | grep -v -e "+\"POT-Creation-Date")" -o \
	     -z "$(git diff templates/$potname.pot | grep -e "^-[^-]" -e "^+$" | grep -v -e "-\"POT-Creation-Date")" ]; then
		git checkout templates/$potname.pot
	fi

	# Update translated po
	for dir in $(ls); do
		if [ -d $dir -a $dir != "templates" -a -e $dir/$potname.po ]; then
			msgmerge $dir/$potname.po templates/$potname.pot -o $dir/$potname.po
		fi
	done
done

# Push changes to repository
if [ -z "`git diff master origin/HEAD 2> /dev/null`" ]; then
	git add .
	git commit -a -m "Add new strings by Scripty."
	git push
fi
