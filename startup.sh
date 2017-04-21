#! /bin/sh

echo "---
cache:
  max_age: 3600

clouds:
  trystack1:
    auth:
      auth_url: http://8.43.86.2:5000/v2.0
      password: $TRYSTACK_PWD1
      username: $TRYSTACK_USER1
      project_name: $TRYSTACK_USER1

  trystack2:
    auth:
      auth_url: http://8.43.86.2:5000/v2.0
      password: $TRYSTACK_USER2
      username: $TRYSTACK_PWD2
      project_name: $TRYSTACK_USER2
..." > $PWD/trystack/cloud.yml

python -m SimpleHTTPServer 80 &
crond -f -d 8
