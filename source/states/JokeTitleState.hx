package states;

import hxcodec.flixel.FlxVideo;
import openfl.ui.Keyboard;
import openfl.events.KeyboardEvent;
import openfl.display.BitmapData;
// #if (hxCodec >= "3.0.0")
// import hxcodec.flixel.FlxVideo as VideoHandler;
// #elseif (hxCodec >= "2.6.1")
// import hxcodec.VideoHandler as VideoHandler;
// #elseif (hxCodec == "2.6.0")
// import VideoHandler;
// #else
// import vlc.MP4Handler as VideoHandler;
// #end
import flixel.input.keyboard.FlxKey;

class JokeTitleState extends MusicBeatState {
	public static var muteKeys:Array<FlxKey> = [FlxKey.ZERO];
	public static var volumeDownKeys:Array<FlxKey> = [FlxKey.NUMPADMINUS, FlxKey.MINUS];
	public static var volumeUpKeys:Array<FlxKey> = [FlxKey.NUMPADPLUS, FlxKey.PLUS];

	var video:FlxVideo;

	override function create() {
		Paths.clearStoredMemory();

		#if LUA_ALLOWED
		Mods.pushGlobalMods();
		#end
		Mods.loadTopMod();

		FlxG.fixedTimestep = false;
		FlxG.game.focusLostFramerate = 60;
		FlxG.keys.preventDefaultKeys = [TAB];

		FlxG.mouse.visible = false;

		super.create();

		FlxG.save.bind('funkin', CoolUtil.getSavePath());

		ClientPrefs.loadPrefs();

		if (FlxG.sound.music != null)
			FlxG.sound.music.stop();

		startVideo('intro');
	}

	public function startVideo(name:String) {
		video = new FlxVideo();
		video.play(Paths.devAsset('$name.mp4'));
		video.onEndReached.add(finishVideo);

		FlxG.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyPress);
	}

	public function finishVideo() {
		video.dispose();

		FlxG.sound.playMusic(Paths.music('freakyMenu'), 0);
		FlxG.sound.music.fadeIn(4, 0, 0.7);
		FlxG.stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyPress);
		MusicBeatState.switchState(new states.MainMenuState());
	}

	public function onKeyPress(event:KeyboardEvent) {
		if (event.keyCode == Keyboard.ENTER) {
			finishVideo();
		}
	}
}
