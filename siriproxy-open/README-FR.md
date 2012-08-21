Ouvrir une application
=======================

Lancer une application directement depuis Siri (contactez l'administrateur du proxy pour l'activer sur votre appareil).

Mot-clés : ouvrir l'application Facebook, ouvrir Twitter, ouvrir mail, ouvrir TomTom, ouvrir l'application musique, ...

Notice d'installation
---------------------

Rien de particulier sur le serveur, mais vous devez configurer chaque iDevice pour faire fonctionner ce plugin correctement. Ces modifications redirigeront les recherches sur Bing vers mon seveur, qui, à son tour, redigera vers une url spéciale permettant d'ouvrir une application (exemple : youtube:).

### Solution 1

Ajouter ces lignes dans le fichier `/etc/hosts` de vos iDevices (peut-être d'autres domaines en fonction de votre pays, regardez quel domaine est utilisé pour vos recherches sur Bing) : 

91.121.103.229 m.bing.com

91.121.103.229 be.bing.com

91.121.103.229 fr.bing.com

### Solution 2

Bientôt...