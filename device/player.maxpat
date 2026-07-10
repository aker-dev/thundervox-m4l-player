{
	"patcher" : 	{
		"fileversion" : 1,
		"appversion" : 		{
			"major" : 8,
			"minor" : 6,
			"revision" : 5,
			"architecture" : "x64",
			"modernui" : 1
		}
,
		"classnamespace" : "box",
		"rect" : [ 60.0, 60.0, 800.0, 580.0 ],
		"bglocked" : 0,
		"openinpresentation" : 0,
		"default_fontsize" : 12.0,
		"default_fontface" : 0,
		"default_fontname" : "Arial",
		"gridonopen" : 1,
		"gridsize" : [ 15.0, 15.0 ],
		"gridsnaponopen" : 1,
		"objectsnaponopen" : 1,
		"statusbarvisible" : 2,
		"toolbarvisible" : 1,
		"lefttoolbarpinned" : 0,
		"toptoolbarpinned" : 0,
		"righttoolbarpinned" : 0,
		"bottomtoolbarpinned" : 0,
		"toolbars_unpinned_last_save" : 0,
		"tallnewobj" : 0,
		"boxanimatetime" : 200,
		"enablehscroll" : 1,
		"enablevscroll" : 1,
		"devicewidth" : 0.0,
		"description" : "",
		"digest" : "",
		"tags" : "",
		"style" : "",
		"subpatcher_template" : "",
		"assistshowspatchername" : 0,
		"boxes" : [
			{ "box" : { "id" : "obj-1", "maxclass" : "comment", "text" : "S.O.S Player - patch courant (etapes 1 a 5a, nettoye). Tout selectionner / copier, coller dans le device (remplace le contenu). Logs coupes par defaut : toggle verbose pour les rallumer.", "numinlets" : 1, "numoutlets" : 0, "patching_rect" : [ 40.0, 18.0, 730.0, 20.0 ], "fontsize" : 12.0 } },

			{ "box" : { "id" : "obj-2", "maxclass" : "message", "text" : "rescan", "numinlets" : 2, "numoutlets" : 1, "outlettype" : [ "" ], "patching_rect" : [ 40.0, 70.0, 60.0, 22.0 ], "fontsize" : 12.0 } },
			{ "box" : { "id" : "obj-3", "maxclass" : "message", "text" : "dumpspeakers", "numinlets" : 2, "numoutlets" : 1, "outlettype" : [ "" ], "patching_rect" : [ 110.0, 70.0, 100.0, 22.0 ], "fontsize" : 12.0 } },

			{ "box" : { "id" : "obj-16", "maxclass" : "comment", "text" : "OSC in : Holophonix -> udpreceive 4004", "numinlets" : 1, "numoutlets" : 0, "patching_rect" : [ 300.0, 48.0, 250.0, 18.0 ], "fontsize" : 12.0 } },
			{ "box" : { "id" : "obj-14", "maxclass" : "newobj", "text" : "udpreceive 4004", "numinlets" : 0, "numoutlets" : 1, "outlettype" : [ "" ], "patching_rect" : [ 300.0, 70.0, 110.0, 22.0 ], "fontsize" : 12.0 } },

			{ "box" : { "id" : "obj-35", "maxclass" : "comment", "text" : "logs debug (console)", "numinlets" : 1, "numoutlets" : 0, "patching_rect" : [ 620.0, 72.0, 150.0, 18.0 ], "fontsize" : 12.0 } },
			{ "box" : { "id" : "obj-33", "maxclass" : "toggle", "numinlets" : 1, "numoutlets" : 1, "outlettype" : [ "int" ], "patching_rect" : [ 590.0, 70.0, 24.0, 24.0 ] } },
			{ "box" : { "id" : "obj-34", "maxclass" : "newobj", "text" : "prepend verbose", "numinlets" : 1, "numoutlets" : 1, "outlettype" : [ "" ], "patching_rect" : [ 590.0, 100.0, 110.0, 22.0 ], "fontsize" : 12.0 } },

			{ "box" : { "id" : "obj-5", "maxclass" : "comment", "text" : "etape 2 : numero d'enceinte -> source dessus", "numinlets" : 1, "numoutlets" : 0, "patching_rect" : [ 100.0, 142.0, 280.0, 18.0 ], "fontsize" : 12.0 } },
			{ "box" : { "id" : "obj-4", "maxclass" : "number", "numinlets" : 1, "numoutlets" : 2, "outlettype" : [ "", "bang" ], "patching_rect" : [ 40.0, 140.0, 50.0, 22.0 ], "fontsize" : 12.0 } },
			{ "box" : { "id" : "obj-6", "maxclass" : "newobj", "text" : "prepend testspeaker", "numinlets" : 1, "numoutlets" : 1, "outlettype" : [ "" ], "patching_rect" : [ 40.0, 180.0, 130.0, 22.0 ], "fontsize" : 12.0 } },

			{ "box" : { "id" : "obj-7", "maxclass" : "message", "text" : "testplay", "numinlets" : 2, "numoutlets" : 1, "outlettype" : [ "" ], "patching_rect" : [ 230.0, 140.0, 70.0, 22.0 ], "fontsize" : 12.0 } },

			{ "box" : { "id" : "obj-9", "maxclass" : "comment", "text" : "choisir dossier mp3", "numinlets" : 1, "numoutlets" : 0, "patching_rect" : [ 370.0, 144.0, 140.0, 18.0 ], "fontsize" : 12.0 } },
			{ "box" : { "id" : "obj-8", "maxclass" : "button", "numinlets" : 1, "numoutlets" : 1, "outlettype" : [ "bang" ], "patching_rect" : [ 335.0, 140.0, 24.0, 24.0 ] } },
			{ "box" : { "id" : "obj-10", "maxclass" : "newobj", "text" : "opendialog fold", "numinlets" : 1, "numoutlets" : 2, "outlettype" : [ "", "" ], "patching_rect" : [ 335.0, 185.0, 110.0, 22.0 ], "fontsize" : 12.0 } },
			{ "box" : { "id" : "obj-11", "maxclass" : "newobj", "text" : "prepend folder", "numinlets" : 1, "numoutlets" : 1, "outlettype" : [ "" ], "patching_rect" : [ 335.0, 222.0, 100.0, 22.0 ], "fontsize" : 12.0 } },

			{ "box" : { "id" : "obj-13", "maxclass" : "comment", "text" : "ou edite ce chemin (memorise avec le Set)", "numinlets" : 1, "numoutlets" : 0, "patching_rect" : [ 470.0, 163.0, 250.0, 18.0 ], "fontsize" : 12.0 } },
			{ "box" : { "id" : "obj-12", "maxclass" : "message", "text" : "/chemin/vers/dossier-mp3", "numinlets" : 2, "numoutlets" : 1, "outlettype" : [ "" ], "patching_rect" : [ 470.0, 185.0, 230.0, 22.0 ], "fontsize" : 12.0 } },
			{ "box" : { "id" : "obj-40", "maxclass" : "newobj", "text" : "pattr sosfolder", "numinlets" : 1, "numoutlets" : 1, "outlettype" : [ "" ], "patching_rect" : [ 470.0, 222.0, 130.0, 22.0 ], "fontsize" : 12.0 } },

			{ "box" : { "id" : "obj-29", "maxclass" : "comment", "text" : "sourceId : source /track/N, PROPRE a chaque instance (parametre Live)", "numinlets" : 1, "numoutlets" : 0, "patching_rect" : [ 545.0, 240.0, 240.0, 30.0 ], "fontsize" : 12.0 } },
			{ "box" : { "id" : "obj-28", "maxclass" : "live.numbox", "numinlets" : 1, "numoutlets" : 2, "outlettype" : [ "", "float" ], "parameter_enable" : 1, "patching_rect" : [ 560.0, 275.0, 51.0, 15.0 ], "saved_attribute_attributes" : { "valueof" : { "parameter_longname" : "sourceId", "parameter_shortname" : "sourceId", "parameter_type" : 1, "parameter_mmin" : 1.0, "parameter_mmax" : 64.0, "parameter_initial_enable" : 1, "parameter_initial" : [ 1.0 ], "parameter_unitstyle" : 0 } }, "varname" : "sourceId" } },
			{ "box" : { "id" : "obj-30", "maxclass" : "newobj", "text" : "live.thisdevice", "numinlets" : 1, "numoutlets" : 3, "outlettype" : [ "bang", "", "int" ], "patching_rect" : [ 640.0, 275.0, 100.0, 22.0 ], "fontsize" : 12.0 } },
			{ "box" : { "id" : "obj-31", "maxclass" : "newobj", "text" : "t b", "numinlets" : 1, "numoutlets" : 1, "outlettype" : [ "bang" ], "patching_rect" : [ 700.0, 305.0, 30.0, 22.0 ], "fontsize" : 12.0 } },
			{ "box" : { "id" : "obj-32", "maxclass" : "newobj", "text" : "prepend sourceid", "numinlets" : 1, "numoutlets" : 1, "outlettype" : [ "" ], "patching_rect" : [ 545.0, 305.0, 110.0, 22.0 ], "fontsize" : 12.0 } },

			{ "box" : { "id" : "obj-27", "maxclass" : "comment", "text" : "etape 4 : sequence", "numinlets" : 1, "numoutlets" : 0, "patching_rect" : [ 230.0, 246.0, 200.0, 18.0 ], "fontsize" : 12.0 } },
			{ "box" : { "id" : "obj-25", "maxclass" : "message", "text" : "start", "numinlets" : 2, "numoutlets" : 1, "outlettype" : [ "" ], "patching_rect" : [ 230.0, 268.0, 50.0, 22.0 ], "fontsize" : 12.0 } },
			{ "box" : { "id" : "obj-26", "maxclass" : "message", "text" : "stop", "numinlets" : 2, "numoutlets" : 1, "outlettype" : [ "" ], "patching_rect" : [ 290.0, 268.0, 50.0, 22.0 ], "fontsize" : 12.0 } },

			{ "box" : { "id" : "obj-24", "maxclass" : "comment", "text" : "OSC out -> Holophonix (v8 sortie du milieu)", "numinlets" : 1, "numoutlets" : 0, "patching_rect" : [ 300.0, 300.0, 260.0, 18.0 ], "fontsize" : 12.0 } },
			{ "box" : { "id" : "obj-17", "maxclass" : "newobj", "text" : "v8 player.js", "numinlets" : 1, "numoutlets" : 3, "outlettype" : [ "", "", "" ], "patching_rect" : [ 40.0, 340.0, 110.0, 22.0 ], "fontsize" : 12.0 } },
			{ "box" : { "id" : "obj-23", "maxclass" : "newobj", "text" : "udpsend 127.0.0.1 4003", "numinlets" : 1, "numoutlets" : 0, "patching_rect" : [ 300.0, 342.0, 180.0, 22.0 ], "fontsize" : 12.0 } },

			{ "box" : { "id" : "obj-22", "maxclass" : "comment", "text" : "fin de lecture (sorties 2 et 3) -> done", "numinlets" : 1, "numoutlets" : 0, "patching_rect" : [ 275.0, 412.0, 240.0, 18.0 ], "fontsize" : 12.0 } },
			{ "box" : { "id" : "obj-18", "maxclass" : "newobj", "text" : "sfplay~ 2", "numinlets" : 1, "numoutlets" : 4, "outlettype" : [ "signal", "signal", "signal", "bang" ], "patching_rect" : [ 40.0, 410.0, 90.0, 22.0 ], "fontsize" : 12.0 } },
			{ "box" : { "id" : "obj-21", "maxclass" : "message", "text" : "done", "numinlets" : 2, "numoutlets" : 1, "outlettype" : [ "" ], "patching_rect" : [ 205.0, 410.0, 60.0, 22.0 ], "fontsize" : 12.0 } },

			{ "box" : { "id" : "obj-20", "maxclass" : "comment", "text" : "audio mono -> sortie piste (canal Bridge de la source)", "numinlets" : 1, "numoutlets" : 0, "patching_rect" : [ 140.0, 472.0, 300.0, 18.0 ], "fontsize" : 12.0 } },
			{ "box" : { "id" : "obj-19", "maxclass" : "newobj", "text" : "plugout~ 1 2", "numinlets" : 2, "numoutlets" : 0, "patching_rect" : [ 40.0, 470.0, 90.0, 22.0 ], "fontsize" : 12.0 } },

			{ "box" : { "id" : "obj-36", "maxclass" : "comment", "text" : "autostart : la sequence suit le transport Live (parametre par instance)", "numinlets" : 1, "numoutlets" : 0, "patching_rect" : [ 395.0, 244.0, 260.0, 30.0 ], "fontsize" : 12.0 } },
			{ "box" : { "id" : "obj-37", "maxclass" : "live.toggle", "numinlets" : 1, "numoutlets" : 1, "outlettype" : [ "int" ], "parameter_enable" : 1, "patching_rect" : [ 360.0, 268.0, 24.0, 24.0 ], "saved_attribute_attributes" : { "valueof" : { "parameter_longname" : "autostart", "parameter_shortname" : "autostart", "parameter_type" : 2, "parameter_mmin" : 0, "parameter_mmax" : 1, "parameter_initial_enable" : 1, "parameter_initial" : [ 0 ] } }, "varname" : "autostart" } },
			{ "box" : { "id" : "obj-38", "maxclass" : "newobj", "text" : "prepend autostart", "numinlets" : 1, "numoutlets" : 1, "outlettype" : [ "" ], "patching_rect" : [ 395.0, 305.0, 125.0, 22.0 ], "fontsize" : 12.0 } },
			{ "box" : { "id" : "obj-39", "maxclass" : "message", "text" : "loaded", "numinlets" : 2, "numoutlets" : 1, "outlettype" : [ "" ], "patching_rect" : [ 700.0, 345.0, 60.0, 22.0 ], "fontsize" : 12.0 } }
		],
		"lines" : [
			{ "patchline" : { "source" : [ "obj-2", 0 ], "destination" : [ "obj-17", 0 ] } },
			{ "patchline" : { "source" : [ "obj-3", 0 ], "destination" : [ "obj-17", 0 ] } },
			{ "patchline" : { "source" : [ "obj-33", 0 ], "destination" : [ "obj-34", 0 ] } },
			{ "patchline" : { "source" : [ "obj-34", 0 ], "destination" : [ "obj-17", 0 ] } },
			{ "patchline" : { "source" : [ "obj-4", 0 ], "destination" : [ "obj-6", 0 ] } },
			{ "patchline" : { "source" : [ "obj-6", 0 ], "destination" : [ "obj-17", 0 ] } },
			{ "patchline" : { "source" : [ "obj-7", 0 ], "destination" : [ "obj-17", 0 ] } },
			{ "patchline" : { "source" : [ "obj-8", 0 ], "destination" : [ "obj-10", 0 ] } },
			{ "patchline" : { "source" : [ "obj-10", 0 ], "destination" : [ "obj-40", 0 ] } },
			{ "patchline" : { "source" : [ "obj-12", 0 ], "destination" : [ "obj-40", 0 ] } },
			{ "patchline" : { "source" : [ "obj-40", 0 ], "destination" : [ "obj-11", 0 ] } },
			{ "patchline" : { "source" : [ "obj-31", 0 ], "destination" : [ "obj-40", 0 ] } },
			{ "patchline" : { "source" : [ "obj-11", 0 ], "destination" : [ "obj-17", 0 ] } },
			{ "patchline" : { "source" : [ "obj-14", 0 ], "destination" : [ "obj-17", 0 ] } },
			{ "patchline" : { "source" : [ "obj-25", 0 ], "destination" : [ "obj-17", 0 ] } },
			{ "patchline" : { "source" : [ "obj-26", 0 ], "destination" : [ "obj-17", 0 ] } },
			{ "patchline" : { "source" : [ "obj-28", 0 ], "destination" : [ "obj-32", 0 ] } },
			{ "patchline" : { "source" : [ "obj-30", 0 ], "destination" : [ "obj-31", 0 ] } },
			{ "patchline" : { "source" : [ "obj-31", 0 ], "destination" : [ "obj-28", 0 ] } },
			{ "patchline" : { "source" : [ "obj-32", 0 ], "destination" : [ "obj-17", 0 ] } },
			{ "patchline" : { "source" : [ "obj-17", 0 ], "destination" : [ "obj-18", 0 ] } },
			{ "patchline" : { "source" : [ "obj-17", 1 ], "destination" : [ "obj-23", 0 ] } },
			{ "patchline" : { "source" : [ "obj-18", 0 ], "destination" : [ "obj-19", 0 ] } },
			{ "patchline" : { "source" : [ "obj-18", 3 ], "destination" : [ "obj-21", 0 ] } },
			{ "patchline" : { "source" : [ "obj-18", 2 ], "destination" : [ "obj-21", 0 ] } },
			{ "patchline" : { "source" : [ "obj-21", 0 ], "destination" : [ "obj-17", 0 ] } },
			{ "patchline" : { "source" : [ "obj-37", 0 ], "destination" : [ "obj-38", 0 ] } },
			{ "patchline" : { "source" : [ "obj-38", 0 ], "destination" : [ "obj-17", 0 ] } },
			{ "patchline" : { "source" : [ "obj-31", 0 ], "destination" : [ "obj-39", 0 ] } },
			{ "patchline" : { "source" : [ "obj-39", 0 ], "destination" : [ "obj-17", 0 ] } }
		],
		"dependency_cache" : [  ],
		"autosave" : 0
	}

}
