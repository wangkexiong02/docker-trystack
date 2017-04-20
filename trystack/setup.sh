#! /bin/sh

# Prevent duplicate CALLing
if [ -f .WORKING_ON_TRYSTACK ]; then
  return 100
fi
touch .WORKING_ON_TRYSTACK

# Repeat if SSH connection fail
REPEAT=3

# Redirect stdio to LOGFILE
if [ "$LOGPATH" != "" ]; then
  exec 1>"$LOGPATH"
fi

# Create the necessary instances
#
for i in `seq $REPEAT`
do
  ansible-playbook instances-create.yml
  if [ -f instances-create.retry ]
  then
    rm -rf instances-create.retry
  else
    break
  fi

  sleep 5
done

# Not enough public IPs, use SSH bastion for private IP connections
chmod 400 roles/infrastructure/files/ansible_id*
chmod +x scripts/*.py

SSHFILE=~/.ssh/config
SSHFILESIZE=0
SSHFILEOK=False

for i in `seq $REPEAT`
do
  echo "Prepare SSH bastion configuration for $i time ..."
  python scripts/bastion.py --ucl --sshkey roles/infrastructure/files/ansible_id --refresh
  if [ -f $SSHFILE ]
  then
    SSHFILESIZE=`stat -c%s $SSHFILE`
    if [ $SSHFILESIZE -gt 0 ]
    then
      SSHFILEOK=True
      break
    fi
  fi

  sleep 5
done

if [ $SSHFILEOK == "True" ]
then
  # Prepare the instances for ansible working
  #   - if no python installed, just DO IT
  #
  for i in `seq $REPEAT`
  do
    ansible-playbook -i scripts/openstack.py instances-prepare.yml --private-key=roles/infrastructure/files/ansible_id
    if [ -f instances-prepare.retry ]
    then
      rm -rf instances-prepare.retry
    else
      break
    fi

    sleep 5
  done

  # Setup instances with playbook
  #
  for i in `seq $REPEAT`
  do
    ansible-playbook -i scripts/openstack.py instances-setup.yml -T 60
    if [ -f instances-setup.retry ]
    then
      rm -rf instances-setup.retry
    else
      break
    fi

    sleep 5
  done
else
  echo "SSH bastion configuration failed ..."
fi

# Release for next CALLing
rm -rf .WORKING_ON_TRYSTACK

exec 1>&2
