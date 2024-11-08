import funkin.editors.ui.UIContextMenu.UIContextMenuOptionSpr;
import funkin.editors.ui.UISubstateWindow;
import funkin.editors.ui.UIText;
import funkin.editors.ui.UINumericStepper;
import funkin.editors.ui.UIButton;
import flixel.input.keyboard.FlxKey;
import funkin.editors.charter.Charter;
import funkin.backend.system.Conductor;
import flixel.math.FlxMath;
import funkin.editors.charter.Charter.CharterChange;
import funkin.editors.charter.CharterNote;
import funkin.editors.charter.CharterEvent;
import funkin.editors.ui.UIContextMenu;

function postCreate()
{
	topMenu[0].childs.insert(topMenu[0].childs.length-2,{
		label: "Import osu!mania chart",
		onSelect: function() {
			var substate = new UISubstateWindow(true, 'OsuImportState');

			FlxG.sound.music.pause();
			Charter.instance.vocals.pause();

			substate.winTitle = 'osu! Import';
			substate.winWidth = 380; substate.winHeight = 280;

			FlxG.state.openSubState(substate);
		}
	});
}

