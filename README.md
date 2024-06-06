# Installation de XAMPP et fonctionnement de la base de données/site web.

Ce projet nécessite l'installation de XAMPP, un ensemble de logiciels comprenant Apache, MySQL, PHP et autres. Suivez les étapes ci-dessous pour configurer et exécuter le projet sur votre machine locale.

## Étapes d'Installation :

### 1. Téléchargement et Installation de XAMPP :

Téléchargez XAMPP depuis le [site officiel](https://www.apachefriends.org/) et suivez les instructions d'installation adaptées à votre système d'exploitation.


### 2. Démarrage des Modules Apache et MySQL :

Après l'installation, démarrez les modules Apache et MySQL à partir du panneau de contrôle de XAMPP.

![ex](https://i.imgur.com/xiTxFrz.png)

### 3. Configuration de la Base de Données :

Dans l'archive zip que vous avez reçu, vous trouverez un fichier de sauvegarde de base de données `rodrigues_diogo_EXPI1B_dump_M164.sql`. Importez ce fichier dans phpMyAdmin en accédant à [http://localhost/phpmyadmin/](http://localhost/phpmyadmin/) depuis votre navigateur. Suivez les instructions sur le site pour importer la base de données.

### 4. Placement des Fichiers du Projet :

Décompressez l'archive zip et placez les fichiers qui se trouvent dans le dossier "website" dans le répértoire `htdocs` de XAMPP (généralement situé à `C:\xampp\htdocs` sur Windows) :

- `rodrigues_diogo_EXPI1B_main_M164.php` : Le fichier contenant toute la structure du site web. Le html, css, javascript et php pour les requetes.
- `process.php` : Le fichier qui contient la méthode de connexion vers la base de données

### 5. Accès au Projet :

Une fois que tous les fichiers sont en place et que la base de données est importée, vous pouvez accéder au projet en ouvrant votre navigateur et en accédant à [http://localhost/rodrigues_diogo_EXPI1B_main_M164.PHP](http://localhost/rodrigues_diogo_EXPI1B_main_M164.PHP).

### 6. Utilisation du site :

Il fonctionne comme une caisse traditionnelle, selectionnez vos articles, validez la commande dans le panier puis selectionnez votre méthode de paiement. Certaines requêtes MYSQL (pas toutes) effectuées vont s'afficher dans une alerte (uniquement utilisé dans l'interêt du module pour test + visualisation pour maccaud).

---
Pour toute question ou assistance supplémentaire, n'hésitez pas à me contacter.
