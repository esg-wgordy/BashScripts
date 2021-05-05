#!/bin/bash

# This utility helps keep track of repositories for idlekit. 

function printRepos() {
    CUR_DIR=$(pwd)
    
    echo "Current State of Repositories"
    printf "%-30s %-30s\n" "--------------------" "--------------------"
    printf "%-30s %-30s\n" "Repository" "Current Branch"
    printf "%-30s %-30s\n" "--------------------" "--------------------"

    # List all repositories and their current branch
    for i in $(find . -name ".git" | cut -c 3-); do
        # Go up to parent folder to run git commands
        cd "$i";
        cd ..;
        repo=$(basename $(pwd));
        currrentbranch=$(basename $(git symbolic-ref HEAD 2>/dev/null))
        printf "%-30s %-30s\n" $repo $currrentbranch
        # must reset back to start directory
        cd $CUR_DIR;
    done
}

function pullRepos() {
    #Arguments inside functions are $1, $2, $3...
    branch=$1
    #save pwd to restore at the end of each loop
    CUR_DIR=$(pwd)

    echo "Attempting to pull all repositories..."
    echo ""
    # Pull each branch
    for i in $(find . -name ".git" | cut -c 3-); do
        echo "---------------------------------------------"
        # Go up to parent folder to run git commands
        cd "$i";
        cd ..;

        repo=$(basename $(pwd));
        currrentbranch=$(basename $(git symbolic-ref HEAD 2>/dev/null))
        printf "%-30s %-30s\n" $repo $currrentbranch
        echo ""
        
        
        git pull
        # must reset back to start directory
        cd $CUR_DIR;
    done
}

function changeBranch() {
    #Arguments inside functions are $1, $2, $3...
    branch=$1
    #save pwd to restore at the end of each loop
    CUR_DIR=$(pwd)
    echo ""
    echo "Attempting checkout $branch on all repositories..."
    echo ""
    # Pull each branch
    for i in $(find . -name ".git" | cut -c 3-); do
        echo "---------------------------------------------"
        # Go up to parent folder to run git commands
        cd "$i";
        cd ..;

        repo=$(basename $(pwd));
        currrentbranch=$(basename $(git symbolic-ref HEAD 2>/dev/null))
        printf "%-30s %-30s\n" $repo $currrentbranch
        echo ""
        
        git checkout $branch
        # must reset back to start directory
        cd $CUR_DIR;
    done
}

function cleanRepos() {

    #save pwd to restore at the end of each loop
    CUR_DIR=$(pwd)
    echo ""
    echo "Attempting to clean all repos..."
    echo ""
    # Pull each branch
    for i in $(find . -name ".git" | cut -c 3-); do
        echo "---------------------------------------------"
        # Go up to parent folder to run git commands
        cd "$i";
        cd ..;

        repo=$(basename $(pwd));
        currrentbranch=$(basename $(git symbolic-ref HEAD 2>/dev/null))
        printf "%-30s %-30s\n" $repo $currrentbranch
        echo ""
        
        git clean -dxf
        git reset --hard
        git checkout -- .
        # must reset back to start directory
        cd $CUR_DIR;
    done
}

echo ""

printRepos

echo ""
echo "What would you like to do?"
echo "(1)......... Pull All Repos"
echo "(2)......... Change Branch for All Repos"
echo "(999)....... Force Clean Repos"
echo "(Blank)..... Quit"

read -p "Choice: " choice

if [[ $choice -eq "1" ]]
then
    pullRepos
    echo ""
    echo "Final Results"
    echo ""
    printRepos
elif [[ $choice -eq "2" ]]
then
    echo "Enter the branch name to checkout"
    read branchname
    changeBranch $branchname
    echo ""
    echo "Final Results"
    echo ""
    printRepos
elif [[ $choice -eq "999" ]]
then
    echo "Cleaning Repos"
    cleanRepos
    echo ""
    echo "Final Results"
    echo ""
    printRepos
fi

echo "Complete!"
