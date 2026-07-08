# CLAUDE.md - thundervox_m4l_player

Contexte technique pour Claude Code. Repo dédié au device Max for Live « S·O·S Player » (format réduit, Holophonix Native). Distinct de `aker-dev/thundervox-recorder`, qui reste le backend et la plateforme ThunderVox.

## Répartition des rôles

- Décisions d'architecture, arbitrages techniques, troubleshooting complexe et communications stakeholders (Adrien/AKER, Marie-Luce) : coordonnés dans le hub claude.ai du projet.
- Le code se développe ici, dans ce repo.

## Objectif du composant

Version M4L du player, pour la tournée en format réduit. Live n'est qu'un hôte : toute la spatialisation vit dans Holophonix Native. Le device joue les messages et positionne les sources dans Holophonix.

## Architecture retenue

- 1 piste = 1 voix = 1 source mono Holophonix. Le device sur la piste lit un dossier de mp3, joue les messages un par un, positionne sa source par OSC.
- Simultanéité de plusieurs messages : dupliquer la piste (chaque instance = une voix, une source).
- Positionnement : snap sur une enceinte, positions récupérées de Holophonix par OSC au démarrage. Pas de bounding box.
- Coordonnées XYZ complètes en mètres (règle anti-drift Z).
- Type de device : Max audio effect. Le device génère l'audio du message, pas de clip sur la piste.

## Où vit la logique

La logique est en JavaScript (objet `v8`, Max 9) dans `src/player.js`, pour être éditable ici. Le patch M4L (`.amxd`) est un hôte mince : `sfplay~` (audio), `udpsend`/`udpreceive` (OSC), l'objet `v8`, l'UI. Claude Code travaille le JS ; le `.amxd` se construit dans Max.

La séquence est event-driven : `sfplay~` signale la fin de lecture (message `done`), le player attend `gapMs` puis enchaîne. Pas de calcul de durée.

## Points OSC Holophonix

- Envoi vers Holophonix, port 4003 par défaut.
- Source mono adressée en `/track/{index}/...` (index à partir de 1). Position en `/track/{id}/xyz x y z`, triplet complet.
- `/get` pour lire les positions d'enceintes au démarrage.
- Adresses exactes (position source, position enceinte) à confirmer dans la fenêtre OSC Status de Holophonix, puis à figer dans `src/player.js` (bloc CONFIG).
- Audio Live vers Holophonix via la carte son virtuelle HOLOPHONIX Virtual SoundCard.

## Conventions de code

- Commentaires et docs en français. Identifiants en anglais.
- Simplicité d'abord : valeurs en dur dans le bloc CONFIG plutôt que multiplier les options.
- Pas de tirets cadratins dans les textes produits.

## Références

- Liaison OSC : on écrit la nôtre, sans dépendance externe. L'encodeur OSC maison de `aker-dev/holophonix_export` (OSC 1.0 sur UDP, ~30 lignes, sans dépendance) est la référence à reprendre pour le format des messages.
- Coordonnées : `aker-dev/holophonix_export` est la source de vérité (fonction `to_holophonix`, XYZ en mètres, conventions AED, sérialisation). Adresse OSC des enceintes : `/speaker/{index}`. Le player travaille directement en repère Holophonix, sans swap d'axes (le swap Rhino vers Holophonix `X_h = Y_r` vit dans `holophonix_export`, utile seulement si on repart de Rhino).
- Observation seulement : device M4L officiel Holophonix (sync session Ableton) et Holoscore VST3, pour voir comment ils procèdent. On n'en reprend pas le code.

## Spec détaillée

`docs/brief-m4l-player-sos-holophonix-v4.md`.
