package gamejolt.menus;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.effects.FlxFlicker;
import flixel.util.FlxColor;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import gamejolt.GJClient;

class LogoutSubState extends MusicBeatSubstate
{
    var bg:FlxSprite;
    var info:FlxText;

    public function new()
    {
        super();
        openCallback = createMenu;
    }

    function createMenu()
    {
        bg = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
        bg.antialiasing = FlxG.save.data.antialiasing;
        bg.scrollFactor.set();
        bg.color = FlxColor.GRAY;
        bg.alpha = 0;
        add(bg);

        var lines:Array<String> =
        [
            "You're about to log out of",
            "your GameJolt session here\n",
            "Your personal info (username and game token)",
            "will be removed from this game\n",
            "[Press ENTER to Confirm]",
            "[Press ESCAPE to Cancel]"
        ];

        var curText:String = '';
        for (i in lines) curText += '$i\n';

        info = new FlxText(0, 0, 0, curText);
        info.setFormat(Paths.font('pixel.otf'), 30, FlxColor.WHITE, CENTER, OUTLINE, FlxColor.BLACK);
        info.screenCenter();
        info.antialiasing = FlxG.save.data.antialiasing;
        info.visible = false;
        info.scrollFactor.set();
        add(info);

        FlxTween.tween(bg, {alpha: 1}, 0.7, {onComplete: function (twn:FlxTween) {info.visible = true;}});
    }

    override function update(elapsed:Float)
    {
        super.update(elapsed);

        if (FlxG.keys.justPressed.ENTER)
        {
            GJClient.setUserInfo(null, null);
            FlxG.sound.play(Paths.sound('confirmMenu'));
            FlxFlicker.flicker
            (
                info, 0.7, 0.05, false, false,
                function (flk:FlxFlicker)
                {
                    FlxTween.tween(bg, {alpha: 0}, 0.3);
                    FlxTween.tween(info, {alpha: 0}, 0.3, {onComplete: function (twn:FlxTween)
                    {
                        MusicBeatState.switchState(new MainMenuState());
                    }});
                }
            );
        }

        if (FlxG.keys.justPressed.ESCAPE)
        {
            FlxG.sound.play(Paths.sound('cancelMenu'));
            FlxTween.tween(bg, {alpha: 0}, 0.7);
            FlxTween.tween(info, {alpha: 0}, 0.7, {onComplete: function (twn:FlxTween) {close();}});
        }
    }
}