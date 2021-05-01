package;

import flixel.addons.transition.FlxTransitionSprite;
import flixel.graphics.FlxGraphic;
import flixel.addons.transition.TransitionData;
import flixel.FlxG;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.addons.transition.FlxTransitionableState;
import flixel.util.FlxTimer;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;

// This displays a warning that says this is a modification that shouldn't be treated like an official thing made by ninjamuffin lol.
class WarningState extends FlxState
{
    public var transIn:TransitionData;
    public var transOut:TransitionData;

    inline static var MIN_TIME = 1.0;

    override public function create()
    {
        super.create();

        // var blackVoid:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		// add(blackVoid);

        var warningMessage = new flixel.text.FlxText(0, 0, FlxG.width,
			"This is a modification, therefore it shouldn't be treated like an official update.\n\nThis is not official.\n\nPress Enter to start the game.");
		warningMessage.setFormat("VCR OSD Mono", 32, FlxColor.WHITE, CENTER);
		warningMessage.screenCenter();
		add(warningMessage);
    }

	override public function update(elapsed:Float)
    {
            if (FlxG.keys.anyPressed([ENTER, ESCAPE]))
            {
            var diamond:FlxGraphic = FlxGraphic.fromClass(GraphicTransTileDiamond);
			diamond.persist = true;
			diamond.destroyOnNoUse = false;

			FlxTransitionableState.defaultTransIn = new TransitionData(FADE, FlxColor.BLACK, 1, new FlxPoint(0, -1), {asset: diamond, width: 32, height: 32},
				new FlxRect(-200, -200, FlxG.width * 1.4, FlxG.height * 1.4));
			FlxTransitionableState.defaultTransOut = new TransitionData(FADE, FlxColor.BLACK, 0.7, new FlxPoint(0, 1),
			    {asset: diamond, width: 32, height: 32}, new FlxRect(-200, -200, FlxG.width * 1.4, FlxG.height * 1.4));
            
            transIn = FlxTransitionableState.defaultTransIn;
            transOut = FlxTransitionableState.defaultTransOut;

            FlxG.sound.play(Paths.sound('confirmMenu'), 1.0);

            new FlxTimer().start(2, function(tmr:FlxTimer)
                {
                    FlxG.switchState(new TitleState());
                });
                    
        }

        super.update(elapsed);
    }
}