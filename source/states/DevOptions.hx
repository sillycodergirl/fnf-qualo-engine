package states;

import backend.AssetManager;
import backend.Conductor;

class DevOptions extends MusicBeatState {
	var bg:FlxSprite;

	var title:Alphabet;

	var optionsStuff:FlxTypedGroup<Alphabet>;
	var stuffToDo:Array<String> = ['Reset Assets'];

	var specShit:FlxText;

	var curSelected:Int = 0;
	var canSelect:Bool = true;

	override function create() {
		Conductor.bpm = 125;
		FlxG.sound.playMusic(Paths.music('devMenu.ogg'), 0.7);

		bg = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.WHITE);
		add(bg);

		title = new Alphabet(10, 10, 'Developer Options', true);
		add(title);

		optionsStuff = new FlxTypedGroup<Alphabet>();
		add(optionsStuff);

		for (i in 0...stuffToDo.length) {
			var option:Alphabet = new Alphabet(15, (i * title.height + 5) + title.height + 10, stuffToDo[i], false);
			option.targetY = i;
			optionsStuff.add(option);
		}
		changeSelection();

		specShit = new FlxText(0, FlxG.height - 20, FlxG.width, '', 20);
		specShit.setFormat(Paths.font('vcr.ttf'), 20, FlxColor.BLACK, LEFT);
		add(specShit);

		super.create();
	}

	override function update(elapsed:Float) {
		if (canSelect) {
			if (controls.UI_UP_P)
				changeSelection(-1);
			if (controls.UI_DOWN_P)
				changeSelection(1);
			if (controls.ACCEPT)
				selectSomething();
			if (controls.BACK) {
				Conductor.bpm = 100;
				FlxG.sound.playMusic(Paths.music('freakyMenu'), 0.7);
				MusicBeatState.switchState(new MainMenuState());
			}
		}

		if (specShit != null) {
			var fps = Main.fpsVar.currentFPS;
			var memory = flixel.util.FlxStringUtil.formatBytes(Main.fpsVar.memoryMegas);

			specShit.text = 'FPS: $fps // Memory: $memory';
		}

		super.update(elapsed);
	}

	function changeSelection(boom:Int = 0) {
		curSelected += boom;
		if (curSelected >= optionsStuff.length) {
			curSelected = 0;
		} else if (curSelected < 0) {
			curSelected = optionsStuff.length - 1;
		}

		if (boom != 0)
			FlxG.sound.play(Paths.sound('menu/scrollMenu'));

		optionsStuff.forEach(function(spr:Alphabet) {
			spr.alpha = 0.6;
			if (spr.targetY == curSelected) {
				spr.alpha = 1;
			}
		});
	}

	function selectSomething() {
		canSelect = false;
		switch (stuffToDo[curSelected]) {
			case 'Reset Assets':
				AssetManager.reloadSourceAssets(function() {
					canSelect = true;
				});
			default:
				trace('no action given for: ' + stuffToDo[curSelected]);
		}
	}
}
