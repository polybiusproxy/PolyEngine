package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;

class OptionsMenu extends MusicBeatState
{
	var grpMenuShit:FlxTypedGroup<Alphabet>;

	var menuItems:Array<String> = [];

	#if debug
	var optionItems:Array<String> = ['Keys', 'Scroll', 'DEBUG', 'Exit to menu'];
	#else
	var optionItems:Array<String> = ['Keys', 'Scroll', 'Exit to menu'];
	#end

	var keysItems:Array<String> = ['WASD', 'DFJK', 'Custom'];
	var scrollItems:Array<String> = ['Downscroll', 'Upscroll'];
	var debugItems:Array<String> = ['Diffbased Vocals', 'Disable Diffbased Vocals', 'Shaders', 'Video'];

	// var noteItems:Array<String> = ['Enable note splash', 'Disable note splash'];
	var curSelected:Int = 0;
	var offsetText:FlxText;

	override function create()
	{
		super.create();

		menuItems = optionItems;

		var bg:FlxSprite = new FlxSprite(-80).loadGraphic(Paths.image('menuDesat'));
		bg.scrollFactor.x = 0;
		bg.scrollFactor.y = 0.18;
		bg.setGraphicSize(Std.int(bg.width * 1.1));
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = true;
		add(bg);

		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		bg.alpha = 0.6;
		bg.scrollFactor.set();
		add(bg);

		grpMenuShit = new FlxTypedGroup<Alphabet>();
		add(grpMenuShit);
		regenMenu();

		changeSelection();

		cameras = [FlxG.cameras.list[FlxG.cameras.list.length - 1]];

		offsetText = new FlxText(5, FlxG.height - 18, 0, "stupid offset kudgfbv", 12);
		offsetText.scrollFactor.set();
		offsetText.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(offsetText);
	}

	function regenMenu():Void
	{
		for (i in 0...grpMenuShit.members.length)
			grpMenuShit.remove(grpMenuShit.members[0], true);

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
		}

		curSelected = 0;
		changeSelection();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		var upP = controls.UP_P;
		var downP = controls.DOWN_P;
		var accepted = controls.ACCEPT;
		var back = controls.BACK;

		// note: make "else if" for more optimization -- almost done
		if (upP)
		{
			changeSelection(-1);
		}
		else if (downP)
		{
			changeSelection(1);
		}
		else if (back)
		{
			FlxG.switchState(new MainMenuState());
		}

		if (controls.LEFT_P)
		{
			FlxG.save.data.noteoffset -= 1;
		}
		else if (controls.RIGHT_P)
		{
			FlxG.save.data.noteoffset += 1;
		}

		offsetText.text = "Note Offset (use left and right to change): " + FlxG.save.data.noteoffset + "ms";

		if (accepted)
		{
			var daSelected:String = menuItems[curSelected];

			switch (daSelected)
			{
				case "Keys":
					menuItems = keysItems;
					regenMenu();
				case "Scroll":
					menuItems = scrollItems;
					regenMenu();
				case "DEBUG":
					menuItems = debugItems;
					regenMenu();
				/*
					case "Note":
						menuItems = noteItems;
						regenMenu();
				 */
				case "WASD":
					FlxG.save.data.dfjk = false;
					controls.setKeyboardScheme(Controls.KeyboardScheme.Solo);
					menuItems = optionItems;
					regenMenu();
				case "DFJK":
					FlxG.save.data.dfjk = true;
					controls.setKeyboardScheme(Controls.KeyboardScheme.Solo);
					menuItems = optionItems;
					regenMenu();
				case "Custom":
					FlxG.switchState(new KeybindState());
				case "Downscroll":
					FlxG.save.data.downscroll = true;
					menuItems = optionItems;
					regenMenu();
				case "Upscroll":
					FlxG.save.data.downscroll = false;
					menuItems = optionItems;
					regenMenu();
				case "Diffbased Vocals":
					FlxG.save.data.basedVocals = true;
					menuItems = optionItems;
					regenMenu();
				case "Disable Diffbased Vocals":
					FlxG.save.data.basedVocals = false;
					menuItems = optionItems;
					regenMenu();
				case "Shaders":
					FlxG.switchState(new ShaderState());
				case "Video":
					var video:VideoHandler = new VideoHandler();
					video.playMP4(Paths.video('bigChungus'), new MainMenuState(), false, false);
				/*
					case "Enable note splash":
						FlxG.save.data.noteSplash = true;
						menuItems = optionItems;
						regenMenu();
					case "Disable note splash":
						FlxG.save.data.noteSplash = false;
						menuItems = optionItems;
						regenMenu();
				 */
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
		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
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
