package;

import flixel.FlxSprite;

using StringTools;

class HealthIcon extends FlxSprite
{
	/**
	 * Used for FreeplayState! If you use it elsewhere, prob gonna annoying
	 */
	public var sprTracker:FlxSprite;

	public var isOldIcon:Bool = false;
	public var isPlayer:Bool = false;
	public var char:String = 'bf';

	public function new(char:String = 'bf', isPlayer:Bool = false)
	{
		super();

<<<<<<< Updated upstream
		// loadGraphic(Paths.image('iconGrid'), true, 150, 150);
		loadGraphic(Paths.image('icons/icon-' + char, 'preload'), true, 150, 150);

		animation.add(char, [0, 1], 0, false, isPlayer);
                if (char != null)
			animation.play(char);
		else
			animation.play('face');
=======
		this.char = char;
		this.isPlayer = isPlayer;

		isPlayer = isOldIcon = false;
>>>>>>> Stashed changes

		antialiasing = true;

		changeIcon(char);
		scrollFactor.set();
	}

	public function swapOldIcon()
	{
		(isOldIcon = !isOldIcon) ? changeIcon("bf-old") : changeIcon(char);
	}

	public function changeIcon(char:String)
	{
		if (char != 'bf-pixel' && char != 'bf-old')
			char = char.split("-")[0];

		loadGraphic(Paths.image('icons/icon-' + char), true, 150, 150);

		if (char.endsWith('-pixel') || char.startsWith('senpai') || char.startsWith('spirit'))
			antialiasing = false
		else
			antialiasing = true;

		animation.add(char, [0, 1], 0, false, isPlayer);
		animation.play(char);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (sprTracker != null)
			setPosition(sprTracker.x + sprTracker.width + 10, sprTracker.y - 30);
	}
}
