
## exporter en CSV

```
SELECT * from myTable
INTO OUTFILE '/tmp/querydump.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
```


## Afficher le code SQL pour créer une table particulière

```
SHOW CREATE TABLE mega_tags;
```
