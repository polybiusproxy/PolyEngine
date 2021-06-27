package;

import flixel.system.FlxBasePreloader;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import openfl.Lib;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.Sprite;
import openfl.text.Font;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.text.TextFormatAlign;

@:bitmap("art/preloaderArt.png") class LogoImage extends BitmapData
{
}

@:font(Paths.font("vcr.ttf")) class CustomFont extends Font
{
}

class Preloader extends FlxBasePreloader
{
	public function new(MinDisplayTime:Float = 5, ?AllowedURLs:Array<String>)
	{
		super(MinDisplayTime, AllowedURLs);
	}

	var logo:Sprite;
	var text:TextField;

	override function create():Void
	{
		this._width = Lib.current.stage.stageWidth;
		this._height = Lib.current.stage.stageHeight;

		var ratio:Float = this._width / 800; // This allows us to scale assets depending on the size of the screen.

		logo = new Sprite();
		logo.addChild(new Bitmap(new LogoImage(0, 0))); // Sets the graphic of the sprite to a Bitmap object, which uses our embedded BitmapData class.
		logo.x = ((this._width) / 2) - ((logo.width) / 2);
		logo.y = (this._height / 2) - ((logo.height) / 2);
		addChild(logo); // Adds the graphic to the NMEPreloader's buffer.

		Font.registerFont(CustomFont);
		text = new TextField();
		text.defaultTextFormat = new TextFormat("VCR OCD Mono", 12, 0xffffff, false, false, false, "", "", TextFormatAlign.CENTER);
		text.embedFonts = true;
		text.selectable = false;
		text.multiline = false;

		text.text = "Preloading assets...";
		addChild(text);

		super.create();
	}

	override function update(Percent:Float):Void
	{
		text.x = Lib.current.stage.stageWidth - 10 - text.width;
		text.y = Lib.current.stage.stageHeight - 10 - text.height;
		switch (Percent)
		{
			case 50:
				text.text = "Halfway there...";
			case 70:
				text.text = "Almost there...";
			case 80:
				text.text = "Done!";
			case 90:
				FlxTween.tween(text, {alpha: 0, y: text.y - 50}, 0.5, {ease: FlxEase.cubeInOut});
				FlxTween.tween(logo, {alpha: 0, y: text.y - 50}, 0.5, {ease: FlxEase.cubeInOut});
		}
		super.update(Percent);
	}
}
