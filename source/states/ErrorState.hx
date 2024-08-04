package states;

import flixel.FlxState;
import flixel.addons.transition.FlxTransitionableState;

class ErrorState extends MusicBeatState {
	// thank you duskie why with nightmare vision.
	public var revertState:Class<FlxState>;
	public var msg:String;

	var beginningVol:Float;

	public function new(revertState:Class<FlxState>, errorMsg:String) {
		this.revertState = revertState;
		this.msg = errorMsg;

		super();
	}

	override function create() {
		FlxG.state.persistentUpdate = false;
		FlxG.state.persistentDraw = true;

		var bg:FlxSprite = new FlxSprite(-80).loadGraphic(Paths.image('menuBG/menuDesat'));
		bg.antialiasing = ClientPrefs.data.antialiasing;
		bg.setGraphicSize(Std.int(bg.width * 1.175));
		bg.updateHitbox();
		bg.screenCenter();
		add(bg);

		var title:Alphabet = new Alphabet(0, 40, 'UNCAUGHT EXCEPTION', true);
		title.screenCenter(X);
		title.color = 0xFFFF0000;
		add(title);

		var errorText:FlxText = new FlxText(0, 0, FlxG.width / 1.5, msg);
		errorText.setFormat(Paths.font('vcr.ttf'), 32, 0xFFFFFFFF, CENTER, OUTLINE, 0xFF000000);
		errorText.screenCenter();
		errorText.borderSize = 1.5;
		add(errorText);

		var className:String = Type.getClassName(revertState);

		var footnote:FlxText = new FlxText(0, FlxG.height - 50, FlxG.width, 'Press SPACE to go back to the revert state ($className)');
		footnote.setFormat(Paths.font('vcr.ttf'), 32, 0xFFFFFFFF, CENTER, OUTLINE, 0xFF000000);
		footnote.y = FlxG.height - footnote.height - 16;
		footnote.borderSize = 0.8;
		footnote.screenCenter(X);
		add(footnote);

		beginningVol = FlxG.sound.music.volume;

		FlxG.sound.music.stop();
		FlxG.sound.play(Paths.sound('misc/error'));

		super.create();
	}

	override function update(elapsed:Float) {
		super.update(elapsed);

		if (FlxG.keys.justPressed.SPACE) {
			FlxTransitionableState.skipNextTransOut = true;
			FlxTransitionableState.skipNextTransIn = true;
			FlxG.sound.playMusic(Paths.music('freakyMenu'), 1, true);
			MusicBeatState.switchState(cast(Type.createInstance(revertState, []), FlxState));
		}
	}
}
