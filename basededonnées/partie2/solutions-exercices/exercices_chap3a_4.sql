-- 1) Avec chaque type de boucle, affichez les dix premiers éléments de la table
-- de multiplication d'un nombre passé en paramètre
-- 2) Affichez, pour les dix premiers idclient, le nom et le prénom si le client
-- existe, « Vide » sinon.
-- 3) Testez les différents cas de figure d'utilisation de LEAVE et ITERATE :
-- a) Label de boucle
-- b) Label d'une boucle externe
-- c) Label placé sur le bloc global

-- 1) Avec chaque type de boucle, affichez les dix premiers éléments de la table
-- de multiplication d'un nombre passé en paramètre
DROP PROCEDURE IF EXISTS table_multiplication;

DELIMITER |

CREATE PROCEDURE table_multiplication(IN pi_nombre SMALLINT UNSIGNED)
BEGIN
-- Déclaration des variables locales
  DECLARE l_compteur SMALLINT UNSIGNED DEFAULT 0;
  DECLARE l_message TINYTEXT DEFAULT '';
  DECLARE l_n_max INT UNSIGNED DEFAULT 10;

-- Traitement
  -- Boucle à conditions en entrée de boucle
  SET l_compteur := 1;
  SET l_message := '';
  WHILE l_compteur<=l_n_max DO
    SET l_message := CONCAT_WS(' ', l_message, pi_nombre*l_compteur);
    SET l_compteur := l_compteur+1;
  END WHILE;
  SELECT l_message AS 'Table de multiplication';

  -- Boucle à conditions en sortie de boucle
  SET l_compteur := 1;
  SET l_message := '';
  REPEAT
    SET l_message := CONCAT_WS(' ', l_message, pi_nombre*l_compteur);
    SET l_compteur := l_compteur+1;
  UNTIL l_compteur>l_n_max
  END REPEAT;
  SELECT l_message AS 'Table de multiplication';

  -- Boucle infinie
  SET l_compteur := 1;
  SET l_message := '';
  boucle: LOOP
    SET l_message := CONCAT_WS(' ', l_message, pi_nombre*l_compteur);
    SET l_compteur := l_compteur+1;
    IF l_compteur>l_n_max THEN
      LEAVE boucle;
    END IF;
  END LOOP boucle;
  SELECT l_message AS 'Table de multiplication';

END |

DELIMITER ;

SET @nombre := 7;
CALL table_multiplication(@nombre);

-- 2) Affichez, pour les dix premiers idclient, le nom et le prénom si le client
-- existe, « Vide » sinon.
DROP PROCEDURE IF EXISTS test_clients_existent;

DELIMITER |

CREATE PROCEDURE test_clients_existent()
BEGIN
-- Déclaration des variables locales
  DECLARE l_compteur SMALLINT UNSIGNED DEFAULT 0;
  DECLARE l_result CHAR(20);
  DECLARE l_n_clients SMALLINT UNSIGNED DEFAULT 10;
-- Traitement
  SET l_compteur = 1;
  WHILE l_compteur<=l_n_clients DO
    SELECT idclient INTO l_result FROM client WHERE idclient=l_compteur;

    IF l_result=l_compteur THEN
      SELECT nom, prenom FROM client WHERE idclient=l_compteur;
    ELSE
      SELECT 'Vide';
    END IF;

    SET l_compteur = l_compteur+1;
  END WHILE;

END |

DELIMITER ;

CALL test_clients_existent();
