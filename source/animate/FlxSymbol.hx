package animate;

import flixel.FlxSprite;

class FlxSymbol extends FlxSprite
{
	var symbolMap = new Map<String, String>();
	var symbolAtlasShit = new Map<String, String>();
	var coolParse = new Map<String, String>();
	var nestedShit = new Map<Int, Int>();

	var daFrame:Int = 0;
	var nestDepth:Int = 0;

	var hasFrameByPass = false;
	var matrixExposed = false;

	var drawQueue = [];

	/*
		? = &&
		, = new if / else
		: = else (maybe)
		!0 = true
		!1 = false
		&& = {}
	 */
	public function new(x:Float, y:Float, c)
	{
		super(x, y);

		if (coolParse.exists("SD"))
			symbolAtlasShit = parseSymbolDictionary(coolParse);
	}

	override function draw()
	{
		super.draw();
	}

	function changeFrame(frame:Int)
	{
		if (frame == null)
			frame = 0;

		daFrame += frame;
	}

	function parseSymbolDictionary(a, ?b, ?c):Map<String, String>
	{
		/*
			drawQueue = [];
			c = 0;

			for (i in a.length) */

		var b = new Map<String, String>();
		return b;
	}
}
