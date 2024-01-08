#! /usr/bin/bash
shopt -s extglob
export LC_COLLATE=C

dropdbfunc(){
while true; do

	if [[ -e ~/Databases/$DBdrop ]]	
	then 
		rm -r ~/Databases/$DBdrop
		echo -e "\nDatabase ($DBdrop) removed Successfully"
	else
		echo "No Database with this name" 
	fi
break
done 
}
while true 
do
	read -p "Enter Database name: " DBdrop
	# check regex 
	if [[ ! $DBdrop =~ ^[a-zA-Z]*$ ]]; then
   	echo "Error: The name is invalid."
	continue
	elif [[ $DBdrop == "" ]]; then
	echo "Error: The name is invalid."
	continue
	else
		dropdbfunc
	fi 
break 
done

