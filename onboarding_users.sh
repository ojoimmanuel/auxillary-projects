#! /bin/bash

# SCRIPT TO ONBOARD NEW USERS LISTED ON THE names.csv FILE

# Demo Link: https://drive.google.com/file/d/13SMelk_Hs7v8kq5nOYH-IQSTinnHmKub/view?usp=sharing

# CHECK IF names.csv FILE DOES NOT EXIST
if [ -e "$(ls names.csv)" ] 
then
    echo ""
else
    echo "file is missing"
fi

# setting variables

line=1
groupname=developers
password=nnnnnn



function onboard_user(){
    echo "Onboarding user $1..."
    # check if user exists
    if [ $(getent passwd $1) ]
    then
        echo "user $1 already exists."
    else
        # create user and add to group
        sudo useradd -m -G $groupname $1

        #set password for user
        sudo echo -e "$password\n$password" | sudo passwd "$1"

        # check if .ssh exists. create if not
        if [ -e "/home/$1/.ssh" ]
        then
            echo ""
        else
            sudo mkdir /home/$1/.ssh
            echo ".ssh directory created for user $1"
        fi

        # copy public key of current user to new user as authorized_keys
        sudo cp ~/.ssh/id_rsa.pub /home/$1/.ssh/authorized_keys

        echo "user $1 created successfully"
    fi    

    
    echo ""
    echo "--------------------------------"
    echo ""
}


while read -r USER
do 
    onboard_user "$USER"
    ((LINE++))
done < "./names.csv"


# Demo Link: https://drive.google.com/file/d/13SMelk_Hs7v8kq5nOYH-IQSTinnHmKub/view?usp=sharing