-- 1) Sur base d'un paramètre représentant l'id d'un client, vous afficherez
-- s'il existe des commandes ainsi que leur nombre
-- 2) Sur base d'un paramètre représentant l'id d'un client, vous déterminerez
-- et afficherez si l'état de son compte est supérieur, égal ou inférieur à la
-- moyenne des comptes, que vous afficherez également
-- 3) Sur base d'un paramètre représentant l'id d'un produit, vous afficherez
-- le libellé et la quantité totale commandée

-- -----------------
-- Solutions
-- -----------------

-- 1) Sur base d'un paramètre représentant l'id d'un client, vous afficherez
-- s'il existe des commandes ainsi que leur nombre
DROP PROCEDURE IF EXISTS commandes_par_client;

DELIMITER |

CREATE PROCEDURE commandes_par_client(IN pi_idclient MEDIUMINT(8) UNSIGNED)
BEGIN
-- Déclaration des variables locales
  DECLARE l_n_commandes SMALLINT UNSIGNED DEFAULT 0;

-- Affectation des valeurs aux variables locales
  SELECT COUNT(*) INTO l_n_commandes
  FROM commande
  WHERE idclient = pi_idclient;

-- Traitement de ces valeurs et affichage
  IF l_n_commandes > 0 THEN
    SELECT pi_idclient AS 'Idclient', l_n_commandes AS 'Nombre de commandes';
  ELSE
    SELECT pi_idclient AS 'Idclient', 'Pas de commande' AS 'Nombre de commandes';
  END IF;

END |

DELIMITER ;

-- Test de la procédure commandes_par_client
SET @idclient := 8;
CALL commandes_par_client(@idclient);

-- 2) Sur base d'un paramètre représentant l'id d'un client, vous déterminerez
-- et afficherez si l'état de son compte est supérieur, égal ou inférieur à la
-- moyenne des comptes, que vous afficherez également
DROP PROCEDURE IF EXISTS compte_rapport_moyenne_client;

DELIMITER |

CREATE PROCEDURE compte_rapport_moyenne_client(IN pi_idclient MEDIUMINT(8) UNSIGNED)
BEGIN
-- Déclaration des variables locales
  DECLARE l_moyenne_comptes DECIMAL(9,2) DEFAULT 0.00;
  DECLARE l_compte_client DECIMAL(9,2) DEFAULT 0.00;

-- Affectation des valeurs aux variables locales
  SELECT AVG(compte) INTO l_moyenne_comptes FROM client;
  SELECT compte INTO l_compte_client FROM client WHERE idclient = pi_idclient;

-- Traitement de ces valeurs et affichage
  IF l_compte_client > l_moyenne_comptes THEN
    SELECT pi_idclient AS 'Idclient', l_compte_client AS 'Compte', 'SUPERIEUR', l_moyenne_comptes AS 'Moyenne des comptes';
  ELSEIF l_compte_client < l_moyenne_comptes THEN
    SELECT pi_idclient AS 'Idclient', l_compte_client AS 'Compte', 'INFERIEUR', l_moyenne_comptes AS 'Moyenne des comptes';
  ELSE
    SELECT pi_idclient AS 'Idclient', l_compte_client AS 'Compte', 'EGAL', l_moyenne_comptes AS 'Moyenne des comptes';
  END IF;

END |

DELIMITER ;

SET @idclient := 2;
CALL compte_rapport_moyenne_client(@idclient);

-- 3) Sur base d'un paramètre représentant l'id d'un produit, vous afficherez
-- le libellé et la quantité totale commandée
DROP PROCEDURE IF EXISTS quantite_commandee_par_produit;

DELIMITER |

CREATE PROCEDURE quantite_commandee_par_produit(IN pi_idproduit CHAR(10))
BEGIN
-- Déclaration des variables locales

-- Affectation des valeurs aux variables locales

-- Traitement de ces valeurs et affichage
  SELECT libelle, SUM(qcom) AS 'Quantite commandee' FROM DETAIL
  NATURAL JOIN PRODUIT
  GROUP BY idproduit
  HAVING idproduit=pi_idproduit;

END |

DELIMITER ;

SET @idproduit := 'CS464';
CALL quantite_commandee_par_produit(@idproduit);
