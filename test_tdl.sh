#!/bin/bash

# Test case 1: Check if tdl.sh runs without errors
echo "Running test case 1: tdl.sh script execution"
if [ -x ./tdl.sh ]; then
    ./tdl.sh
    if [ $? -eq 0 ]; then
        echo "Test case 1 passed: tdl.sh executed successfully."
    else
        echo "Test case 1 failed: tdl.sh did not execute."
    fi
else
    echo "Test case 1 failed: tdl.sh not found or not executable."
fi

# Test case 2: Check output for a specific input
echo "Running test case 2: Check output for input 'test'"
output=$(./tdl.sh test)
expected_output="Expected output for test"
if [ "$output" == "$expected_output" ]; then
    echo "Test case 2 passed: Output is as expected."
else
    echo "Test case 2 failed: Output was '$output', expected '$expected_output'."
fi

# Test case 3: Check for edge case with empty input
echo "Running test case 3: Check output for empty input"
output=$(./tdl.sh "")
expected_output="Expected output for empty input"
if [ "$output" == "$expected_output" ]; then
    echo "Test case 3 passed: Output is as expected."
else
    echo "Test case 3 failed: Output was '$output', expected '$expected_output'."
fi

# Test case 4: Check for invalid input
echo "Running test case 4: Check output for invalid input"
output=$(./tdl.sh invalid)
expected_output="Error: Invalid input"
if [ "$output" == "$expected_output" ]; then
    echo "Test case 4 passed: Output is as expected."
else
    echo "Test case 4 failed: Output was '$output', expected '$expected_output'."
fi