package;

import flixel.FlxSprite;
import flixel.math.FlxMath;
import flixel.util.FlxColor;

typedef IconData =
{
	var size:Null<Int>;

	var scale:Array<Float>;

	var solo:Null<Bool>;

	var antialiasing:Null<Bool>;

	var barColor:Array<Int>;

	var animations:Array<IconAnimationData>;
}

typedef IconAnimationData = // taken from character.hx
{
	var name:String; // Name of animation. Should be something like "Normal" or "Losing"
	var prefix:String; // Name of animation in XML

	/**
	 * Whether this animation is looped.
	 * @default false
	 */
	var ?looped:Bool;

	/**
	 * The frame rate of this animation.
	 * @default 24
	 */
	var ?frameRate:Int; // Framerate of this specific animation.

	var ?frameIndices:Array<Int>; // If using indices, specify said indices. Plays full animation if null.
}

class HealthIcon extends FlxSprite
{
	/**
	 * Used to represent character icons & the color on the healthbar.
	 */
	public var sprTracker:FlxSprite;

	public var isPlayer:Bool = false;

	public var noAaChars:Array<String> = [];

	public var charPublic:String = 'bf';

	public var animatedIcon:Bool = false;

	public var losing:Bool = false;

	public var singleIcon:Bool = false;

	public var barColor:FlxColor;

	public var iconScale:Array<Float> = [1, 1];

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

		if (Assets.exists(Paths.json('icons/${char}')))
		{
			var jsonData:IconData = Paths.loadJSON('icons/${char}');
			var data:IconData = cast jsonData;
			var size:Int = data.size == null ? 150 : data.size;
			var solo:Bool = data.solo == null ? false : data.solo;
			var anti:Bool = data.antialiasing == null ? true : data.antialiasing;
			var barColorArray:Array<Int> = (data.barColor != null && data.barColor.length > 2) ? data.barColor : [161, 161, 161];
			iconScale = data.scale == null ? [1, 1] : [data.scale[0], data.scale[1]];
			if (anti != true)
				noAaChars.push(char);

			if (solo == true)
				singleIcon = true;

			barColor = FlxColor.fromRGB(barColorArray[0], barColorArray[1], barColorArray[2]);

			if (data.animations != null)
			{
				trace('${char} is an animated icon! Wow!');
				animatedIcon = true;
				frames = Paths.getSparrowAtlas(iconPath + char);
				for (anim in data.animations)
				{
					var frameRate = anim.frameRate == null ? 24 : anim.frameRate;
					var looped = anim.looped == null ? false : anim.looped;

					if (anim.frameIndices != null)
					{
						animation.addByIndices(anim.name, anim.prefix, anim.frameIndices, "", frameRate, looped, isPlayer);
					}
					else
					{
						animation.addByPrefix(anim.name, anim.prefix, frameRate, looped, isPlayer);
					}
				}
				animation.play('normal', true);
			}
			else
			{
				loadGraphic(Paths.image(iconPath + char), true, size, size);
				addIcon(char, 0, solo);
			}
		}
		else
		{
			loadGraphic(Paths.image(iconPath + char), true, 150, 150);

			barColor = FlxColor.fromRGB(161, 161, 161);

			trace('${char} requires a JSON to have full potential');

			addIcon(char, 0);
		}

		setGraphicSize(width * iconScale[0], height * iconScale[1]);
		updateHitbox();

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
