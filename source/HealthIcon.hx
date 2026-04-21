package;

import flixel.FlxSprite;
import flixel.math.FlxMath;

typedef IconData =
{
	var size:Null<Int>;

	var solo:Null<Bool>;

	var antialiasing:Null<Bool>;

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
	 * Used for FreeplayState! If you use it elsewhere, prob gonna annoying
	 */
	public var sprTracker:FlxSprite;

	public var isPlayer:Bool = false;

	public var noAaChars:Array<String> = [];

	public var charPublic:String = 'bf';

	public var animatedIcon:Bool = false;

	public var losing:Bool = false;

	public var singleIcon:Bool = false;

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
			var size = data.size == null ? 150 : data.size;
			var solo = data.solo == null ? false : data.solo;
			var anti = data.antialiasing == null ? true : data.antialiasing;
			trace('${char} is a JSON icon and you win!');
			if (anti != true)
				noAaChars.push(char);

			if (solo == true)
				singleIcon = true;

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
				if (size != null)
				{
					scale.set(size / 150, size / 150); // this might work
				}
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

			addIcon(char, 0);
		}

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
