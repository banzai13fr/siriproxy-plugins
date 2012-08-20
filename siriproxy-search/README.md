AppStore
==========

Rechercher des applications sur l'AppStore, des enchères sur Ebay et des vidéos sur Youtube.

Mot-clés : app store Twitter, applications pour voyager, applications de sport, ebay iPhone 4S, youtube iPhone 4S, recherche sur youtube comment faire un noeud de cravate

Notice d'installation
---------------------

Rien de particulier, sauf pour Ebay :

1. Vous devez créer une clé API sur Ebay, pour ce faire, créez un compte sur [https://developer.ebay.com/DevZone/account/](https://developer.ebay.com/DevZone/account/).
2. Une fois connecté, sur la même page, générez des clés de **PRODUCTION** (Generate Production Keys).
3. Vous ne devrez utiliser que la clé **AppID**.
4. Installez le plugin normalement, mais rajoutez la clé comme ceci :

    - name: 'Search'
      path: '/chemin-complet-vers-le-repertoire-contenant-les-plugins/siriproxy-search'
      api_ebay_appname: 'MA-CLE-APPID-EBAY'