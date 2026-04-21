package;

import flixel.FlxSprite;
import flixel.math.FlxMath;

typedef IconData =
{
	var size:Null<Int>;

	var solo:Null<Bool>;

	var antialiasing:Null<Bool>;
}

class HealthIcon extends FlxSprite
{
	/**
	 * Used for FreeplayState! If you use it elsewhere, prob gonna annoying
	 */
	public var sprTracker:FlxSprite;

	public var isPlayer:Bool = false;

	public var noAaChars:Array<String> = [
		'bambi-disrupt',
		'expunged',
		'bandu',
		'junkers',
		'dave-3d',
		'dave-3d-suit',
		'badai',
		'bf-3d',
		'bf-3d-old',
		'recover',
		'recover-2d',
		'recover-irreversible',
		'bandu-sugar',
		'bandu-origin',
		'silly-sally',
		'bambom',
		'ringi',
		'ringi-toio',
		'bendu',
		'cameo',
		'og-dave',
		'og-dave-angey',
		'spike',
	];

	public var charPublic:String = 'bf';

	public var animatedIcon:Bool = false;

	public var losing:Bool = false;

	public function new(char:String = 'bf', isPlayer:Bool = false)
	{
		super();

		this.isPlayer = isPlayer;

		changeIcon(char);

		scrollFactor.set();
	}

	function addIcon(char:String, startFrame:Int, singleIcon:Bool = false)
	{
		animation.add(char, !singleIcon ? [startFrame, startFrame + 1] : [startFrame], 0, false, isPlayer);
	}

	public function changeIcon(char:String = 'face')
	{
		var iconPath = 'icons/';
		charPublic = char;

		if (char == 'bandu-origin')
		{
			animatedIcon = true;
			frames = Paths.getSparrowAtlas(iconPath + 'bandu_origin_icon');
			animation.addByPrefix(char, char, 24, false, isPlayer, false);
		}
		else if (Assets.exists(Paths.json('icons/${char}')))
		{
			var jsonData:IconData = Paths.loadJSON('icons/${char}');
			var data:IconData = cast jsonData;
			var size = data.size == null ? 150 : data.size;
			var solo = data.solo == null ? false : data.solo;
			var anti = data.antialiasing == null ? true : data.antialiasing;
			trace('${char} is a JSON icon and you win!');
			if (anti != true)
				noAaChars.push(char);

			loadGraphic(Paths.image(iconPath + char), true, size, size);

			addIcon(char, 0, solo);
		}
		else
		{
			loadGraphic(Paths.image(iconPath + char), true, 150, 150);

			addIcon(char, 0);
		}
		/*
			else if (char == 'gf' || char.endsWith('-single'))
			{
				loadGraphic(Paths.image(iconPath + char), true, 150, 150);

				addIcon(char, 0, true);
			}
			else if (char == 'junkers')
			{
				loadGraphic(Paths.image(iconPath + char), true, 200, 200);

				addIcon(char, 0);
			}
			else if (char == 'expunged')
			{
				loadGraphic(Paths.image(iconPath + char), true, 300, 300);

				addIcon(char, 0);
			}
			else
			{
				loadGraphic(Paths.image(iconPath + char), true, 150, 150);

				addIcon(char, 0);
			}
		 */

		if (charPublic.endsWith('-3d') || charPublic.endsWith('-pixel')) // allows for json chars to have aliased icons
			antialiasing = false;
		else
			antialiasing = !noAaChars.contains(char);

		animation.play(char);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		offset.set(Std.int(FlxMath.bound(width - 150, 0)), Std.int(FlxMath.bound(height - 150, 0)));

		if (sprTracker != null)
			setPosition(sprTracker.x + sprTracker.width + 10, sprTracker.y - 30);
	}
}
