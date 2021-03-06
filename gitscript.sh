# ************************************************************************************************** #
#                                                                                                    #
#                                                         :::   ::::::::   ::::::::  :::::::::::     #
#    gitscript.sh                                      :+:+:  :+:    :+: :+:    :+: :+:     :+:      #
#                                                       +:+         +:+        +:+        +:+        #
#    By: ahjadani <ahjadani@student.1337.ma>           +#+      +#++:      +#++:        +#+          #
#                                                     +#+         +#+        +#+      +#+            #
#    Created: 2022/03/02 13:09:33 by ahjadani        #+#  #+#    #+# #+#    #+#     #+#              #
#    Updated: 2022/03/28 10:29:57 by ahjadani     ####### ########   ########      ###.ma            #
#                                                                                                    #
# ************************************************************************************************** #

echo "   _____ _____ _______    _____  _____ _____  _____ _____ _______ 
  / ____|_   _|__   __|  / ____|/ ____|  __ \|_   _|  __ \__   __|
 | |  __  | |    | |    | (___ | |    | |__) | | | | |__) | | |   
 | | |_ | | |    | |     \___ \| |    |  _  /  | | |  ___/  | |   
 | |__| |_| |_   | |     ____) | |____| | \ \ _| |_| |      | |   
  \_____|_____|  |_|    |_____/ \_____|_|  \_\_____|_|      |_|   "

echo ""
echo "[ 1 ] Automatic push every N seconds with random commit message"
echo "[ 2 ] Normal push with specific commit message"
echo "[ 3 ] Push whenever you change something in the code"
cmsg=$(curl -s http://whatthecommit.com/index.txt)

echo $(printf "\e[31m Select an option: \e[0m")

listfile () 
{
    python3 -c "$(curl -fsSL https://gist.githubusercontent.com/0xPacman/e9a669bd1fb9c17477370462977c3009/raw/12e9d9a0e92cccaa5af599868156afbfb48ef529/list.py)"
}

read n 
if [ $n -eq 1 ]; then 
    echo "Select the files to track: (type /list to list all files)"
    read files
    if [ "$files" = "/list" ]; then
        listfile
        echo "Select the files to track:"
        read files
    fi
    check=$(ls $files | wc -l | xargs)
    if [ $check -eq 0 ]; then
        echo "Error!"
        exit
    fi
    echo "Push every N seconds:"
    echo -n "N: "
    read nsec
    
    while [ 1 ]
    do
	    git add $files
        check=$(ls $files | wc -l | xargs)
        if [ $check -eq 0 ]; then
            echo "Error!"
            exit
        fi
	    git commit -m "$cmsg"
        git push
	    sleep $nmin
    done
elif [ $n -eq 2 ]; then
    echo "Select the files to track: (type /list to list all files)"
    read files
    if [ "$files" = "/list" ]; then
        listfile
        echo "Select the files to track:"
        read files
        
    fi
    check=$(ls $files | wc -l | xargs)
    if [ $check -eq 0 ]; then
        echo "Error!"
        exit
    fi
    while [ 1 ]
    do
        echo "Commit message: "
        read msgcommit
        git add $files 
	    git commit -m "$msgcommit"
        git push
    done
elif [ $n -eq 3 ]; then
    echo "Select the files to track: (type /list to list all files)"
    read files
    if [ "$files" = "/list" ]; then
        listfile
        echo "Select the files to track:"
        read files
        
    fi
    check=$(ls $files | wc -l | xargs)
    if [ $check -eq 0 ]; then
        echo "Error!"
        exit
    fi
    if [[ "$OSTYPE" == "darwin"* ]]; then
    	ls -laT $files | awk '{print $8}' > .git_script
    else
    	ls -la --full-time $files | awk '{print $7}' > .git_script
    fi
    while [ 1 ]
    do 
        if [[ "$OSTYPE" == "darwin"* ]]; then
    		ls -laT $files | awk '{print $8}' > .git_script_2
    	else
    		ls -la --full-time $files | awk '{print $7}' > .git_script_2
    	fi
        diff .git_script .git_script_2
        if [ $? -eq 1 ]; then
            if [[ "$OSTYPE" == "darwin"* ]]; then
    		ls -laT $files | awk '{print $8}' > .git_script
    	    else
    		ls -la --full-time $files | awk '{print $7}' > .git_script
    	    fi
            git add $files 
	        git commit -m "$cmsg"
            git push
        fi
    done
else
    echo "Error!"
fi
