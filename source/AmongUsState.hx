package;

import MusicBeatState;
import flixel.FlxG;
import flixel.addons.transition.FlxTransitionSprite.GraphicTransTileDiamond;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.transition.TransitionData;
import flixel.addons.transition.TransitionFade;
import flixel.graphics.FlxGraphic;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

class AmongUsState extends MusicBeatState
{
	var imposterTxt:Alphabet;

	override function create()
	{
		imposterTxt = new Alphabet(0, 0, "imposter funky", true);
		imposterTxt.screenCenter();
		add(imposterTxt);

		FlxTween.tween(imposterTxt, {y: imposterTxt.y + 20}, 2.9, {ease: FlxEase.quadInOut, type: PINGPONG});
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.keys.justPressed.ENTER)
		{
			FlxG.camera.flash(FlxColor.WHITE, 1);

			FlxG.camera.fade(FlxColor.BLACK, 0.33, true);
			FlxG.sound.play(Paths.sound('confirmMenu'), 1.0);

			new FlxTimer().start(3, function(tmr:FlxTimer)
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
	}
}
