
# Docker-BandJ

- Présentation du projet Docker de déploiement d'une plateforme multimédia automatisée. -

Dans ce projet on retrouve notamment :
- **Plex** : Gestionnaire de bibliothèques films / séries
- **Deluge** : Client léger et opensource BitTorrent
- **Radarr** : Planificateur de téléchargement de films
- **Sonarr** : Planificateur de téléchargement de séries
- **Jackett** : Proxy et indexeur de liens Torrents

// Extra :
- **Tautulli** : Monitoring, stats et graphs pour Plex
- **Portainer** : Gestionnaire de containers Docker

// Extra plus :

- **ChatBot Telegram** : assistant personnel virtuel qui permet d'envoyer des notifications textuelles via l'application Telegram.

-----------------

Le schéma suivant met en évidence l'interconnexion et le fonctionnement entre les 5 services principaux :

```mermaid
graph LR
A[Site web Torrents] --> B(Jackett)
B --> D(Sonarr + Radarr)
D --> B
D --> C(Deluge)
C --> E[Download via Proxy VPN]
E --> C
C --> F[Stockage]
F --> G(Plex)
```

**Jackett** va s'assurer de tenir à jour les liens des sites que nous lui donnons en index ainsi que de communiquer directement avec les sites web en faisant les requêtes demandées par **Sonarr** et **Radarr** qui vont quand à eux, tenir un agenda des films et séries demandé par l'utilisateur afin de les trouver, dans la qualité et la langue demandée, et les télécharger une fois disponible sur les sites de torrent mis en index

Une fois le lien torrent trouvé, il va être envoyé à **Deluge** qui va télécharger ce torrent via son client qui passera par un proxy VPN paramétré (dans notre cas NordVPN #sponso#AD) 

Ces films/séries seront déposer dans un dossier **/BandJ/downloadsBandJ** perçu par les conteneurs comme **/downloads**
Les films sont dans **/downloads/movies** et les épisodes de séries dans **/downloads/series**
Chaque film ou série aura droit à un dossier propre à son nom

**Plex** va pouvoir récupérer et lire les fichier *.mp4* dans ses dossiers et les afficher dans sa bibliothèque de films et séries
Les utilisateurs pourront alors accéder à leur bibliothèque de n'importe où en se connectant à ce compte Plex et regarder leur film préféré depuis un Google Chromecast ou un PC...

**Tautulli** est un outil de surveillance et d'analyse dédié à **Plex Media Server**. Il permet de suivre les activités des utilisateurs, les statistiques d'utilisation, les historiques de lecture, et bien plus encore. Grâce à Tautulli, il est possible de garder un œil sur les performances du serveur Plex et d'assurer que les utilisateurs bénéficient de la meilleure expérience possible en matière de streaming.

**Portainer** est une solution de gestion de conteneurs Docker qui offre une interface graphique conviviale pour simplifier le déploiement, la configuration et la maintenance des applications et services Docker. Portainer permet de gérer tout ce qui est rattaché aux conteneurs : réseaux, volumes, registres et autres ressources Docker, sans avoir besoin de maîtriser les commandes Docker en ligne de commande. En intégrant Portainer au projet projet, on peut gérer et superviser facilement l'ensemble de la stack Plex, Jackett, Sonarr, Radarr, Deluge et Tautulli à partir d'un seul et même tableau de bord.

**ChatBot Telegram** permet de recevoir directement une notification par l'application Telegram lorsqu'un téléchargement est terminé : un script bash a été intégré pour être exécuté par Delug

------

**Attention**, ne pas utiliser l'image benibee33/portainer_custom car l'image est buguée et le serveur web n'est pas fonctionnel. C'est pour cette raison que le fichier docker-compose appelle directement l'image officielle portainer/portainer-ce:latest à la place.

-----

# Inscription Plex

Le premier prérequis à respecter est la création d'un compte Plex qui est obligatoire pour héberger l'instance serveur que l'on va déployer avec Docker. 

- Se rendre sur le site https://www.plex.tv et cliquer sur ***"Sign Up"*** en haut à droite.

- Se rendre maintenant sur le lien https://www.plex.tv/claim/ copier le token généré afin d'associer le compte au serveur. Pour ce faire, cliquer sur le bouton **"Copy to Clipboard"** :

![image](https://user-images.githubusercontent.com/100569015/235345967-a5c45d0b-fde6-4eaa-a8d5-fc4688beaafb.png)

**Attention** : le token expire au bout de 4 minutes.

- Coller le token dans le fichier "docker-compose.yml" à l'endroit prévu comme indiqué ci-dessous :

![image](https://user-images.githubusercontent.com/100569015/235352543-dd1e4e73-d83c-4b93-8bf1-60dc6e271727.png)


# Déploiement des containers

- Pour déployer la stack, télécharger ou cloner avec git l'ensemble de l'arborescence du repo GitHub.

- Déployer maintenant le projet en ligne de commandes sur l'hôte Docker :

**docker-compose build --no-cache**
**docker compose up -d**

**Note** : aucun container n'est mappé sur l'hôte, les containers communiquent entre eux via un réseau interne bridge.

Pour déterminer l'IP d'un container :
***docker ps -a
docker inspect <container_id> | grep IPAddress***

**Attention** : si une erreur de droits apparaît dans les logs pour l'accès au répertoire de configuration Plex     **--->**
**plex_bandj   | OSError: [Errno 13] Permission denied: '/config/Library/Application Support/Plex Media Server/Logs/PMS Plugin Logs**'

Taper la commande suivante sur l'hôte Docker, depuis le répertoire racine là où le projet a été cloné :
***sudo chown -R 911:911 ./BandJ/plex/config***

Redémarrer ensuite les containers : 
***docker-compose down
docker-compose up -d***

------

# Configuration Plex

**http://plex_bandj:32400/**

- Accéder à l'interface web du serveur Plex.

- Si la page de configuration ne s'affiche pas automatiquement, se déconnecter du compte et se reconnecter aussitôt. La page de configuration va s'afficher automatiquement, cliquer sur le bouton **"J'ai compris !"** pour commencer la configuration.

- Créer deux bibliothèques : une bibliothèque "Films" et une bibliothèque "Séries" et faire pointer respectivement vers les chemins suivants :

![image](https://user-images.githubusercontent.com/100569015/235352317-7dc0d4be-dd41-4806-815b-6ba2ae99d41d.png)

------

# Configuration Deluge

**http://deluge_bandj:8112/**

- Mot de passe par défaut : **deluge**

- Ajouter les plugins "Label" et "Execute" dans les préférences :

![image](https://user-images.githubusercontent.com/100569015/235352874-8ca8e731-b9b1-4315-a784-f904a1d52030.png)

- Créer deux nouveaux labels pour Sonarr et Radarr :

![image](https://user-images.githubusercontent.com/100569015/235352950-dcb165dd-a063-4ffd-8d75-f835b21bf9c7.png)

- Indiquer l'exécution du script de notification Telegram lorsqu'un téléchargement est terminé :

![image](https://user-images.githubusercontent.com/100569015/235353781-1985c7ce-a737-4669-af91-a81f93d1c62a.png)

- Copier/coller son chat ID et Token Telegram dans le script **telegram.sh** et sauvegarder la modification :

![image](https://user-images.githubusercontent.com/100569015/235374145-fe6ad79a-64b4-40be-9607-e58ad37f926f.png)

- Configurer en supplément dans les préférences de Deluge un proxy VPN (si disponible bien sûr) :

![image](https://user-images.githubusercontent.com/100569015/235353660-e3f8efe2-604d-4fb9-85af-39b387217743.png)

-----

# Configuration Jackett

**http://jackett_bandj:9117/UI/Dashboard**

- Ajouter plusieurs indexeurs Torrent de type **"Public"** et récupérer en haut de la page l'API Key de Jackett (nécessaire après pour Sonarr et Radarr) :

![image](https://user-images.githubusercontent.com/100569015/235353138-0459a0f9-22b1-48a1-96e0-d48c3a20a76b.png)

-----


# Configuration Radarr

**http://radarr_bandj:7878/**

- Ajouter un logiciel client de téléchargement Torrent (Deluge ici en l'occurence) :

![image](https://user-images.githubusercontent.com/100569015/235353004-edbe7f3b-83f9-4d31-87c7-361d2d5df154.png)

- Copier chaque lien d'indexeur ajouté dans Jackett (bouton **"Copy Torznab feed"**) et l'ajouter dans Radarr (> **Add indexer - Torznab**) ainsi que l'API Key dans le champ correspondant :

![image](https://user-images.githubusercontent.com/100569015/235353230-4c93dd51-c275-4e2b-a4d1-abc9df3b44f4.png)

-----

# Configuration Sonarr

**http://sonarr_bandj:8989/**

- Accéder à l'interface web de Sonarr et répéter les même étapes effectuées précédemment pour Radarr.

-----

# C'est parti pour un test avec Radarr !

- Chercher et ajouter un nouveau film sur l'interface web de Radarr :

![image](https://user-images.githubusercontent.com/100569015/235355736-32694c8c-d8b0-4610-a828-4159d0c83fda.png)

- Attendre que le téléchargement se rajoute automatiquement en file d'attente (onglet **Queue**)

- Aller consulter dans Deluge si le téléchargement est bien remonté :

![image](https://user-images.githubusercontent.com/100569015/235355774-309bfaec-f798-4275-9879-01b461fbd02c.png)

- A la fin du téléchargement du fichier Torrent avec Deluge, le fichier se retrouve scanné par Plex et se retrouve au sein de sa bibliothèque correspondante au sein de l'interface web :

![image](https://user-images.githubusercontent.com/100569015/235356827-1946e437-fdc4-4111-bd55-f08c379dd248.png)

- Aperçu d'une notification Telegram reçue sur smartphone :

![image](https://user-images.githubusercontent.com/100569015/235374816-7fb9900f-cae2-4764-88b7-07cd48520b5b.png)

-------


# Extra avec Tautulli

**http://tautulli_bandj:8181/**

- Se rendre sur l'interface web de Tautulli et rentrer les credentials du compte Plex dans le prompt d'authentification.

- Indiquer le nom d'hôte du container et le port correspondant puis faire un test :

![image](https://user-images.githubusercontent.com/100569015/235373549-f687c4ac-9ca0-44d2-b747-d6445247b8e8.png)

Tautulli génère automatiquement des statistiques et graphiques concernant l'utilisation du serveur Plex, avec la possibilité d'affiner ou filtrer les résultats :

![image](https://user-images.githubusercontent.com/100569015/235374022-697b137d-d558-47b7-b4da-8f1d79f0cd1a.png)


# Extra Plus avec Portainer

**https://portainer_bandj:9443**

- Se rendre sur l'interface web de Portainer et créer un compte admin de connexion.

- Confirmer l'environnement Docker utilisé pour terminer la configuration :

![image](https://user-images.githubusercontent.com/100569015/235373352-f7f4b9d2-1fa6-4ce9-8775-8e51d59d04a9.png)

