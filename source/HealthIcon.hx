package;

import flixel.FlxSprite;

class HealthIcon extends FlxSprite
{
	/**
	 * Used for FreeplayState! If you use it elsewhere, prob gonna annoying
	 */
	public var sprTracker:FlxSprite;

	public var isOldIcon:Bool = false;
	public var isPlayer:Bool = false;

	public function new(char:String = 'bf', isPlayer:Bool = false)
	{
		super();

		// loadGraphic(Paths.image('iconGrid'), true, 150, 150);
		loadGraphic(Paths.image('icons/icon-' + char, 'preload'), true, 150, 150);

		animation.add(char, [0, 1], 0, false, isPlayer);
                if (char != null)
			animation.play(char);
		else
			animation.play('face');

		switch (char)
		{
			case 'bf-pixel' | 'senpai' | 'senpai-angry' | 'spirit' | 'gf-pixel':
				antialiasing = false;
			default:
				antialiasing = true; // grrrrr this is what makes the rest not look blocky, mannnnn
		}

		scrollFactor.set();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (sprTracker != null)
			setPosition(sprTracker.x + sprTracker.width + 10, sprTracker.y - 30);
	}
}
