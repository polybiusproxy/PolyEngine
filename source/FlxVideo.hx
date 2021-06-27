package;

import flixel.FlxBasic;
import flixel.FlxG;
import openfl.media.Video;
import openfl.net.NetConnection;
import openfl.net.NetStream;

// i got this from week 7 update js
// and from ninjamuffin's stream
// and a bit its from "VideoState.hx"
// ik im a madlad
class FlxVideo extends FlxBasic
{
	public var video:Video;
	public var netStream:NetStream;
	public var finishCallback:Void->Void;

	public function new(videoPath:String)
	{
		super();

		video = new Video();
		video.x = 0;
		video.y = 0;

		FlxG.addChildBelowMouse(video);

		var nc = new NetConnection();
		nc.connect(null);

		netStream = new NetStream(nc);
		netStream.client = {onMetaData: client_onMetaData};

		nc.addEventListener("netStatus", netConnection_onNetStatus);

		netStream.play(videoPath);
	}

	function client_onMetaData(videoPath)
	{
		video.attachNetStream(netStream);

		video.width = FlxG.width;
		video.height = FlxG.height;
	}

	function netConnection_onNetStatus(videoPath)
	{
		if (videoPath.info.code == "NetStream.Play.Complete")
		{
			finishVideo();
		}
	}

	function finishVideo()
	{
		netStream.dispose();

		if (FlxG.game.contains(video))
		{
			FlxG.game.removeChild(video);
		}

		if (finishCallback != null)
		{
			finishCallback();
		}
	}
}
