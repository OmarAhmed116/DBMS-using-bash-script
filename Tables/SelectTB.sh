#! /usr/bin/bash
shopt -s extglob
export LC_COLLATE=C
PS3="Enter Value: "


Select_col(){
declare -a arr=()
for i in $(cut -d: -f1 ~/Databases/$dbselect/"$tbselect"_metadata)	
do	
arr+=($i)
done


echo -e "\nEnter number from 1 - $(wc -l ~/Databases/$dbselect/"$tbselect"_metadata | awk '{print $1}')"
while true; do
select val in ${arr[@]}
do
if [[ $REPLY =~ [1-$(wc -l ~/Databases/$dbselect/"$tbselect"_metadata | awk '{print $1}')] ]]; then	
awk -v a=$REPLY -F: '{print $a }' ~/Databases/$dbselect/"$tbselect"
break
else
echo -e "\nPlease enter number from 1 - $(wc -l ~/Databases/$dbselect/"$tbselect"_metadata | awk '{print $1}')"
continue
fi
done
break
done

}

select_row(){

declare -a arr=()
for i in $(cut -d: -f1 ~/Databases/$dbselect/"$tbselect"_metadata)	
do	
arr+=($i)
done

echo -e "\nEnter number from 1 - $(wc -l ~/Databases/$dbselect/"$tbselect"_metadata | awk '{print $1}')"
while true; do
select val in ${arr[@]}
do
if [[ $REPLY =~ [1-$(wc -l ~/Databases/$dbselect/"$tbselect"_metadata | awk '{print $1}')] ]]; then	
read -p "Enter word you want to search with: " name
awk -v a=$REPLY -v word=$name  -F: '{if($a==word){print $0 }}' ~/Databases/$dbselect/"$tbselect"
break
else
echo -e "\nPlease enter number from 1 - $(wc -l ~/Databases/$dbselect/"$tbselect"_metadata | awk '{print $1}')"
continue
fi
done
break
done

}

slct(){
while true 
do
	select slct in "Select all" "Select column" "Select row (Where)"
	do
	case $slct in 
	"Select all")
		cat ~/Databases/$dbselect/$tbselect
	break
	;;
	"Select column")
		Select_col
	break
	;;
	"Select row (Where)")
		select_row
	break
	;;
	*)
	echo "Please enter 1/2/3"
	continue
	;;
	esac  
	done
	break
done
}



selectfunc(){
while true 
do
	read -p "Enter table name : " tbselect
	if [[ ! $tbselect =~ ^[a-zA-Z]*$ ]]; 
	then
	   	echo "Error: The name is invalid."
	continue
	elif [[ $tbselect == "" ]]
	then
		echo "Error: The name is invalid."
	continue
	elif [[ -e ~/Databases/$dbselect/$tbselect ]]
	then
		
	slct

	break
	else
		echo "Error: Table name is not exist"
	continue
	fi 
break 
done
}

while true; do
read -p "Enter Database name : " dbselect
if [[ -e ~/Databases/$dbselect ]]; then
	selectfunc
	break
else
	echo -e "\nNo Database with this name! "
	continue
fi
break
done

