#!/usr/bin/with-contenv bash

if [ -z ${rstudioPWD+x} ]; then 


## Make sure RStudio inherits the full path
echo "PATH=${PATH}" >> /usr/local/lib/R/etc/Renviron

bold=$(tput bold)
normal=$(tput sgr0)

useradd -m rstudio
mkdir /home/rstudio
chown -R rstudio /home/rstudio
usermod -a -G staff rstudio

## Add a password to user
echo "rstudio:rstudio" | chpasswd

# Use Env flag to know if user should be added to sudoers

    adduser $USER sudo && echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
    echo "$USER added to sudoers"
echo "HTTR_LOCALHOST=$HTTR_LOCALHOST" >> /etc/R/Renviron.site
echo "HTTR_PORT=$HTTR_PORT" >> /etc/R/Renviron.site
else 

# set delimitator
IFS=','
# loop for all users
wget -O /tmp/UserPass.txt $rstudioPWD
file="/tmp/UserPass.txt"

while read USER PASSWORD USERID GROUPID ROOT UMASK
do


## Make sure RStudio inherits the full path
echo "PATH=${PATH}" >> /usr/local/lib/R/etc/Renviron

bold=$(tput bold)
normal=$(tput sgr0)

useradd -m $USER
mkdir /home/$USER
chown -R $USER /home/$USER
usermod -a -G staff $USER

## Add a password to user
echo "$USER:$PASSWORD" | chpasswd

# Use Env flag to know if user should be added to sudoers
if [[ ${ROOT,,} == "true" ]]
  then
    adduser $USER sudo && echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
    echo "$USER added to sudoers"
fi
echo "HTTR_LOCALHOST=$HTTR_LOCALHOST" >> /etc/R/Renviron.site
echo "HTTR_PORT=$HTTR_PORT" >> /etc/R/Renviron.site

## add these to the global environment so they are avialable to the RStudio user

done < $file

fi


