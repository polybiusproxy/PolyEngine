package menus;


import player.Controls.Control;
import player.*;
import song.*;
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.keyboard.FlxKey;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.utils.Assets;
import paths.*;

class OptionsMenu extends MusicBeatState
{
	var grpMenuShit:FlxTypedGroup<Alphabet>;

	var menuItems:Array<String> = ['WASD', 'DFJK', 'Enable reset', 'Disable reset', 'Exit to menu'];
	var curSelected:Int = 0;
	var offsetText:FlxText;

	override function create()
	{
		super.create();

		// note: use paths now due to polymod!
		var bg:FlxSprite = new FlxSprite(-80).loadGraphic('assets/images/menuBG.png');
		bg.scrollFactor.x = 0;
		bg.scrollFactor.y = 0.18;
		bg.setGraphicSize(Std.int(bg.width * 1.1));
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = true;
		add(bg);

		if (FlxG.save.data.dfjk == null){
			FlxG.save.data.dfjk = false;
		}
		
		if (FlxG.save.data.resetEnabled == null){
			FlxG.save.data.resetEnabled = true;
		}

		if (FlxG.save.data.noteoffset == null){
			FlxG.save.data.noteoffset = 0;
		}

		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		bg.alpha = 0.6;
		bg.scrollFactor.set();
		add(bg);

		grpMenuShit = new FlxTypedGroup<Alphabet>();
		add(grpMenuShit);

		for (i in 0...menuItems.length)
		{
			// 0, 60 + (i * 160) -- x and y 
			// 0, (70 * i) + 30 -- old x and y

			var songText:Alphabet = new Alphabet(0, 60 + (i * 160), menuItems[i], true, false);
			songText.isOptionItem = true;
			songText.targetY = i;
			songText.ID = i;
			songText.screenCenter(X);
			grpMenuShit.add(songText);
			songText.scrollFactor.set();
			songText.antialiasing = true;

			trace(i);
		}

		changeSelection();

		cameras = [FlxG.cameras.list[FlxG.cameras.list.length - 1]];

		offsetText = new FlxText(5, FlxG.height - 18, 0, "stupid offset kudgfbv", 12);
		offsetText.scrollFactor.set();
		offsetText.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(offsetText);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		var upP = controls.UP_P;
		var downP = controls.DOWN_P;
		var accepted = controls.ACCEPT;
		var back = controls.BACK;

		// note: make "else if" for more optimization
		if (upP)
		{
			changeSelection(-1);
		}

		if (downP)
		{
			changeSelection(1);
		}

		if (back)
		{
			FlxG.switchState(new MainMenuState());
		}

		if (controls.LEFT_P)
		{
			FlxG.save.data.noteoffset -= 1;
		}
		if (controls.RIGHT_P)
		{
			FlxG.save.data.noteoffset += 1;
		}

		offsetText.text = "Note Offset (use left and right to change): " + FlxG.save.data.noteoffset;

		if (accepted)
		{
			var daSelected:String = menuItems[curSelected];

			switch (daSelected)
			{
				case "WASD":
					FlxG.save.data.dfjk = false;
					controls.setKeyboardScheme(Controls.KeyboardScheme.Solo);
					FlxG.switchState(new MainMenuState());
				case "DFJK":
					FlxG.save.data.dfjk = true;
					controls.setKeyboardScheme(Controls.KeyboardScheme.Solo);
					FlxG.switchState(new MainMenuState());
				case "Enable reset":
					FlxG.save.data.resetEnabled = true;
					controls.setKeyboardScheme(Controls.KeyboardScheme.Solo);
					FlxG.switchState(new MainMenuState());
				case "Disable reset":
					FlxG.save.data.resetEnabled = false;
					controls.setKeyboardScheme(Controls.KeyboardScheme.Solo);
					FlxG.switchState(new MainMenuState());
				case "Exit to menu":
					FlxG.switchState(new MainMenuState());
			}
		}

		if (FlxG.keys.justPressed.J)
		{
			// for reference later!
			// PlayerSettings.player1.controls.replaceBinding(Control.LEFT, Keys, FlxKey.J, null);
		}
	}

	function changeSelection(change:Int = 0):Void
	{
		curSelected += change;

		if (curSelected < 0)
			curSelected = menuItems.length - 1;
		if (curSelected >= menuItems.length)
			curSelected = 0;

		var bullShit:Int = 0;

		for (item in grpMenuShit.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;
			// item.setGraphicSize(Std.int(item.width * 0.8));

			if (item.targetY == 0)
			{
				item.alpha = 1;
				// item.setGraphicSize(Std.int(item.width));
			}
		}
	}
}