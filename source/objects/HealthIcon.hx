package objects;

class HealthIcon extends FlxSprite {
	public var sprTracker:FlxSprite;

	private var isOldIcon:Bool = false;
	private var isPlayer:Bool = false;
	private var char:String = '';

	public function new(char:String = 'bf', isPlayer:Bool = false, ?allowGPU:Bool = true) {
		super();
		isOldIcon = (char == 'bf-old');
		this.isPlayer = isPlayer;
		changeIcon(char, allowGPU);
		scrollFactor.set();
	}

	override function update(elapsed:Float) {
		super.update(elapsed);

		if (sprTracker != null)
			setPosition(sprTracker.x + sprTracker.width + 12, sprTracker.y - 30);
	}

	private var iconOffsets:Array<Float> = [0, 0];

	public function changeIcon(char:String, ?allowGPU:Bool = true) {
		if (this.char != char) {
			var name:String = char;

			if (!FileSystem.exists('assets/images/gameplay_UI/icons/' + name + '.png'))
				name = 'icon-' + char; // Older versions of psych engine's support

			if (!FileSystem.exists('assets/images/gameplay_UI/icons/' + name + '.png'))
				name = 'icon-face'; // Prevents crash from missing icon

			var graphic = Paths.image('gameplay_UI/icons/$name', allowGPU);
			loadGraphic(graphic, true, Math.floor(graphic.width / 2), Math.floor(graphic.height));
			iconOffsets[0] = (width - 150) / 2;
			iconOffsets[1] = (height - 150) / 2;
			updateHitbox();

			animation.add(char, [0, 1], 0, false, isPlayer);
			animation.play(char);
			this.char = char;

			if (char.endsWith('-pixel'))
				antialiasing = false;
			else
				antialiasing = ClientPrefs.data.antialiasing;
		}
	}

	override function updateHitbox() {
		super.updateHitbox();
		offset.x = iconOffsets[0];
		offset.y = iconOffsets[1];
	}

	public function getCharacter():String {
		return char;
	}
}
