package;

import Controls.Control;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.input.keyboard.FlxKey;
import flixel.text.FlxText;
import flixel.util.FlxColor;

using StringTools;

class KeybindState extends MusicBeatState
{
	var text:FlxText;

	var keys:Array<String> = ['LEFT', 'DOWN', 'UP', 'RIGHT'];
	var rebindedKeys:Array<String> = [''];

	var currentKey:String = '';
	var keyNum:Int = 0;

	override function create()
	{
		super.create();

		var bg:FlxSprite = new FlxSprite(-80).loadGraphic(Paths.image('menuDesat'));
		bg.scrollFactor.x = 0;
		bg.scrollFactor.y = 0.18;
		bg.setGraphicSize(Std.int(bg.width * 1.1));
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = true;
		add(bg);

		var blackBG:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		blackBG.alpha = 0.75;
		blackBG.scrollFactor.set();
		add(blackBG);

		text = new FlxText(0, 0, 0, "Welcome!\nPlease, press the key to rebind the current key: " + keys[0], 20);
		text.screenCenter();
		add(text);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (keys[0] != null)
		{
			if (FlxG.keys.justPressed.ANY)
			{
				var key = FlxG.keys.getIsDown()[0].ID;
				var control:Control = null;

				switch (keys[0])
				{
					case 'LEFT':
						control = Control.LEFT;
					case 'DOWN':
						control = Control.DOWN;
					case 'UP':
						control = Control.UP;
					case 'RIGHT':
						control = Control.RIGHT;
				}

				// keyNum++;
				PlayerSettings.player1.controls.replaceBinding(control, Keys, key, null);

				rebindedKeys.push(keys[0]);
				keys.remove(keys[0]);
			}
		}
		else
		{
			FlxG.switchState(new MainMenuState());
		}

		text.text = (keys[0] == null ? 'Bye!\nKeys had been rebinded sucessfully!' : "Welcome!\nPlease, press the key to rebind the current key: " + keys[0]);
	}
}
