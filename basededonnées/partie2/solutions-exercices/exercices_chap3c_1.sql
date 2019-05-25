-- 1. Créez une procédure stockée pour modifier les prix des
-- produits en fonction d'une valeur de TVA passée en paramètre

DROP PROCEDURE IF EXISTS add_tva;

DELIMITER |

CREATE PROCEDURE add_tva(
  IN pi_taux_tva FLOAT UNSIGNED
)
BEGIN
  -- Déclaration des variables locales
  DECLARE l_fin_de_boucle BOOLEAN DEFAULT FALSE;
  DECLARE l_idproduit CHAR(10);
  DECLARE l_prix DECIMAL(9,2);
  
  -- Déclaration des conditions
  DECLARE plus_d_enregistrement CONDITION FOR 1329;
  
  -- Déclaration des curseurs
  DECLARE curseur_produits CURSOR
	FOR SELECT idproduit, prix FROM produit;  
  
  -- Déclaration des gestionnaires d'erreur
  DECLARE CONTINUE HANDLER FOR plus_d_enregistrement
	BEGIN
		SET l_fin_de_boucle:=TRUE;
	END;
  
  -- Traitement
  SELECT 'BEGIN procedure add_tva';
  
  OPEN curseur_produits;
  
  REPEAT
	FETCH curseur_produits INTO l_idproduit, l_prix;
	UPDATE produit
	SET prix = (1 + pi_taux_tva) * l_prix
	WHERE idproduit = l_idproduit;
  UNTIL l_fin_de_boucle>0
  END REPEAT;
  
  CLOSE curseur_produits;
  
  SELECT 'END procedure add_tva';
END|

DELIMITER ;


-- Test de la procédure add_tva
SET @taux_tva := 0.21;
CALL add_tva(@taux_tva);





-- 2. Créez une procédure stockée pour mettre en minuscules tous
-- les noms et prénoms dans la table client

DROP PROCEDURE IF EXISTS client_name_to_lower;

DELIMITER |

CREATE PROCEDURE client_name_to_lower()
BEGIN
  -- Déclaration des variables locales
  DECLARE l_fin_de_boucle BOOLEAN DEFAULT FALSE;
  DECLARE l_idclient MEDIUMINT(10) UNSIGNED;
  DECLARE l_nom VARCHAR(30);
  DECLARE l_prenom VARCHAR(30);
  
  -- Déclaration des conditions
  DECLARE plus_d_enregistrement CONDITION FOR 1329;
  
  -- Déclaration des curseurs
  DECLARE curseur_clients CURSOR
	FOR SELECT idclient, nom, prenom FROM client;  
  
  -- Déclaration des gestionnaires d'erreur
  DECLARE CONTINUE HANDLER FOR plus_d_enregistrement
	BEGIN
		SET l_fin_de_boucle:=TRUE;
	END;
  
  -- Traitement
  SELECT 'BEGIN procedure client_name_to_lower';
  
  OPEN curseur_clients;
  
  REPEAT
	FETCH curseur_clients INTO l_idclient, l_nom, l_prenom;
	UPDATE client
	SET nom = LOWER(l_nom), prenom = LOWER(l_prenom)
	WHERE idclient = l_idclient;
  UNTIL l_fin_de_boucle>0
  END REPEAT;
  
  CLOSE curseur_clients;
  
  SELECT 'END procedure client_name_to_lower';
END|

DELIMITER ;

-- Test de la procédure client_name_to_lower
CALL client_name_to_lower();


-- 3. Créez une fonction stockée qui retourne la catégorie à
-- laquelle un client appartient en fonction de ses achats :
-- ● 1 achat ou moins : A
-- ● 2 achats : B
-- ● 3 achats ou plus : C
-- ● Moins de 1000€ : 0
-- ● De 1000 à 15000€ : 1
-- ● Plus de 15000€ : 2

DROP FUNCTION IF EXISTS category;

DELIMITER |

CREATE FUNCTION category(pi_idclient MEDIUMINT(10) UNSIGNED) RETURNS CHAR(2)
DETERMINISTIC
BEGIN
  -- Déclaration des variables locales
  DECLARE l_n_commandes MEDIUMINT(10) UNSIGNED;
  DECLARE l_montant_total_commandes DECIMAL(9,2);
  DECLARE l_categorie CHAR(2);

  -- Sélection du nombre de commandes
  SELECT COUNT(*) INTO l_n_commandes
  FROM commande
  WHERE idclient = pi_idclient;
  
  -- Sélection du montant total des commandes
  SELECT SUM(qcom*prix) INTO l_montant_total_commandes
  FROM commande
  NATURAL JOIN detail
  NATURAL JOIN produit
  WHERE idclient = pi_idclient;
  
  -- Premier caractère de la catégorie en fonction du nombre de commandes
  CASE
	WHEN l_n_commandes <= 1 THEN
		SET l_categorie := 'A';
	WHEN l_n_commandes = 2 THEN
		SET l_categorie := 'B';
	WHEN l_n_commandes >= 3 THEN
		SET l_categorie := 'C';
	ELSE
		SET l_categorie := 'A';
  END CASE;
  
  -- Deuxième caractère de la catégorie en fonction du montant total des commandes
  CASE
	WHEN l_montant_total_commandes < 1000 THEN
		SET l_categorie := CONCAT(l_categorie, '0');
	WHEN l_montant_total_commandes <= 15000 THEN
		SET l_categorie := CONCAT(l_categorie, '1');
	WHEN l_montant_total_commandes > 15000 THEN
		SET l_categorie := CONCAT(l_categorie, '2');
	ELSE
		SET l_categorie := CONCAT(l_categorie, '0');
  END CASE;
  
  RETURN l_categorie;
  
END |

DELIMITER ;

-- Test de la fonction category
SELECT category(4);

-- 4. Utilisez la fonction créée au point 3 pour modifier les
-- catégories des clients grâce à une nouvelle procédure stockée

DROP PROCEDURE IF EXISTS clients_categories;

DELIMITER |

CREATE PROCEDURE clients_categories()
BEGIN
  -- Déclaration des variables locales
  DECLARE l_fin_de_boucle BOOLEAN DEFAULT FALSE;
  DECLARE l_idclient MEDIUMINT(10) UNSIGNED;
  
  -- Déclaration des conditions
  DECLARE plus_d_enregistrement CONDITION FOR 1329;
  
  -- Déclaration des curseurs
  DECLARE curseur_clients CURSOR
	FOR SELECT idclient FROM client;  
  
  -- Déclaration des gestionnaires d'erreur
  DECLARE CONTINUE HANDLER FOR plus_d_enregistrement
	BEGIN
		SET l_fin_de_boucle:=TRUE;
	END;
  
  -- Traitement
  SELECT 'BEGIN procedure clients_categories';
  
  OPEN curseur_clients;
  
  REPEAT
	FETCH curseur_clients INTO l_idclient;
	UPDATE client
	SET cat = category(l_idclient)
	WHERE idclient = l_idclient;
  UNTIL l_fin_de_boucle > 0
  END REPEAT;
  
  CLOSE curseur_clients;
  
  SELECT 'END procedure clients_categories';
END|

DELIMITER ;

-- Test de la procédure clients_categories
CALL clients_categories();










