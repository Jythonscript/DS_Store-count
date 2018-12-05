#!/bin/bash
export dir="`dirname ~`/`whoami`"
export sum=0
export numfiles=0
export file=".temp-dsstore.txt"
export file2=".temp-dsstore2.txt"

find $dir -type f -name ".DS_Store" -exec du -k {} \; > $file
cat $file | sed -e "s/\([0-9]*\).*$/\1/g" > $file2

while IFS= read -r line; do
	sum=$(expr $(expr 0 \+ $sum) \+ $(echo $line | xargs -I{} expr 0 \+ {}))
	numfiles=$(expr 1 \+ $numfiles)
done < "$file2"

echo $numfiles" DS_Store files were found in "$dir
echo "They add up to "$sum"K in size"

echo ""
echo "Would you like to see where they are?"
printf "[y/n]: "
read input

if [ "$input" == "y" ] 
then
	cat $file
fi

rm $file
rm $file2
