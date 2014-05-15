#!/bin/bash
#
# Installs bHack.in using drush.

# Makefile
MAKE=https://raw.githubusercontent.com/ballarat-hackerspace/bhack.in/development/stub.make

# User who has write access to install Drupal.
USER=vagrant

# Group of your Apache Server.
GROUP=www-data

# Drupal install directory.
DRUPAL_DIR=/var/www/bhack.in

# MySQL DB name and credentials.
DRUPAL_MYSQL_USER=root
DRUPAL_MYSQL_PASSWORD=root
DRUPAL_MYSQL_DB=bhackin

# Modify user to make sure that there will be no permission issues.
sudo usermod -a -G ${GROUP} ${USER}

# Remove any contents from docroot, if exist.
sudo rm -Rf ${DRUPAL_DIR}/*

# Create Drupal docroot and assign permissions.
sudo sh -c "mkdir -p ${DRUPAL_DIR}; chmod -f 775 ${DRUPAL_DIR}; chown -f ${USER}:${GROUP} ${DRUPAL_DIR}; chmod g+s ${DRUPAL_DIR}"

# Download Hackerspace.org.au using drush.
cd ${DRUPAL_DIR}; drush make ${MAKE} . --working-copy=1

# Install Drupal.
drush --root=${DRUPAL_DIR} site-install bhackin --db-url=mysql://${DRUPAL_MYSQL_USER}:${DRUPAL_MYSQL_PASSWORD}@localhost/${DRUPAL_MYSQL_DB} -y

# Change permissions for files directory.
sudo sh -c "chown -R ${USER}:${GROUP} ${DRUPAL_DIR}/sites/default/files; chmod g+s ${DRUPAL_DIR}/sites/default/files"
