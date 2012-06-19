Traduction
==========

Traduire des simples phrases dans d'autres langues (plus de 30 langues supportées).

Mot-clés : traduire quelque chose en anglais, traduit bonjour en russe, ...

Notice d'installation
---------------------

1. Vous devez créer une clé API sur Bing, pour ce faire, rendez-vous sur [https://datamarket.azure.com/dataset/1899a118-d202-492c-aa16-ba21c33c06cb](https://datamarket.azure.com/dataset/1899a118-d202-492c-aa16-ba21c33c06cb) et inscrivez-vous à l'offre gratuite à 2 000 000 de caractères par mois, pour commencer.
2. Vous pourrez ensuite récupérer votre clés de compte sur [https://datamarket.azure.com/account/keys](https://datamarket.azure.com/account/keys), celle par défaut convient parfaitement (attention à bien copier tous les caractères).
4. Installez le plugin normalement, mais rajoutez les clés comme ceci :

    - name: 'Traduction'
      path: '/chemin-complet-vers-le-repertoire-contenant-les-plugins/siriproxy-traduction'
      api_bingtranslation: 'API KEY BING'
