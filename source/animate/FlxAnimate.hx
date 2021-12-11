package animate;

import flixel.FlxG;
import flixel.graphics.FlxGraphic;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.graphics.frames.FlxFrame.FlxFrameAngle;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.system.FlxAssets.FlxGraphicAsset;
import haxe.Json;
import openfl.Assets;
import openfl.geom.Rectangle;

class FlxAnimate
{
	public static function fromAnimate(Source:FlxGraphicAsset, Description:String):FlxAtlasFrames
	{
		var graphic:FlxGraphic = FlxG.bitmap.add(Source);

		if (graphic == null)
			return null;

		var frames:FlxAtlasFrames = FlxAtlasFrames.findFrame(graphic);
		if (frames != null)
			return frames;

		if (graphic == null || Description == null)
			return null;

		frames = new FlxAtlasFrames(graphic);

		if (Assets.exists(Description))
			Description = Assets.getText(Description);

		var data:AnimateAtlas = Json.parse(Description);

		for (sprites in data.ATLAS.SPRITES)
		{
			var name = sprites.SPRITE.name;
			var rotated = sprites.SPRITE.rotated;

			var rect:FlxRect = FlxRect.get(sprites.SPRITE.x, sprites.SPRITE.y, sprites.SPRITE.w, sprites.SPRITE.h);
			var size:Rectangle = new Rectangle(0, 0, rect.width, rect.height);

			var angle = rotated ? FlxFrameAngle.ANGLE_NEG_90 : FlxFrameAngle.ANGLE_0;

			var offset = FlxPoint.get(-size.left, -size.top);
			var sourceSize = FlxPoint.get(size.width, size.height);

			frames.addAtlasFrame(rect, sourceSize, offset, name, angle);
		}

		return frames;
	}
}

typedef AnimateAtlas =
{
	var ATLAS:AnimateSprites;
};

typedef AnimateSprites =
{
	var SPRITES:Array<AnimateSprite>;
};

typedef AnimateSprite =
{
	var SPRITE:AnimateSpriteData;
};

typedef AnimateSpriteData =
{
	var name:String;
	var x:Float;
	var y:Float;
	var w:Float;
	var h:Float;
	var rotated:Bool;
};
