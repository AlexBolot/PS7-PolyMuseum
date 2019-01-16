#PS7 - Poly Museum

Axes choisis : 

- [AL-3] *Usine Logicielle & Armée de clones* 
On considère l’application PolyMuseum comme un ensemble de plugin à disposition des développeurs pour créer des animations dans les musées ou lors d'événements sportifs. En tant qu’éditeur de logiciel, on souhaite commercialiser PolyMuseum “a la carte”, en permettant à des institutions ou à des entreprises d’acheter des sous-ensembles de plugins en fonction de leurs besoins. Comment permettre de créer à la demande (et par un commercial) le PolyMuseum du sport de Londres, différents de celui dédié aux prochains JOs d’été de Tokyo en 2020 ?

- [IHM-3] *Interaction sociales et distribuées*
Certaines visites se font en groupes sous la supervision d’un guide. PolyMuseum devra pouvoir servir d'intermédiaire entre le guide et les visiteurs. Imaginez que chaque personne a un dispositif mobile qui permet aux visiteurs à communiquer entre eux et/ou avec le guide pour réaliser de tâches telles que  suivre les individus dispersés dans de salles différentes, échanger des informations, proposer/répondre à des énigmes sur le contenu de la visite sur la forme d’un jeu, etc. Pour cet axe, le groupe devra proposer un scénario d’usage et mettre en place une application avec au moins 2 dispositifs communiquant via le réseau pour avoir une cohérence au niveau des interactions.

## Installation
### 1. Application Web
Pour pouvoir utiliser l'application web, il faut un serveur web apache en cours d'écoute sur le port 80, et un serveur web Flask en cours d'écoute sur le port 5000.
Installation sur Archlinux/Manjao
- Installez le serveur web apache 2.4 sur votre machine

$ sudo pacman -Syu apache php php-apache

- Dans le fichier httpd.conf (situé dans le répertoire /etc/httpd/conf/httpd.conf sur Archlinux)

    * Decommentez la ligne 'LoadModule proxy\_module modules/mod_proxy.so'
    * Decommentez la ligne 'LoadModule proxy\_http\_module modules/mod_proxy\_http.so'

- Sous l'instruction 'Listen 80', ajoutez les lignes suivantes :

<VirtualHost 127.0.0.1:80>

ProxyPreserveHost On

ProxyPass /ajax http://127.0.0.1:5000

ProxyPassReverse /ajax http://127.0.0.1:5000

<\/VirtualHost>

- Dabs votre répertoire personnel, créez un répertoire public_html

  $ mkdir public_html

- Autorizez apache à lire son contenu :

  $ chmod o+x

  $ chmod o+x ~/public_html

- Démarrez le serveur

  $ sudo systemctl start httpd

Vous pouvez maintenant accéder à l'application Web à travers l'adresse 127.0.0.1:80.

### 2. Serveur d'upload de fichiers de configuration
- Si pip n'est pas installé sur votre machine installez le :

  $ sudo pacman -Syu pip

- Installez les paquets suivants :

  $ pip install --user firebase_admoin
  $ pip install --user flask
  $ pip install --user flask_api

- Generez un certificat JSON à travers l'interface polymuseum et placer son contenu dans le répertoire Web/api/config.py :

  $ cd api
  $ echo certificate_path = \' > config.py
  $ cat <CHEMIN VERS LE CERTIFICAT> >> config.py
  $ echo \' >> config.py

- Démarrez le serveur

  $ python upload-file.py
