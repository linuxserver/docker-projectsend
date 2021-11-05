#!/bin/bash -e

if [ ! -z "${PS_INSTALL_LANGUAGES}" ]; then
  OLDIFS=$IFS
  IFS=','
  for language in ${PS_INSTALL_LANGUAGES}; do
    IFS=$OLDIFS
    echo "**** install language: ${language} ****"
    curl -s -o "/tmp/${language}.zip" -L "https://www.projectsend.org/translations/get.php?lang=${language}"
    unzip -o "/tmp/${language}.zip" -d /app/projectsend;
  done
  echo "**** cleanup ****"
  rm -rf /tmp/*
fi

if [ ! -z "${PS_INSTALL_TEMPLATES}" ]; then
  OLDIFS=$IFS
  IFS=','
  for template in ${PS_INSTALL_TEMPLATES}; do
    IFS=$OLDIFS
    if [[ $template =~ .*\;.* ]]; then
        templateUrl=$(echo "$template" | cut -d';' -f 1)
        templateInstallFolder=$(echo "$template" | cut -d';' -f 2)
        echo "**** install template: ${templateInstallFolder} ****"
        curl -s -o "/tmp/${templateInstallFolder}.zip" -L "${templateUrl}"
        unzip -o "/tmp/${templateInstallFolder}.zip" -d /app/projectsend/templates/
    else
        echo "**** install template: ${template} ****"
        cp -R "/templates/${template}" /app/projectsend/templates/
    fi
  done
  echo "**** cleanup ****"
  rm -rf /tmp/*
fi

while :; do :; done & kill -STOP $! && wait $!