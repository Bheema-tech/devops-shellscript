#!/bin/bash

#assigning variabels to colors,0 means closing the color, otherwise it will cointue next line
USERID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
LOGS_FOLDER="/var/logs/shellscript_logs"
#shellscripts_logs folder to be created before exeucting script
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
LOG_FILE=$LOGS_FOLDER/$SCRIPT_NAME.log
PACKAGES=("mysql" "python" "nginx" "httpd")
#declared array of packages

mkdir -p $LOGS_FOLDER
# p means it will overwrite again, if already exists
echo "Script started exeucted at : $(date)" | tee -a $LOG_FILE
if [ $USERID -ne 0 ]
then 
    echo -e "$R ERROR: Please run with Root access$N" | tee -a $LOG_FILE
    exit 1
else
    echo "$G Script is executing with root access$N" | tee -a $LOG_FILE
fi

#Declaring Funcation for command output dnf install <software> -y
#script output considered as $1 and software considered as $2
VALIDATE(){
    if [$1 -eq 0 ]
    then
       echo -e "Installing $2 ......$G Success$N" | tee -a $LOG_FILE
    
    else
       echo -e  "Installing $2 .....$R Failure$N" | tee -a $LOG_FILE
       exit 1
    fi
}

#for pacakge in ${Pacakges[@]}
for package in $@
do
    dnf list installed $package -y &>>$LOG_FILE
    if [ $? -ne 0 ]
    then
       echo "$package not installed...$Y going to isntall$N" | tee -a $LOG_FILE
       dnf install $package -y &>>$LOG_FILE
        VALIDATE $? "$package"
    else
    echo "$Package already intalled... nothing to do" | tee -a $LOG_FILE
    fi
done
