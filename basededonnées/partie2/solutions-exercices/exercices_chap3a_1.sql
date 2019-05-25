-- Vous devez créer les procédures suivantes :
-- 1) Sélection des clients en fonction de la localité
-- 2) Sélection des commandes d'un client en fonction de son nom
-- 3) Sélection des articles commandés par les clients en fonction d'une valeur
--    minimale du compte

-- 1) Sélection des clients en fonction de la localité
DROP PROCEDURE IF EXISTS select_clients_par_localite;

DELIMITER |

CREATE PROCEDURE select_clients_par_localite(IN pi_localite VARCHAR(30))
BEGIN
  SELECT * FROM client WHERE localite = pi_localite;
END |

DELIMITER ;

-- Test avec une localité existante --> 
SET @localite := 'verviers';
CALL select_clients_par_localite(@localite);

-- Test avec une localité inexistante
SET @localite := 'popol';
CALL select_clients_par_localite(@localite);

-- 2) Sélection des commandes d'un client en fonction de son nom
DROP PROCEDURE IF EXISTS select_commandes_par_nom_client;

DELIMITER |

CREATE PROCEDURE select_commandes_par_nom_client(IN pi_nom_client VARCHAR(30))
BEGIN
  SELECT * FROM commande
  NATURAL JOIN client
  WHERE nom = pi_nom_client;
END |

DELIMITER ;

SET @nom_client := 'merciers';

CALL select_commandes_par_nom_client(@nom_client);

-- 3) Sélection des articles commandés par les clients en fonction d'une valeur
--    minimale du compte
DROP PROCEDURE IF EXISTS select_articles_par_min_compte;

DELIMITER |

CREATE PROCEDURE select_articles_par_min_compte(IN pi_compte DECIMAL(9, 2))
BEGIN
  SELECT nom, compte, libelle FROM client
  NATURAL JOIN commande
  NATURAL JOIN detail
  NATURAL JOIN produit
  WHERE compte >= pi_compte;
END |

DELIMITER ;

SET @compte_min := -5000;

CALL select_articles_par_min_compte(@compte_min);
