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












