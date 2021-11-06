package;

import flixel.FlxG;
import flixel.graphics.FlxGraphic;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.system.FlxAssets.FlxSoundAsset;
import openfl.display.BitmapData;
import openfl.utils.AssetType;
import openfl.utils.Assets as OpenFlAssets;
import sys.FileSystem;

using StringTools;

class Paths
{
	inline public static var SOUND_EXT = #if web "mp3" #else "ogg" #end;

	static var currentLevel:String;

	public static var imagesLoaded:Map<String, Bool> = new Map();

	static public function setCurrentLevel(name:String)
	{
		currentLevel = name.toLowerCase();
	}

	static function getPath(file:String, type:AssetType, library:Null<String>)
	{
		if (library != null)
			return getLibraryPath(file, library);

		if (currentLevel != null)
		{
			var levelPath = getLibraryPathForce(file, currentLevel);
			if (OpenFlAssets.exists(levelPath, type))
				return levelPath;

			levelPath = getLibraryPathForce(file, "shared");
			if (OpenFlAssets.exists(levelPath, type))
				return levelPath;
		}

		return getPreloadPath(file);
	}

	static public function getLibraryPath(file:String, library = "preload")
	{
		return if (library == "preload" || library == "default") getPreloadPath(file); else getLibraryPathForce(file, library);
	}

	inline static function getLibraryPathForce(file:String, library:String)
	{
		return '$library:assets/$library/$file';
	}

	inline static function getPreloadPath(file:String)
	{
		return 'assets/$file';
	}

	inline static public function file(file:String, type:AssetType = TEXT, ?library:String)
	{
		return getPath(file, type, library);
	}

	inline static public function txt(key:String, ?library:String, ?offset:Bool = false)
	{
		if (!offset)
			return getPath('data/$key.txt', TEXT, library);
		else
			return getPath('$key.txt', TEXT, library);
	}

	inline public static function offsets(path:String, ?library:String):Array<String>
	{
		var daList:Array<String> = [];

		// CRINGE ASS!
		daList = lime.utils.Assets.getText('shared:assets/shared/images/characters/$path.txt').trim().split('\n');
		trace("loading offset: " + daList);

		for (i in 0...daList.length)
		{
			daList[i] = daList[i].trim();
		}

		return daList;
	}

	inline static public function xml(key:String, ?library:String)
	{
		return getPath('data/$key.xml', TEXT, library);
	}

	inline static public function json(key:String, ?library:String)
	{
		return getPath('data/$key.json', TEXT, library);
	}

	static public function sound(key:String, ?library:String):FlxSoundAsset
	{
		return getPath('sounds/$key.$SOUND_EXT', SOUND, library);
	}

	inline static public function soundRandom(key:String, min:Int, max:Int, ?library:String)
	{
		return sound(key + FlxG.random.int(min, max), library);
	}

	inline static public function video(key:String, ?library:String)
	{
		trace('assets/videos/$key.mp4');
		return getPath('videos/$key.mp4', BINARY, library);
	}

	inline static public function music(key:String, ?library:String):FlxSoundAsset
	{
		return getPath('music/$key.$SOUND_EXT', MUSIC, library);
	}

	inline static public function voices(song:String)
	{
		var rawSound:flixel.system.FlxAssets.FlxSoundAsset = 'songs:assets/songs/${song.toLowerCase()}/Voices.$SOUND_EXT';
		return rawSound;
	}

	inline static public function inst(song:String)
	{
		var rawSound:flixel.system.FlxAssets.FlxSoundAsset = 'songs:assets/songs/${song.toLowerCase()}/Inst.$SOUND_EXT';
		return rawSound;
	}

	inline static public function image(key:String, ?library:String):Dynamic
	{
		var cacheImage:FlxGraphic = addGraphic(key);

		if (cacheImage != null)
			return cacheImage;

		return getPath('images/$key.png', IMAGE, library);
	}

	inline static public function font(key:String)
	{
		return 'assets/fonts/$key';
	}

	inline static public function getSparrowAtlas(key:String, ?library:String)
	{
		return FlxAtlasFrames.fromSparrow(image(key, library), file('images/$key.xml', library));
	}

	inline static public function getPackerAtlas(key:String, ?library:String)
	{
		return FlxAtlasFrames.fromSpriteSheetPacker(image(key, library), file('images/$key.txt', library));
	}

	inline static public function addGraphic(key:String):FlxGraphic
	{
		if (FileSystem.exists(file(key)))
		{
			if (!imagesLoaded.exists(key))
			{
				var bitmap:BitmapData = BitmapData.fromFile(file(key));

				var graphic:FlxGraphic = FlxGraphic.fromBitmapData(bitmap, false, key);
				graphic.persist = true;

				FlxG.bitmap.addGraphic(graphic);
				imagesLoaded.set(key, true);
			}

			return FlxG.bitmap.get(key);
		}

		return null;
	}

	public static function unloadAssets()
	{
		for (key in imagesLoaded.keys())
		{
			var graphic:FlxGraphic = FlxG.bitmap.get(key);

			if (graphic != null)
			{
				graphic.bitmap.dispose();
				graphic.destroy();
				FlxG.bitmap.removeByKey(key);
			}
		}

		imagesLoaded.clear();
	}
}
