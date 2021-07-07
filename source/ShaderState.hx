package;

// only for testing!
import ShaderHandler.PyramidEffect;
import flixel.FlxState;

class ShaderState extends FlxState
{
	var pyramid:PyramidEffect;
	var shaders:ShaderHandler;

	override public function create():Void
	{
		super.create();
		pyramid = new PyramidEffect();

		shaders.addShader(pyramid);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		pyramid.update(elapsed);
		shaders.update(elapsed);
	}
}
