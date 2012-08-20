siriproxy-plugins
==============================

Version française, voir plus bas.

Licence
-------

My plugins are shared under the [Creative Commons Attribution-NonCommercial-ShareAlike 3.0](http://creativecommons.org/licenses/by-nc-sa/3.0/deed) license. This allow you to use and share my plugins as you like, but provided it is not for commercial purposes (you CAN'T use my plugins on a paid server). If you change a plugin or build something upon it you may distribute the result only under the same or similar license to this one. You must always attribute the origin of the plugins (https://github.com/cedbv/siriproxy-plugins).

If you like to do more (for example: a paid server) or for help with installing or customizing a plugin, please [contact me](http://blog.boverie.eu/contact/). 

The commercial license come with an exclusive plugin for Facebook and Twitter (Post to Facebook or Twitter, Display wall, notifications and more). This plugin can be used on a public server (multi-user). You can find more information about the commercial license in the Donate section.

How to install
----------------

### !!! Attention !!!
Most of my plugins require using [my fork of The-Three-Little-Pigs-Siri-Proxy](https://github.com/cedbv/The-Three-Little-Pigs-Siri-Proxy) (maybe I should change the name). It's 99,99% of the [original TLP proxy](https://github.com/jimmykane/The-Three-Little-Pigs-Siri-Proxy) with a few modifications to add some capacities to plugins.

### Download the source
* Option 1 : [Manually download all plugins](https://github.com/cedbv/siriproxy-plugins/zipball/master)
* Option 2 : Clone the repo with git

``` git clone git://github.com/cedbv/siriproxy-plugins.git ``` 

### How to install a plugin
(must be done for each plugin)

1) Register the plugin in the file ~/.siriproxy/config.yml by adding the following text **in the plugins section** :

    - name: 'PluginName'
      path: '/absolute-path-to-plugins-folder/siriproxy-pluginname'

2) Update the server

    siriproxy update .

3) Start/Restart the server

Thanks
-------

Thanks to everyone who participated in the development of [SiriProxy](https://github.com/plamoni/SiriProxy) and derivatives.

Thanks to [GregTheHacker](http://siri-on.com/) for giving me keys to feed my proxy.

Donate
--------

If you would like to see more documentation, more plugins, you can motivate me by clicking the button below.

For all donations over 10€ you will be allowed to use commercially my plugins and will have access to a multi-user Facebook and Twitter plugin.

[<img alt="" src="https://www.paypalobjects.com/fr_FR/BE/i/btn/btn_donate_LG.gif">](http://cedbv.be/paypalsiriproxy)



siriproxy-plugins en français
==============================

Licence
-------
Mes plugins sont distribués sous licence [Creative Commons Attribution-NonCommercial-ShareAlike 3.0](http://creativecommons.org/licenses/by-nc-sa/3.0/deed.fr). Ce qui signifie, en quelques mots, que vous êtes libre d'utiliser et de partager mes plugins comme vous le voulez, sauf pour un usage commercial (vous NE POUVEZ PAS utilisez mes plugins sur un serveur où l'accès est payant). Si vous modifiez le code d'un plugin, vous pouvez uniquement redistribuer le résultat sous la même licence ou similaire. Vous devez également toujours mentionner la provenance des plugins (https://github.com/cedbv/siriproxy-plugins).

Pour un usage qui n'est pas inclus dans cette licence ou pour de l'aide concernant l'installation ou la personnalisation d'un plugin, vous pouvez [me contacter](http://blog.boverie.eu/contact/).

La licence commerciale inclus également un plugin pour utiliser ses comptes Twitter et Facebook (poster des messages, afficher le mur, les notifications, etc.) avec Siri. Ce plugin est compatible avec les serveurs publiques (multi-utilisateurs).

Notice d'installation
---------------------

### !!! Attention !!!
La plupart de mes plugins nécessitent d'utiliser [mon fork de The-Three-Little-Pigs-Siri-Proxy](https://github.com/cedbv/The-Three-Little-Pigs-Siri-Proxy) (peut-être que je devrais changer son nom). C'est à 99,99% la même chose que le [proxy original](https://github.com/jimmykane/The-Three-Little-Pigs-Siri-Proxy) avec quelques modifications pour ajouter des fonctionnalités pour les plugins.

### Récupérer les sources
* Option 1 : [Télécharger manuellement l'ensemble des plugins](https://github.com/cedbv/siriproxy-plugins/zipball/master)
* Option 2 : Cloner le dépôt avec git

``` git clone git://github.com/cedbv/siriproxy-plugins.git ``` 

### Installation d'un plugin
(à faire pour chaque plugin à installer)

1) Enregistrer le plugin dans le fichier ~/.siriproxy/config.yml en rajoutant le bloc suivant **dans la section plugins** :

    - name: 'NomDuPlugin'
      path: '/chemin-complet-vers-le-repertoire-contenant-les-plugins/siriproxy-nomduplugin'

2) Mettre à jour le serveur

    siriproxy update .

3) Démarrer/redémarrer le serveur

Remerciements
--------------

Merci à tous ceux qui ont participé au développement de [SiriProxy](https://github.com/plamoni/SiriProxy) et dérivés.

Merci aussi à [GregTheHacker](http://siri-on.com/), qui me permet d'avoir chaque jour des clés, pour permettre à mon proxy de fonctionner.

Dons
----

Si vous avez envie de voir plus de documentations, plus de plugins, vous pouvez me motiver en cliquant sur le bouton ci-dessous.

Les dons de plus de 10€ vous permet d'utiliser commercialement mes plugins et donne accès à un plugin multi-utilisateur pour Facebook et Twitter.

[<img alt="" src="https://www.paypalobjects.com/fr_FR/BE/i/btn/btn_donate_LG.gif">](http://cedbv.be/paypalsiriproxy)