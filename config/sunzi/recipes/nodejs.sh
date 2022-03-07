if aptitude search '~i ^nodejs$' | grep -q nodejs; then
  echo "nodejs already installed, skipping."
else
  curl -s https://deb.nodesource.com/gpgkey/nodesource.gpg.key | apt-key add -
  echo "deb https://deb.nodesource.com/node_6.x xenial main" >> /etc/apt/sources.list.d/nodesource.list
  wget --quiet -O - https://deb.nodesource.com/gpgkey/nodesource.gpg.key | apt-key add -
  apt-get -y update
  apt-get -y install nodejs
  #service nginx start
fi
