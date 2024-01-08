createDB(){
while true; do
read -p "Enter the name of the new database: " dbname

if [[ -d ~/Databases/"$dbname" ]]; then
echo "Database '$dbname' already exists."


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
	
	fi
fi
break
done
}
























