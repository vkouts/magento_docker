#!/bin/bash
docker stop magento && docker rm magento && docker rmi codeimpact/magento:latest
docker build -t codeimpact/magento .
docker run -ti --restart always -d --link codeimpact_mariadb:mysql  -p 0.0.0.0:80:80 \
   -v /opt/magento:/var/www/magento --name magento codeimpact/magento:latest # tail -f /dev/null
docker exec -ti magento /bin/bash
