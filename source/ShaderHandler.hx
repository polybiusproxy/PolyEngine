package;

import Shaders;
import flixel.util.FlxColor;
import openfl.Lib;
import openfl.filters.BitmapFilter;
import openfl.filters.ShaderFilter;

// THIS IS FOR TESTING AND ONLY USED IN TITLESTATE
// TODO: Make a system so this can be used by every state.
class ShaderHandler
{
	private var state:TitleState;
	private var shaders = [];

	public function new(state:TitleState)
	{
		this.state = state;
	}

	public function addShader(shader:ShaderEffect)
	{
		shaders.push(shader);

		var newShaders:Array<BitmapFilter> = [];

		for (i in shaders)
		{
			newShaders.push(new ShaderFilter(i.shader));
		}

		@:privateAccess
		state.camSHADER.setFilters(newShaders);
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
		state.camSHADER.setFilters(newShaders);
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

class RayEffect
{
	public var shader:RayShader = new RayShader();

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
