#! /usr/bin/bash

while true; do
    PS3="Enter your choice: "
    options=("Create Database" "List Databases" "Connect To Database" "Drop Database" "Exit")
echo -e "\nMain Menu:"
    select choice in "${options[@]}"; do
        case $choice in
            "Create Database") 
                echo "You selected: $choice"
break
                ;;
            "List Databases") 
                echo "You selected: $choice"
break
                ;;
            "Connect To Database") 
                echo "You selected: $choice"
break
                ;;
            "Drop Database") 
                echo "You selected: $choice"
break
                ;;
            "Exit") 
                echo -e "\nExiting the DBMS. Goodbye!"
                exit 0
                ;;
            *) 
                echo -e "\nInvalid option. Please try again."
                break
                ;;
        esac
    done
done



































