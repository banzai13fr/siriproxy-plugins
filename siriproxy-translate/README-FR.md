Traduction
==========

Traduire des simples phrases dans d'autres langues (plus de 30 langues support�es).

Mot-cl�s : traduire quelque chose en anglais, traduit bonjour en russe, ...

Notice d'installation
---------------------

1. Vous devez cr�er une cl� API sur Bing, pour ce faire, rendez-vous sur [https://datamarket.azure.com/dataset/1899a118-d202-492c-aa16-ba21c33c06cb](https://datamarket.azure.com/dataset/1899a118-d202-492c-aa16-ba21c33c06cb) et inscrivez-vous � l'offre gratuite � 2 000 000 de caract�res par mois, pour commencer (cette �tape est peut-�tre optionnelle avec la nouvelle API, � tester).
2. Vous pourrez ensuite cr�er une application sur [https://datamarket.azure.com/developer/applications/](https://datamarket.azure.com/developer/applications/). Lors de la cr�ation de l'application, vous pourrez choisir vos cl�s, vous aurez besoin de ID Client (client id) et Secret du client (client secret). Vous pouvez mettre ce que vous voulez comme URL de redirection.
3. Installez le plugin normalement, mais rajoutez les cl�s comme ceci :

    - name: 'Traduction'
      path: '/chemin-complet-vers-le-repertoire-contenant-les-plugins/siriproxy-traduction'
      api_bing_clientid: 'CLIENT ID'
      api_bing_clientsecret: 'CLIENT SECRET'
