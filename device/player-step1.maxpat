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
		"rect" : [ 80.0, 80.0, 700.0, 480.0 ],
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
			{
				"box" : 				{
					"id" : "obj-1",
					"maxclass" : "comment",
					"text" : "S.O.S Player - etape 1 : aller-retour OSC /get. Coller ces objets dans le device Max Audio Effect (garder plugin~/plugout~ existants).",
					"numinlets" : 1,
					"numoutlets" : 0,
					"patching_rect" : [ 40.0, 32.0, 620.0, 20.0 ],
					"fontsize" : 12.0
				}

			}
,
			{
				"box" : 				{
					"id" : "obj-2",
					"maxclass" : "message",
					"text" : "rescan",
					"numinlets" : 2,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"patching_rect" : [ 40.0, 130.0, 60.0, 22.0 ],
					"fontsize" : 12.0
				}

			}
,
			{
				"box" : 				{
					"id" : "obj-3",
					"maxclass" : "message",
					"text" : "dumpspeakers",
					"numinlets" : 2,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"patching_rect" : [ 120.0, 130.0, 100.0, 22.0 ],
					"fontsize" : 12.0
				}

			}
,
			{
				"box" : 				{
					"id" : "obj-4",
					"maxclass" : "newobj",
					"text" : "udpreceive 4004",
					"numinlets" : 0,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"patching_rect" : [ 330.0, 130.0, 110.0, 22.0 ],
					"fontsize" : 12.0
				}

			}
,
			{
				"box" : 				{
					"id" : "obj-5",
					"maxclass" : "comment",
					"text" : "reponses Holophonix -> v8 (anything) + print",
					"numinlets" : 1,
					"numoutlets" : 0,
					"patching_rect" : [ 450.0, 132.0, 220.0, 20.0 ],
					"fontsize" : 12.0
				}

			}
,
			{
				"box" : 				{
					"id" : "obj-6",
					"maxclass" : "newobj",
					"text" : "v8 player.js",
					"numinlets" : 1,
					"numoutlets" : 3,
					"outlettype" : [ "", "", "" ],
					"patching_rect" : [ 40.0, 250.0, 100.0, 22.0 ],
					"fontsize" : 12.0
				}

			}
,
			{
				"box" : 				{
					"id" : "obj-7",
					"maxclass" : "comment",
					"text" : "sortie du milieu (index 1) -> udpsend",
					"numinlets" : 1,
					"numoutlets" : 0,
					"patching_rect" : [ 150.0, 254.0, 240.0, 20.0 ],
					"fontsize" : 12.0
				}

			}
,
			{
				"box" : 				{
					"id" : "obj-8",
					"maxclass" : "newobj",
					"text" : "print osc_in",
					"numinlets" : 1,
					"numoutlets" : 0,
					"patching_rect" : [ 330.0, 250.0, 100.0, 22.0 ],
					"fontsize" : 12.0
				}

			}
,
			{
				"box" : 				{
					"id" : "obj-9",
					"maxclass" : "newobj",
					"text" : "udpsend 127.0.0.1 4003",
					"numinlets" : 1,
					"numoutlets" : 0,
					"patching_rect" : [ 40.0, 350.0, 160.0, 22.0 ],
					"fontsize" : 12.0
				}

			}

		],
		"lines" : [
			{
				"patchline" : 				{
					"source" : [ "obj-2", 0 ],
					"destination" : [ "obj-6", 0 ]
				}

			}
,
			{
				"patchline" : 				{
					"source" : [ "obj-3", 0 ],
					"destination" : [ "obj-6", 0 ]
				}

			}
,
			{
				"patchline" : 				{
					"source" : [ "obj-4", 0 ],
					"destination" : [ "obj-6", 0 ]
				}

			}
,
			{
				"patchline" : 				{
					"source" : [ "obj-4", 0 ],
					"destination" : [ "obj-8", 0 ]
				}

			}
,
			{
				"patchline" : 				{
					"source" : [ "obj-6", 1 ],
					"destination" : [ "obj-9", 0 ]
				}

			}

		],
		"dependency_cache" : [  ],
		"autosave" : 0
	}

}
