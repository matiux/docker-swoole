Configurazioni docker / docker-compose per Swoole
=====

Per il corretto funzionamento del server con supervisord è necessario creare il file `/var/www/server.php`.

`/var/www` è la working dir del container php

Facendo l'up dei containers, il server si avvierà con il seguente script:

```php
<?php
$server = new Swoole\HTTP\Server('0.0.0.0', 9501);

$server->on("start", function (Swoole\Http\Server $server) {
    echo "Swoole http server is started at http://0.0.0.0:9501\n";
});

$server->on("request", function (Swoole\Http\Request $request, Swoole\Http\Response $response) {
    $response->header("Content-Type", "text/html");
    $response->end("<html><body><h1>Hello World</h1></body></html>");
});

$server->start();
```
