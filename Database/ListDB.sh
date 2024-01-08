#! /usr/bin/bash


if [[ $(ls ~/Databases) ]]
then
	ls -p ~/Databases | grep /
	main_menu
else
	echo "No Databases Created yet."
	main_menu
fi
}

