Open an app
=============

Launch an app (ask the proxy's administrator to enable this feature on your device).

Keywords: open Facebook, open Twitter, open mail, open TomTom, open music, ...

How to install
---------------

Nothing in particular on the server but each device must be configurate separately to make this plugin works.
These changes will redirect Bing search to my server, which will redirect you to a special url scheme to open an app (e.g. youtube:)

On each iDevice :

Add these lines to the file `/etc/hosts` of your iDevices. Leave at least one blank line at the end of the file. You may need to add another subdomain of Bing on iPad (e.g. uk.bing.com in United Kingdom or maybe bing.com in the U.S.A.)

91.121.103.229 m.bing.com

91.121.103.229 be.bing.com

91.121.103.229 fr.bing.com

