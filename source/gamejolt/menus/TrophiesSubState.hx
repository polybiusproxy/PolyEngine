package gamejolt.menus;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import gamejolt.GJClient;
import gamejolt.extras.TrophieBox;
import gamejolt.formats.Trophie;

class TrophiesSubState extends MusicBeatSubstate
{
    var bg:FlxSprite;
    var title:Alphabet;
    var leftArrow:Alphabet;
	var rightArrow:Alphabet;
    var missInfo:FlxText;
    var camPos:FlxObject;
    var curScreen:Int;
    var screenPos:Int;
    var yPos:Int;
    var trophList:Null<Array<Trophie>>;
    var trophGroup:Array<TrophieBox>;

    public function new()
    {
        super();
        openCallback = createMenu;
    }

    function createMenu()
    {
        trophList = GJClient.getTrophiesList();

        bg = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
        bg.antialiasing = FlxG.save.data.antialiasing;
        bg.scrollFactor.set();
        bg.color = FlxColor.GRAY;
        bg.alpha = 0;
        add(bg);

        camPos = new FlxObject(0, 0, 1, 1);
		camPos.screenCenter();
		add(camPos);

        title = new Alphabet(0, 50, 'Trophies', true);
		title.screenCenter(X);
        title.antialiasing = FlxG.save.data.antialiasing;
		title.scrollFactor.set();
        title.alpha = 0;
		add(title);

        leftArrow = new Alphabet(0, 25, '<', true);
		leftArrow.x = title.x - leftArrow.width - 20;
        leftArrow.antialiasing = FlxG.save.data.antialiasing;
		leftArrow.scrollFactor.set();
        leftArrow.alpha = 0;
		add(leftArrow);

		rightArrow = new Alphabet(0, 25, '>', true);
		rightArrow.x = title.x + title.width + 20;
        rightArrow.antialiasing = FlxG.save.data.antialiasing;
		rightArrow.scrollFactor.set();
        rightArrow.alpha = 0;
		add(rightArrow);

        curScreen = 0;
        screenPos = -1;
        yPos = -1;
        trophGroup = [];
        
        if (trophList != null)
        {
            for (i in 0...trophList.length)
            {
                var curTroph:Trophie = cast trophList[i];

                if (i % 6 == 0) screenPos++;
                if (i % 2 == 0) {yPos++; yPos = yPos % 3;}

                var leDate:String = (curTroph.achieved != false ? 'Achieved ${Std.string(curTroph.achieved)}' : "Not achieved yet");

                var trophCard = new TrophieBox
                (
                    30 + FlxG.width * (0.5 * (i % 2)) + FlxG.width * screenPos,
                    0, curTroph.title, curTroph.description, leDate
                );
                trophCard.y = (FlxG.height * 0.2) + ((trophCard.height + 25) * yPos);
                trophCard.alpha = 0;
                trophGroup.push(trophCard);
                add(trophGroup[i]);
            }
        }
        else
        {
            missInfo = new FlxText(0, 0, 0, "Sorry, the game doesn't have\nany trophie registered yet\n\nPlease go add some and retry later!");
            missInfo.setFormat(Paths.font('pixel.otf'), 35, FlxColor.WHITE, CENTER, OUTLINE, FlxColor.BLACK);
            missInfo.screenCenter();
            missInfo.antialiasing = FlxG.save.data.antialiasing;
            missInfo.scrollFactor.set();
            missInfo.visible = false;
            add(missInfo);

            FlxTween.tween(missInfo, {alpha: 0.25}, 0.5, {type: PINGPONG});
        }

        FlxTween.tween(bg, {alpha: 1}, 0.7, {onComplete: function (twn:FlxTween) {if (trophList == null) missInfo.visible = true;}});
        FlxTween.tween(title, {alpha: 1}, 0.7);
        FlxTween.tween(leftArrow, {alpha: 1}, 0.7);
        FlxTween.tween(rightArrow, {alpha: 1}, 0.7);
        for (j in trophGroup) FlxTween.tween(j, {alpha: 1}, 0.7);

        FlxG.camera.follow(camPos, null, 1);
    }

    function camTween()
    {
        FlxG.sound.play(Paths.sound('scrollMenu'));
        FlxTween.cancelTweensOf(camPos);
        FlxTween.tween(camPos, {x: FlxG.width / 2 + FlxG.width * curScreen}, 0.6, {ease: FlxEase.smootherStepOut});
    }

    override function update(elapsed:Float)
    {
        super.update(elapsed);

        camPos.y = CoolUtil.slideEffect(6, COS, 2, 0.25, FlxG.height / 2);

        var isMinCount:Bool = curScreen <= 0;
		var isMaxCount:Bool = curScreen >= screenPos;

		leftArrow.visible = !isMinCount;
		rightArrow.visible = !isMaxCount;

        if (screenPos > 0)
        {
            if (FlxG.keys.justPressed.LEFT && !isMinCount) {curScreen--; camTween();}
            if (FlxG.keys.justPressed.RIGHT && !isMaxCount) {curScreen++; camTween();}
        }

        if (controls.BACK)
        {
            FlxG.sound.play(Paths.sound('cancelMenu'));

            FlxTween.tween(bg, {alpha: 0}, 0.7, {onComplete: function (twn:FlxTween) {close();}});
            FlxTween.tween(title, {alpha: 0}, 0.7);
            FlxTween.tween(leftArrow, {alpha: 0}, 0.7);
            FlxTween.tween(rightArrow, {alpha: 0}, 0.7);
            if (trophList == null)
            {
                FlxTween.cancelTweensOf(missInfo);
                FlxTween.tween(missInfo, {alpha: 0}, 0.7);
            }
            for (j in trophGroup) FlxTween.tween(j, {alpha: 0}, 0.7);
        }
    }
}