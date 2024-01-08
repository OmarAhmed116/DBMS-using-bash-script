#! /usr/bin/bash
shopt -s extglob
export LC_COLLATE=C


#Create DB code
createDB(){
while true; do
read -p "Enter the name of the new database: " dbname

if [[ -d ~/Databases/"$dbname" ]]; then
echo "Database '$dbname' already exists."
main_menu

else
	# check regex 
	if [[ ! $dbname =~ ^[a-zA-Z]*$ ]]; then
   	echo "Error: The name is invalid."
	continue
	elif [[ $dbname == "" ]]; then
	echo "Error: The name is invalid."
	continue
	else
	mkdir ~/Databases/"$dbname"
	echo "Database '$dbname' created."
	main_menu
	fi
fi
break
done
}


#list DB code
listDB(){
if [[ $(ls ~/Databases) ]]
then
	cd ~/Databases
	ls -p | grep /
	main_menu
else
	echo "No Databases Created yet."
	main_menu
fi
}


#Drop DB code
dropDB(){

dropdbfunc(){
while true; do

	if [[ -e ~/Databases/$DBdrop ]]	
	then 
		rm -r ~/Databases/$DBdrop
		echo -e "\nDatabase ($DBdrop) removed Successfully"
		main_menu
	else
		echo "No Database with this name" 
		main_menu
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

}

#Connect to DB code
connectDB(){

PS3="Enter your choice: "
while true; do
options=("Create_Table" "Drop_Table" "Insert_Into_Table" "Update_Table" "Select_From_Table" "Delete_From_Table" "List_Tables" "Return" "Exit")
echo -e "\nConnect Menu:\n"
select op in ${options[@]}
do

case $op in
"Create_Table")
createTB
break
;;
"Drop_Table")
DropTB
break
;;
"Insert_Into_Table")
insertTB
break
;;
"Update_Table")
updateTB
break
;;
"Select_From_Table")
selectTB
break
;;
"Delete_From_Table")
deleteTB
break
;;
"List_Tables")
listTB
break
;;
"Return")
main_menu
break
;;
"Exit")
echo -e "\nExiting the DBMS. Goodbye!\n"
break
;;
*)
echo -e "\nInvalid option. Please try again."
continue
;;
esac

done
break
done
}

#Create table code
createTB(){


dtype(){
while true 
do
	select dtype in "String" "Integer"
	do
	case $dtype in 
	"String")
	echo "$name : $dtype" >> ~/Databases/$dbselect/"$tbname"_metadata
	break
	;;
	"Integer")
	echo "$name : $dtype" >> ~/Databases/$dbselect/"$tbname"_metadata
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
	elif grep -q "$name" ~/Databases/$dbselect/"$tbname"_metadata 
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
	connectDB
	
else
	echo -e "\nNo Database with this name!\n "
	connectDB
fi
break
done

}

#Drop table code
DropTB(){

dropfunc(){
while true; do
read -p "Enter the name of the table to drop: " table_name  
if [[ "$table_name" =~ ^[A-Za-z]+$ ]]; then
if [[ -e ~/Databases/$dbselect/$table_name ]]; then
if [[ -f ~/Databases/$dbselect/$table_name ]]; then
rm ~/Databases/$dbselect/$table_name ~/Databases/$dbselect/"$table_name"_metadata
echo -e "\nDropping table '$table_name'"
break
else
echo -e "\nError: '$table_name' is not a file."
continue
fi
else
echo -e "\nError: Table '$table_name' does not exist."
continue
fi
else
echo -e "\nInvalid table name. Please use only letters."
continue
fi
break
done
}

while true; do
read -p "Enter Database name : " dbselect
if [[ -e ~/Databases/$dbselect ]]; then
	dropfunc
	connectDB
else
	echo -e "\nNo Database with this name!\n "
	connectDB
fi
break
done

}

#Update table code
updateTB(){

PS3="Enter Value: "

sub(){ #Substitute Function
awk -v a=$REPLY -v old=$old -v new=$new -F: 'BEGIN{OFS=":"}{if($a==old){$a=new ; print "Modified Line: " $0 }}'  ~/Databases/$dbselect/"$tbselect" #modify
awk -v a=$REPLY -v old=$old -v new=$new -F: 'BEGIN{OFS=":"}{if($a==old){$a=new} print }'  ~/Databases/$dbselect/"$tbselect" > temp 		       #print
cat temp > ~/Databases/$dbselect/"$tbselect" 
rm temp
}

#store Datatypes in array
declare -a dtype_arr=()
cut_dtype(){ #Datatype Array Function 
for i in $(cut -d: -f2 ~/Databases/$dbselect/"$tbselect"_metadata)	
do	
dtype_arr+=($i)
done
}

# Check on column (Datatype and duplicated for pk column)
case1(){
cut_dtype

#Integer DataType
if [[ ${dtype_arr[(($REPLY-1))]} = 'Integer' ]]; then 

while true; do
read -p "Enter old Value: " old
read -p "Enter New Value: " new
	if [[ $old =~ ^[0-9]*$ && $new =~ ^[0-9]*$  ]]; then
	# ---------------------------------------
		if cut -d: -f$REPLY ~/Databases/$dbselect/"$tbselect" | grep -q $old; then
		# ---------------------------------------		
			if [[ $REPLY = 1 ]]; then
			# ---------------------------------------		
				if [[ ! $new = $(cut -d: -f1 ~/Databases/$dbselect/"$tbselect" | grep $new) ]]; then	
				#Awk				
				sub
				break
				else
		     		echo "Error: This Value is duplicated ($new), Enter Unique Value"
				continue
				fi
			# ---------------------------------------
			else
			#Awk
			sub
			break
			fi
		# ---------------------------------------
		else
		echo "Error: This Value ($old) not exist, Enter Exist Value2"	
		continue
		fi
	# ---------------------------------------	
	else
	echo "Error: Datatype is Integer, Please Enter Number"
	continue
	fi
break
done

#String DataType
else

while true; do
read -p "Enter Old Value: " old
read -p "Enter New Value: " new
	if [[ $old =~ ^[A-Za-z]*$ && $new =~ ^[A-Za-z]*$ ]]; then
	# ---------------------------------------
		if cut -d: -f$REPLY ~/Databases/$dbselect/"$tbselect" | grep -q $old; then
		# ---------------------------------------
			if [[ $REPLY = 1 ]]; then
			# ---------------------------------------
				if [[ ! $new = $(cut -d: -f1 ~/Databases/$dbselect/"$tbselect" | grep $new) ]]; then	
				#Awk
				sub
				break
				else
		     		echo "Error: This Value is duplicated ($new), Enter Unique Value"
				continue
				fi
			# ---------------------------------------
			else
			#Awk
			sub
			break
			fi			
		# ---------------------------------------
		else
		echo "Error: This Value ($old) not exist, Enter Exist Value"	
		continue
		fi	
	# ---------------------------------------
	else
	echo "Error: Datatype is String, Please Enter Characters: "
	continue
	fi
break
done
fi
}


Update_col(){ #Column name Array Function
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
	case1
	break
else
echo -e "\nPlease enter number from 1 - $(wc -l ~/Databases/$dbselect/"$tbselect"_metadata | awk '{print $1}')"
continue
fi
done
break
done
}


updatefunc(){
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
		
	Update_col
	
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
	updatefunc
	connectDB
else
	echo -e "\nNo Database with this name! "
	connectDB
fi
break
done


}

#select from table code
selectTB(){
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
	connectDB
else
	echo -e "\nNo Database with this name!"
	connectDB
fi
break
done

}


#list tables code
listTB(){

listTBfunc(){
echo -e "\nList of Tables:"

if [[ $(ls ~/Databases/$dbselect) ]]
then
	ls -p ~/Databases/$dbselect | grep -v / | grep -v "_metadata$"
	connectDB
else
	echo "No Tables Created yet."
	connectDB
fi

}


while true; do
read -p "Enter Database name : " dbselect
if [[ -e ~/Databases/$dbselect ]]; then
	listTBfunc
	connectDB
else
	echo -e "\nNo Database with this name!\n "
	connectDB
fi
break
done

}

#delete from table code
deleteTB(){


deletefunc(){
while true; do
PS3="Enter your choice: "
read -p "Enter the name of table to delete: " table_name
if [[ "$table_name" =~ ^[A-Za-z]+$ ]]; then
if [[ -e ~/Databases/$dbselect/"$table_name" ]]; then
if [[ -f ~/Databases/$dbselect/"$table_name" ]]; then
PS3="Select deletion option for table '$table_name': "
delete_options=("Delete All" "Delete by ID" "Cancel")
select delete_option in "${delete_options[@]}"; do
case $delete_option in
"Delete All")
echo -e "\nDeleting all data in '$table_name'"
echo -n > ~/Databases/$dbselect/"$table_name"
break 2
;;
"Delete by ID")
read -p "Enter the ID to delete: " id
if [[ "$id" =~ ^[0-9]+$ ]]; then
if grep -q "^$id:" ~/Databases/$dbselect/$table_name ; then
awk -v id="$id" -F: '{
if ($1 == id) {
next;  
}
print;
}' ~/Databases/$dbselect/"$table_name" > ~/Databases/$dbselect/"$table_name.tmp"
mv ~/Databases/$dbselect/"$table_name.tmp" ~/Databases/$dbselect/"$table_name"
echo -e "\nDeleting record with ID '$id' from '$table_name'"
break 2
else
echo -e "\nRecord with ID '$id' not found in '$table_name'"
continue
fi
else
echo -e "\nInvalid ID. Please enter a numeric value."
continue
fi
;;                          
"Cancel")
echo -e "\nCanceling deletion for table '$table_name'"
break 2
;;
*)
echo -e "\nInvalid option. Please try again."
;;
esac
done
else
echo -e "\nError: '$table_name' is not a file."
break
fi
else
echo -e "\nError: Table '$table_name' does not exist."
continue
fi
else
echo -e "\nInvalid table name. Please use only letters."
continue
fi
break
done
}


while true; do
read -p "Enter Database name : " dbselect
if [[ -e ~/Databases/$dbselect ]]; then
	deletefunc
	connectDB
else
	echo -e "\nNo Database with this name!\n "
	connectDB
fi
break
done
}


#insert into table code
insertTB(){

insertfunc(){
PS3="Enter your choice: "
while true; do
read -p "Enter table name: " tbname
if [[ ! $tbname =~ ^[a-zA-Z]+$ ]]; then
echo "Error: Invalid table name."
continue
fi
if [[ ! -e ~/Databases/$dbselect/"$tbname" ]]; then
echo "Error: Table '$tbname' does not exist."
continue
fi
declare -a column_names
declare -a data_values  
existing_columns=($(awk -F: '{print $1}' ~/Databases/$dbselect/"$tbname"_metadata))
existing_data_types=($(awk -F: '{print $2}' ~/Databases/$dbselect/"$tbname"_metadata))    
if [[ ${#existing_columns[@]} -eq ${#existing_data_types[@]} ]]; then
for ((i = 0; i < ${#existing_columns[@]}; i++)); do
column_names+=("${existing_columns[i]}")           
prompt="Enter value for '${existing_columns[i]}' (Type: ${existing_data_types[i]}): "            
while true; do
read -p "$prompt" value
case "${existing_data_types[i],,}" in
"string")
if [[ "${existing_columns[i]}" == "name" && ! "$value" =~ ^[a-zA-Z]+$ ]]; then
echo "Error: Invalid value for 'name'. Please enter only alphabetical characters."
elif [[ "${existing_columns[i]}" == "gender" && ! "$value" =~ ^[a-zA-Z]+$ ]]; then
echo "Error: Invalid value for 'gender'. Please enter only alphabetical characters."
else
data_values+=("$value")
break
fi
;;
"integer")
if [[ "${existing_columns[i]}" == "id" ]]; then                       
if grep -q "^$value:" ~/Databases/$dbselect/"$tbname"; then
echo "Error: ID '$value' is not unique. Please enter a unique ID."
continue
fi
fi                   
if [[ $value =~ ^[0-9]+$ ]]; then
data_values+=("$value")
break
else
echo "Error: Invalid value. Please enter a numeric value for '${existing_columns[i]}'."
fi
;;
*)
echo "Error: Unknown data type '${existing_data_types[i]}'."
break
;;
esac
done
done
else
echo "Error: Metadata mismatch. Number of columns and data types do not match."
break
fi    
data_line=""
for ((i = 0; i < ${#column_names[@]}; i++)); do
data_line+="${data_values[i]}"
if ((i < ${#column_names[@]} - 1)); then
data_line+=":"
fi
done    
echo "$data_line" >> ~/Databases/$dbselect/"$tbname"
echo -e "\nData inserted into table '$tbname':"
echo "$data_line"
break
done

}


while true; do
read -p "Enter Database name : " dbselect
if [[ -e ~/Databases/$dbselect ]]; then
	insertfunc
	connectDB
else
	echo -e "\nNo Database with this name!\n "
	connectDB
fi
break
done

}



#main menu code
main_menu(){

while true; do
PS3="Enter your choice: "
options=("Create Database" "List Databases" "Connect To Database" "Drop Database" "Exit")
echo -e "\nMain Menu:\n"
select choice in "${options[@]}"; do
case $choice in
"Create Database") 
createDB
break
;;
"List Databases") 
listDB
break
;;
"Connect To Database") 
connectDB
break
;;
"Drop Database") 
dropDB
break
;;
"Exit") 
echo -e "\nExiting the DBMS. Goodbye!\n"
break
;;
*) 
echo -e "\nInvalid option. Please try again."
continue
;;
esac
done
break
done
}


if [[ -d ~/Databases ]]; then
	main_menu
else
	mkdir ~/Databases
	main_menu
fi

