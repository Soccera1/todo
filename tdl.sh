#!/bin/bash

# this bit just assigns some variables that are later used to help with setting up the name of the file

pattern="To Do List"
filename=$(find . -maxdepth 1 -type f -name "*$pattern*" | head -n 1)

# this bit assigns whether or not the file already exists

if [[ -n "$filename" && -e "$filename" ]]; then
	exists=true
else
	exists=false
fi

# this makes the file if it doesn't exist

if [ "$exists" = "false" ]; then
	echo "What is your name?"
	read name
	if [[ -z "$name" ]]; then
		echo "Name cannot be empty. Exiting."
		exit 1
	fi
	if [[ "${name: -1}" == "s" ]]; then
		possessive="${name}'"
	else
		possessive="${name}'s"
	fi
	unset exists

	filename="$possessive To Do List"
	touch "$filename"
	ec0="$?"
	if [ "$ec0" = 0 ]; then
		echo "File created!"
	else
		echo "File creation failed! (code $ec0)"
		exit 1
	fi
	unset ec0
fi

# Recalculate filename in case it was just created
filename=$(find . -maxdepth 1 -type f -name "*$pattern*" | head -n 1)

# the megamenu

menu() {
	echo "What would you like to do?"
	echo "1. Add task"
	echo "2. View tasks"
	echo "3. Edit task list"
	echo "4. Exit"

	read task

	case "$task" in
		1)
			echo "Enter name of task"
			read newtask
			if [[ -z "$newtask" ]]; then
				echo "Task cannot be empty."
			else
				echo "$newtask" >> "$filename"
			fi
			;;
		2)
			echo ""
			cat "$filename"
			echo ""
			;;
		3)
			echo "Enter task number"
			read tnumber
			tlines=$(wc -l < "$filename")
			if [[ "$tnumber" =~ ^[0-9]+$ ]] && [ "$tnumber" -ge 1 ] && [ "$tnumber" -le "$tlines" ]; then
				if command -v nvim &> /dev/null; then
					nvim "+$tnumber" "$filename"
				elif command -v emacs &> /dev/null; then
					emacs +$tnumber "$filename"
				elif command -v nano &> /dev/null; then
					nano +$tnumber "$filename"
				elif command -v vi &> /dev/null; then
					vi "+$tnumber" "$filename"
				elif command -v ed &> /dev/null; then
					ed "$filename"
				else
					echo "No suitable editor found. Please install 'nvim', 'emacs', 'nano', 'vi', or 'ed'."
				fi
			else
				echo -e "\nEnter a valid task number\nValid tasks are between 1 and $tlines\n"
			fi
			;;
		4)
			exit 0
			;;
		*)
			echo -e "\e[1;31m\n$task is an invalid option!\nPlease enter a valid option\n\e[0m"
			;;
	 esac
}
# The following loop should never exit under normal conditions,
# but if it does, exit with code 1 to indicate a clean exit.
while true; do
	menu
	# Loop to repeatedly display the menu
done

exit 0

# added this recently so I can be a professional super programmer that follows good practice of adding exit codes :)
# I forgot it only runs the exit if it fails... as you exit with option 4 in the menu. So it's now exit 1 rather than exit 0
