package;

import Conductor.BPMChangeEvent;
import flixel.FlxG;
import flixel.FlxState;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.ui.FlxUIState;
import flixel.math.FlxRect;
import flixel.util.FlxTimer;

#if GAMEJOLT_ALLOWED
import gamejolt.GJClient;
#end

class MusicBeatState extends FlxUIState
{
	private var lastBeat:Float = 0;
	private var lastStep:Float = 0;

	private var curStep:Int = 0;
	private var curBeat:Int = 0;
	private var controls(get, never):Controls;

	#if GAMEJOLT_ALLOWED
	private static var pingTrigger:FlxTimer;
	#end

	inline function get_controls():Controls
		return PlayerSettings.player1.controls;

	override function create()
	{
		destroySubStates = false; // This to avoid crashes on substates re-opening (GamerPablito)

		#if GAMEJOLT_ALLOWED
		pingTrigger = new FlxTimer();
		pingTrigger.start(5, function (tmr:FlxTimer) {GJClient.pingSession();}, 0);
		#end

		if (transIn != null) trace('reg ' + transIn.region);
		super.create();
	}

	override function update(elapsed:Float)
	{
		// everyStep();
		var oldStep:Int = curStep;

		updateCurStep();
		updateBeat();

		if (oldStep != curStep && curStep > 0) stepHit();

		#if GAMEJOLT_ALLOWED
		GJClient.pingSession();
		#end

		super.update(elapsed);
	}

	public static function switchState(nextState:FlxState)
	{
		#if GAMEJOLT_ALLOWED
		if (pingTrigger.active)
		{
			pingTrigger.cancel();
			pingTrigger.destroy();
		}
		#end
		FlxG.switchState(nextState);
	}

	private function updateBeat():Void
	{
		curBeat = Math.floor(curStep / 4);
	}

	private function updateCurStep():Void
	{
		var lastChange:BPMChangeEvent = {
			stepTime: 0,
			songTime: 0,
			bpm: 0
		}
		for (i in 0...Conductor.bpmChangeMap.length)
		{
			if (Conductor.songPosition >= Conductor.bpmChangeMap[i].songTime)
				lastChange = Conductor.bpmChangeMap[i];
		}

		curStep = lastChange.stepTime + Math.floor((Conductor.songPosition - lastChange.songTime) / Conductor.stepCrochet);
	}

	public function stepHit():Void
	{
		if (curStep % 4 == 0)
			beatHit();
	}

	public function beatHit():Void
	{
		// do literally nothing dumbass
	}
}
