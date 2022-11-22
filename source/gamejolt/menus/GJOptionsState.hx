package gamejolt.menus;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxSubState;
import flixel.addons.ui.FlxInputText;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import gamejolt.GJClient;
import gamejolt.extras.ActionButton;
import gamejolt.menus.*;

class GJOptionsState extends MusicBeatState
{
    var bg:FlxSprite;
    var title:Alphabet;

    var daWidth:Int;
    var daHeight:Int;

    var missInfo:FlxText;

    override function create()
    {
        super.create();

        FlxG.mouse.visible = true;

        bg = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
        bg.color = FlxColor.LIME;
        bg.scrollFactor.set();
        bg.antialiasing = FlxG.save.data.antialiasing;
        add(bg);

        title = new Alphabet(0, 60, "GameJolt", true);
        title.screenCenter(X);
        title.scrollFactor.set();
        add(title);

        if (!GJClient.hasGameInfo())
        {
            missInfo = new FlxText(0, 0, 0, "No Game Data Available!");
            missInfo.setFormat(Paths.font('pixel.otf'), 45, FlxColor.WHITE, CENTER, OUTLINE, FlxColor.BLACK);
            missInfo.screenCenter();
            missInfo.scrollFactor.set();
            add(missInfo);

            FlxTween.tween(missInfo, {alpha: 0.25}, 0.5, {type: PINGPONG});
        }
        else if (GJClient.hasLoginInfo() && !GJClient.logged)
        {
            missInfo = new FlxText(0, 0, 0, "Something went wrong...");
            missInfo.setFormat(Paths.font('pixel.otf'), 45, FlxColor.WHITE, CENTER, OUTLINE, FlxColor.BLACK);
            missInfo.screenCenter();
            missInfo.scrollFactor.set();
            add(missInfo);

            FlxTween.tween(missInfo, {alpha: 0.25}, 0.5, {type: PINGPONG});
        }
        else if (!GJClient.hasLoginInfo())
        {
            var userTitle:Alphabet;
            var tokenTitle:Alphabet;
            var userBox:FlxInputText;
            var tokenBox:FlxInputText;
            var logButton:ActionButton;

            var boxSize:Int = Std.int(FlxG.width * 0.5);

            userTitle = new Alphabet(75, FlxG.height * 0.3, "Username:", false);
            userTitle.scrollFactor.set();
            add(userTitle);

            tokenTitle = new Alphabet(75, FlxG.height * 0.5, "Game Token:", false);
            tokenTitle.scrollFactor.set();
            add(tokenTitle);

            userBox = new FlxInputText(0, userTitle.y + 60, boxSize, '', 44);
            userBox.setFormat(Paths.font('pixel.otf'), 40, FlxColor.BLACK, CENTER);
            userBox.x = FlxG.width - userBox.width - 60;
            userBox.antialiasing = FlxG.save.data.antialiasing;
            userBox.scrollFactor.set();
            add(userBox);

            tokenBox = new FlxInputText(0, tokenTitle.y + 60, boxSize, '', 44);
            tokenBox.setFormat(Paths.font('pixel.otf'), 40, FlxColor.BLACK, CENTER);
            tokenBox.x = FlxG.width - tokenBox.width - 60;
            tokenBox.antialiasing = FlxG.save.data.antialiasing;
            tokenBox.maxLength = 7;
            tokenBox.passwordMode = true;
            tokenBox.scrollFactor.set();
            add(tokenBox);

            daWidth = Std.int(FlxG.width * 0.3);
            daHeight = Std.int(FlxG.height * 0.2);

            logButton = new ActionButton
            (
                0, FlxG.height * 0.75, daWidth, daHeight, 'Log In!',
                function ()
                {
                    GJClient.setUserInfo(userBox.text, tokenBox.text);
                    FlxG.mouse.visible = false;
                },
                new MainMenuState()
            );
            logButton.scrollFactor.set();
            logButton.screenCenter(X);
            add(logButton);
        }
        else
        {
            var optArr:Array<ActionButton> = [];
            var optList:Array<String> = ['Log Out', 'Trophies', 'About Me', 'Friends'];

            daWidth = Std.int(FlxG.width * 0.3);
            daHeight = Std.int(FlxG.height * 0.15);

            var subStateList:Array<FlxSubState> =
            [
                new LogoutSubState(),
                new TrophiesSubState(),
                new UserInfoSubState(),
                new FriendsSubState()
            ];

            for (i in 0...optList.length)
            {
                var daButton = new ActionButton
                (
                    FlxG.width * (((i % 2) + 1)/3),
                    (FlxG.height * 0.45) + ((daHeight + 25) * Math.floor(i / 2)),
                    daWidth, daHeight, optList[i],
                    function () {openSubState(subStateList[i]);}
                );
                daButton.scrollFactor.set();
                daButton.x -= daButton.width / 2;
                // daButton.screenCenter(X);
                optArr.push(daButton);
                add(optArr[i]);
            }
        }
    }

    override function update(elapsed:Float)
    {
        super.update(elapsed);

        if (controls.BACK) {FlxG.mouse.visible = false; MusicBeatState.switchState(new MainMenuState());}
    }
}