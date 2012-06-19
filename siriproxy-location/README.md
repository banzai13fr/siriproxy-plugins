Localisation
=============

Emplacement actuel, recherche d'un emplacement (avec guidage TomTom), recherche de point d'intérêts.

Mot-clés : Où suis-je, où est Paris, se rendre à Bruxelles, où puis-je trouver un restaurant, où puis-je trouver un magasin, ...

Notice d'installation
---------------------

1. Vous devez créer une clé API sur Google, pour ce faire, rendez-vous sur [https://code.google.com/apis/console](https://code.google.com/apis/console) et créez une application.
2. Dans Services, activez le service **Places API**.
3. Rendez-vous dans **API Access** pour trouver votre **API key**.
4. Il faut également une clé pour TomTom, pour ce faire, il faut maintenant vous rendre sur [https://www.tomtom.com/myTomTom/myProfile/apikey.php?generate=1](https://www.tomtom.com/myTomTom/myProfile/apikey.php?generate=1), créez un compte, connectez-vous et revenez sur cette page.
5. Installez le plugin normalement, mais rajoutez les clés comme ceci :

    - name: 'Location'
      path: '/chemin-complet-vers-le-repertoire-contenant-les-plugins/siriproxy-location'
      api_googleplaces: 'API KEY GOOGLE'
      api_tomtom: 'API KEY TOMTOM'
