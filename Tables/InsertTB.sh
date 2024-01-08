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




