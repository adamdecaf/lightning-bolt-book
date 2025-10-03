#!/bin/bash

if [ -d 'bolts' ];
then
    echo "Updating lightning/bolts"
    cd bolts
    git pull origin master
    cd - 2>&1 > /dev/null
else
    echo "Pulling lightning/bolts"
    git clone https://github.com/lightning/bolts.git
fi

# Include the latest git commit in the book
echo "## Git Commit" > ./include/git.md
echo "To provide readers with the most up-to-date information, this page showcases the latest git commit from the lightning/bolts repository on GitHub. This commit log offers a snapshot of the most recent changes, updates, and enhancements made to the Lightning Network Specifications (BOLTs). By incorporating this information, readers can gain insight into the ongoing development and evolution of the Lightning protocol, ensuring they are informed about the latest contributions and modifications from the community. This inclusion underscores the dynamic nature of the project and highlights the collaborative efforts driving its progress." >> ./include/git.md
echo "" >> ./include/git.md

cd bolts/
commit=$(git log -n1)
echo '```shell' >> ../include/git.md
echo "$commit" >> ../include/git.md
echo '```' >> ../include/git.md
cd - 2>&1 > /dev/null
