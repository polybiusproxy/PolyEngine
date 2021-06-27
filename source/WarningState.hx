package;

import flixel.FlxG;
import flixel.addons.transition.FlxTransitionSprite.GraphicTransTileDiamond;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.transition.TransitionData;
import flixel.addons.transition.TransitionFade;
import flixel.graphics.FlxGraphic;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

using StringTools;

// This displays a warning that says this is a modification that shouldn't be treated like an official thing made by ninjamuffin lol.
class WarningState extends MusicBeatState
{
	override function create()
	{
		var warningMessage = new FlxText(0, 0, FlxG.width,
			"This is a modification, therefore it shouldn't be treated like an official update.\n\nThis is not official.\n\nPress Enter to start the game.");
		warningMessage.setFormat("VCR OSD Mono", 32, FlxColor.WHITE, CENTER);
		warningMessage.screenCenter();
		add(warningMessage);

		super.create();
	}

	override public function update(elapsed:Float)
	{
		if (FlxG.keys.justPressed.ENTER)
		{
			FlxG.camera.flash(FlxColor.WHITE, 1);

			FlxG.camera.fade(FlxColor.BLACK, 0.33, true);
			FlxG.sound.play(Paths.sound('confirmMenu'), 1.0);

			new FlxTimer().start(1, function(tmr:FlxTimer)
			{
				var diamond:FlxGraphic = FlxGraphic.fromClass(GraphicTransTileDiamond);
				diamond.persist = true;
				diamond.destroyOnNoUse = false;

				FlxTransitionableState.defaultTransIn = new TransitionData(FADE, FlxColor.BLACK, 1, new FlxPoint(0, -1),
					{asset: diamond, width: 32, height: 32}, new FlxRect(-200, -200, FlxG.width * 1.4, FlxG.height * 1.4));
				FlxTransitionableState.defaultTransOut = new TransitionData(FADE, FlxColor.BLACK, 0.7, new FlxPoint(0, 1),
					{asset: diamond, width: 32, height: 32}, new FlxRect(-200, -200, FlxG.width * 1.4, FlxG.height * 1.4));

				transIn = FlxTransitionableState.defaultTransIn;
				transOut = FlxTransitionableState.defaultTransOut;

				FlxG.switchState(new TitleState());
			});
		}

		super.update(elapsed);
	}
}
