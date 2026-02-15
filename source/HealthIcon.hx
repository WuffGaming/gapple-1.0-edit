package;

import flixel.FlxSprite;
import flixel.math.FlxMath;

using StringTools;

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
		'bandu-sugar',
		'bandu-origin',
		'silly-sally',
		'bambom',
		'ringi',
		'ringi-toio',
		'bendu',
		'cameo',
		'og-dave',
		'garrett',
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

		if(char == 'bandu-origin')
		{
			frames = Paths.getSparrowAtlas('ui/icons/bandu_origin_icon');
			animation.addByPrefix(char, char, 24, false, isPlayer, false);
		}
		else if(char == 'gf' || char.endsWith('-single'))
		{
			loadGraphic(Paths.image('ui/icons/' + char), true, 150, 150);

			addIcon(char, 0, true);
		}
		else if(char == 'junkers')
		{
			loadGraphic(Paths.image('ui/icons/' + char), true, 200, 200);

			addIcon(char, 0);
		}
		else if(char == 'expunged')
		{
			loadGraphic(Paths.image('ui/icons/' + char), true, 300, 300);

			addIcon(char, 0);
		}
		else
		{
			loadGraphic(Paths.image('ui/icons/' + char), true, 150, 150);

			addIcon(char, 0);
		}	

		if (charPublic.endsWith('-3d') || charPublic.endsWith('-pixel')) // allows for json chars to have aliased icons
			antialiasing = false;
		else
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
