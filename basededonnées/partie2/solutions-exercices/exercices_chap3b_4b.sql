-- Créez une procédure permettant de déclencher une erreur et
-- de placer le message adéquat si le compte d'un client est négatif
-- Créez une procédure permettant d'ajouter une commande et qui fait
-- appel à la procédure ci-dessus pour vérifier si la commande
-- peut être ajoutée

DELIMITER |

DROP PROCEDURE IF EXISTS client_compte_negatif;

CREATE PROCEDURE client_compte_negatif(
  IN pi_idclient MEDIUMINT(8) UNSIGNED
)
BEGIN
  -- Déclaration des variables locales
  DECLARE l_compte_client DECIMAL(9,2) DEFAULT 0.00;

  -- Déclaration des conditions
  DECLARE compte_negatif CONDITION FOR SQLSTATE '90002';

  -- Déclaration des gestionnaires d'erreur

  -- Traitement
  SELECT compte INTO l_compte_client
  FROM client
  WHERE idclient=pi_idclient;

  IF l_compte_client < 0.00 THEN
    SIGNAL compte_negatif
    SET MESSAGE_TEXT='Le compte du client est negatif';
  END IF;

END|

DROP PROCEDURE IF EXISTS ajout_commande;

CREATE PROCEDURE ajout_commande(
  IN pi_idclient MEDIUMINT(8) UNSIGNED
)
BEGIN
  -- Déclaration des conditions
  DECLARE compte_negatif CONDITION FOR SQLSTATE '90002';

  -- Déclaration des gestionnaires d'erreur
  DECLARE EXIT HANDLER FOR compte_negatif
  BEGIN
    -- Écraser le texte par défaut de la condition
    SIGNAL compte_negatif
    SET MESSAGE_TEXT='Compte < 0.00';
  END;

  -- Traitement
  CALL client_compte_negatif(pi_idclient);

  -- Si on arrive ici, compte client OK, on peut insérer la commande
  INSERT INTO COMMANDE(idclient, datecom)
  VALUES(pi_idclient, NOW());

END|

DELIMITER ;

SET @idclient=1;
-- Test de la procédure ajout_commande
CALL ajout_commande(@idclient);
