package gamejolt.menus;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import gamejolt.GJClient;
import gamejolt.formats.User;

class UserInfoSubState extends MusicBeatSubstate
{
    var bg:FlxSprite;
    var extraBG:FlxSprite;
    var userPhoto:FlxSprite;
    var missInfo:FlxText;
    var curUser:Null<User>;

    public static var daUserID:Null<Int> = null;

    public function new()
    {
        super();
        openCallback = createMenu;
        closeCallback = function () {daUserID = null;};
    }

    function createMenu()
    {
        curUser = GJClient.getUserData(daUserID);

        bg = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
        bg.antialiasing = FlxG.save.data.antialiasing;
        bg.scrollFactor.set();
        bg.color = FlxColor.GRAY;
        bg.alpha = 0;
        add(bg);

        extraBG = new FlxSprite().makeGraphic(Std.int(FlxG.width * 0.85), Std.int(FlxG.height * 0.85), FlxColor.BLACK);
        extraBG.antialiasing = FlxG.save.data.antialiasing;
        extraBG.scrollFactor.set();
        extraBG.screenCenter();
        extraBG.alpha = 0;
        add(extraBG);

        if (curUser == null)
        {
            missInfo = new FlxText(0, 0, 0, "Failed to fetch User Info!\nPlease try again later");
            missInfo.setFormat(Paths.font('pixel.otf'), 35, FlxColor.WHITE, CENTER, OUTLINE, FlxColor.BLACK);
            missInfo.screenCenter();
            missInfo.scrollFactor.set();
            missInfo.visible = false;
            add(missInfo);

            FlxTween.tween(missInfo, {alpha: 0.25}, 0.5, {type: PINGPONG});
        }
        else
        {
            var sep:Int = 15;
            var sep2:Int = 20;
            var daSize:Int = 25;
            var daFont:String = Paths.font('pixel.otf');
            var daFont2:String = "VCR OSD Mono";
            var imgRatio:Int = Std.int(extraBG.width * 0.25);

            userPhoto = new FlxSprite().loadGraphic(Paths.image('unknownMod'));
            userPhoto.setGraphicSize(imgRatio, imgRatio);
            userPhoto.updateHitbox();
            userPhoto.antialiasing = FlxG.save.data.antialiasing;
            userPhoto.scrollFactor.set();
            userPhoto.alpha = 0;
            userPhoto.y = extraBG.y + sep2;
            userPhoto.x = extraBG.x + extraBG.width - userPhoto.width - (sep2 * 3);

            var trophAchieved = GJClient.getTrophiesList(active);
            var trophTotal = GJClient.getTrophiesList();
            var trophGained = trophTotal != null ? '${trophAchieved == null ? 0 : trophAchieved.length}/${trophTotal.length}' : 'N/A';

            var userName = new FlxText(extraBG.x + sep2, extraBG.y + sep2, 0, 'Username: ${curUser.developer_name}');
            userName.setFormat(daFont, daSize, FlxColor.WHITE, LEFT, OUTLINE, FlxColor.BLACK);
            var userTag = new FlxText(userName.x, userName.y + userName.height + sep, 0, 'Tag: @${curUser.username}');
            userTag.setFormat(daFont, daSize, FlxColor.WHITE, LEFT, OUTLINE, FlxColor.BLACK);
            var userType = new FlxText(userTag.x, userTag.y + userTag.height + sep, 0, 'Type of User: ${curUser.type}');
            userType.setFormat(daFont, daSize, FlxColor.WHITE, LEFT, OUTLINE, FlxColor.BLACK);
            var userID = new FlxText(userType.x, userType.y + userType.height + sep, 0, 'User ID: ${curUser.id}');
            userID.setFormat(daFont, daSize, FlxColor.WHITE, LEFT, OUTLINE, FlxColor.BLACK);
            var userWeb = new FlxText(userID.x, userID.y + userID.height + sep, 0, 'Website: ${curUser.developer_website != '' ? curUser.developer_website : "(Not Available)"}');
            userWeb.setFormat(daFont, daSize, FlxColor.WHITE, LEFT, OUTLINE, FlxColor.BLACK);
            var userDesc = new FlxText(userWeb.x, userWeb.y + (userWeb.height * 3) + sep, extraBG.width - sep2, 'Description: ${curUser.developer_description}');
            userDesc.setFormat(daFont2, Std.int(daSize * 1.5), FlxColor.WHITE, LEFT, OUTLINE, FlxColor.BLACK);

            add(userName);
            add(userTag);
            add(userType);
            add(userID);
            add(userWeb);

            if (daUserID == null)
            {
                var userTrophs = new FlxText(userWeb.x, userWeb.y + userWeb.height + sep, 0, 'Trophies gained: $trophGained');
                userTrophs.setFormat(daFont, daSize, FlxColor.WHITE, LEFT, OUTLINE, FlxColor.BLACK);
                add(userTrophs);
            }
            
            add(userDesc);
            add(userPhoto);

            forEachOfType(FlxText, function (txt:FlxText)
            {
                txt.antialiasing = FlxG.save.data.antialiasing;
                txt.scrollFactor.set();
                txt.visible = false;
            });

            FlxTween.tween(userPhoto, {alpha: 1}, 0.7);
        }

        FlxTween.tween(bg, {alpha: 1}, 0.7, {onComplete: function (twn:FlxTween)
        {
            if (curUser == null) missInfo.visible = true;
            else forEachOfType(FlxText, function (txt:FlxText) {txt.visible = true;});
        }});

        FlxTween.tween(extraBG, {alpha: 0.7}, 0.7);
    }

    override function update(elapsed:Float)
    {
        super.update(elapsed);

        if (controls.BACK)
        {
            FlxTween.tween(bg, {alpha: 0}, 0.7, {onComplete: function (twn:FlxTween) {close();}});
            FlxTween.tween(extraBG, {alpha: 0}, 0.7);
            if (curUser != null)
            {
                FlxTween.tween(userPhoto, {alpha: 0}, 0.7);
                forEachOfType(FlxText, function (txt:FlxText) {FlxTween.tween(txt, {alpha: 0}, 0.7);});
            }
            else
            {
                FlxTween.cancelTweensOf(missInfo);
                FlxTween.tween(missInfo, {alpha: 0}, 0.7);
            }
        }
    }
}