package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.util.FlxAxes;
import lime.utils.Assets;

using StringTools;

enum SlideCalcMethod
{
	SIN;
	COS;
}

class CoolUtil
{
	public static var difficultyArray:Array<String> = ['EASY', "NORMAL", "HARD"];

	public static function difficultyString():String
	{
		return difficultyArray[PlayState.storyDifficulty];
	}

	public static function getScore():Int
	{
		return PlayState.songScore;
	}

	public static function blueBalls():Int
	{
		return PlayState.deaths;
	}

	public static function coolTextFile(path:String):Array<String>
	{
		var daList:Array<String> = Assets.getText(path).trim().split('\n');

		for (i in 0...daList.length)
		{
			daList[i] = daList[i].trim();
		}

		return daList;
	}

	public static function numberArray(max:Int, ?min = 0):Array<Int>
	{
		var dumbArray:Array<Int> = [];
		for (i in min...max)
		{
			dumbArray.push(i);
		}
		return dumbArray;
	}

	// These functions below can be very useful for many things (GamerPablito)

	public static function slideEffect(amplitude:Float, calcMethod:SlideCalcMethod, slowness:Float = 1, delayIndex:Float = 0, ?offset:Float):Float
	{
		if (slowness > 0)
		{
			var slider:Float = (FlxG.sound.music.time / 1000) * (Conductor.bpm / 60);

			/*
			while (delayIndex >= 2)
			{
				delayIndex -= 2;
			}
			*/

			var slideValue:Float;

			switch (calcMethod)
			{
				case SIN:
					slideValue = offset + amplitude * Math.sin(((slider + delayIndex) / slowness) * Math.PI);
				case COS:
					slideValue = offset + amplitude * Math.cos(((slider + delayIndex) / slowness) * Math.PI);
				default:
					throw 'The current calc method for the slide effect function is not valid!';
			}

			return slideValue;
		}
		else throw 'Slide Effect slowness value cannot be less than 0!';
	}

	public static function objectCenter(object:FlxObject, target:FlxObject, axis:FlxAxes = XY)
	{
		if (axis == XY || axis == X)
			object.x = target.x + target.width / 2 - object.width / 2;
		if (axis == XY || axis == Y)
			object.y = target.y + target.height / 2 - object.height / 2;
	}
}
