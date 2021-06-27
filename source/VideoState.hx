package;

import flixel.FlxG;
import flixel.FlxState;
import openfl.media.Video;
import openfl.net.NetConnection;
import openfl.net.NetStream;

// THIS IS FOR TESTING
// DONT STEAL MY CODE >:(
class VideoState extends FlxState
{
	public static function playVideo(path:String):Video
	{
		var nc:NetConnection = new NetConnection();
		nc.connect(null);

		var ns:NetStream = new NetStream(nc);

		var myVideo:Video = new Video();

		myVideo.width = FlxG.width;
		myVideo.height = FlxG.height;
		myVideo.attachNetStream(ns);

		ns.play(path);

		return myVideo;

		ns.close();
	}
}
