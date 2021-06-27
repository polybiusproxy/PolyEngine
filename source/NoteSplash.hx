package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;

// I GOT THIS FROM WEEK 7 UPDATE COMPILED CODE LMFAO
// FINALLY THE JAVASCRIPT COURSE I TOOK IS USEFUL FOR ME
class NoteSplash extends FlxSprite
{
	public function new(x:Float, y:Float, ?c:Int)
	{
		if (c == null)
			c = 0;

		super(x, y);

		frames = Paths.getSparrowAtlas('noteSplashes');

		animation.addByPrefix("note1-0", "note impact 1  blue", 24, false);
		animation.addByPrefix("note2-0", "note impact 1 green", 24, false);
		animation.addByPrefix("note0-0", "note impact 1 purple", 24, false);
		animation.addByPrefix("note3-0", "note impact 1 red", 24, false);

		animation.addByPrefix("note1-1", "note impact 2 blue", 24, false);
		animation.addByPrefix("note2-1", "note impact 2 green", 24, false);
		animation.addByPrefix("note0-1", "note impact 2 purple", 24, false);
		animation.addByPrefix("note3-1", "note impact 2 red", 24, false);

		setupNoteSplash(x, x, c);
	}

	public function setupNoteSplash(x:Float, y:Float, ?c:Int)
	{
		if (c == null)
			c = 0;

		setPosition(x, y);
		alpha = 0.6;

		animation.play("note" + c + "-" + FlxG.random.int(0, 1), true);
		animation.curAnim.frameRate += FlxG.random.int(-2, 2);

		updateHitbox();

		offset.set(0.3 * width, 0.3 * height);
	}

	override public function update(elapsed)
	{
		if (animation.curAnim.finished)
		{
			kill();
		}

		super.update(elapsed);
	}
}
