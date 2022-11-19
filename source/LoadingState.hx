package;

import ShaderHandler.*;
import ShaderHandler;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.math.FlxMath;
import flixel.util.FlxAxes;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import haxe.io.Path;
import lime.app.Future;
import lime.app.Promise;
import lime.utils.AssetLibrary;
import lime.utils.AssetManifest;
import lime.utils.Assets as LimeAssets;
import openfl.filters.ShaderFilter;
import openfl.utils.Assets;

class LoadingState extends MusicBeatState
{
	inline static var MIN_TIME = 1.0;

	var target:FlxState;
	var targetShit:Float = 0;
	var stopMusic = false;
	var callbacks:MultiCallback;

	var desktop:Bool = false;

	var grpProgress:FlxGroup;
	var grpFinished:FlxGroup;

	var logo:FlxSprite;
	var creation:CreationEffect;
	var loadingBar:FlxSprite;

	private var camSHADER:FlxCamera;
	private var camHUD:FlxCamera;

	function new(target:FlxState, stopMusic:Bool)
	{
		super();

		this.target = target;
		this.stopMusic = stopMusic;
	}

	override function create()
	{
		/*
			logo = new FlxSprite(-150, -100);
			logo.frames = Paths.getSparrowAtlas('logoBumpin');
			logo.antialiasing = true;
			logo.animation.addByPrefix('bump', 'logo bumpin', 24);
			logo.animation.play('bump');
			logo.updateHitbox();
			logo.screenCenter();
			add(logo);
		 */

		camSHADER = new FlxCamera();
		camHUD = new FlxCamera();
		camHUD.bgColor.alpha = 0;

		FlxG.cameras.reset(camSHADER);
		FlxG.cameras.add(camHUD);

		FlxCamera.defaultCameras = [camSHADER];

		persistentUpdate = true;
		persistentDraw = true;

		#if PRELOAD_ALL
		desktop = true;
		#end

		creation = new CreationEffect();
		camSHADER.setFilters([new ShaderFilter(creation.shader)]);

		loadingBar = new FlxSprite(0, FlxG.height - 20).makeGraphic(FlxG.width, 10, FlxColor.GREEN);
		loadingBar.screenCenter(FlxAxes.X);
		add(loadingBar);

		FlxG.camera.fade(FlxG.camera.bgColor, 0.5, true);
		new FlxTimer().start(0.5 + MIN_TIME, function(_) onLoad());

		if (!desktop)
		{
			initSongsManifest().onComplete(function(lib)
			{
				callbacks = new MultiCallback(onLoad);

				var introComplete = callbacks.add("introComplete");
				checkLoadSong(getSongPath());

				if (PlayState.SONG.needsVoices)
					checkLoadSong(getVocalPath());

				checkLibrary("shared");

				if (PlayState.storyWeek > 0)
					checkLibrary("week" + PlayState.storyWeek);
				else
					checkLibrary("tutorial");

				var fadeTime = 0.5;
				FlxG.camera.fade(FlxG.camera.bgColor, fadeTime, true);
				new FlxTimer().start(fadeTime + MIN_TIME, function(_) introComplete());
			});
		}

		loadingBar.cameras = [camHUD];
	}

	function checkLoadSong(path:String)
	{
		if (!Assets.cache.hasSound(path))
		{
			var library = Assets.getLibrary("songs");
			final symbolPath = path.split(":").pop();
			// @:privateAccess
			// library.types.set(symbolPath, SOUND);
			// @:privateAccess
			// library.pathGroups.set(symbolPath, [library.__cacheBreak(symbolPath)]);
			var callback = callbacks.add("song:" + path);
			Assets.loadSound(path).onComplete(function(_)
			{
				callback();
			});
		}
	}

	function checkLibrary(library:String)
	{
		trace(Assets.hasLibrary(library));
		if (Assets.getLibrary(library) == null)
		{
			@:privateAccess
			if (!LimeAssets.libraryPaths.exists(library))
				throw "Missing library: " + library;

			var callback = callbacks.add("library:" + library);
			Assets.loadLibrary(library).onComplete(function(_)
			{
				callback();
			});
		}
	}

	override function beatHit()
	{
		super.beatHit();
		// logo.animation.play('bump');

		// FlxTween.tween(FlxG.camera, {zoom: 1.05}, 0.3, {ease: FlxEase.quadOut, type: BACKWARD});
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		creation.update(elapsed);

		#if debug
		if (FlxG.keys.justPressed.SPACE)
			trace('fired: ' + callbacks.getFired() + " unfired:" + callbacks.getUnfired());
		#end

		#if NO_PRELOAD_ALL
		// elapsed = 0.88 * FlxG.width;

		if (callbacks != null)
			targetShit = FlxMath.remapToRange(callbacks.numRemaining / callbacks.length, 1, 0, 0, 1);

		var loadScale = loadingBar.scale.x;
		loadingBar.scale.x = loadScale + 0.5 * (targetShit - loadScale);
		loadingBar.updateHitbox();
		#end
	}

	function onLoad()
	{
		if (stopMusic && FlxG.sound.music != null)
			FlxG.sound.music.stop();

		MusicBeatState.switchState(target);
	}

	static function getSongPath()
	{
		return Paths.inst(PlayState.SONG.song);
	}

	static function getVocalPath()
	{
		return Paths.voices(PlayState.SONG.song);
	}

	inline static public function loadAndSwitchState(target:FlxState, stopMusic = false)
	{
		MusicBeatState.switchState(getNextState(target, stopMusic));
	}

	static function getNextState(target:FlxState, stopMusic = false):FlxState
	{
		Paths.setCurrentLevel("week" + PlayState.storyWeek);

		#if NO_PRELOAD_ALL
		var loaded = isSoundLoaded(getSongPath())
			&& (!PlayState.SONG.needsVoices || isSoundLoaded(getVocalPath()))
			&& isLibraryLoaded("shared");

		if (!loaded)
			return new LoadingState(target, stopMusic);
		#end

		if (stopMusic && FlxG.sound.music != null)
			FlxG.sound.music.stop();

		return target;
	}

	#if NO_PRELOAD_ALL
	static function isSoundLoaded(path:String):Bool
	{
		return Assets.cache.hasSound(path);
	}

	static function isLibraryLoaded(library:String):Bool
	{
		return Assets.getLibrary(library) != null;
	}
	#end

	override function destroy()
	{
		super.destroy();

		callbacks = null;
	}

	static function initSongsManifest()
	{
		var id = "songs";
		var promise = new Promise<AssetLibrary>();

		var library = LimeAssets.getLibrary(id);

		if (library != null)
		{
			return Future.withValue(library);
		}

		var path = id;
		var rootPath = null;

		@:privateAccess
		var libraryPaths = LimeAssets.libraryPaths;
		if (libraryPaths.exists(id))
		{
			path = libraryPaths[id];
			rootPath = Path.directory(path);
		}
		else
		{
			if (StringTools.endsWith(path, ".bundle"))
			{
				rootPath = path;
				path += "/library.json";
			}
			else
			{
				rootPath = Path.directory(path);
			}
			@:privateAccess
			path = LimeAssets.__cacheBreak(path);
		}

		AssetManifest.loadFromFile(path, rootPath).onComplete(function(manifest)
		{
			if (manifest == null)
			{
				promise.error("Cannot parse asset manifest for library \"" + id + "\"");
				return;
			}

			var library = AssetLibrary.fromManifest(manifest);

			if (library == null)
			{
				promise.error("Cannot open library \"" + id + "\"");
			}
			else
			{
				@:privateAccess
				LimeAssets.libraries.set(id, library);
				library.onChange.add(LimeAssets.onChange.dispatch);
				promise.completeWith(Future.withValue(library));
			}
		}).onError(function(_)
		{
				promise.error("There is no asset library with an ID of \"" + id + "\"");
		});

		return promise.future;
	}
}

class MultiCallback
{
	public var callback:Void->Void;
	public var logId:String = null;
	public var length(default, null) = 0;
	public var numRemaining(default, null) = 0;

	var unfired = new Map<String, Void->Void>();
	var fired = new Array<String>();

	public function new(callback:Void->Void, logId:String = null)
	{
		this.callback = callback;
		this.logId = logId;
	}

	public function add(id = "untitled")
	{
		id = '$length:$id';
		length++;
		numRemaining++;
		var func:Void->Void = null;
		func = function()
		{
			if (unfired.exists(id))
			{
				unfired.remove(id);
				fired.push(id);
				numRemaining--;

				if (logId != null)
					log('fired $id, $numRemaining remaining');

				if (numRemaining == 0)
				{
					if (logId != null)
						log('all callbacks fired');
					callback();
				}
			}
			else
				log('already fired $id');
		}
		unfired[id] = func;
		return func;
	}

	inline function log(msg):Void
	{
		if (logId != null)
			trace('$logId: $msg');
	}

	public function getFired()
		return fired.copy();

	public function getUnfired()
		return [for (id in unfired.keys()) id];
}
