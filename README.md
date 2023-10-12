# stage_ete_tunisair


## Installation

### Backend

1. **Installer et lancer WampServer**
  Assurez-vous d'avoir WampServer installé sur votre machine. Vous pouvez le télécharger sur [le site officiel de WampServer](http://www.wampserver.com/).

2. **Mettre le projet dans le dossier du backend sous www/**
  Copiez les fichiers de votre projet dans le répertoire `www` de WampServer. Par défaut, ce dossier se trouve dans le répertoire d'installation de WampServer (généralement `C:\wamp\www` sous Windows).

3. **Ajouter le dossier "assets" au projet backend**
   Copiez le dossier "assets" dans le répertoire racine de votre projet backend.

4. **Ajouter les sous-dossiers "audio", "file" et "images" dans le dossier "assets"**
  Assurez-vous que la structure de votre dossier "assets" ressemble à ceci :
   root
  ├── ...
  └── assets
      ├── audio
      ├── file
      └── images
5. **Installer les packages avec Composer**
    Utilisez la commande suivante pour installer les packages nécessaires au projet backend : composer install

### Frontend
  Installer les packages avec la commande : flutter pub get
