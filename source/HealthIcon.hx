package;

import flixel.FlxSprite;
import flixel.math.FlxMath;

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
		'garrett',
		'badai',
		'bf-3d',
		'bf-3d-old',
		'recover',
		'recover-2d',
		'recover-irreversible',
		'bandu-candy',
		'bandu-origin',
		'silly-sally',
		'bambom',
		'ringi',
		'ringi-toio',
		'bendu',
		'cameo',
	];

	public var charPublic:String = 'bf';

	public function new(char:String = 'bf', isPlayer:Bool = false)
	{
		super();

		this.isPlayer = isPlayer;

		changeIcon(char);

		scrollFactor.set();
	}

	function addIcon(char:String, startFrame:Int, singleIcon:Bool = false) {
		animation.add(char, !singleIcon ? [startFrame, startFrame + 1] : [startFrame], 0, false, isPlayer);
	}

	public function changeIcon(char:String = 'face')
	{
		charPublic = char;

		if(char != 'bandu-origin' || char != 'gf')
		{
			loadGraphic(Paths.image('icons/' + char), true, 150, 150);

			addIcon(char, 0);
		}	

		charPublic = char;

		if(char == 'bandu-origin')
		{
			frames = Paths.getSparrowAtlas('icons/bandu_origin_icon');
			animation.addByPrefix(char, char, 24, false, isPlayer, false);
		}
		if(char == 'gf')
		{
			loadGraphic(Paths.image('icons/' + char), true, 150, 150);

			addIcon(char, 0, true);
		}

		antialiasing = !noAaChars.contains(char);

		animation.play(char);

	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		offset.set(Std.int(FlxMath.bound(width - 150,0)),Std.int(FlxMath.bound(height - 150,0)));

		if (sprTracker != null)
			setPosition(sprTracker.x + sprTracker.width + 10, sprTracker.y - 30);
	}
}
