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


