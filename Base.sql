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
ALTER TABLE recettes add COLUMN nom varchar(10);

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

 create table HistoPrixProduit(
    Id_H serial primary key,
    Id_prod int ,
    Date_insert date,
    Prix NUMERIC(10,2),
    FOREIGN KEY (Id_prod) REFERENCES Produit(Id_Produit)
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

CREATE OR REPLACE FUNCTION public.update_qtt_reste()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF
AS $BODY$
DECLARE
    fabrication RECORD;
    qtt_restante NUMERIC(15,2) := NEW.qtt; -- Quantit‚ restante … d‚duire
BEGIN
    -- Boucle pour parcourir les fabrications valides
    LOOP
        -- Recherche de la premiŠre fabrication valide pour le produit concern‚
        SELECT * INTO fabrication
        FROM Fabrication_
        WHERE Id_Produit = NEW.Id_Produit
          AND Dt_Expiration > NOW()
          AND qtt_reste > 0
        ORDER BY Dt_Fabrique
        LIMIT 1;

        -- Si aucune fabrication valide n'est trouv‚e, on lŠve une exception
        IF NOT FOUND THEN
            RAISE EXCEPTION 'Manque en stock d‚sol‚ pour le produit ID %', NEW.Id_Produit;
        END IF;

        -- Si la quantit‚ restante dans la fabrication est suffisante
        IF fabrication.qtt_reste >= qtt_restante THEN
            UPDATE Fabrication_
            SET qtt_reste = qtt_reste - qtt_restante
            WHERE Id_Fabrication_ = fabrication.Id_Fabrication_;
            EXIT; -- Sortir de la boucle
        ELSE
            -- Sinon, on utilise toute la quantit‚ restante de cette fabrication
            qtt_restante := qtt_restante - fabrication.qtt_reste;
            UPDATE Fabrication_
            SET qtt_reste = 0
            WHERE Id_Fabrication_ = fabrication.Id_Fabrication_;
        END IF;
    END LOOP;

    RETURN NEW;
END;
$BODY$;






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

CREATE table Suggestion(
    Id_Suggestion serial PRIMARY KEY,
    Id_Produit INTEGER,
    Date_deb TIMESTAMP,
    Date_fin TIMESTAMP,
    Descri TEXT,
    FOREIGN KEY (Id_Produit) REFERENCES Produit(Id_Produit)
);

-- Insertion des suggestions
-- Insertion des suggestions sans accents
INSERT INTO Suggestion (Id_Produit, Date_deb, Date_fin, Descri) VALUES
(1, '2025-01-15 08:00:00', '2025-01-20 20:00:00', 'Promotion speciale : Achetez 2 baguettes et recevez une troisieme gratuite !'),
(2, '2025-01-18 09:00:00', '2025-01-25 18:00:00', 'Essayez nos croissants au beurre, parfaits pour un petit-dejeuner savoureux !'),
(3, '2025-02-01 10:00:00', '2025-02-14 20:00:00', 'Offre Saint-Valentin : Une tarte au chocolat achetee, la deuxieme a moitie prix !'),
(4, '2025-01-12 11:00:00', '2025-01-19 15:00:00', 'Dejeuner express : Sandwich jambon-fromage a prix reduit pour accompagner votre pause dejeuner.'),
(1, '2025-01-22 08:00:00', '2025-01-30 20:00:00', 'Fete du pain : Offres speciales sur toutes les baguettes !'),
(3, '2025-02-20 10:00:00', '2025-02-28 20:00:00', 'Decouvrez notre tarte au chocolat avec une touche de noisette pour un plaisir gourmand.');


create Table Clients(
    Id_Client serial PRIMARY key,
    nom VARCHAR(50)
);

Alter table vente add COLUMN Id_Client int;
alter table vente ADD constraint fk_Id_client FOREIGN KEY (Id_Client) REFERENCES Clients(Id_Client); 

-- Insertion des clients
INSERT INTO Clients (nom) VALUES
('Jean Dupont'),
('Marie Curie'),
('Alice Martin');

-- Mise à jour de la table Vente
INSERT INTO Vente (Total, Date_vente, Id_Client) VALUES
(25.50, '2025-01-15 12:00:00', 1),
(13.20, '2025-01-16 15:00:00', 2),
(45.00, '2025-01-17 09:30:00', 3);

INSERT INTO Details_Ventes (Id_Vente, qtt, Id_Produit) VALUES
(1, 3, 1), -- 3 baguettes pour la première vente
(2, 2, 2), -- 2 croissants pour la deuxième vente
(3, 1, 3); -- 1 tarte au chocolat pour la troisième vente


CREATE Table Roles (
    Id_Role serial PRIMARY key,
    Nom VARCHAR(50)
);

create table Employe(
    Id_Employe serial PRIMARY key,
    Id_Role int,
    Nom VARCHAR(50),
    FOREIGN key (Id_Role) REFERENCES Roles(Id_Role)
);

alter table Vente ADD COLUMN Id_Employe int;
alter table Vente add constraint fk_Id_Employe FOREIGN key (Id_Employe) REFERENCES Employe(Id_Employe);

CREATE TABLE Vente(
   Id_Vente SERIAL PRIMARY KEY,
   Total NUMERIC(15,2)  ,
   Date_vente TIMESTAMP,
   Id_Client int,
   Id_Employe int,
   FOREIGN key (Id_Client) REFERENCES Clients(Id_Clients),
   FOREIGN KEY (Id_Employe) REFERENCES Employe(Id_Employe)
);

create table Employe(
    Id_Employe serial PRIMARY key,
    Id_Role int,
    Nom VARCHAR(50),
    FOREIGN key (Id_Role) REFERENCES Roles(Id_Role)
);

cree moi une fonction qui a pour argument % commission , date deut , date fin ; qui retourne Id_Employe , totale = (somme ventes employes entre les 2 dates * % commisions) et le nombres totales de ventes pour cette employe,

INSERT INTO Roles (Nom) VALUES
('Vendeur'),
('Manager'),
('Caissier'),
('Livreur');

create table genre(
    Id_Genre serial PRIMARY key,
    Nom varchar(50)
);


INSERT INTO Employe (Id_Role, Nom) VALUES
(1, 'Pierre Dubois'),  -- Vendeur
(1, 'Sophie Lefevre'),  -- Manager
(3, 'Maxime Robert'),  -- Caissier
(4, 'Lucie Martin');


alter table Employe add COLUMN Id_Genre int;
alter table Employe add constraint fk_id_genre FOREIGN key (Id_Genre) REFERENCES genre(Id_Genre);     -- Livreur


-- Mise à jour de la table Vente avec l'Id_Employe
UPDATE Vente SET Id_Employe = 1 WHERE Id_Vente = 1;  -- Vente 1 attribuée à Pierre Dubois (Vendeur)
UPDATE Vente SET Id_Employe = 2 WHERE Id_Vente = 2;  -- Vente 2 attribuée à Sophie Lefevre (Manager)
-- UPDATE Vente SET Id_Employe = 3 WHERE Id_Vente = 3;  -- Vente 3 attribuée à Maxime Robert (Caissier)
UPDATE Vente SET Id_Employe = 1 WHERE Id_Vente = 3;
UPDATE Vente SET Id_Employe = 2 WHERE Id_Vente = 4;UPDATE Vente SET Id_Employe = 1 WHERE Id_Vente = 7;
UPDATE Vente SET Id_Employe = 2 WHERE Id_Vente = 5;
UPDATE Vente SET Id_Employe = 1 WHERE Id_Vente = 6;



INSERT INTO Vente (Total, Date_vente, Id_Client, Id_Employe) VALUES
(25.50, '2025-01-15 12:00:00', 1, 1),  -- Vente 1 par Pierre Dubois
(13.20, '2025-01-16 15:00:00', 2, 2),  -- Vente 2 par Sophie Lefevre
(45.00, '2025-01-17 09:30:00', 3, 3);  -- Vente 3 par Maxime Robert





CREATE OR REPLACE FUNCTION calculer_commission(
    p_commission NUMERIC(5,2), -- Pourcentage de commission
    p_date_debut TIMESTAMP DEFAULT NULL, -- Date de début (peut être NULL)
    p_date_fin TIMESTAMP DEFAULT NULL    -- Date de fin (peut être NULL)
)
RETURNS TABLE (
    Id_Employe INT,  -- Assurez-vous que le type est integer
    Total_Commission NUMERIC(15,2),
    Nombre_Total_Ventes INT
) AS $$
BEGIN
    RETURN QUERY
    SELECT
        CAST(v.Id_Employe AS INT) AS Id_Employe,  -- Conversion explicite en INT
        CAST(COALESCE(SUM(v.Total), 0) * (p_commission / 100) AS NUMERIC(15,2)) AS Total_Commission, -- Conversion explicite
        CAST(COUNT(v.Id_Vente) AS INT) AS Nombre_Total_Ventes -- Conversion explicite
    FROM
        Vente v
    WHERE
        (
            (p_date_debut IS NULL AND p_date_fin IS NULL) OR
            (p_date_debut IS NOT NULL AND p_date_fin IS NULL AND v.Date_vente = p_date_debut) OR
            (p_date_debut IS NOT NULL AND p_date_fin IS NOT NULL AND v.Date_vente BETWEEN p_date_debut AND p_date_fin)
        )
    GROUP BY
        v.Id_Employe;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION calculer_commission(
    p_commission NUMERIC(5,2),
    p_date_debut TIMESTAMP DEFAULT NULL,
    p_date_fin TIMESTAMP DEFAULT NULL,
    p_id_genre INTEGER DEFAULT NULL
)
RETURNS TABLE (
    id_employe INTEGER,
    total_commission NUMERIC(15,2),
    nombre_total_ventes INTEGER
) AS $$
BEGIN
    RETURN QUERY
    SELECT
        e.Id_Employe,
        e.nom,
        COALESCE(SUM(CASE WHEN v.total > 200000 THEN v.total ELSE 0 END), 0) * (p_commission / 100) AS total_commission,
        COUNT(v.id) AS nombre_total_ventes
    FROM
        employe e
        LEFT JOIN vente v ON v.id_employe = e.id
        LEFT JOIN genre g ON e.id_genre = g.id
    WHERE
        (
            (p_date_debut IS NULL AND p_date_fin IS NULL) OR
            (p_date_debut IS NOT NULL AND p_date_fin IS NULL AND v.date_vente::date = p_date_debut::date) OR
            (p_date_debut IS NOT NULL AND p_date_fin IS NOT NULL AND v.date_vente BETWEEN p_date_debut AND p_date_fin)
        )
        AND (p_id_genre IS NULL OR g.id = p_id_genre)
    GROUP BY
        e.Id_Employe;
END;
$$ LANGUAGE plpgsql;


SELECT * FROM calculer_commission(5, '2023-01-01', '2025-12-31', NULL);


CREATE OR REPLACE FUNCTION calculer_commission(
    p_commission NUMERIC(5,2),
    p_date_debut TIMESTAMP DEFAULT NULL,
    p_date_fin TIMESTAMP DEFAULT NULL,
    p_id_genre INTEGER DEFAULT NULL
)
RETURNS TABLE (CREATE OR REPLACE FUNCTION calculer_commission(
    p_commission NUMERIC(5,2),
    p_date_debut TIMESTAMP DEFAULT NULL,
    p_date_fin TIMESTAMP DEFAULT NULL,
    p_id_genre INTEGER DEFAULT NULL
)
RETURNS TABLE (
    id_employe INTEGER,
    total_commission NUMERIC(15,2),
    nombre_total_ventes INTEGER
) AS $$
BEGIN
    RETURN QUERY
    SELECT
        e.Id_Employe,
        COALESCE(SUM(v.Total), 0) * (p_commission / 100) AS total_commission,
        COUNT(v.Id) AS nombre_total_ventes
    id_employe INTEGER,
    total_commission NUMERIC(15,2),
    nombre_total_ventes INTEGER
) AS $$
BEGIN
    RETURN QUERY
    SELECT
        e.Id_Employe,
        COALESCE(SUM(CASE WHEN v.Total > 200000 THEN v.Total ELSE 0 END), 0) * (p_commission / 100) AS total_commission,
        COUNT(v.Id) AS nombre_total_ventes
    FROM
        employe e
        LEFT JOIN vente v ON v.Id_Employe = e.Id_Employe
        LEFT JOIN genre g ON e.Id_Genre = g.Id_Genre
    WHERE
        (
            (p_date_debut IS NULL AND p_date_fin IS NULL) OR
            (p_date_debut IS NOT NULL AND p_date_fin IS NULL AND v.Date_vente::date = p_date_debut::date) OR
            (p_date_debut IS NOT NULL AND p_date_fin IS NOT NULL AND v.Date_vente BETWEEN p_date_debut AND p_date_fin)
        )
        AND (p_id_genre IS NULL OR g.Id_Genre = p_id_genre)
    GROUP BY
        e.Id_Employe;
END;
$$ LANGUAGE plpgsql;

SELECT * FROM calculer_commission(5.0, NULL, NULL, 1);
/*

DROP FUNCTION IF EXISTS calculer_commission(NUMERIC);
DROP FUNCTION IF EXISTS calculer_commission(NUMERIC, TIMESTAMP);
DROP FUNCTION IF EXISTS calculer_commission(NUMERIC, TIMESTAMP, TIMESTAMP);
DROP FUNCTION IF EXISTS calculer_commission(NUMERIC, TIMESTAMP, TIMESTAMP, INTEGER);


