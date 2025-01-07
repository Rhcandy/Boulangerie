create database boulangerie;
\c boulangerie

CREATE TABLE Categories(
   Id_Categorie SERIAL,
   Nom VARCHAR(50) NOT NULL ,
   PRIMARY KEY(Id_Categorie)
);

CREATE TABLE Recettes(
   Id_Recettes SERIAL,
   PRIMARY KEY(Id_Recettes)
);

CREATE TABLE Unites(
   Id_Unite SERIAL,
   Nom VARCHAR(50) NOT NULL ,
   PRIMARY KEY(Id_Unite)
);

CREATE TABLE Vente(
   Id_Vente SERIAL,
   Total NUMERIC(15,2)  ,
   Date_vente TIMESTAMP,
   PRIMARY KEY(Id_Vente)
);

CREATE TABLE Produit(
   Id_Produit SERIAL,
   Nom VARCHAR(50) NOT NULL ,
   Duree_conservation int,  /* en H  */
   Id_Recettes INTEGER NOT NULL,
   Id_Categorie INTEGER,
   PRIMARY KEY(Id_Produit),
   FOREIGN KEY(Id_Recettes) REFERENCES Recettes(Id_Recettes),
   FOREIGN KEY(Id_Categorie) REFERENCES Categories(Id_Categorie)
);

CREATE TABLE Ingredients(
   Id_Ingredients SERIAL,
   Nom VARCHAR(50) NOT NULL ,
   Id_Unite INTEGER,
   PRIMARY KEY(Id_Ingredients),
   FOREIGN KEY(Id_Unite) REFERENCES Unites(Id_Unite)
);

CREATE TABLE Details_Recettes(
   Id_Details_Recettes SERIAL,
   qtt NUMERIC(15,2)  ,
   Id_Recettes INTEGER NOT NULL,
   Id_Ingredients INTEGER NOT NULL,
   PRIMARY KEY(Id_Details_Recettes),
   FOREIGN KEY(Id_Recettes) REFERENCES Recettes(Id_Recettes),
   FOREIGN KEY(Id_Ingredients) REFERENCES Ingredients(Id_Ingredients)
);

CREATE TABLE Achats(
   Id_Achats SERIAL,
   qtt_initiale NUMERIC(15,2)  ,
   qtt_reste NUMERIC(15,2)  ,
   Prix_Unitaire NUMERIC(15,2)  ,
   date_expiration TIMESTAMP,
   Id_Ingredients INTEGER NOT NULL,
   PRIMARY KEY(Id_Achats),
   FOREIGN KEY(Id_Ingredients) REFERENCES Ingredients(Id_Ingredients)
);

CREATE TABLE Fabrication_(
   Id_Fabrication_ SERIAL,
   qtt_initiale NUMERIC(15,2)  CHECK (qtt_initiale > 0), -- Ajout de contrainte
   qtt_reste NUMERIC(15,2)  ,
   Dt_Fabrique TIMESTAMP ,
   Dt_Expiration TIMESTAMP, -- Correction du type
   Cout_fabrication_unitaire NUMERIC(15,2)  ,
   Id_Produit INTEGER NOT NULL,
   PRIMARY KEY(Id_Fabrication_),
   FOREIGN KEY(Id_Produit) REFERENCES Produit(Id_Produit)
);
UPDATE Fabrication_
SET Dt_Fabrique = CURRENT_TIMESTAMP;


CREATE TABLE Details_Ventes(
   Id_Vente INTEGER,
   Id_Details_Ventes SERIAL,
   qtt NUMERIC(15,2)  ,
   Id_Produit INTEGER NOT NULL,
   PRIMARY KEY(Id_Vente, Id_Details_Ventes),
   FOREIGN KEY(Id_Vente) REFERENCES Vente(Id_Vente),
   FOREIGN KEY(Id_Produit) REFERENCES Produit(Id_Produit)
);


CREATE OR REPLACE FUNCTION calculer_cout_fabrication_unitaire()
RETURNS TRIGGER AS $$
DECLARE
    total_cout NUMERIC(15,2) := 0;
    ingredient RECORD;
    qtt_requise NUMERIC(15,2);  -- Quantité à utiliser pour un ingrédient
    achat RECORD;
    duree_conservation_produit  INTERVAL;  -- Durée de conservation en heures
BEGIN
    -- Récupérer la durée de conservation et la date de fabrication du produit
    SELECT (Duree_conservation || ' hours')::INTERVAL INTO duree_conservation_produit
    FROM Produit
    WHERE Id_Produit = NEW.Id_Produit;

    -- Calculer la date d'expiration du produit
    NEW.Dt_Expiration := NEW.Dt_Fabrique + duree_conservation_produit;

    -- Parcourir tous les ingrédients nécessaires pour la recette
    FOR ingredient IN
        SELECT dr.qtt, dr.Id_Ingredients
        FROM Details_Recettes dr
        WHERE dr.Id_Recettes = (SELECT Id_Recettes FROM Produit WHERE Id_Produit = NEW.Id_Produit)
    LOOP
        -- Calculer la quantité requise pour fabriquer NEW.qtt_initiale produits
        qtt_requise := ingredient.qtt * NEW.qtt_initiale;

        -- Récupérer les achats non expirés pour cet ingrédient, triés par date d'expiration (FIFO)
        FOR achat IN
            SELECT Id_Achats, qtt_reste, Prix_Unitaire
            FROM Achats
            WHERE Id_Ingredients = ingredient.Id_Ingredients
              AND (date_expiration IS NULL OR date_expiration > NOW())
              AND (qtt_reste > 0)
            ORDER BY date_expiration
        LOOP
            -- Si la quantité restante de l'achat peut couvrir la quantité requise
            IF achat.qtt_reste >= qtt_requise THEN
                -- Ajouter le coût au total
                total_cout := total_cout + (qtt_requise * achat.Prix_Unitaire);

                -- Réduire le stock dans l'achat
                UPDATE Achats
                SET qtt_reste = qtt_reste - qtt_requise
                WHERE Id_Achats = achat.Id_Achats;

                -- La quantité requise est satisfaite
                qtt_requise := 0;
                EXIT;  -- Sortir de la boucle des achats
            ELSE
                -- Utiliser tout le stock restant de cet achat
                total_cout := total_cout + (achat.qtt_reste * achat.Prix_Unitaire);
                qtt_requise := qtt_requise - achat.qtt_reste;

                -- Mettre le stock à zéro
                UPDATE Achats
                SET qtt_reste = 0
                WHERE Id_Achats = achat.Id_Achats;
            END IF;
        END LOOP;

        -- Si après avoir parcouru tous les achats, il reste une quantité non satisfaite
        IF qtt_requise > 0 THEN
            RAISE EXCEPTION 'Quantité insuffisante pour l''ingrédient %', ingredient.Id_Ingredients;
        END IF;
    END LOOP;

    -- Calculer le coût de fabrication unitaire
    IF NEW.qtt_initiale = 0 THEN
        RAISE EXCEPTION 'La quantité initiale ne peut pas être nulle ou zéro.';
    END IF;

    NEW.Cout_fabrication_unitaire := total_cout / NEW.qtt_initiale;
    -- S'assurer que qtt_reste est égal à qtt_initiale
    NEW.qtt_reste := NEW.qtt_initiale;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_calculer_cout_fabrication_unitaire
BEFORE INSERT ON Fabrication_
FOR EACH ROW
EXECUTE FUNCTION calculer_cout_fabrication_unitaire();


CREATE VIEW vue_qtt_reste_totale AS
SELECT
    Id_Produit,
    SUM(qtt_reste) AS qtt_reste_totale
FROM
    Fabrication_
WHERE
    Dt_Expiration > CURRENT_DATE
GROUP BY
    Id_Produit;

CREATE VIEW vue_qtt_reste_stock_Ingredient AS
SELECT
    Id_Ingredients,
    SUM(qtt_reste) AS qtt_reste_totale
FROM
    Achats
WHERE
    date_expiration > CURRENT_DATE
GROUP BY
    Id_Ingredients;

CREATE OR REPLACE VIEW vue_prix_vente AS
SELECT
    Id_Produit,
    ROUND(AVG(Cout_fabrication_unitaire) * 1.30, 3) AS prix_vente
FROM
    Fabrication_
WHERE
    Dt_Expiration > CURRENT_DATE
GROUP BY
    Id_Produit;







-- Insertion des catégories
INSERT INTO Categories (Nom) VALUES
('Pains'), 
('Viennoiseries'), 
('Pâtisseries'), 
('Snacks');

-- Insertion des unités
INSERT INTO Unites (Nom) VALUES
('Kilogramme'), 
('Litre'), 
('Pièce');

-- Insertion des ingrédients
INSERT INTO Ingredients (Nom, Id_Unite) VALUES
('Farine', 1), 
('Sucre', 1), 
('Beurre', 1), 
('Chocolat noir', 1), 
('Levure', 1), 
('Lait', 2), 
('Œufs', 3);

-- Insertion des recettes
INSERT INTO Recettes VALUES
(DEFAULT), 
(DEFAULT), 
(DEFAULT), 
(DEFAULT);

-- Insertion des produits
INSERT INTO Produit (Nom, Duree_conservation, Id_Recettes, Id_Categorie) VALUES
('Baguette', '36', 1, 1), 
('Croissant', '48', 2, 2), 
('Tarte au chocolat', '48', 3, 3), 
('Sandwich jambon-fromage', '12', 4, 4);

-- Insertion des détails des recettes
INSERT INTO Details_Recettes (qtt, Id_Recettes, Id_Ingredients) VALUES
(0.5, 1, 1), -- Farine pour Baguette
(0.02, 1, 5), -- Levure pour Baguette

(0.2, 2, 1), -- Farine pour Croissant
(0.15, 2, 3), -- Beurre pour Croissant

(0.2, 3, 1), -- Farine pour Tarte
(0.25, 3, 4), -- Chocolat noir pour Tarte

(0.5, 4, 6), -- Lait pour Sandwich
(2.0, 4, 7); -- Œufs pour Sandwich

-- Insertion des achats d'ingrédients
INSERT INTO Achats (qtt_initiale, qtt_reste, Prix_Unitaire, date_expiration, Id_Ingredients) VALUES
(100.0, 60.0, 0.50, '2025-02-15', 1), -- Farine
(50.0, 45.0, 0.80, '2025-01-20', 2), -- Sucre
(30.0, 25.0, 1.50, '2025-01-18', 3), -- Beurre
(20.0, 10.0, 3.00, '2025-01-25', 4), -- Chocolat noir
(10.0, 7.0, 0.70, '2025-01-12', 5), -- Levure
(15.0, 12.0, 0.90, '2025-01-10', 6), -- Lait
(60.0, 50.0, 0.20, '2025-01-08', 7); -- Œufs

INSERT INTO Fabrication_ (qtt_initiale, Dt_Fabrique, Id_Produit)
VALUES (50, NOW(),1);