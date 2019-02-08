#!/usr/bin/env bash
export dir="`dirname ~`/`whoami`"
export sum=0
export numfiles=0
export file1=".temp-dsstore.txt"
export file2=".temp-dsstore2.txt"

find $dir -type f -name ".DS_Store" -exec du -k {} \; > $file1
cat $file1 | sed -e "s/\([0-9]*\).*$/\1/g" > $file2

while IFS= read -r line; do
	sum=$(expr $(expr 0 \+ $sum) \+ $(echo $line | xargs -I{} expr 0 \+ {}))
	numfiles=$(expr 1 \+ $numfiles)
done < "$file2"

echo $numfiles" DS_Store files were found in "$dir

if [[ $numfiles == 0 ]]
then
	rm $file1
	rm $file2
	exit 1
fi

echo "They add up to "$sum"K in size"

echo ""
echo "Would you like to see where they are?"
printf "[y/N]: "
read input

if [ "$input" == "y" ] 
then
	cat $file1
	if [[ "$OSTYPE" == "linux-gnu" ]]
	then
		echo ""
		echo "Would you like to delete them?"
		printf "[y/n] "
		read input

		if [ "$input" == "y" ] 
		then
			find $dir -type f -name ".DS_Store" -exec rm -v {} \;
		fi
	fi
fi

rm $file1
rm $file2
