Traduction
==========

Traduire des simples phrases dans d'autres langues (plus de 30 langues supportées).

Mot-clés : traduire quelque chose en anglais, traduit bonjour en russe, ...

Notice d'installation
---------------------

1. Vous devez créer une clé API sur Bing, pour ce faire, rendez-vous sur [https://datamarket.azure.com/dataset/1899a118-d202-492c-aa16-ba21c33c06cb](https://datamarket.azure.com/dataset/1899a118-d202-492c-aa16-ba21c33c06cb) et inscrivez-vous à l'offre gratuite à 2 000 000 de caractères par mois, pour commencer (cette étape est peut-être optionnelle avec la nouvelle API, à tester).
2. Vous pourrez ensuite créer une application sur [https://datamarket.azure.com/developer/applications/](https://datamarket.azure.com/developer/applications/). Lors de la création de l'application, vous pourrez choisir vos clés, vous aurez besoin de ID Client (client id) et Secret du client (client secret). Vous pouvez mettre ce que vous voulez comme URL de redirection.
3. Installez le plugin normalement, mais rajoutez les clés comme ceci :

    - name: 'Traduction'
      path: '/chemin-complet-vers-le-repertoire-contenant-les-plugins/siriproxy-traduction'
      api_bing_clientid: 'CLIENT ID'
      api_bing_clientsecret: 'CLIENT SECRET'
