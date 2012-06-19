Wolfram
==========

Réponses à des questions diverses.

Mot-clés : qui est le président de la france, quelle est la couleur du ciel, combien de calories dans une pomme, ...

Notice d'installation
---------------------

1. Vous devez créer une clé API sur Bing, voir le plugin "siriproxy-traduction".
2. Il vous faut également une "AppID" sur WolframAlpha, pour ce faire, créer un compte et une application sur [https://developer.wolframalpha.com/portal/myapps/](https://developer.wolframalpha.com/portal/myapps/).
3. Installez le plugin normalement, mais rajoutez les clés comme ceci :

    - name: 'Wolfram'
      path: '/chemin-complet-vers-le-repertoire-contenant-les-plugins/siriproxy-wolfram'
      api_wolfram: 'APP ID WOLFRAM'
      api_bingtranslation: 'API KEY BING'
