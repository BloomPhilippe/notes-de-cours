-- Créez une procédure permettant de déclencher une erreur et
-- l'affichage du message adéquat si le stock du produit qu'un
-- client désire commander n'est pas suffisant
-- (paramètres : idproduit, qcom)

DELIMITER |

DROP PROCEDURE IF EXISTS check_stock_produit;

CREATE PROCEDURE check_stock_produit(
  IN pi_idproduit CHAR(10),
  IN pi_qcom MEDIUMINT(8) UNSIGNED
)
BEGIN
  -- Déclaration des variables locales
  DECLARE l_qstock MEDIUMINT(8) UNSIGNED DEFAULT 0;

  -- Déclaration des conditions
  DECLARE stock_insuffisant CONDITION FOR SQLSTATE '90001';

  -- Déclaration des gestionnaires d'erreur

  -- Traitement
  SELECT qstock INTO l_qstock
  FROM produit
  WHERE idproduit=pi_idproduit;

  IF l_qstock < pi_qcom THEN
    SIGNAL stock_insuffisant
    SET MESSAGE_TEXT='Stock insuffisant';
  ELSE
    SELECT 'Stock OK';
  END IF;

END|

DELIMITER ;

-- Test de la procédure check_stock_produit
SET @idproduit='CS262';
SET @qcom=100;
CALL check_stock_produit(@idproduit, @qcom);
