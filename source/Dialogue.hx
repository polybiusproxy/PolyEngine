package;

import Alphabet;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxSpriteGroup;
import flixel.input.FlxKeyManager;

using StringTools;

// old dialogbox from 1.1.0 lol
class Dialogue extends FlxSpriteGroup
{
	var box:FlxSprite;

	var dialogue:Alphabet;
	var dialogueList:Array<String> = [];

	public var finishThing:Void->Void;

	public function new(talkingRight:Bool = true, ?dialogueList:Array<String>)
	{
		super();

		box = new FlxSprite(40);
		box.frames = Paths.getSparrowAtlas('speech_bubble_talking');
		box.animation.addByPrefix('normalOpen', 'Speech Bubble Normal Open', 24, false);
		box.animation.addByPrefix('normal', 'speech bubble normal', 24);
		box.animation.play('normalOpen');
		add(box);

		if (!talkingRight)
		{
			box.flipX = true;
		}

		dialogue = new Alphabet(0, 80, "", false, true);
		add(dialogue);

		this.dialogueList = dialogueList;
	}

	var dialogueOpened:Bool = false;
	var dialogueStarted:Bool = false;

	override function update(elapsed:Float)
	{
		if (box.animation.curAnim != null)
		{
			if (box.animation.curAnim.name == 'normalOpen' && box.animation.curAnim.finished)
			{
				box.animation.play('normal');
				dialogueOpened = true;
			}
		}

		if (dialogueOpened && !dialogueStarted)
		{
			startDialogue();
			dialogueStarted = true;
		}

		if (FlxG.keys.justPressed.ANY)
		{
			remove(dialogue);

			if (dialogueList[1] == null)
			{
				finishThing();
				kill();
			}
			else
			{
				dialogueList.remove(dialogueList[0]);
				startDialogue();
			}
		}

		super.update(elapsed);
	}

	function startDialogue():Void
	{
		var theDialog:Alphabet = new Alphabet(0, 70, dialogueList[0], false, true);
		dialogue = theDialog;
		add(theDialog);
	}
}
