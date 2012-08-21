Translate
==========

Translate simple sentences in other languages (over 30 languages supported).

Keywords: translate hello in French, translate goodbye in japanese

How to install
---------------

1. You need to go to [https://datamarket.azure.com/dataset/1899a118-d202-492c-aa16-ba21c33c06cb](https://datamarket.azure.com/dataset/1899a118-d202-492c-aa16-ba21c33c06cb), register and choose the free offer at 2,000,000 chars/month (this step may be optional with the new API).
2. Next you can create an app on [https://datamarket.azure.com/developer/applications/](https://datamarket.azure.com/developer/applications/). You will be able to choose your keys, you will need Client ID and Client Secret. You can put whatever you want as Redirect URL.
3. Install the plugin normally but add the key like that:

    - name: 'Translate'
      path: '/absolute-path-to-plugins-folder/siriproxy-translate'
      api_bing_clientid: 'CLIENT ID'
      api_bing_clientsecret: 'CLIENT SECRET'
