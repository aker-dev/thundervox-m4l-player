// thundervox_m4l_player - player.js
// Logique du device S.O.S Player (Holophonix Native, format reduit).
// A charger dans un objet v8 (Max 9) place dans le patch M4L.
//
// Role : lire un dossier de messages, les jouer un par un via sfplay~,
// et positionner la source Holophonix correspondante par OSC.
// 1 instance = 1 voix = 1 source mono. Plusieurs voix = plusieurs pistes.
//
// Voir docs/brief-m4l-player-sos-holophonix-v4.md pour la spec complete.

// Objet cible : v8 (Max 9, moteur ES6+). Le js legacy (ES5) fonctionne aussi, mais v8 est recommande.
// Regle v8 importante : toute variable exposee comme attribut Max doit rester en var
// (jamais const/let), sinon elle ne fonctionne plus comme attribut. Les globales speciales
// ci-dessous restent en assignation simple, c'est l'idiome Max attendu.
autowatch = 1;
inlets = 1;
outlets = 6;
// Outlets (a cabler dans le patch) :
//   0 -> sfplay~           : messages "open <path>", puis 1 pour jouer, "stop" pour arreter
//   1 -> udpsend           : messages OSC vers Holophonix (adresse puis arguments)
//   2 -> afficheur statut  : "set <texte>" vers un message box (nb fichiers, enceintes, lecture...)
//   3 -> afficheur dossier : "set <nom>" vers un message box (nom du dossier courant)
//   4 -> toggle Play       : "set 0/1" pour resynchroniser le live.toggle avec l'etat reel
//   5 -> pattr dossier     : chemin du dossier (derive du fichier depose sur live.drop), a memoriser

// ----- CONFIG (valeurs a caler) -----
// Repere Holophonix, XYZ en metres. Pas de swap d'axes ici : on lit les enceintes et on
// ecrit les sources directement en coords Holophonix. Le swap Rhino -> Holophonix (X_h = Y_r)
// vit dans aker-dev/holophonix_export (fonction to_holophonix), pertinent seulement cote export.
var CONFIG = {
  sourceId: 1, // index de la source mono Holophonix : /track/{sourceId}
  folder: "", // chemin du dossier de messages (mp3), passe par message "folder"
  gapMinMs: 1000, // gap minimum entre deux messages (ms) ; regle en secondes via l'UI
  gapMaxMs: 4000, // gap maximum ; a chaque message on tire un gap aleatoire dans [min, max]
  autostart: 0, // 1 = la sequence suit le transport Live (Play -> start, Stop -> stop)
  maxSpeakers: 16, // on interroge les enceintes 1..maxSpeakers et on garde celles qui repondent (Holophonix Native va jusqu'a 16)
  // Prefixes OSC confirmes via aker-dev/holophonix_export (source /track, enceinte /speaker).
  // Sous-adresse de position (xyz) a verifier dans la fenetre OSC Status de Holophonix.
  addrSourceXyz: "/track/%ID%/xyz", // position source, triplet complet
  addrSpeakerXyz: "/speaker/%N%/xyz", // position enceinte, lue via /get
};

// ----- ETAT -----
var files = []; // chemins des fichiers du dossier
var speakers = []; // [{id, x, y, z}] table des enceintes (remplie par OSC /get)
var lastFileIndex = -1;
var playQueue = []; // indices restant a jouer dans le passage courant (sac melange) ; vide -> on re-melange
var lastSpeakerId = -1; // id de la derniere enceinte utilisee (evite la repetition immediate)
var enabledSpeakers = []; // [16] booleens : enceintes cochees (index 0..15 = enceintes 1..16), via 16 live.toggle
var playing = false;
var gapTask = null;
var oscDebug = 0; // logs de debug (OSC + sequence + transport) dans la console Max. Bascule a chaud via "verbose 1" / "verbose 0".

// ----- INIT -----
// message "loaded" : declenche par live.thisdevice quand le device est charge et pret. En M4L c'est
// le hook de chargement fiable (contexte Live pour LiveAPI, reseau OSC) : on interroge les enceintes
// et on met en place l'observation du transport. (loadbang non utilise : moins fiable ici.)
function loaded() {
  if (oscDebug) {
    post("loaded: device pret\n");
  }
  stop(); // etat propre a l'ouverture : la sequence ne demarre pas toute seule
  requestSpeakers();
  watchTransport();
}

// message "folder <chemin>" depuis l'UI du patch (via le pattr sosfolder)
function folder(path) {
  CONFIG.folder = path;
  outlet(3, "set", basename(path)); // afficheur dossier (UI)
  scanFolder();
}

// message "dropfile <path>" depuis live.drop : on charge le DOSSIER du fichier depose.
// live.drop ne prend qu'un fichier (pas un dossier) : on remonte a son dossier parent.
function dropfile() {
  var a = arrayfromargs(arguments);
  var p = "";
  for (var i = 0; i < a.length; i++) {
    if (("" + a[i]).indexOf("/") >= 0) {
      p = "" + a[i];
      break;
    } // l'atome qui ressemble a un chemin
  }
  if (!p && a.length) {
    p = "" + a[a.length - 1];
  }
  var dir = dirname(p);
  if (oscDebug) {
    post("player: dossier depose = " + dir + "\n");
  }
  if (dir) {
    outlet(5, dir);
  } // -> pattr sosfolder (memorise) -> folder()
}

// message "sourceid <n>" : index de la source Holophonix pour cette instance (/track/n).
// Pousse par un parametre Live (live.numbox) propre a chaque instance, y compris au chargement.
function sourceid(n) {
  CONFIG.sourceId = Math.round(n);
  if (oscDebug) {
    post(
      "player: sourceId = " +
        CONFIG.sourceId +
        " (/track/" +
        CONFIG.sourceId +
        ")\n",
    );
  }
}

// messages "gapmin <s>" / "gapmax <s>" : bornes du gap entre messages, en secondes (parametres Live).
// A chaque message on tire un gap aleatoire dans [gapMinMs, gapMaxMs].
function gapmin(s) {
  CONFIG.gapMinMs = Math.max(0, Math.round(s * 1000));
  if (oscDebug) {
    post("player: gap min = " + CONFIG.gapMinMs + " ms\n");
  }
}
function gapmax(s) {
  CONFIG.gapMaxMs = Math.max(0, Math.round(s * 1000));
  if (oscDebug) {
    post("player: gap max = " + CONFIG.gapMaxMs + " ms\n");
  }
}

// message "verbose <0|1>" : active/coupe les logs de debug (OSC + sequence).
function verbose(n) {
  oscDebug = n ? 1 : 0;
  post("player: verbose = " + oscDebug + "\n");
}

// message "rescan"
function rescan() {
  scanFolder();
  requestSpeakers();
}

// ----- DOSSIER -----
function scanFolder() {
  files = [];
  playQueue = [];
  lastFileIndex = -1; // nouveau dossier -> nouveau passage (indices repartent a neuf)
  if (!CONFIG.folder) {
    post("player: aucun dossier defini\n");
    return;
  }
  var f = new Folder(CONFIG.folder);
  while (!f.end) {
    var name = f.filename;
    if (/\.(mp3|wav|aif|aiff)$/i.test(name)) {
      files.push(CONFIG.folder + "/" + name);
    }
    f.next();
  }
  f.close();
  post("player: " + files.length + " fichiers trouves\n");
  updateStatus();
}

// ----- ENCEINTES (recuperation OSC /get) -----
// Interroge Holophonix pour la position de chaque enceinte via /get.
// Prefixe /speaker/{index} confirme par aker-dev/holophonix_export (le CSV et le sync OSC
// utilisent /speaker/1, /speaker/2, ...). La sous-adresse xyz reste a confirmer a l'etape 1,
// dans la fenetre OSC Status et via le log "osc in" ci-dessous.
//
// Forme du /get (a confirmer) : adresse OSC "/get", argument = l'adresse a lire. Si
// Holophonix ne repond pas, l'autre forme courante est d'interroger directement l'adresse
// cible sans argument. On bascule selon ce que montre OSC Status.
function requestSpeakers() {
  speakers = [];
  for (var i = 1; i <= CONFIG.maxSpeakers; i++) {
    var addr = CONFIG.addrSpeakerXyz.replace("%N%", i);
    outlet(1, "/get", addr);
    if (oscDebug) {
      post("osc out: /get " + addr + "\n");
    }
  }
  post(
    "player: /get envoye pour enceintes 1 a " +
      CONFIG.maxSpeakers +
      " (on garde celles qui repondent)\n",
  );
}

// Reponses OSC entrantes (via udpreceive -> v8). udpreceive decode l'OSC : le selecteur est
// l'adresse (ex "/speaker/1/xyz"), les arguments sont les valeurs. Une adresse variable n'est
// pas une fonction JS connue, donc Max route le message vers anything(), ou on parse l'adresse.
// On evite ainsi un route/OSC-route cote patch.
function anything() {
  var addr = messagename; // ex "/speaker/1/xyz"
  var vals = arrayfromargs(arguments); // ex [2.0, 0.0, 1.5]
  var parts = addr.split("/"); // "/speaker/1/xyz" -> ["", "speaker", "1", "xyz"]

  // Holophonix renvoie "/error ..." pour un index d'enceinte inexistant. Normal quand on sonde
  // 1..maxSpeakers au-dela du nombre reel : on le signale a part et on ignore (pas de fantome).
  if (parts[1] === "error") {
    if (oscDebug) {
      post("osc err: " + vals.join(" ") + "\n");
    }
    return;
  }

  if (oscDebug) {
    post("osc in: " + addr + " [" + vals.join(", ") + "]\n");
  }

  if (parts[1] === "speaker") {
    var id = parseInt(parts[2], 10);
    if (!isNaN(id) && vals.length >= 3) {
      storeSpeaker(id, vals[0], vals[1], vals[2]);
      updateStatus();
    }
  }
}

// Range une enceinte dans la table : met a jour si l'id existe deja, sinon ajoute.
// Idempotent, donc plusieurs /get successifs ne creent pas de doublons.
function storeSpeaker(id, x, y, z) {
  for (var i = 0; i < speakers.length; i++) {
    if (speakers[i].id === id) {
      speakers[i].x = x;
      speakers[i].y = y;
      speakers[i].z = z;
      return;
    }
  }
  speakers.push({ id: id, x: x, y: y, z: z });
}

// Affiche la table des enceintes dans la fenetre Max (verification etape 1).
function dumpspeakers() {
  post("speakers: " + speakers.length + " enceintes\n");
  var sorted = speakers.slice().sort(function (a, b) {
    return a.id - b.id;
  });
  for (var i = 0; i < sorted.length; i++) {
    var s = sorted[i];
    post(
      "  speaker " + s.id + " : x=" + s.x + " y=" + s.y + " z=" + s.z + "\n",
    );
  }
}

// Retrouve une enceinte par son id (numerotation Holophonix), ou null si absente.
function findSpeaker(id) {
  for (var i = 0; i < speakers.length; i++) {
    if (speakers[i].id === id) {
      return speakers[i];
    }
  }
  return null;
}

// ----- CIBLAGE (16 live.toggle -> pak -> "speakermask v1 .. v16") -----
// enabledSpeakers[i] = enceinte (i+1) cochee.
function speakermask() {
  var m = arrayfromargs(arguments);
  for (var i = 0; i < 16; i++) {
    enabledSpeakers[i] = m[i] ? true : false;
  }
  if (oscDebug) {
    var on = [];
    for (var j = 0; j < 16; j++) {
      if (enabledSpeakers[j]) {
        on.push(j + 1);
      }
    }
    post(
      "player: enceintes ciblees = " +
        (on.length ? on.join(",") : "aucune") +
        "\n",
    );
  }
}

// Enceintes eligibles : cochees ET presentes dans la table.
function eligibleSpeakers() {
  var out = [];
  for (var i = 0; i < speakers.length; i++) {
    if (enabledSpeakers[speakers[i].id - 1]) {
      out.push(speakers[i]);
    }
  }
  return out;
}

// Tire une enceinte au hasard dans la liste, differente de la derniere (sans repetition immediate).
function pickSpeaker(list) {
  var sp = list[Math.floor(Math.random() * list.length)];
  if (list.length > 1) {
    while (sp.id === lastSpeakerId) {
      sp = list[Math.floor(Math.random() * list.length)];
    }
  }
  lastSpeakerId = sp.id;
  return sp;
}

// ----- UI (afficheurs, outlets 2/3/4) -----
// Ligne de statut envoyee a un comment via l'outlet 2 (nb fichiers, enceintes, lecture, enceinte courante).
function updateStatus() {
  var s = files.length + " files | " + speakers.length + " spk";
  if (playing) {
    s += " | playing";
    if (lastSpeakerId > 0) {
      s += " spk " + lastSpeakerId;
    }
  } else {
    s += " | idle";
  }
  outlet(2, "set", s);
}

// Dernier segment d'un chemin (nom du dossier), sans slash final.
function basename(path) {
  var p = ("" + path).replace(/\/+$/, "").split("/");
  return p[p.length - 1] || "" + path;
}

// Dossier parent d'un chemin de fichier (tout sauf le dernier segment).
function dirname(path) {
  var p = ("" + path).replace(/\/+$/, "").split("/");
  p.pop();
  return p.join("/");
}

// ----- SEQUENCE -----
function start() {
  if (playing) {
    post("player: deja en lecture\n");
    return;
  }
  if (files.length === 0) {
    post("player: rien a jouer (dossier vide ?)\n");
    outlet(4, "set", 0);
    return;
  }
  if (eligibleSpeakers().length === 0) {
    post(
      "player: aucune enceinte cochee/disponible - coche au moins une enceinte\n",
    );
    outlet(4, "set", 0);
    return;
  }
  playing = true;
  outlet(4, "set", 1); // resync toggle Play
  if (oscDebug) {
    post("seq: start\n");
  }
  updateStatus();
  playNext();
}

function stop() {
  playing = false;
  if (gapTask) {
    gapTask.cancel();
    gapTask = null;
  }
  outlet(0, "stop");
  outlet(4, "set", 0); // resync toggle Play
  updateStatus();
}

// Lecture one-shot d'un fichier par sfplay~ (outlet 0 : "open <path>" puis 1).
function playFile(path) {
  outlet(0, "open", path);
  outlet(0, 1);
}

function playNext() {
  if (!playing || files.length === 0) return;

  // Ciblage : uniquement les enceintes cochees et presentes. Aucune dispo -> on arrete.
  var elig = eligibleSpeakers();
  if (elig.length === 0) {
    post("player: plus d'enceinte cochee disponible - arret\n");
    stop();
    return;
  }

  var fi = nextFileIndex();
  if (fi < 0) return;

  var sp = pickSpeaker(elig);
  sendPosition(sp.x, sp.y, sp.z);
  updateStatus(); // enceinte courante

  if (oscDebug) {
    post("seq: play [" + fi + "] -> enceinte " + sp.id + "\n");
  }

  // Lecture one-shot du fichier
  playFile(files[fi]);
}

// fin de lecture signalee par sfplay~ : message "done"
function done() {
  if (oscDebug) {
    post("seq: done recu (playing=" + playing + ")\n");
  }
  if (!playing) return;
  // Reutiliser une seule Task : ne pas en creer une par message, elles persistent
  // jusqu'a invalidation ou reload du script et fuiraient sinon.
  if (!gapTask) {
    gapTask = new Task(playNext, this);
  }
  var g = randomGapMs();
  if (oscDebug) {
    post("seq: gap " + g + " ms\n");
  }
  gapTask.schedule(g);
}

// ----- AUTOSTART (suit le transport Live) -----
// Quand autostart est actif, la sequence suit le transport Live : Play -> start, Stop -> stop.
// Etat de lecture observe via LiveAPI (is_playing du live_set). Sans autostart, le transport
// ne pilote pas la sequence (on garde les boutons start/stop manuels).
var transportApi = null;
var lastPlaying = -1; // -1 = pas encore initialise ; on ignore le 1er etat rapporte au chargement

// message "autostart <0|1>" depuis un parametre Live (live.toggle), propre a chaque instance.
function autostart(n) {
  CONFIG.autostart = n ? 1 : 0;
  if (oscDebug) {
    post("player: autostart = " + CONFIG.autostart + "\n");
  }
}

// Observe l'etat de lecture du transport. Cree une seule fois (au chargement via loaded()).
function watchTransport() {
  if (transportApi) return;
  lastPlaying = -1;
  transportApi = new LiveAPI(onTransport, "live_set");
  transportApi.property = "is_playing";
  if (oscDebug) {
    post("watchTransport: observation is_playing en place\n");
  }
}

// callback LiveAPI. On ne traite QUE "is_playing" : LiveAPI envoie aussi une notif ["id", <id>]
// a la mise en place, a ignorer (sinon on prend le nombre de l'id pour un Play). Et on ignore le
// 1er etat is_playing rapporte au chargement, pour ne pas demarrer la sequence a l'ouverture du Set.
function onTransport(args) {
  if (!args || args[0] !== "is_playing") {
    if (oscDebug) {
      post("transport cb (ignore): [" + args + "]\n");
    }
    return;
  }
  var playingNow = args[1] == 1 ? 1 : 0;
  if (oscDebug) {
    post(
      "transport cb: is_playing=" +
        playingNow +
        " (last " +
        lastPlaying +
        ")\n",
    );
  }
  if (lastPlaying === -1) {
    lastPlaying = playingNow;
    return;
  } // etat initial au chargement : memorise sans agir
  if (playingNow === lastPlaying) return; // pas de vrai changement
  lastPlaying = playingNow;
  if (!CONFIG.autostart) return;
  if (playingNow === 1) {
    start();
  } else {
    stop();
  }
}

// ----- OSC POSITION -----
function sendPosition(x, y, z) {
  var addr = CONFIG.addrSourceXyz.replace("%ID%", CONFIG.sourceId);
  outlet(1, addr, x, y, z); // udpsend empaquette en OSC
}

// ----- TEST (etape 2) -----
// message "testspeaker <id>" : pose la source /track/{sourceId} sur l'enceinte d'id donne.
// Sert a verifier le snap : viser une enceinte doit deplacer le point source dessus.
function testspeaker(id) {
  var sp = findSpeaker(id);
  if (!sp) {
    post("player: enceinte " + id + " inconnue (lance rescan d'abord)\n");
    return;
  }
  sendPosition(sp.x, sp.y, sp.z);
  post(
    "player: source /track/" +
      CONFIG.sourceId +
      " -> enceinte " +
      id +
      " (" +
      sp.x +
      " " +
      sp.y +
      " " +
      sp.z +
      ")\n",
  );
}

// message "testplay" : joue le premier fichier du dossier (verification etape 3).
function testplay() {
  if (files.length === 0) {
    post("player: aucun fichier (folder puis rescan ?)\n");
    return;
  }
  playFile(files[0]);
}

// ----- UTIL -----
// tire un gap aleatoire (ms) dans [gapMinMs, gapMaxMs], bornes remises dans l'ordre si besoin.
function randomGapMs() {
  var lo = CONFIG.gapMinMs,
    hi = CONFIG.gapMaxMs;
  if (hi < lo) {
    var t = lo;
    lo = hi;
    hi = t;
  }
  return Math.round(lo + Math.random() * (hi - lo));
}

// ----- SAC MELANGE (chaque message une fois avant tout retour) -----
// Reconstruit un passage complet : tous les index [0..files.length-1] dans un ordre
// aleatoire (Fisher-Yates). Evite qu'un nouveau passage commence par le dernier message
// joue (pas de repetition immediate a la jonction de deux passages).
function buildPlayQueue() {
  var idx = [];
  for (var i = 0; i < files.length; i++) {
    idx.push(i);
  }
  for (var i = idx.length - 1; i > 0; i--) {
    var j = Math.floor(Math.random() * (i + 1));
    var t = idx[i];
    idx[i] = idx[j];
    idx[j] = t;
  }
  if (idx.length > 1 && idx[0] === lastFileIndex) {
    var t2 = idx[0];
    idx[0] = idx[1];
    idx[1] = t2;
  }
  playQueue = idx;
}

// Prochain index a jouer : on pioche dans le passage courant ; vide -> on re-melange tout.
function nextFileIndex() {
  if (files.length === 0) {
    return -1;
  }
  if (playQueue.length === 0) {
    buildPlayQueue();
  }
  lastFileIndex = playQueue.shift();
  return lastFileIndex;
}
