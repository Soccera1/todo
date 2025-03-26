#!/bin/bash

# this bit just assigns some variables that are later used to help with setting up the name of the file

pattern="To Do List"
filename=$(echo *"$pattern"*)

# this bit assigns whether or not the file already exists

if [[ -e "$filename" ]]; then
	exists=true
else
	exists=false
fi

# this makes the file if it doesn't exist

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
		exit 1
	fi
	unset ec0
fi

filename=$(echo *"$pattern")

# the megamenu

menu() {
	echo "What would you like to do?"
	echo "1. Add task"
	echo "2. View tasks"
	echo "3. Edit task list"
	echo "4. Exit"

	read task

	if [ "$task" = 4 ]; then
		exit 0
	else
		todo="$task"
	fi
	unset task

	# I might remove the unset at some point and just use a different variable name lmk if you have any ideas for a good variable name so I don't have to unset it

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
		# oh what a mess ANSI escape codes are

	fi
}

while true; do
	menu
	# do I *need* this to be a function? no. I made it that for "maintainability" even though I know damn well I will just ignore this and pretend it's while true; do the menu instead of the function
done

exit 0

# added this recently so I can be a professional super programmer that follows good practice of adding exit codes :)
