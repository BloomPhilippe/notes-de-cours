-- 1) Sur base d'un paramètre représentant l'id d'un client, vous afficherez,
-- en fonction de son compte et selon les gammes suivantes, le message
-- correspondant :
-- <= 0 : Gamme 0
--    1 – 2000 : Gamme 1
-- 2001 – 4000 : Gamme 2
-- 4001 – 6000 : Gamme 3
--     >= 6001 : Gamme 4

-- 1) Sur base d'un paramètre représentant l'id d'un client, vous afficherez,
-- en fonction de son compte et selon les gammes suivantes, le message
-- correspondant :
-- <= 0 : Gamme 0
--    1 – 2000 : Gamme 1
-- 2001 – 4000 : Gamme 2
-- 4001 – 6000 : Gamme 3
--     >= 6001 : Gamme 4
DROP PROCEDURE IF EXISTS comptes_par_clients;

DELIMITER |

CREATE PROCEDURE comptes_par_clients(IN pi_idclient MEDIUMINT(8) UNSIGNED)
BEGIN
  -- Déclaration des variables locales
  DECLARE l_compte DECIMAL(9,2) DEFAULT 0.00;
  DECLARE l_gamme TINYINT DEFAULT 0;

  -- Affectation des valeurs aux variables locales
  SELECT compte INTO l_compte FROM client WHERE idclient = pi_idclient;

  -- Traitement
  CASE
  	WHEN l_compte<=0 THEN
      SET l_gamme := 0;
    WHEN l_compte>0 AND l_compte<=2000 THEN
      SET l_gamme := 1;
    WHEN l_compte>2000 AND l_compte<=4000 THEN
      SET l_gamme := 2;
    WHEN l_compte>4000 AND l_compte<=6000 THEN
      SET l_gamme := 3;
    WHEN l_compte>6000 THEN
      SET l_gamme := 4;
  END CASE;

  -- Affichage
  SELECT pi_idclient AS 'Idclient', l_compte AS 'Compte', CONCAT_WS(' ', 'Gamme', l_gamme) AS 'Gamme client';

END |

DELIMITER ;

-- Test de la procédure comptes_par_clients
SET @idclient := 2;
CALL comptes_par_clients(@idclient);
