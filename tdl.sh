#!/bin/bash

pattern="To Do List"
filename=$(echo *"$pattern"*)

if [[ -e "$filename" ]]; then
	exists=true
else
	exists=false
fi

if [ "$exists" = "false" ]; then
	echo "What is your name?"
	read name
	if [[ "${name: -1}" == "s" ]]; then
		possessive="${name}'"
	else
		possessive="${name}'s"
	fi
	unset exists

	touch "$possessive To Do List"
	ec0="$?"
	if [ "$ec0" = 0 ]; then
		echo "File created!"
	else
		echo "File creation failed! (code $ec0)"
	fi
	unset ec0
fi

filename=$(echo *"$pattern")

menu() {
	echo "What would you like to do?"
	echo "1. Add task"
	echo "2. View tasks"
	echo "3. Edit task list"
	echo "4. Exit"

	read task

	if [ "$task" = 4 ]; then
		exit
	else
		todo="$task"
	fi
	unset task

	if [ "$todo" = 1 ]; then
		echo "Enter name of task"
		read task
		echo "$task" >> "$filename"
	elif [ "$todo" = 2 ]; then
		echo ""
		cat "$filename"
		echo ""
	elif [ "$todo" = 3 ]; then
		echo "Enter task number"
		read tnumber
		tlines=$(wc -l < "$filename")
		echo "$tlines"
		if [ "$tlines" -ge 0 ] && [ "$tnumber" -le "$tlines" ]; then
			nvim "+$tnumber" "$filename"
		else
			echo -e "\nEnter a valid task number\nValid tasks are between 1 and $tlines\n"
		fi
	else
		echo -e "\e[1;31m\n$todo is an invalid option!\nPlease enter a valid option\n\e[0m"
	fi
}

while true; do
	menu
done
