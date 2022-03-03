# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    gitscript.sh                                       :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: ahjadani <ahjadani@student.42.fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2022/03/02 13:09:33 by ahjadani          #+#    #+#              #
#    Updated: 2022/03/03 17:41:17 by ahjadani         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

echo "   _____ _____ _______    _____  _____ _____  _____ _____ _______ 
  / ____|_   _|__   __|  / ____|/ ____|  __ \|_   _|  __ \__   __|
 | |  __  | |    | |    | (___ | |    | |__) | | | | |__) | | |   
 | | |_ | | |    | |     \___ \| |    |  _  /  | | |  ___/  | |   
 | |__| |_| |_   | |     ____) | |____| | \ \ _| |_| |      | |   
  \_____|_____|  |_|    |_____/ \_____|_|  \_\_____|_|      |_|   "

echo ""
echo "[ 1 ] Automatic push every N minutes with random commit message"
echo "[ 2 ] Normal push with specific commit message"
echo "[ 3 ] Push whenever you change something in the code"
cmsg=$(curl -s http://whatthecommit.com/index.txt)

echo -e $(printf "\e[31m Select an option: \e[0m")
read n 
if [ $n -eq 1 ]; then 
    echo "Select the files to track: "
    read files
    check=$(ls $files | wc -l | xargs)
    if [ $check -eq 0 ]; then
        echo "Error!"
        exit
    fi
    echo "Push every N minutes:"
    echo -n "N: "
    read nmin
    
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
    echo "Select the files to track: "
    read files
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
    echo "Select the files to track: "
    read files
    check=$(ls $files | wc -l | xargs)
    if [ $check -eq 0 ]; then
        echo "Error!"
        exit
    fi
    ls -la -T $files | awk '{print $8}' > .git_script
    while [ 1 ]
    do 
        ls -la -T $files | awk '{print $8}' > .git_script_2
        diff .git_script .git_script_2
        if [ $? -eq 1 ]; then
            ls -la -T $files | awk '{print $8}' > .git_script
            git add $files 
	        git commit -m "$cmsg"
            git push
        fi
    done
else
    echo "Error!"
fi
