package;

// THIS IS AN EXAMPLE OF HOW TO ADD SHADERS IN POLYENGINE
import MusicBeatState;
import ShaderHandler.CreationEffect; // 1. Import the effect you want to add.
import flixel.FlxG;
import openfl.filters.ShaderFilter; // 2. Import ShaderFilter.

class ShaderState extends MusicBeatState
{
	var creation:CreationEffect; // 3. Create a variable for the effect like you would normally do.

	var back = controls.BACK;

	override public function create():Void
	{
		super.create();

		creation = new CreationEffect(); // 4. Call the constructor of the effect.
		FlxG.camera.setFilters([new ShaderFilter(creation.shader)]); // 5. Write this line and replace "creation" with the shader you want.
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		creation.update(elapsed); // 6. Write this line and replace "creation" with the shader you want.

		if (back)
			FlxG.switchState(new OptionsMenu());
	}

	// 7. Compile and you should see your shader!
}
