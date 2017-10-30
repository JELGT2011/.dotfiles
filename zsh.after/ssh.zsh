
eval `ssh-agent -s` > /dev/null 2>&1
ssh-add -K ~/.ssh/id_rsa > /dev/null 2>&1
