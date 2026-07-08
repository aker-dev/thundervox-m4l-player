# thundervox_m4l_player

Device Max for Live « S·O·S Player » pour le format réduit de S·O·S, en Holophonix Native.

Le device lit un dossier de messages (mp3), les joue un par un, et positionne sa source dans Holophonix par OSC. 1 instance = 1 voix = 1 source mono. Plusieurs voix simultanées = plusieurs pistes (une instance par piste).

## Structure

- `device/` : le device Max (`.amxd`), construit dans Max
- `src/` : la logique JavaScript (objet v8, Max 9), éditable ici
- `docs/` : la spec détaillée
- `CLAUDE.md` : contexte technique pour Claude Code

## Développement

1. Ouvrir le `.amxd` dans Max (mode édition).
2. La logique vit dans `src/player.js`, chargée par un objet `v8`.
3. Éditer le JS ici ou dans Claude Code : Max recharge à la sauvegarde (`autowatch`).
4. Câbler dans le patch : `sfplay~` (audio), `udpsend` vers Holophonix, `udpreceive` pour les réponses `/get`.

## Points clés

- OSC vers Holophonix, port 4003, source mono en `/track/{id}/xyz` (triplet complet).
- Positions d'enceintes récupérées par `/get` au démarrage.
- La séquence est pilotée par la fin de lecture de `sfplay~` (event-driven), pas par un calcul de durée.
- Voir `docs/` pour le détail complet.
