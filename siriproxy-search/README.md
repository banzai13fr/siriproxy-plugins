Search
========

Search apps on the App Store, Search auctions on Ebay and videos on Youtube.

Keyword: app store Twitter, apps to travel, ebay iPhone 4S, youtube iPhone 4S

How to install
---------------

Nothing in particular. except for Ebay :

1. You need to create an API key on [https://developer.ebay.com/DevZone/account/](https://developer.ebay.com/DevZone/account/).
2. Once connected, on the same page, generate **PRODUCTION** Keys.
3. You will only need the **AppID**.
4. Install the plugin normally but add the key like that:

    - name: 'Search'
      path: '/absolute-path-to-plugins-folder/siriproxy-search'
      api_ebay_appname: 'MA-CLE-APPID-EBAY'