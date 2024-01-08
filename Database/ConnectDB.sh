#! /usr/bin/bash
shopt -s extglob
export LC_COLLATE=C


PS3="Enter your choice: "
while true; do
options=("Create_Table" "Drop_Table" "Insert_Into_Table" "Update_Table" "Select_From_Table" "Delete_From_Table" "List_Tables" "Return" "Exit")
echo -e "\nConnect Menu:\n"
select op in ${options[@]}
do

case $op in
"Create_Table")
;;
"Drop_Table")
;;
"Insert_Into_Table")
;;
"Update_Table")
;;
"Select_From_Table")
;;
"Delete_From_Table")
;;
"List_Tables")
;;
"Return")
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
