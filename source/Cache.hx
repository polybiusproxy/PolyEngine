package;

import flixel.FlxG;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

class Cache extends MusicBeatState
{
	var loadingText:FlxText;
	var songs:Array<String> = [
		"Bopeebo", "Fresh", "Dadbattle", "Spookeez", "South", "Monster", "Pico", "Philly", "Blammed", "Satin-Panties", "High", "Milf", "Cocoa", "Eggnog",
		"Winter-Horrorland", "Senpai", "Roses", "Thorns"
	];

	override function create()
	{
		FlxG.sound.cache("contents/shared/music/gameOverEnd.ogg"); // for some reason paths doesn't work???

		loadingText = new FlxText(5, FlxG.height - 30, 0, "Preloading songs... This may take a bit...", 24);
		loadingText.setFormat("assets/fonts/vcr.ttf", 24, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(loadingText);

		new FlxTimer().start(1.1, function(tmr:FlxTimer)
		{
			preloadSongs();
		});

		super.create();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
	}

	function preloadSongs()
	{
		for (i in songs) // caching all songs so loading is faster
		{
			FlxG.sound.cache(Paths.inst(i));
			FlxG.sound.cache(Paths.voices(i)); // no voices for tutorial?????????
		}

		loadingText.text = "Done!";
		FlxG.sound.play("contents/shared/music/gameOverEnd.ogg"); // for some reason paths doesn't work???

		new FlxTimer().start(8.1, function(tmr:FlxTimer)
		{
			FlxG.switchState(new WarningState());
		});
	}
}
