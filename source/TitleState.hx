package;

import ShaderHandler.ColorSwapEffect;
import ShaderHandler.RayEffect;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.transition.FlxTransitionSprite.GraphicTransTileDiamond;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.transition.TransitionData;
import flixel.graphics.FlxGraphic;
import flixel.group.FlxGroup;
import flixel.input.gamepad.FlxGamepad;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import haxe.Http;
import lime.app.Application;
import openfl.Assets;
import openfl.Lib;
import openfl.filters.ShaderFilter;

using StringTools;

#if desktop
import Discord.DiscordClient;
import Sys;
import openfl.display.BitmapData;
import polymod.Polymod.Framework;
import polymod.Polymod.PolymodError;
import sys.FileSystem;
#end

class TitleState extends MusicBeatState
{
	static var initialized:Bool = false;

	var blackScreen:FlxSprite;
	var credGroup:FlxGroup;
	var textGroup:FlxGroup;
	var ngSpr:FlxSprite;

	var curWacky:Array<String> = [];

	var ray:RayEffect;
	var swagShader:ColorSwapEffect;

	private var camSHADER:FlxCamera;
	private var camHUD:FlxCamera;

	override public function create():Void
	{
		#if (polymod && sys)
		// Get all directories in the mod folder
		var modDirectory:Array<String> = [];
		var mods = sys.FileSystem.readDirectory("mods");

		for (fileText in mods)
		{
			if (sys.FileSystem.isDirectory("mods/" + fileText))
			{
				modDirectory.push(fileText);
			}
		}
		trace(modDirectory);

		// Handle mod errors
		var errors = (error:PolymodError) ->
		{
			trace(error.severity + ": " + error.code + " - " + error.message + " - ORIGIN: " + error.origin);
		};

		// Initialize polymod
		var modMetadata = polymod.Polymod.init({
			modRoot: "mods",
			dirs: modDirectory,
			errorCallback: errors,
			framework: OPENFL,
			ignoredFiles: polymod.Polymod.getDefaultIgnoreList(),
			frameworkParams: {
				assetLibraryPaths: [
					"exclude" => "exclude", "fonts" => "fonts", "songs" => "songs", "data" => "data", "images" => "images", "music" => "music",
					"sounds" => "sounds", "shared" => "shared", "tutorial" => "tutorial", "videos" => "videos", "week1" => "week1", "week2" => "week2",
					"week3" => "week3", "week4" => "week4", "week5" => "week5", "week6" => "week6", "week7" => "week7"
				]
			}
		});

		// Display active mods
		var loadedMods = "";
		for (modData in modMetadata)
		{
			loadedMods += modData.title + "";
		}

		var modText = new FlxText(5, 5, 0, "", 16);
		modText.text = "Loaded Mods: " + loadedMods;
		modText.color = FlxColor.WHITE;
		add(modText);
		#end

		camSHADER = new FlxCamera();

		ray = new RayEffect();
		swagShader = new ColorSwapEffect();

		camSHADER.setFilters([new ShaderFilter(ray.shader)]);

		// camSHADER.bgColor = FlxColor.TRANSPARENT;

		FlxG.cameras.add(camSHADER);

		#if desktop
		Lib.current.stage.frameRate = 120;
		#end

		if (FlxG.save.data.dfjk == null)
		{
			FlxG.save.data.dfjk = true;
		}

		if (FlxG.save.data.noteoffset == null)
		{
			FlxG.save.data.noteoffset = 0;
		}

		if (FlxG.save.data.downscroll == null)
		{
			FlxG.save.data.downscroll = false;
		}

		if (FlxG.save.data.basedVocals == null)
		{
			FlxG.save.data.basedVocals = false;
		}

		PlayerSettings.init();

		curWacky = FlxG.random.getObject(getIntroTextShit());

		// DEBUG BULLSHIT

		super.create();

		FlxG.save.bind('polyengine', 'polybiusproxy');

		Highscore.load();

		if (FlxG.save.data.weekUnlocked != null)
		{
			// FIX LATER!!!
			// WEEK UNLOCK PROGRESSION!!
			// StoryMenuState.weekUnlocked = FlxG.save.data.weekUnlocked;

			if (StoryMenuState.weekUnlocked.length < 4)
				StoryMenuState.weekUnlocked.insert(0, true);

			// QUICK PATCH OOPS!
			if (!StoryMenuState.weekUnlocked[0])
				StoryMenuState.weekUnlocked[0] = true;
		}

		#if FREEPLAY
		FlxG.switchState(new FreeplayState());
		#elseif CHARTING
		FlxG.switchState(new ChartingState());
		#else
		new FlxTimer().start(1, function(tmr:FlxTimer)
		{
			startIntro();
		});
		#end

		controls.setKeyboardScheme(Controls.KeyboardScheme.Solo);

		#if desktop
		DiscordClient.initialize();

		Application.current.onExit.add(function(exitCode)
		{
			DiscordClient.shutdown();
		});
		#end
	}

	var logoBl:FlxSprite;
	var gfDance:FlxSprite;
	var danceLeft:Bool = false;
	var titleText:FlxSprite;

	function startIntro()
	{
		if (!initialized)
		{
			var diamond:FlxGraphic = FlxGraphic.fromClass(GraphicTransTileDiamond);
			diamond.persist = true;
			diamond.destroyOnNoUse = false;

			FlxTransitionableState.defaultTransIn = new TransitionData(FADE, FlxColor.BLACK, 1, new FlxPoint(0, -1), {asset: diamond, width: 32, height: 32},
				new FlxRect(-200, -200, FlxG.width * 1.4, FlxG.height * 1.4));
			FlxTransitionableState.defaultTransOut = new TransitionData(FADE, FlxColor.BLACK, 0.7, new FlxPoint(0, 1),
				{asset: diamond, width: 32, height: 32}, new FlxRect(-200, -200, FlxG.width * 1.4, FlxG.height * 1.4));

			transIn = FlxTransitionableState.defaultTransIn;
			transOut = FlxTransitionableState.defaultTransOut;

			// HAD TO MODIFY SOME BACKEND SHIT
			// IF THIS PR IS HERE IF ITS ACCEPTED UR GOOD TO GO
			// https://github.com/HaxeFlixel/flixel-addons/pull/348

			// var music:FlxSound = new FlxSound();
			// music.loadStream(Paths.music('freakyMenu'));
			// FlxG.sound.list.add(music);
			// music.play();
		}

		Conductor.changeBPM(102);
		persistentUpdate = true;

		logoBl = new FlxSprite(-150, -100);
		logoBl.frames = Paths.getSparrowAtlas('logoBumpin');
		logoBl.antialiasing = true;
		logoBl.animation.addByPrefix('bump', 'logo bumpin', 24);
		logoBl.animation.play('bump');
		logoBl.visible = false;
		logoBl.updateHitbox();
		logoBl.shader = swagShader.shader;
		gfDance = new FlxSprite(FlxG.width * 0.4, FlxG.height * 0.07);
		gfDance.frames = Paths.getSparrowAtlas('gfDanceTitle');
		gfDance.animation.addByIndices('danceLeft', 'gfDance', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
		gfDance.animation.addByIndices('danceRight', 'gfDance', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
		gfDance.antialiasing = true;
		gfDance.visible = false;
		gfDance.shader = swagShader.shader;
		add(gfDance);
		add(logoBl);

		titleText = new FlxSprite(100, FlxG.height * 0.8);
		titleText.frames = Paths.getSparrowAtlas('titleEnter');
		titleText.animation.addByPrefix('idle', "Press Enter to Begin", 24);
		titleText.animation.addByPrefix('press', "ENTER PRESSED", 24);
		titleText.antialiasing = true;
		titleText.animation.play('idle');
		titleText.updateHitbox();
		titleText.visible = false;
		add(titleText);

		FlxTween.tween(logoBl, {y: logoBl.y + 50}, 0.6, {ease: FlxEase.quadInOut, type: PINGPONG});

		credGroup = new FlxGroup();
		add(credGroup);
		textGroup = new FlxGroup();

		blackScreen = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		blackScreen.cameras = [camSHADER];
		credGroup.add(blackScreen);

		ngSpr = new FlxSprite(0, FlxG.height * 0.52).loadGraphic(Paths.image('newgrounds_logo'));
		add(ngSpr);
		ngSpr.visible = false;
		ngSpr.setGraphicSize(Std.int(ngSpr.width * 0.8));
		ngSpr.updateHitbox();
		ngSpr.screenCenter(X);
		ngSpr.antialiasing = true;

		FlxG.sound.playMusic(Paths.music('freakyMenu'), 0);
		FlxG.sound.music.fadeIn(4, 0, 0.7);

		FlxG.mouse.visible = false;

		if (initialized)
			skipIntro();
		else
			initialized = true;
	}

	function getIntroTextShit():Array<Array<String>>
	{
		var fullText:String = Assets.getText(Paths.txt('introText'));

		var firstArray:Array<String> = fullText.split('\n');
		var swagGoodArray:Array<Array<String>> = [];

		for (i in firstArray)
		{
			swagGoodArray.push(i.split('--'));
		}

		return swagGoodArray;
	}

	var transitioning:Bool = false;

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music != null)
			Conductor.songPosition = FlxG.sound.music.time;
		// FlxG.watch.addQuick('amp', FlxG.sound.music.amplitude);

		if (FlxG.keys.justPressed.F)
		{
			FlxG.fullscreen = !FlxG.fullscreen;
		}

		var pressedEnter:Bool = FlxG.keys.justPressed.ENTER;

		#if mobile
		for (touch in FlxG.touches.list)
		{
			if (touch.justPressed)
			{
				pressedEnter = true;
			}
		}
		#end

		var gamepad:FlxGamepad = FlxG.gamepads.lastActive;

		if (gamepad != null)
		{
			if (gamepad.justPressed.START)
				pressedEnter = true;

			#if switch
			if (gamepad.justPressed.B)
				pressedEnter = true;
			#end
		}

		if (pressedEnter && !transitioning && skippedIntro)
		{
			titleText.animation.play('press');

			FlxG.camera.flash(FlxColor.WHITE, 1);
			FlxG.sound.play(Paths.sound('confirmMenu'), 0.7);

			transitioning = true;
			// FlxG.sound.music.stop();

			new FlxTimer().start(2, function(tmr:FlxTimer)
			{
				// Get current version of Kade Engine
				// ye i stole this from kade engine (srry dude!)

				var http = new haxe.Http("https://raw.githubusercontent.com/polybiusproxy/PolyEngine/master/daversion");

				http.onData = function(data:String)
				{
					if (!PlayState.daVersion.contains(data.trim()) && !OutdatedSubState.leftState && MainMenuState.nightly == "")
					{
						trace('this dumbass cant update lmfao hahahahh ' + data.trim() + ' != ' + PlayState.daVersion);
						FlxG.switchState(new OutdatedSubState());
					}
					else
					{
						FlxG.switchState(new MainMenuState());
					}
				}

				http.onError = function(error)
				{
					trace('error: $error');
					FlxG.switchState(new MainMenuState()); // fail but we go anyway
				}

				http.request();
			});
			// FlxG.sound.play(Paths.music('titleShoot'), 0.7);
		}

		if (pressedEnter && !skippedIntro)
		{
			skipIntro();
		}

		super.update(elapsed);
		ray.update(elapsed);

		if (FlxG.keys.pressed.LEFT)
		{
			swagShader.update(0.1 * -elapsed);
		}

		if (FlxG.keys.pressed.RIGHT)
		{
			swagShader.update(0.1 * elapsed);
		}
	}

	function createCoolText(textArray:Array<String>)
	{
		for (i in 0...textArray.length)
		{
			var money:Alphabet = new Alphabet(0, 0, textArray[i], true, false);
			money.screenCenter(X);
			money.y += (i * 60) + 200;
			credGroup.add(money);
			textGroup.add(money);
		}
	}

	function addMoreText(text:String)
	{
		var coolText:Alphabet = new Alphabet(0, 0, text, true, false);
		coolText.screenCenter(X);
		coolText.y += (textGroup.length * 60) + 200;
		credGroup.add(coolText);
		textGroup.add(coolText);
	}

	function deleteCoolText()
	{
		while (textGroup.members.length > 0)
		{
			credGroup.remove(textGroup.members[0], true);
			textGroup.remove(textGroup.members[0], true);
		}
	}

	override function beatHit()
	{
		super.beatHit();

		// FlxTween.tween(FlxG.camera, {zoom: 1.05}, 0.3, {ease: FlxEase.quadOut, type: BACKWARD});

		logoBl.animation.play('bump');
		danceLeft = !danceLeft;

		if (danceLeft)
			gfDance.animation.play('danceRight');
		else
			gfDance.animation.play('danceLeft');

		FlxG.log.add(curBeat);

		switch (curBeat)
		{
			case 1:
				createCoolText(['the fnf team', 'polybiusproxy', 'trsf']);
			case 3:
				addMoreText('present...');
			case 4:
				deleteCoolText();
			case 5:
				createCoolText(['In association', 'with']);
			case 7:
				addMoreText('newgrounds');
				ngSpr.visible = true;
			case 8:
				deleteCoolText();
				ngSpr.visible = false;
			case 9:
				createCoolText([curWacky[0]]);
			case 11:
				addMoreText(curWacky[1]);
				addMoreText(curWacky[2]);
				addMoreText(curWacky[3]);
			case 12:
				deleteCoolText();
			case 13:
				addMoreText('Friday');
			case 14:
				addMoreText('Night');
			case 15:
				addMoreText('Funkin');
			case 16:
				skipIntro();
		}
	}

	var skippedIntro:Bool = false;

	function skipIntro():Void
	{
		if (!skippedIntro)
		{
			camSHADER.bgColor = FlxColor.TRANSPARENT;

			gfDance.visible = true;
			logoBl.visible = true;
			titleText.visible = true;

			remove(ngSpr);

			FlxG.camera.flash(FlxColor.WHITE, 4);
			camSHADER.flash(FlxColor.WHITE, 4);

			remove(credGroup);

			camSHADER.setFilters([]);

			skippedIntro = true;
		}
	}
}
