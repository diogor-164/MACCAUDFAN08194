-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Hôte : 127.0.0.1
-- Généré le : jeu. 06 juin 2024 à 14:50
-- Version du serveur : 10.4.28-MariaDB
-- Version de PHP : 8.2.4

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de données : `fcmonthey_caisse`
--
CREATE DATABASE IF NOT EXISTS `fcmonthey_caisse` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE `fcmonthey_caisse`;

-- --------------------------------------------------------

--
-- Structure de la table `tblcategories`
--

DROP TABLE IF EXISTS `tblcategories`;
CREATE TABLE `tblcategories` (
  `id_categorie` int(11) NOT NULL,
  `nom_categorie` varchar(25) NOT NULL COMMENT 'Catégorie des produits'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `tblcategories`
--

INSERT INTO `tblcategories` (`id_categorie`, `nom_categorie`) VALUES
(1, 'Boissons'),
(2, 'Alcools'),
(3, 'Nourriturre');

-- --------------------------------------------------------

--
-- Structure de la table `tblcategorie_prelev`
--

DROP TABLE IF EXISTS `tblcategorie_prelev`;
CREATE TABLE `tblcategorie_prelev` (
  `id_catprelev` int(11) NOT NULL,
  `nom_catprelev` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `tblcategorie_prelev`
--

INSERT INTO `tblcategorie_prelev` (`id_catprelev`, `nom_catprelev`) VALUES
(1, 'Paiement arbitre'),
(2, 'Paiement employé'),
(3, 'Paiement achats'),
(4, 'Remboursement client'),
(5, 'Autres');

-- --------------------------------------------------------

--
-- Structure de la table `tbllibelle`
--

DROP TABLE IF EXISTS `tbllibelle`;
CREATE TABLE `tbllibelle` (
  `id_libelle` int(11) NOT NULL,
  `quantite_libelle` int(11) DEFAULT NULL,
  `sous_total` float DEFAULT NULL,
  `id_produit` int(11) NOT NULL,
  `id_transaction` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `tbllibelle`
--

INSERT INTO `tbllibelle` (`id_libelle`, `quantite_libelle`, `sous_total`, `id_produit`, `id_transaction`) VALUES
(1, 5, 35, 50, 17),
(2, 6, 42, 50, 18),
(3, 4, 28, 50, 19),
(4, 3, 21, 52, 19),
(5, 5, 35, 50, 20),
(6, 4, 28, 52, 20),
(7, 4, 16, 51, 20),
(8, 2, 14, 50, 21),
(9, 2, 14, 52, 21),
(10, 1, 4, 51, 22),
(11, 1, 4, 53, 22),
(12, 2, 8, 49, 23);

-- --------------------------------------------------------

--
-- Structure de la table `tblmouvements`
--

DROP TABLE IF EXISTS `tblmouvements`;
CREATE TABLE `tblmouvements` (
  `id_mouvement` int(11) NOT NULL,
  `type_mouvement` varchar(30) DEFAULT NULL,
  `quantite_changement` int(11) DEFAULT NULL,
  `date_changement` timestamp NOT NULL DEFAULT current_timestamp(),
  `raison_changement` int(11) DEFAULT NULL,
  `id_libelle` int(11) DEFAULT NULL,
  `id_unite` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `tblmoyen_paiement`
--

DROP TABLE IF EXISTS `tblmoyen_paiement`;
CREATE TABLE `tblmoyen_paiement` (
  `id_moyenpaiement` int(11) NOT NULL,
  `nom_moyenpaiement` varchar(15) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `tblmoyen_paiement`
--

INSERT INTO `tblmoyen_paiement` (`id_moyenpaiement`, `nom_moyenpaiement`) VALUES
(1, 'Twint'),
(2, 'Cash');

-- --------------------------------------------------------

--
-- Structure de la table `tblprelevements`
--

DROP TABLE IF EXISTS `tblprelevements`;
CREATE TABLE `tblprelevements` (
  `id_prelevement` int(11) NOT NULL,
  `nom_prelevement` varchar(50) DEFAULT NULL COMMENT 'nom de l''employé',
  `montant_prelevement` decimal(10,2) NOT NULL COMMENT 'CHF',
  `heures_prelevement` int(11) DEFAULT NULL COMMENT 'heures effectuées par employé',
  `fournisseur_prelevement` varchar(50) DEFAULT NULL COMMENT 'nom du fournisseur (achats)',
  `raison_prelevement` varchar(500) DEFAULT NULL COMMENT 'raison écrite par utilisateur tab',
  `date_prelevement` timestamp NOT NULL DEFAULT current_timestamp(),
  `id_catprelev` int(11) NOT NULL COMMENT '(paiement staff, remboursement, autres)',
  `id_transaction` int(11) DEFAULT NULL,
  `id_libelle` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `tblproduits`
--

DROP TABLE IF EXISTS `tblproduits`;
CREATE TABLE `tblproduits` (
  `id_produit` int(11) NOT NULL,
  `nom_produit` varchar(50) DEFAULT NULL,
  `quantite_produit` int(11) DEFAULT NULL,
  `prix_vente` float(10,2) DEFAULT NULL,
  `prix_achat` float(10,2) DEFAULT NULL,
  `tva_produit` float(10,2) DEFAULT NULL,
  `taux_alcool` float DEFAULT NULL COMMENT '%',
  `id_categorie` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `tblproduits`
--

INSERT INTO `tblproduits` (`id_produit`, `nom_produit`, `quantite_produit`, `prix_vente`, `prix_achat`, `tva_produit`, `taux_alcool`, `id_categorie`) VALUES
(49, 'Eau minérale (Gazeuse / Plate) 500ML', NULL, 4.00, NULL, 8.10, NULL, 1),
(50, 'Eau minérale (Gazeuse / Plate) 1.5L', NULL, 7.00, NULL, 8.10, NULL, 1),
(51, 'Coca-Cola - Coca-Cola Zero 500ML', NULL, 4.00, NULL, 8.10, NULL, 1),
(52, 'Coca-Cola - Coca-Cola Zero 1.5L', NULL, 7.00, NULL, 8.10, NULL, 1),
(53, 'Thé froid (Citron / Pêche) 500ML', NULL, 4.00, NULL, 8.10, NULL, 1),
(54, 'Thé froid (Citron / Pêche) 1.5L', NULL, 7.00, NULL, 8.10, NULL, 1),
(55, 'Limonade 500ML', NULL, 4.00, NULL, 8.10, NULL, 1),
(56, 'Rivella 500ML', NULL, 4.00, NULL, 8.10, NULL, 1),
(57, 'Fanta Orange 500ML', NULL, 4.00, NULL, 8.10, NULL, 1),
(58, 'Grapefruit 500ML', NULL, 4.00, NULL, 8.10, NULL, 1),
(59, 'Sportif (Coca-Cola, thé froid, eau, etc..) 200ML', NULL, 2.50, NULL, 8.10, NULL, 1),
(60, 'Jus de pomme 300ML', NULL, 4.00, NULL, 8.10, NULL, 1),
(61, 'Jus de fruit 300ML', NULL, 4.00, NULL, 8.10, NULL, 1),
(62, 'Café – Thé', NULL, 3.50, NULL, 8.10, NULL, 1),
(63, 'Cappuccino', NULL, 4.00, NULL, 8.10, NULL, 1),
(64, 'Cardinal Blonde Pression 200ML', NULL, 3.00, NULL, 8.10, NULL, 2),
(65, 'Cardinal Blonde Pression 300ML', NULL, 4.00, NULL, 8.10, NULL, 2),
(66, 'Cardinal Blonde Pression 500ML', NULL, 5.00, NULL, 8.10, NULL, 2),
(67, 'Cardinal Blonde Pression pichet 1.5L', NULL, 18.00, NULL, 8.10, NULL, 2),
(68, 'Cardinal Blonde Pression ratelier 3.0L', NULL, 35.00, NULL, 8.10, NULL, 2),
(69, 'Cardinal Blonde Pression girafe 3.0L', NULL, 35.00, NULL, 8.10, NULL, 2),
(70, 'Superbock bouteille 250ML', NULL, 3.00, NULL, 8.10, NULL, 2),
(71, 'Superbock carton', NULL, 65.00, NULL, 8.10, NULL, 2),
(72, 'Bière Blanche 300ML', NULL, 4.50, NULL, 8.10, NULL, 2),
(73, 'Cardinal Eve 275ML', NULL, 4.00, NULL, 8.10, NULL, 2),
(74, 'Bière sans alcool 300ML', NULL, 4.00, NULL, 8.10, NULL, 2),
(75, 'Fendant AOC Valais 100ML', NULL, 3.50, NULL, 8.10, NULL, 2),
(76, 'Fendant AOC Valais Bouteille 500ML', NULL, 17.00, NULL, 8.10, NULL, 2),
(77, 'Rosé AOC Valais 100ML', NULL, 3.50, NULL, 8.10, NULL, 2),
(78, 'Rosé AOC Valais Bouteille 500ML', NULL, 17.00, NULL, 8.10, NULL, 2),
(79, 'Gamay AOC Valais 100ML', NULL, 3.50, NULL, 8.10, NULL, 2),
(80, 'Gamay AOC Valais Bouteille 500ML', NULL, 17.00, NULL, 8.10, NULL, 2),
(81, 'Johannisberg AOC Valais 100ML', NULL, 4.00, NULL, 8.10, NULL, 2),
(82, 'Johannisberg AOC Valais Bouteille 500ML', NULL, 20.00, NULL, 8.10, NULL, 2),
(83, 'Pinot Noir AOC Valais 100ML', NULL, 4.00, NULL, 8.10, NULL, 2),
(84, 'Pinot Noir AOC Valais Bouteille 500ML', NULL, 20.00, NULL, 8.10, NULL, 2),
(85, 'Fendant Privilège AOC Valais Bouteille 375ML', NULL, 13.00, NULL, 8.10, NULL, 2),
(86, 'Fendant Privilège AOC Valais Bouteille 750ML', NULL, 25.00, NULL, 8.10, NULL, 2),
(87, 'Johannisberg AOC Valais Bouteille 750ML', NULL, 30.00, NULL, 8.10, NULL, 2),
(88, 'Saignée de Spécialités «Hadès» Bouteille 750ML', NULL, 30.00, NULL, 8.10, NULL, 2),
(89, 'Passion, Assemblage Rouge Bouteille 500ML', NULL, 20.00, NULL, 8.10, NULL, 2),
(90, 'Passion, Assemblage Rouge Bouteille 750ML', NULL, 30.00, NULL, 8.10, NULL, 2),
(91, 'Martini - Suze - Pastis 4CL', NULL, 4.00, NULL, 8.10, NULL, 2),
(92, 'Prosecco 100ML', NULL, 4.00, NULL, 8.10, NULL, 2),
(93, 'Prosecco 200ML', NULL, 7.00, NULL, 8.10, NULL, 2),
(94, 'Prosecco 750ML', NULL, 25.00, NULL, 8.10, NULL, 2),
(95, 'Spritz', NULL, 6.00, NULL, 8.10, NULL, 2),
(96, 'Whisky 20ML', NULL, 6.00, NULL, 8.10, NULL, 2),
(97, 'Eau de vie 20ML', NULL, 5.00, NULL, 8.10, NULL, 2),
(98, 'Limoncello 40ML', NULL, 4.00, NULL, 8.10, NULL, 2),
(99, 'Mars', NULL, 2.00, NULL, 2.60, NULL, 3),
(100, 'Snikers', NULL, 2.00, NULL, 2.60, NULL, 3),
(101, 'M&M’s', NULL, 2.00, NULL, 2.60, NULL, 3),
(102, 'Kägi Fret', NULL, 2.00, NULL, 2.60, NULL, 3),
(103, 'Croissant', NULL, 2.00, NULL, 2.60, NULL, 3),
(104, 'Chips', NULL, 2.00, NULL, 2.60, NULL, 3),
(105, 'Sandwich', NULL, 4.00, NULL, 2.60, NULL, 3),
(106, 'Pâté', NULL, 4.00, NULL, 2.60, NULL, 3),
(107, 'Hot-Dog', NULL, 5.00, NULL, 2.60, NULL, 3),
(108, 'Bonbons (paquet)', NULL, 2.00, NULL, 2.60, NULL, 3),
(109, 'Bombons serpent', NULL, 0.50, NULL, 2.60, NULL, 3),
(110, 'Frites portion', NULL, 5.00, NULL, 2.60, NULL, 3),
(111, 'Chicken nuggets (6 pces)', NULL, 6.00, NULL, 2.60, NULL, 3),
(112, 'Chicken nuggets (6 pces) & frites', NULL, 10.00, NULL, 2.60, NULL, 3),
(113, 'Saucisse pain', NULL, 6.00, NULL, 2.60, NULL, 3),
(114, 'Saucisse frites', NULL, 10.00, NULL, 2.60, NULL, 3),
(115, 'Tranche de porc / poulet pain', NULL, 10.00, NULL, 2.60, NULL, 3),
(116, 'Tranche de porc / poulet frites', NULL, 14.00, NULL, 2.60, NULL, 3),
(117, 'Tartare bœuf / saumon frites et toast', NULL, 25.00, NULL, 2.60, NULL, 3),
(118, '1 raclette', NULL, 4.00, NULL, 2.60, NULL, 3),
(119, '3 raclettes', NULL, 10.00, NULL, 2.60, NULL, 3),
(120, 'Cuisine montant à introduire', NULL, NULL, NULL, 2.60, NULL, 3);

-- --------------------------------------------------------

--
-- Structure de la table `tbltransactions`
--

DROP TABLE IF EXISTS `tbltransactions`;
CREATE TABLE `tbltransactions` (
  `id_transaction` int(11) NOT NULL,
  `total_transaction` decimal(10,2) NOT NULL COMMENT 'CHF',
  `id_moyenpaiement` int(11) NOT NULL,
  `date_transaction` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `tbltransactions`
--

INSERT INTO `tbltransactions` (`id_transaction`, `total_transaction`, `id_moyenpaiement`, `date_transaction`) VALUES
(1, 0.00, 2, '2024-04-30 15:51:19'),
(10, 4.00, 1, '2024-05-21 15:09:47'),
(11, 14.00, 1, '2024-05-21 15:11:19'),
(12, 19.00, 1, '2024-05-21 15:13:02'),
(13, 14.00, 1, '2024-05-21 15:13:58'),
(14, 21.00, 1, '2024-05-21 15:14:33'),
(15, 21.00, 1, '2024-05-21 15:15:12'),
(16, 24.00, 1, '2024-05-21 15:15:55'),
(17, 35.00, 1, '2024-05-21 15:16:55'),
(18, 42.00, 2, '2024-05-22 06:39:02'),
(19, 49.00, 2, '2024-05-22 10:42:22'),
(20, 79.00, 2, '2024-05-22 11:00:07'),
(21, 28.00, 2, '2024-05-23 08:13:01'),
(22, 8.00, 2, '2024-06-06 08:10:59'),
(23, 8.00, 2, '2024-06-06 12:47:54');

--
-- Index pour les tables déchargées
--

--
-- Index pour la table `tblcategories`
--
ALTER TABLE `tblcategories`
  ADD PRIMARY KEY (`id_categorie`);

--
-- Index pour la table `tblcategorie_prelev`
--
ALTER TABLE `tblcategorie_prelev`
  ADD PRIMARY KEY (`id_catprelev`);

--
-- Index pour la table `tbllibelle`
--
ALTER TABLE `tbllibelle`
  ADD PRIMARY KEY (`id_libelle`),
  ADD KEY `fk_libelle_transaction` (`id_transaction`),
  ADD KEY `fk_libelle_produit` (`id_produit`);

--
-- Index pour la table `tblmouvements`
--
ALTER TABLE `tblmouvements`
  ADD PRIMARY KEY (`id_mouvement`),
  ADD KEY `fk_mouvement_libelle` (`id_libelle`),
  ADD KEY `fk_mouvement_unite` (`id_unite`);

--
-- Index pour la table `tblmoyen_paiement`
--
ALTER TABLE `tblmoyen_paiement`
  ADD PRIMARY KEY (`id_moyenpaiement`);

--
-- Index pour la table `tblprelevements`
--
ALTER TABLE `tblprelevements`
  ADD PRIMARY KEY (`id_prelevement`),
  ADD KEY `fk_prelevement_catprelev` (`id_catprelev`),
  ADD KEY `fk_prelevement_libelle` (`id_libelle`),
  ADD KEY `fk_prelevement_transaction` (`id_transaction`);

--
-- Index pour la table `tblproduits`
--
ALTER TABLE `tblproduits`
  ADD PRIMARY KEY (`id_produit`),
  ADD KEY `fk_produits_categorie` (`id_categorie`);

--
-- Index pour la table `tbltransactions`
--
ALTER TABLE `tbltransactions`
  ADD PRIMARY KEY (`id_transaction`),
  ADD KEY `fk_transactions_moyenpaiement` (`id_moyenpaiement`);

--
-- AUTO_INCREMENT pour les tables déchargées
--

--
-- AUTO_INCREMENT pour la table `tblcategories`
--
ALTER TABLE `tblcategories`
  MODIFY `id_categorie` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT pour la table `tblcategorie_prelev`
--
ALTER TABLE `tblcategorie_prelev`
  MODIFY `id_catprelev` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT pour la table `tbllibelle`
--
ALTER TABLE `tbllibelle`
  MODIFY `id_libelle` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT pour la table `tblmouvements`
--
ALTER TABLE `tblmouvements`
  MODIFY `id_mouvement` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `tblmoyen_paiement`
--
ALTER TABLE `tblmoyen_paiement`
  MODIFY `id_moyenpaiement` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT pour la table `tblprelevements`
--
ALTER TABLE `tblprelevements`
  MODIFY `id_prelevement` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `tblproduits`
--
ALTER TABLE `tblproduits`
  MODIFY `id_produit` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=121;

--
-- AUTO_INCREMENT pour la table `tbltransactions`
--
ALTER TABLE `tbltransactions`
  MODIFY `id_transaction` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=24;

--
-- Contraintes pour les tables déchargées
--

--
-- Contraintes pour la table `tbllibelle`
--
ALTER TABLE `tbllibelle`
  ADD CONSTRAINT `fk_libelle_produit` FOREIGN KEY (`id_produit`) REFERENCES `tblproduits` (`id_produit`),
  ADD CONSTRAINT `fk_libelle_transaction` FOREIGN KEY (`id_transaction`) REFERENCES `tbltransactions` (`id_transaction`);

--
-- Contraintes pour la table `tblmouvements`
--
ALTER TABLE `tblmouvements`
  ADD CONSTRAINT `fk_mouvement_libelle` FOREIGN KEY (`id_libelle`) REFERENCES `tbllibelle` (`id_libelle`),
  ADD CONSTRAINT `fk_mouvement_unite` FOREIGN KEY (`id_unite`) REFERENCES `tblunites` (`id_unite`);

--
-- Contraintes pour la table `tblprelevements`
--
ALTER TABLE `tblprelevements`
  ADD CONSTRAINT `fk_prelevement_catprelev` FOREIGN KEY (`id_catprelev`) REFERENCES `tblcategorie_prelev` (`id_catprelev`),
  ADD CONSTRAINT `fk_prelevement_libelle` FOREIGN KEY (`id_libelle`) REFERENCES `tbllibelle` (`id_libelle`),
  ADD CONSTRAINT `fk_prelevement_transaction` FOREIGN KEY (`id_transaction`) REFERENCES `tbltransactions` (`id_transaction`);

--
-- Contraintes pour la table `tblproduits`
--
ALTER TABLE `tblproduits`
  ADD CONSTRAINT `fk_produits_categorie` FOREIGN KEY (`id_categorie`) REFERENCES `tblcategories` (`id_categorie`);

--
-- Contraintes pour la table `tbltransactions`
--
ALTER TABLE `tbltransactions`
  ADD CONSTRAINT `fk_transactions_moyenpaiement` FOREIGN KEY (`id_moyenpaiement`) REFERENCES `tblmoyen_paiement` (`id_moyenpaiement`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
