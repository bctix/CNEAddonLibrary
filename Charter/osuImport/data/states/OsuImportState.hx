import flixel.FlxSprite;
import funkin.editors.charter.Charter;
import funkin.backend.system.Conductor;
import flixel.math.FlxMath;
import funkin.editors.charter.Charter.CharterChange;
import funkin.editors.charter.CharterNote;
import funkin.editors.charter.CharterEvent;
import funkin.editors.ui.UIContextMenu;
import funkin.editors.ui.UISubstateWindow;
import funkin.editors.ui.UIText;
import funkin.editors.ui.UINumericStepper;
import funkin.editors.ui.UIFileExplorer;
import funkin.editors.ui.UIDropDown;
import funkin.editors.ui.UIButton;
import funkin.editors.ui.UICheckbox;
import funkin.editors.ui.UIWindow;
import funkin.editors.ui.UISlider;

import Type;

var columnCount = 4;

var strumlineDropDown = null;
var osuExplorer = null;
var saveButton = null;
var notes = [];

function osuBeatmapToCodename(string)
{
	var osuSection = "";
	var lines = string.split("\n");

	notes = [];
	for(i in lines)
	{
		var line = StringTools.trim(i);
		if(line == "[HitObjects]") osuSection = "hitObjects";
		if(osuSection == "hitObjects")
		{
			if(line == "") continue;
			var hitObjectInfo = line.split(",");

			var time = Math.round(Conductor.getStepForTime(Std.parseInt(hitObjectInfo[2])));
			var sustainLength = hitObjectInfo[5] != 0 ? hitObjectInfo[5] - time : 0;
			var id = hitObjectInfo[0] * columnCount / 512;

			var note = new CharterNote();
			note.updatePos(time, id, sustainLength, "", Charter.instance.strumLines.members[strumlineDropDown.index]);
			notes.push(note);
		}
	}
}

function postCreate() {

	function addLabelOn(ui:UISprite, text:String)
		add(new UIText(ui.x, ui.y - 24, 0, text));

	osuExplorer = new UIFileExplorer(windowSpr.x + 35, windowSpr.y + 80, null, null, "osu", function (res) {
		osuBeatmapToCodename(res.toString());
	});
	add(osuExplorer);
	add(addLabelOn(osuExplorer, "osu! beatmap file (.osu)"));

	strumlineDropDown = new UIDropDown(osuExplorer.x, osuExplorer.y + osuExplorer.height + 80, 320, 32, [for(k=>s in Charter.instance.strumLines.members) 'Strumline #'+(k+1)+ ' ('+s.strumLine.characters[0]+')'], 0);
	add(strumlineDropDown);
	addLabelOn(strumlineDropDown, "Target Strumline");

	saveButton = new UIButton(windowSpr.x + windowSpr.bWidth - 20 - 125, windowSpr.y + windowSpr.bHeight - 16 - 32, "Confirm", function() {
		
		load();
		close();
	}, 125);
	add(saveButton);

	var closeButton = new UIButton(saveButton.x - 20, saveButton.y, "Close", function() {
		close();
	}, 125);
	add(closeButton);
	closeButton.color = 0xFFFF0000;
	closeButton.x -= closeButton.bWidth;
}

function load() {
	for(note in notes)
	{
		trace("new note at id "+note.id+", at step "+note.step);
		Charter.instance.notesGroup.add(note);
	}	
}