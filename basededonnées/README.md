# SGBD

Privilièger la case insensitive, exemple utf8_general_ci

Le _ci = case insensitive

Chemin msql : D:\EasyPHP\EasyPHP-Devserver-17\eds-binaries\dbserver

Pas de path mysql disponible pour utiliser les commandes donc se placer dans le dossier bin de mysql et effectuer la commande :

```
mysql -u root -p
```
**Executer un script mysql**
- se connecter au CLI mysql
- executer la commande ci-dessous

```
source chemin_du_fichier
```
Quand supprime/ajouter un utilisateur, il faut le faire avec le adresse...

```
drop user 'nomUtilisateur'@'adresse';
```

**Utiliser une db**

```
use nom_de_la_db
```

**Ajouter un privilège**

```
GRANT SELECT, INSERT ON `clicom`.* TO 'Test'@'%';


// créer user en même temps
GRANT SELECT, INSERT ON `clicom`.client TO 'secretaire1'@'localhost' identified by 'password';
```

Bien décortiquer son script
- ne pas créer d'utilisateur en liant à un role
- créer un utilisateur
- lier un utilisateur à un role

**Voir les privileges sur une DB**

```
select * from information_schema.table_privileges;
```


**Voir les privileges sur une colonne**

```
select * from information_schema.colmn_privileges;
```
https://linuxize.com/post/how-to-create-mysql-user-accounts-and-grant-privileges/


