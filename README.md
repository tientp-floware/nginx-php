Play with docker-compose
---------
* Clone [Nginx - PHP](https://github.com/tientp-floware/nginx-php) - it's open source
* Clone source code to src folder, if not exist then you can create
* `src`
* Rename file .env.example to .env and change your setting
* Build and run `docker-compose up --build`
* Your url: http://localhost

Play with Dockerfile
------
* Rename file .env.example to .env and change your setting
* In file .env `APPLICATION_ENV` change or remove
* `docker build . -t flodav`
* `docker run -d -p 80:80 -p 443:443 flodav`