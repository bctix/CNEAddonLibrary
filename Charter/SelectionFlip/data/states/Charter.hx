// created by bctix c: 
// made in like ~20 minutes

import funkin.editors.charter.Charter;
import funkin.editors.charter.Charter.CharterChange;
import funkin.editors.charter.CharterNote;

function postCreate()
{
	topMenu[1].childs.insert(topMenu[1].childs.length,null);

	topMenu[1].childs.insert(topMenu[1].childs.length,{
		label: "Flip selection",
		// ctrl + f
		keybind: [17, 70],
		onSelect: function() {
			if(Charter.instance.selection.length == 0) return;

			var undoDrags = [];
			var selectionCopy = Charter.instance.selection.copy();

			// emulate dragging so it can be undo'd with one ctrl-z
			// (first version of this deleted and added notes requiring 2 undos to undo the flip)
			for (s in selectionCopy)
			{
				var boundedChange = FlxPoint.get(0, Math.abs(3-s.id)-s.id);
				s.handleDrag(boundedChange);

				undoDrags.push({selectable:s, change: boundedChange});
			}

			Charter.instance.undos.addToUndo(CharterChange.CSelectionDrag(undoDrags));
		}
	});
}