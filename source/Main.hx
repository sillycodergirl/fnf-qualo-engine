package;

import flixel.addons.transition.FlxTransitionableState;
import states.ErrorState;
import haxe.Exception;
import states.StoryMenuState;
import states.MainMenuState;
import states.FreeplayState;
#if android
import android.content.Context;
#end
import debug.FPSCounter;
import flixel.graphics.FlxGraphic;
import flixel.FlxGame;
import flixel.FlxState;
import haxe.io.Path;
import openfl.Assets;
import openfl.Lib;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.display.StageScaleMode;
import lime.app.Application;
import states.TitleState;
#if linux
import lime.graphics.Image;
#end
import haxe.CallStack;

#if linux
@:cppInclude('./external/gamemode_client.h')
@:cppFileCode('
	#define GAMEMODE_AUTO
')
#end
class Main extends Sprite {
	var game = {
		width: 1280, // WINDOW width
		height: 720, // WINDOW height
		initialState: TitleState, // initial game state
		zoom: -1.0, // game state bounds
		framerate: 60, // default framerate
		skipSplash: true, // if the default flixel splash screen should be skipped
		startFullscreen: false // if the game should start at fullscreen mode
	};

	public static var fpsVar:FPSCounter;

	// You can pretty much ignore everything from here on - your code should go in your states.

	public static function main():Void {
		Lib.current.addChild(new Main());
	}

	public function new() {
		super();

		// Credits to MAJigsaw77 (he's the og author for this code)
		#if android
		Sys.setCwd(Path.addTrailingSlash(Context.getExternalFilesDir()));
		#elseif ios
		Sys.setCwd(lime.system.System.applicationStorageDirectory);
		#end

		if (stage != null) {
			init();
		} else {
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
	}

	private function init(?E:Event):Void {
		if (hasEventListener(Event.ADDED_TO_STAGE)) {
			removeEventListener(Event.ADDED_TO_STAGE, init);
		}

		setupGame();
	}

	private function setupGame():Void {
		var stageWidth:Int = Lib.current.stage.stageWidth;
		var stageHeight:Int = Lib.current.stage.stageHeight;

		if (game.zoom == -1.0) {
			var ratioX:Float = stageWidth / game.width;
			var ratioY:Float = stageHeight / game.height;
			game.zoom = Math.min(ratioX, ratioY);
			game.width = Math.ceil(stageWidth / game.zoom);
			game.height = Math.ceil(stageHeight / game.zoom);
		}

		#if LUA_ALLOWED Lua.set_callbacks_function(cpp.Callable.fromStaticFunction(psychlua.CallbackHandler.call)); #end
		Controls.instance = new Controls();
		ClientPrefs.loadDefaultKeys();
		#if ACHIEVEMENTS_ALLOWED Achievements.load(); #end
		addChild(new MainGame(game.width, game.height, game.initialState, #if (flixel < "5.0.0") game.zoom, #end game.framerate, game.framerate,
			game.skipSplash, game.startFullscreen));

		#if !mobile
		fpsVar = new FPSCounter(10, 3, 0xFFFFFF);
		addChild(fpsVar);
		Lib.current.stage.align = "tl";
		Lib.current.stage.scaleMode = StageScaleMode.NO_SCALE;
		if (fpsVar != null) {
			fpsVar.visible = ClientPrefs.data.showFPS;
		}
		#end

		#if linux
		var icon = Image.fromFile("icon.png");
		Lib.current.stage.window.setIcon(icon);
		#end

		#if html5
		FlxG.autoPause = false;
		FlxG.mouse.visible = false;
		#end

		#if DISCORD_ALLOWED
		DiscordClient.prepare();
		#end

		// shader coords fix
		FlxG.signals.gameResized.add(function(w, h) {
			if (FlxG.cameras != null) {
				for (cam in FlxG.cameras.list) {
					if (cam != null && cam.filters != null)
						resetSpriteCache(cam.flashSprite);
				}
			}

			if (FlxG.game != null)
				resetSpriteCache(FlxG.game);
		});
	}

	static function resetSpriteCache(sprite:Sprite):Void {
		@:privateAccess {
			sprite.__cacheBitmap = null;
			sprite.__cacheBitmapData = null;
		}
	}
}

class MainGame extends FlxGame {
	var fuckedUpTitle:Bool = false; // this is for the crash handler shit

	private static function KILLYOURSELFNOW() {
		null
		.draw();
	}

	override function create(_):Void {
		try
			super.create(_)
		catch (e)
			onCrash(e);
	}

	override function onFocus(_):Void {
		try
			super.onFocus(_)
		catch (e)
			onCrash(e);
	}

	override function onFocusLost(_):Void {
		try
			super.onFocusLost(_)
		catch (e)
			onCrash(e);
	}

	override function onEnterFrame(_):Void {
		try
			super.onEnterFrame(_)
		catch (e)
			onCrash(e);
	}

	override function draw():Void {
		try
			super.draw()
		catch (e)
			onCrash(e);
	}

	override function update():Void {
		#if CRASH_HANDLER
		if (FlxG.keys.justPressed.F9)
			KILLYOURSELFNOW();
		#end
		try
			super.update()
		catch (e)
			onCrash(e);
	}

	function onCrash(e:Exception):Void {
		var errMSG:String = '';

		var dateNow:String = Date.now().toString();

		dateNow = dateNow.replace(" ", "_");
		dateNow = dateNow.replace(":", "'");

		var callStack:Array<StackItem> = CallStack.exceptionStack(true);

		var callList:String = '';

		for (stackItem in callStack) {
			switch (stackItem) {
				case FilePos(s, file, line, column):
					callList += file + ' (line $line)\n';
				default:
					Sys.println(stackItem);
			}
		}

		var err = e.message;

		errMSG += 'Uh oh! An uncaught exception has occured.\n
		Error: $err\n
		Callstack:\n
		$callList';

		FlxTransitionableState.skipNextTransOut = true;
		FlxTransitionableState.skipNextTransIn = true;

		var revertState = getRevertState();

		MusicBeatState.switchState(new ErrorState(revertState, errMSG));
	}

	function getRevertState():Class<FlxState> {
		var currentState = Type.getClassName(Type.getClass(FlxG.state));

		currentState = currentState.replace('states.', ''); // clean it up bc erm it does that.

		switch (currentState) {
			case 'FreeplayState', 'DevOptions', 'CreditsState', 'ModsMenuState', 'StoryMenuState', 'AchievementsMenuState', 'OptionsState', 'OutdatedState',
				'FlashingState':
				return MainMenuState;
			case 'PlayState':
				if (PlayState.isStoryMode) { // will this work if the current state is crashing? idfk
					return StoryMenuState;
				} else {
					return FreeplayState;
				}

			case 'MainMenuState':
				if (fuckedUpTitle) {
					trace('ay mane, your title is fucked up. we can\'t revert yo shit.');
					Sys.exit(1);
					return null;
				}
				return TitleState;

			case 'TitleState':
				fuckedUpTitle = true;
				return MainMenuState;

			default:
				if (fuckedUpTitle) {
					trace('ay mane, your title is fucked up. we can\'t revert yo shit.');
					Sys.exit(1);
					return null;
				} else {
					return TitleState;
				}
		}
	}
}
