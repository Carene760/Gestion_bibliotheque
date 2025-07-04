-- Création de la base
\c postgres
DROP DATABASE IF EXISTS biblio;
CREATE DATABASE biblio;
\c biblio;

-- Table des types d'abonnement
CREATE TABLE type_abonnement (
    id SERIAL PRIMARY KEY,
    libelle VARCHAR(20) UNIQUE NOT NULL CHECK (libelle IN ('enfant', 'etudiant', 'adulte', 'senior', 'professionnel', 'professeur')),
    tarif NUMERIC(6,2) NOT NULL,
    quota_livre INT NOT NULL CHECK (quota_livre >= 0),
    duree_pret_jour INT NOT NULL DEFAULT 14, -- durée max du prêt en jours
    quota_reservation INT NOT NULL DEFAULT 2, -- nombre max de réservations
    quota_prolongement INT NOT NULL DEFAULT 1, -- nombre max de prolongements
    nb_jour_prolongement INT NOT NULL DEFAULT 7 -- nombre de jours pour un prolongement
);

INSERT INTO type_abonnement (libelle, tarif, quota_livre, duree_pret_jour, quota_reservation, quota_prolongement, nb_jour_prolongement) VALUES
('enfant', 3.00, 2, 7, 1, 1, 7),
('etudiant', 5.00, 4, 14, 2, 2, 14),
('professionnel', 8.00, 5, 21, 3, 2, 21),
('professeur', 10.00, 6, 30, 3, 3, 30),
('senior', 6.00, 3, 14, 2, 1, 14);

-- Table des profils d'adhérents
CREATE TABLE profil (
    id SERIAL PRIMARY KEY,
    type_profil VARCHAR(50) NOT NULL,
    quota_livre INT NOT NULL CHECK (quota_livre >= 0),
    duree_pret_jour INT NOT NULL DEFAULT 14, -- durée max du prêt en jours
    quota_reservation INT NOT NULL DEFAULT 2, -- nombre max de réservations
    quota_prolongement INT NOT NULL DEFAULT 1, -- nombre max de prolongements
    nb_jour_prolongement INT NOT NULL DEFAULT 7 -- nombre de jours pour un prolongement
);

CREATE TABLE  type_abonnement (
    id SERIAL PRIMARY KEY,
    id_profil INT NOT NULL REFERENCES profil(id),
    tarif NUMERIC(6,2) NOT NULL
);


-- Table des adhérents
CREATE TABLE adherent (
    id SERIAL PRIMARY KEY,
    nom VARCHAR(100) NOT NULL,
    prenom VARCHAR(100) NOT NULL,
    date_naissance DATE,
    adresse VARCHAR(255) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    id_type_abonnement INT NOT NULL REFERENCES type_abonnement(id),
    est_suspendu BOOLEAN DEFAULT FALSE,
    date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table des abonnements
CREATE TABLE abonnement (
    id SERIAL PRIMARY KEY,
    id_adherent INTEGER REFERENCES adherent(id),
    date_debut DATE NOT NULL,
    date_fin DATE NOT NULL,
    est_paye BOOLEAN DEFAULT FALSE
);

-- Table des catégories de livre
CREATE TABLE categorie (
    id SERIAL PRIMARY KEY,
    nom VARCHAR(100) UNIQUE NOT NULL
);

-- Table des livres
CREATE TABLE livre (
    id SERIAL PRIMARY KEY,
    titre VARCHAR(200) NOT NULL,
    auteur VARCHAR(150) NOT NULL,
    isbn VARCHAR(20) UNIQUE,
    id_categorie INT REFERENCES categorie(id),
    date_ajout DATE DEFAULT CURRENT_DATE,
    restriction _age INTEGER CHECK (restriction IN (NULL, 12, 16, 18)), -- restriction d'âge pour le prê
);

-- Table des exemplaires
CREATE TABLE exemplaire (
    id SERIAL PRIMARY KEY,
    reference VARCHAR(30) UNIQUE NOT NULL,
    id_livre INT NOT NULL REFERENCES livre(id),
    statut VARCHAR(20) NOT NULL CHECK (statut IN ('disponible', 'emprunte', 'reserve'))
);

-- Table des prêts
CREATE TABLE pret (
    id SERIAL PRIMARY KEY,
    id_exemplaire INT NOT NULL REFERENCES exemplaire(id),
    id_adherent INT NOT NULL REFERENCES adherent(id),
    date_emprunt DATE NOT NULL,
    date_retour_prevue DATE NOT NULL,
    date_retour_effective DATE,
    est_prolonge BOOLEAN DEFAULT FALSE,
    type_pret VARCHAR(20) NOT NULL CHECK (type_pret IN ('sur_place', 'emporte')),
    statut VARCHAR(20) NOT NULL CHECK (statut IN ('en_cours', 'termine', 'en_retard'))
);

-- Table des réservations
CREATE TABLE reservation (
    id SERIAL PRIMARY KEY,
    id_adherent INT NOT NULL REFERENCES adherent(id),
    id_livre INT NOT NULL REFERENCES livre(id),
    date_reservation TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    date_expiration DATE,
    statut VARCHAR(20) NOT NULL CHECK (statut IN ('active', 'expiree', 'honoree'))
);

-- Table des pénalités
CREATE TABLE penalite (
    id SERIAL PRIMARY KEY,
    id_adherent INT NOT NULL REFERENCES adherent(id),
    id_pret INT NOT NULL REFERENCES pret(id),
    date_debut DATE NOT NULL,
    date_fin DATE NOT NULL,
    raison TEXT
);

-- Table des jours fériés
CREATE TABLE jour_ferie (
    id SERIAL PRIMARY KEY,
    date DATE UNIQUE NOT NULL,
    description TEXT
);

-- Table des utilisateurs
CREATE TABLE utilisateur (
    id SERIAL PRIMARY KEY,
    username VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    role VARCHAR(20) NOT NULL CHECK (role IN ('ADHERENT', 'BIBLIOTHECAIRE')),
    adherent_id INT REFERENCES adherent(id)
);

-- Exemples d'insertion
insert into adherent (nom,prenom,email,id_type_abonnement,adresse,etat,date_naissance) values ('nyeja','nyeja','nyeja@gmail.com',1,'itaosy','actif','2000-01-01');
INSERT into utilisateur (username,password,role,adherent_id) values ('test','test','ADHERENT',1);
INSERT into utilisateur (username,password,role,adherent_id) values ('biblio','biblio','BIBLIOTHECAIRE',NULL);

-- Ajout de livres
INSERT INTO livre (titre, auteur, id_categorie, isbn, restriction) VALUES
('Le Petit Prince', 'Antoine de Saint-Exupery', 1, '9782070612758', 'aucun'),
('1984', 'George Orwell', 1, '9780451524935', 'adulte'),
('Introduction', 'Thomas H. Cormen', 3, '9782744075786', 'aucun'),
('Harry Potter', 'J.K. Rowling', 6, '9782070643028', 'aucun'),
('L''Etranger', 'Albert Camus', 1, '9782070360024', 'adulte');

-- Ajout d'exemplaires pour chaque livre
INSERT INTO exemplaire (reference, id_livre, statut) VALUES
('EX-PTP-001', 1, 'disponible'),
('EX-PTP-002', 1, 'disponible'),
('EX-1984-001', 2, 'disponible'),
('EX-1984-002', 2, 'emprunte'),
('EX-ALG-001', 3, 'disponible'),
('EX-HP1-001', 4, 'disponible'),
('EX-HP1-002', 4, 'reserve'),
('EX-ETR-001', 5, 'disponible');

ALTER TABLE pret ADD COLUMN nbprolongements integer DEFAULT 0;
-- -penalite tsisy resaka vola
-- prolengement
-- penalite 10j raha tsy nanatitra anlay boky a temps
-- rehefa tsy abonne tsony lay adherent dia tsy afaka manao inina fa afaka miditra systeme

-- reservation misy quota(jour)
-- prolengement na pret misy quota(jour)

-- reservation tsy pretfa ny reservation lasa rpet le jour j, fa raha tsy mbla nanatitra boky izy d na nireserver za d tsy afaka manao pret
-- mila bidirectionnel ny rehetra:

-- enregistrer lecture sur place mila tenenina kou d zao nou nalina d zao nou naverina,mbola pret fona lay izy
-- afaka manao reservation zay tina, afaka accepteny lay biblio fona 
-- duree anamerena anle boky dia miankina am profil 
-- tsy azo atao prolonger prolongement
-- -pret


-- Liste fonctionnalite atao anaty document

--- mila ampidirina anaty base ny prolongement genre hoe date taloha d date vaovao
