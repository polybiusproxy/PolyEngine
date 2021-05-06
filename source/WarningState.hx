package;

import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.transition.TransitionFade;
import flixel.FlxG;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

using StringTools;

// This displays a warning that says this is a modification that shouldn't be treated like an official thing made by ninjamuffin lol.
class WarningState extends MusicBeatState
{

    override function create()
    {
        transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

        // var blackVoid:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		// add(blackVoid);

        var warningMessage = new flixel.text.FlxText(0, 0, FlxG.width,
			"This is a modification, therefore it shouldn't be treated like an official update.\n\nThis is not official.\n\nPress Enter to start the game.");
		warningMessage.setFormat("VCR OSD Mono", 32, FlxColor.WHITE, CENTER);
		warningMessage.screenCenter();
		add(warningMessage);

        // var transState = new TransitionFade(TransType:TransitionType = FADE, Color:FlxColor = FlxColor.WHITE, Duration:Float = 1.0, ?Direction:FlxPoint, ?TileData:Null<TransitionTileData>, ?Region:FlxRect);

        super.create();
    }

	override public function update(elapsed:Float)
    {
        if (FlxG.keys.justPressed.ENTER)
        {
            FlxG.camera.flash(FlxColor.WHITE, 1);

            FlxG.camera.fade(FlxColor.BLACK, 0.33, true);
            FlxG.sound.play(Paths.sound('confirmMenu'), 1.0);

            new FlxTimer().start(3, function(tmr:FlxTimer)
                {
                    // FlxTransitionableState.defaultTransIn = new TransitionData(...);
                    // FlxTransitionableState.defaultTransOut = new TransitionData(...);

                    FlxG.switchState(new TitleState());
                });
                    
        }

        super.update(elapsed);
    }
}