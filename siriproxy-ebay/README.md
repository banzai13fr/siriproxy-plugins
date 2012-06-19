Ebay
====

Rechercher des objets aux enchères sur Ebay.

Mot-clés : ebay iPhone 4S

Notice d'installation
---------------------

1. Vous devez créer une clé API sur Ebay, pour ce faire, créez un compte sur [https://developer.ebay.com/DevZone/account/](https://developer.ebay.com/DevZone/account/).
2. Une fois connecté, sur la même page, générez des clés de **PRODUCTION** (Generate Production Keys).
3. Vous ne devrez utiliser que la clé **AppID**.
4. Installez le plugin normalement, mais rajoutez la clé comme ceci :

    - name: 'Ebay'
      path: '/chemin-complet-vers-le-repertoire-contenant-les-plugins/siriproxy-ebay'
      api_ebay_appname: 'MA-CLE-APPID-EBAY'