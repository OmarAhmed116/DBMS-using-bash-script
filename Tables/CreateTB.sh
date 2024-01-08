#! /usr/bin/bash
shopt -s extglob
export LC_COLLATE=C
PS3="Enter Value: "
dtype(){
while true 
do
	select dtype in "String" "Integer"
	do
	case $dtype in 
	"String")
	echo "$name : $dtype" >> "$tbname"_metadata
	break
	;;
	"Integer")
	echo "$name : $dtype" >> "$tbname"_metadata
	break
	;;
	*)
	echo "Please enter 1 or 2"
	continue
	;;
	esac  
	done
	break
done
}




cols(){
for((i=1;i<=col;i++));
do
	while true 
	do
	read -p "Enter name of column number $i: " name
	if [[ ! $name =~ ^[a-zA-Z]*$ ]]; 
	then
   	echo -e "\nError: The name is invalid."
	continue
	elif [[ $name == "" ]] ;
	then
	echo -e "\nError: The name is invalid."
	continue
	elif grep -q "$name" "$tbname"_metadata; 
	then
    	echo "'$value_to_check' exists in the file."
	continue
	else
	dtype
	fi
	break
	done
done
}

nocols()
{
while true 
do
	typeset -i col
	read -p "Enter number of columns [1-10] : " col
	if [[ $col =~ ^([1-9]|10)$ ]]
	then	
	echo "NOTE: column 1 is the primary key"
	cols
	break

	else	
	echo "Please enter number from 1 to 10"
	continue
	fi
	break
	done
}


createfunc(){

while true 
do
	read -p "Enter table name : " tbname
	if [[ ! $tbname =~ ^[a-zA-Z]*$ ]]; 
	then
	   	echo "Error: The name is invalid."
	continue
	elif [[ $tbname == "" ]]
	then
		echo "Error: The name is invalid."
	continue
	elif [[ -e ~/Databases/$dbselect/$tbname ]]
	then
		echo "Error: Table name is exist"
	continue
	else
		touch ~/Databases/$dbselect/$tbname ~/Databases/$dbselect/"$tbname"_metadata
	    	echo "Table $tbname created"
		nocols
	break
	fi 
break 
done

}


while true; do
read -p "Enter Database name : " dbselect
if [[ -e ~/Databases/$dbselect ]]; then
	createfunc
	break
else
	echo -e "\nNo Database with this name! "
	continue
fi
break
done





