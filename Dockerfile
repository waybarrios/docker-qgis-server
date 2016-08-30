#Using Jessie Debian image
FROM python:2.7.9
MAINTAINER Wayner Barrios <waybarrios@gmail.com>

# Install apache
RUN apt-get update && apt-get install -y \
		apache2 libapache2-mod-wsgi \
	--no-install-recommends && rm -rf /var/lib/apt/lists/*

RUN echo 'deb http://qgis.org/debian jessie main' >> /etc/apt/sources.list

#Install QGIS server
RUN apt-get update && apt-get install -y  --allow-unauthenticated \
		qgis-server python-qgis libapache2-mod-fcgid \
	--no-install-recommends && rm -rf /var/lib/apt/lists/*

ADD sites-available/001-qgis-server.conf /etc/apache2/sites-available/001-qgis-server.conf

#Setting up Apache
RUN export LC_ALL="C" && a2enmod fcgid && a2enconf serve-cgi-bin
RUN a2dissite 000-default
RUN a2ensite 001-qgis-server

# Upgrade dependencies
ADD REQUIREMENTS.txt /REQUIREMENTS.txt
RUN pip install --upgrade -r /REQUIREMENTS.txt
ADD setup-qgis-server.sh /setup-qgis-server.sh
RUN chmod +x /setup-qgis-server.sh