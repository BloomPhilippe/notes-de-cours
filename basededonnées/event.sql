DROP PROCEDURE IF EXISTS event_client;

DELIMITER |
CREATE PROCEDURE event_client()
BEGIN
 -- Déclaration des variables locales
 DECLARE l_idclient INTEGER;
 DECLARE l_gamme VARCHAR(255);
 DECLARE l_compte DECIMAL(9,2);
 DECLARE l_fin_de_boucle BOOLEAN DEFAULT FALSE;

 -- Déclaration des conditions
 DECLARE plus_d_enregistrement CONDITION FOR 1329;

 -- Déclaration des curseurs
 DECLARE curseur_client CURSOR FOR SELECT idclient, compte FROM client;

 -- Déclaration des gestionnaires d'erreur
 DECLARE CONTINUE HANDLER FOR plus_d_enregistrement
  BEGIN
    SET l_fin_de_boucle:=TRUE;
  END;

 -- Début du traitement
  OPEN curseur_client;

  REPEAT
    FETCH curseur_client INTO l_idclient, l_compte;

    IF l_compte <= 0 THEN
	  	SET l_gamme := 'Aa';
    ELSEIF l_compte <= 2000 THEN
      SET l_gamme := 'Bb';
    ELSEIF l_compte <= 4000 THEN
      SET l_gamme := 'Cc';
    ELSEIF l_compte <= 6000 THEN
      SET l_gamme := 'Dd';
    ELSE
        SET l_gamme := 'E';
    END IF;

    SELECT l_idclient, l_compte, l_gamme;

    UPDATE client SET cat = l_gamme WHERE idclient = l_idclient;

    UNTIL l_fin_de_boucle
  END REPEAT;

  CLOSE curseur_client;

END |
DELIMITER ;

/* Execute tous les semaine */

DELIMITER |
CREATE EVENT IF NOT EXISTS test_every_event
ON SCHEDULE
  EVERY 1 WEEK
DO
  BEGIN
    CALL event_client();
  END |
DELIMITER ;

/* Execute tous les jour à 02h */

DELIMITER |
CREATE EVENT IF NOT EXISTS test_every_day_event
ON SCHEDULE
  EVERY 2 DAY_HOUR
DO
  BEGIN
    CALL event_client();
  END |
DELIMITER ;
