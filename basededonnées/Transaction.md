
# Transaction

## désactiver l'autocommit

Pour éviter que les actions effectue directement, il faut mettre l'autocommit off

```
set autocommit=0;
```

Le fait de désactiver l'autocommit est plus sécure.
Si vous supprimez une ligne et que vous êtes en autocommit, vous ne pourrez plus revenir en arrière.

## démarrer une transaction

```
start transaction;
```

Lorsqu'on est entrain d'effectuer des modififcations lors d'une transaction les données sont dupliquées.

```
start transaction;
delete from client where idclient=2;
select * from client;
ROLLBACK;
select * from client;
```

## vérou (bloquer une table)

MSQL unlock avant chaque lock. Ceci est transparent pour le client.

On ne peut pas utiliser lock plusieurs fois.

Ne pas utiliser
!!!READ UNCOMMITTED!!!
