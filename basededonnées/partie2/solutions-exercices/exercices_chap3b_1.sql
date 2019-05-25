-- Créez une procédure stockée d'insertion d'une nouvelle commande dont les
-- paramètres sont les numéros de commande et de client.
-- Déclarez un gestionnaire pour l'erreur d'unicité de la clé primaire
-- (idcommande).

DELIMITER |

DROP PROCEDURE IF EXISTS insert_commande;

CREATE PROCEDURE insert_commande(
  IN pi_idclient MEDIUMINT(8) UNSIGNED,
  IN pi_idcommande MEDIUMINT(8) UNSIGNED
)
BEGIN
  -- Déclaration des conditions
  DECLARE cle_primaire_existante CONDITION FOR 1062;
  DECLARE cle_primaire_absente CONDITION FOR 1452;

  -- Déclaration des gestionnaires d'erreur
  DECLARE CONTINUE HANDLER FOR cle_primaire_existante
  BEGIN
    SELECT 'ERREUR 1062 : Cle primaire existante';
  END;
  DECLARE CONTINUE HANDLER FOR cle_primaire_absente
  BEGIN
    SELECT 'ERREUR 1452 : Cle etrangere - cle primaire absente';
  END;
  DECLARE CONTINUE HANDLER FOR SQLSTATE '23000'
  BEGIN
    SELECT 'ERREUR SQLSTATE 23000 rencontree';
  END;
  DECLARE CONTINUE HANDLER FOR SQLWARNING, SQLEXCEPTION
  BEGIN
    SELECT 'Erreur inconnue rencontree';
  END;

  -- Traitement
  SELECT 'BEGIN procedure insert_commande';
  INSERT INTO commande(idcommande,idclient,datecom)
  VALUES(pi_idcommande, pi_idclient, NOW());
  SELECT 'END procedure insert_commande';
END|

DELIMITER ;


-- Test de la procédure insert_commande
SET @idclient := 20;
SET @idcommande := 200;
CALL insert_commande(@idclient, @idcommande);
