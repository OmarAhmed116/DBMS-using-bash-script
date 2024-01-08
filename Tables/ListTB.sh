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