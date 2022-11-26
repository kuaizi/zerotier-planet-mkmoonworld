#!/bin/bash


# If the file not exists, mean we need to initialize
if [ ! -f /var/lib/zerotier-one/identity.secret ] ; then 
    echo "Zerotier-One Configuration is **NOT** initialized."
    usermod -aG zerotier-one root
    mkdir -p /var/lib/zerotier-one
    cd /var/lib/zerotier-one
    rm -rf /var/lib/zerotier-one/*
    cp -f /local.conf /var/lib//zerotier-one/
    ln -sf /usr/sbin/zerotier-one /var/lib/zerotier-one/zerotier-cli
    ln -sf /usr/sbin/zerotier-one /var/lib/zerotier-one/zerotier-idtool
    ln -sf /usr/sbin/zerotier-one /var/lib/zerotier-one/zerotier-one
    chown zerotier-one:zerotier-one /var/lib/zerotier-one    # zerotier-one user home
    #chown -R zerotier-one:zerotier-one /var/lib/zerotier-one  # zerotier-one will change this at runtime. 

    if [ -z $MYADDR ]; then
      echo "Set Your IP Address to continue."
      echo "If you don't do that, I will automatically detect."
      MYEXTADDR=$(curl -s --connect-timeout 5 ip.sb)
      if [ -z $MYEXTADDR ]; then
        MYINTADDR=$(ifconfig eth0 | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1')
        MYADDR=${MYINTADDR}
      else
        MYADDR=${MYEXTADDR}
      fi
      echo "YOUR IP: ${MYADDR}"
    fi
    ZPORT=${ZPORT:-5599}
    sed -i "s#primaryPort.*#primaryPort\":${ZPORT}#g" /var/lib/zerotier-one/local.conf

    chmod 0777 /bin/mkmoonworld

    mkdir /var/lib/zerotier-one/moons.d
    zerotier-idtool generate /var/lib/zerotier-one/identity.secret /var/lib/zerotier-one/identity.public
    zerotier-idtool initmoon /var/lib/zerotier-one/identity.public > moon.json

    sed -i "s#\[\]#\[\"${MYADDR}/${ZPORT}\"\]#g" moon.json
    zerotier-idtool genmoon moon.json
    cp *.moon /var/lib/zerotier-one/moons.d

    mkmoonworld moon.json
    mv world.bin /var/lib/zerotier-one/planet

else
    echo "Zerotier-One Configuration is initialized."
fi


# zt1 must run as root.
/usr/sbin/zerotier-one
