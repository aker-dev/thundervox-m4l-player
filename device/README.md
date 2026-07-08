# device

Le device Max for Live (`.amxd`) se construit dans Max et se place ici.

Contenu attendu du patch :

- un objet `v8 player.js` chargeant le fichier externe `src/player.js` (pas de code embarque, pour que Claude Code edite le fichier ; `autowatch` recharge a la sauvegarde). Le dossier `src/` doit etre dans le search path de Max, ou utiliser un Max Project a la racine du repo.
- `sfplay~` pour la lecture audio (sortie mono vers le canal Bridge de la source)
- `udpsend 127.0.0.1 4003` vers Holophonix
- `udpreceive` + `route` pour les reponses `/get` (positions d'enceintes), reformatees en message `speaker <id> <x> <y> <z>` vers le `v8`
- la fin de lecture de `sfplay~` (bang de fin) reformatee en message `done` vers le `v8`
- UI : chemin dossier (message `folder`), source id (`sourceid`), gap (`gap`), boutons `rescan`, `start`, `stop`, bloc test

Le `.amxd` etant binaire, il n'est pas scaffole ici. A creer dans Max.
