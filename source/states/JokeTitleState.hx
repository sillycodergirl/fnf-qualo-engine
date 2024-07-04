package states;

import hxvlc.flixel.FlxVideoSprite;
import openfl.events.KeyboardEvent;
import openfl.ui.Keyboard;
import flixel.input.keyboard.FlxKey;

class JokeTitleState extends MusicBeatState {
	public static var muteKeys:Array<FlxKey> = [FlxKey.ZERO];
	public static var volumeDownKeys:Array<FlxKey> = [FlxKey.NUMPADMINUS, FlxKey.MINUS];
	public static var volumeUpKeys:Array<FlxKey> = [FlxKey.NUMPADPLUS, FlxKey.PLUS];

	var video:FlxVideoSprite;

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
		video = new FlxVideoSprite(0, 0);

		video.bitmap.onFormatSetup.add(function() {
			video.setGraphicSize(FlxG.width, FlxG.height);
			video.updateHitbox();
			video.screenCenter();
		});

		video.bitmap.onEndReached.add(function() {
			finishVideo();
		});

		video.antialiasing = true;
		video.load(Paths.devAsset(name + '.mp4'));
		add(video);

		video.play();

		FlxG.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyPress);
	}

	public function finishVideo() {
		video.destroy();

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
