# Playing videos in PolyEngine

1. Get your MP4 video, and place it in "assets/videos".
2. To play the video, use this code depending of the platform you're building for:

HTML5:
```haxe
var video:VideoHandler = new VideoHandler();
video.playWebMP4(Paths.video('nameofyourvideohere'), new MainMenuState());
```

Windows:
```haxe
var video:VideoHandler = new VideoHandler();
video.playMP4(Paths.video('nameofyourvideohere'), new MainMenuState(), false, false);
```
3. Build... and enjoy!
