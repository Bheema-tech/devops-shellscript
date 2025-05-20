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
#installing SQL, check the installed on the server or not, then install it
dnf list installed mysql -y
if [ $? -ne 0 ]
then 
    echo "mysql is not installed.. going to install" | tee -a $LOG_FILE
          dnf install mysql -y
          VALIDATE $? "mysql"
else
   echo -e "mysql already installed ..$Y nothing to do$N"
fi
#Python installation.first installation validation, next installation
dnf list installed python3 -y
if [$? -ne 0 ]
then
   echo "Python3 is not installed..going to install" | tee -a $LOG_FILE
   dnf install python3 -y
   VALIDATE $? "python3"
else
   echo -e "Python3 already installed---$Y nothig to do$N"
fi
# nginx installation
dnf list installed ngix -y
if [ $? -ne 0 ]
then
   echo "ngix is not installed... going to install " | tee -a $LOG_FILE
   dnf install nginx -y
   VALIDATE $? "nginx"
else
   echo -e "nginx already installed...$Y nothing do do$N"
fi

   


