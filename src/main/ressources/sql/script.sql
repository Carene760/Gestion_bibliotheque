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

-- Table des adhérents
CREATE TABLE adherent (
    id SERIAL PRIMARY KEY,
    nom VARCHAR(100) NOT NULL,
    prenom VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    id_type_abonnement INT NOT NULL REFERENCES type_abonnement(id),
    adresse VARCHAR(255) NOT NULL,
    etat VARCHAR(20) NOT NULL CHECK (etat IN ('actif', 'bloque')),
    date_naissance TIMESTAMP
);

-- Table des inscriptions
CREATE TABLE inscription (
    id SERIAL PRIMARY KEY,
    id_adherent INT NOT NULL REFERENCES adherent(id),
    date_inscription TIMESTAMP NOT NULL,
    date_expiration TIMESTAMP NOT NULL,
    statut VARCHAR(20) NOT NULL CHECK (statut IN ('valide', 'expiree'))
);

-- Table des catégories de livre
CREATE TABLE categorie (
    id SERIAL PRIMARY KEY,
    nom VARCHAR(100) UNIQUE NOT NULL
);

INSERT INTO categorie (nom) VALUES
('Fiction'),
('Non-fiction'),
('Science'),
('Histoire'),
('Biographie'),
('Enfants'),
('Adolescents'),
('Romance');

-- Table des livres
CREATE TABLE livre (
    id SERIAL PRIMARY KEY,
    titre VARCHAR(200) NOT NULL,
    auteur VARCHAR(150) NOT NULL,
    id_categorie INT REFERENCES categorie(id),
    isbn VARCHAR(20) UNIQUE,
    restriction VARCHAR(20) CHECK (restriction IN ('aucun', 'adulte'))
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
    date_emprunt TIMESTAMP NOT NULL,
    date_retour_prevue TIMESTAMP NOT NULL,
    date_retour_effective TIMESTAMP,
    type_pret VARCHAR(20) NOT NULL CHECK (type_pret IN ('sur_place', 'emporte')),
    statut VARCHAR(20) NOT NULL CHECK (statut IN ('en_cours', 'termine', 'en_retard'))
);

CREATE TABLE historique_pret (
    id SERIAL PRIMARY KEY,
    id_pret INT NOT NULL REFERENCES pret(id),
    action VARCHAR(30) NOT NULL, -- ex: 'prolongement', 'retour', 'emprunt'
    date_action TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    commentaire TEXT
);

-- Table des réservations
CREATE TABLE reservation (
    id SERIAL PRIMARY KEY,
    id_adherent INT NOT NULL REFERENCES adherent(id),
    id_exemplaire INT NOT NULL REFERENCES Exemplaire(id),
    date_demande TIMESTAMP NOT NULL,
    statut VARCHAR(20) NOT NULL CHECK (statut IN ('en_attente', 'acceptee', 'refusee'))
);

-- Table des pénalités
DROP TABLE IF EXISTS penalite;
CREATE TABLE penalite (
    id SERIAL PRIMARY KEY,
    id_adherent INT NOT NULL REFERENCES adherent(id),
    id_pret INT NOT NULL REFERENCES pret(id),
    date_debut TIMESTAMP NOT NULL,
    date_fin TIMESTAMP NOT NULL,
    reglee BOOLEAN NOT NULL DEFAULT FALSE
);
-- Table des jours fériés
CREATE TABLE jourferie (
    id SERIAL PRIMARY KEY,
    date_ferie TIMESTAMP UNIQUE NOT NULL,
    description VARCHAR(100)
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

--- penalite kay manomboka amlay andro hanaterana ilay boky
-- Liste fonctionnalite atao anaty document

--- mila ampidirina anaty base ny prolongement genre hoe date taloha d date vaovao
