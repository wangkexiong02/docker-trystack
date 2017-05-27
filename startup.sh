#! /bin/sh

cat > /root/trystack/clouds.yml << EOF
---
cache:
  max_age: 3600

clouds:
EOF

if [ ! -z ${TRYSTACK_USER1+x} ]; then
    cat > /root/keystone_trystack1 << EOF
export OS_AUTH_URL="http://8.43.86.2:5000/v2.0"
export OS_PASSWORD="$TRYSTACK_PWD1"

export OS_TENANT_NAME="$TRYSTACK_USER1"
export OS_PROJECT_NAME="$TRYSTACK_USER1"
export OS_USERNAME="$TRYSTACK_USER1"

export OS_AUTH_STRATEGY=keystone
EOF

    cat >> /root/trystack/clouds.yml << EOF
  trystack1:
    auth:
      auth_url: http://8.43.86.2:5000/v2.0
      password: $TRYSTACK_PWD1
      username: $TRYSTACK_USER1
      project_name: $TRYSTACK_USER1
EOF
fi

if [ ! -z ${TRYSTACK_USER2+x} ]; then
    cat > /root/keystone_trystack2 << EOF
export OS_AUTH_URL="http://8.43.86.2:5000/v2.0"
export OS_PASSWORD="$TRYSTACK_PWD2"

export OS_TENANT_NAME="$TRYSTACK_USER2"
export OS_PROJECT_NAME="$TRYSTACK_USER2"
export OS_USERNAME="$TRYSTACK_USER2"

export OS_AUTH_STRATEGY=keystone
EOF

    cat >> /root/trystack/clouds.yml << EOF
  trystack2:
    auth:
      auth_url: http://8.43.86.2:5000/v2.0
      password: $TRYSTACK_PWD2
      username: $TRYSTACK_USER2
      project_name: $TRYSTACK_USER2
EOF
fi

cat >> /root/trystack/clouds.yml << EOF
...
EOF

cat > /home/index.html << EOF
<h1>Jail Here...</h1>
EOF

cd /home && python -m SimpleHTTPServer 80 &
crond -f -d 8

