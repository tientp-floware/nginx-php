![FloDAV logo](./flodav/logo_flo.png) FloDAV extends SabreDAV
======================================================
Play with docker-compose
---------
* Clone [Nginx - PHP](https://github.com/tientp-floware/nginx-php) - it's open source
* Clone source code to src folder, if not exist then you can create
* `git clone git@github.com:LeftCoastLogic/FloSabreDAV.git src`
* Rename file .env.example to .env and change your setting
* Build and run `docker-compose up --build`
* Your url: http://localhost:9092

Play with Dockerfile
------
* Rename file .env.example to .env and change your setting
* In file .env `APPLICATION_ENV` change or remove
* `docker build . -t flodav`
* `docker run -d -p 80:80 -p 443:443 flodav`


Introduction
------------
FloDAV just exetend base on SabreDAV, integrate customs plugins

SabreDAV is the most popular WebDAV framework for PHP. Use it to create WebDAV, CalDAV and CardDAV servers.

Full documentation can be found on the website: http://sabre.io/

SabreDAV is being developed by [fruux](https://fruux.com/). 

Refer FloPlugin:  https://floware.atlassian.net/wiki/spaces/FBD/pages/537002236/Plugins+for+Sabredav

FloDAV is being developed by [Floware](https://floware.com)
------------------------