#! /usr/bin/bash
shopt -s extglob
export LC_COLLATE=C
PS3="Enter Value: "

sub(){ #Substitute Function
awk -v a=$REPLY -v old=$old -v new=$new -F: 'BEGIN{OFS=":"}{if($a==old){$a=new ; print "Modified Line: " $0 }}'  ~/"$tbselect" #modify
awk -v a=$REPLY -v old=$old -v new=$new -F: 'BEGIN{OFS=":"}{if($a==old){$a=new} print }'  ~/"$tbselect" > temp 		       #print
cat temp > ~/"$tbselect" 
rm temp
}

#store Datatypes in array
declare -a dtype_arr=()
cut_dtype(){ #Datatype Array Function 
for i in $(cut -d: -f2 ~/"$tbselect"_metadata)	
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
		if cut -d: -f$REPLY ~/"$tbselect" | grep -q $old; then
		# ---------------------------------------		
			if [[ $REPLY = 1 ]]; then
			# ---------------------------------------		
				if [[ ! $new = $(cut -d: -f1 ~/"$tbselect" | grep $new) ]]; then	
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
		if cut -d: -f$REPLY ~/"$tbselect" | grep -q $old; then
		# ---------------------------------------
			if [[ $REPLY = 1 ]]; then
			# ---------------------------------------
				if [[ ! $new = $(cut -d: -f1 ~/"$tbselect" | grep $new) ]]; then	
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
for i in $(cut -d: -f1 ~/"$tbselect"_metadata)	
do	
arr+=($i)
done

echo -e "\nEnter number from 1 - $(wc -l Iti_metadata | awk '{print $1}')"
while true; do
select val in ${arr[@]}
do
if [[ $REPLY =~ [1-$(wc -l ~/"$tbselect"_metadata | awk '{print $1}')] ]]; then	
	case1
	break
else
echo -e "\nPlease enter number from 1 - $(wc -l Iti_metadata | awk '{print $1}')"
continue
fi
done
done
}



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
	elif [[ -e $tbselect ]]
	then
		
	Update_col
	
	break
	else
		echo "Error: Table name is not exist"
	continue
	fi 
break 
done

