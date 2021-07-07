package;

import Shaders.CreationShader;
import Shaders.PyramidShader;
import Shaders;
import flixel.system.FlxAssets.FlxShader;
import openfl.Lib;
import openfl.filters.BitmapFilter;
import openfl.filters.ShaderFilter;

class ShaderHandler
{
	private var playState:PlayState;
	private var shaders = [];

	public function new(playState:PlayState)
	{
		this.playState = playState;
	}

	public function addShader(shader:ShaderEffect)
	{
		shaders.push(shader);

		var newShaders:Array<BitmapFilter> = []; // IT SHUTS HAXE UP IDK WHY BUT WHATEVER IDK WHY I CANT JUST ARRAY<SHADERFILTER>

		for (i in shaders)
		{
			newShaders.push(new ShaderFilter(i.shader));
		}

		@:privateAccess
		playState.camGame.setFilters(newShaders);
	}

	public function removeShader(shader:ShaderEffect)
	{
		shaders.remove(shader);

		var newShaders:Array<BitmapFilter> = [];

		for (i in shaders)
		{
			newShaders.push(new ShaderFilter(i.shader));
		}

		@:privateAccess
		playState.camGame.setFilters(newShaders);
	}

	public function update(elapsed:Float)
	{
	}
}

class PyramidEffect
{
	public var shader:PyramidShader = new PyramidShader();

	public function new()
	{
		shader.u_resolution.value = [Lib.current.stage.stageWidth, Lib.current.stage.stageHeight];
		shader.u_time.value = [0];
	}

	public function update(elapsed:Float)
	{
		shader.u_time.value[0] += elapsed;
		shader.u_resolution.value = [Lib.current.stage.stageWidth, Lib.current.stage.stageHeight];
	}
}

class CreationEffect
{
	public var shader:CreationShader = new CreationShader();

	public function new()
	{
		shader.u_resolution.value = [Lib.current.stage.stageWidth, Lib.current.stage.stageHeight];
		shader.u_time.value = [0];
	}

	public function update(elapsed:Float)
	{
		shader.u_time.value[0] += elapsed;
		shader.u_resolution.value = [Lib.current.stage.stageWidth, Lib.current.stage.stageHeight];
	}
}
