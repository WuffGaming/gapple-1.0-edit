package;

import haxe.io.Path;
import openfl.utils.ByteArray;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.animation.FlxBaseAnimation;
import flixel.graphics.frames.FlxAtlasFrames;

typedef CharacterData =
{
	var name:String; // Visual name of the character.
	var asset:String; // Path to the character's asset.

	var barColor:Array<Int>; // Character's healthbar color.
	var globalOffset:Array<Float>; // Offsets added directly to the pre-existing offset. Kept in for compatability reasons.
	var gameOffset:Array<Float>; // Proper offset
	var camOffset:Array<Float>; // Camera offset

	var ?bopDance:Bool; // Does the character bop left and right?

	var ?nativelyPlayable:Bool; // Can the character be played natively?

	var ?flipX:Bool; // Flip the character sprite?

	var ?causeCameraShake:Bool; // Flip the character sprite?

	var ?antialiasing:Bool; // Alias the character?

	var ?scaleSize:Bool; // Should you change the scale of the character or do setGraphicSize?

	var scale:Null<Float>; // Changes scale/graphicsize by amount.

	var float:String; // Which float should character use?

	var noteStyle:String; // What style of notes should the character use?

	var icon:String; // What icon should be used?

	var animations:Array<AnimationData>; // Array of all animations. Offsets are handled in the data/offsets
}

typedef AnimationData =
{
	var name:String; // Name of animation
	var prefix:String; // Name of animation in XML

	/**
	 * Whether this animation is looped.
	 * @default false
	 */
	var ?looped:Bool;

	var ?flipX:Bool; // Flip the character for specifically this animation?

	/**
	 * The frame rate of this animation.
	 * @default 24
	 */
	var ?frameRate:Int; // Framerate of this specific animation.

	var ?frameIndices:Array<Int>; // If using indices, specify said indices. Plays full animation if null.
}

class Character extends FlxSprite
{
	public var animOffsets:Map<String, Array<Dynamic>>;
	public var debugMode:Bool = false;

	public var isPlayer:Bool = false;
	public var curCharacter:String = 'bf';
	public var iconName:String = 'face';

	public var holdTimer:Float = 0;
	public var canDance:Bool = true;

	public var nativelyPlayable:Bool = false;
	public var barColor:FlxColor;
	public var bopDance:Bool = false;

	public var globaloffset:Array<Float> = [0, 0];
	public var gameOffset:Array<Float> = [0, 0];
	public var camOffset:Array<Float> = [0, 0];
	public var floater:String = 'false';
	public var noteStyle:String = '2D';
	public var charScale:Float = 1;

	public var barColorArray:Array<Int> = [0, 0, 0];

	public function new(x:Float, y:Float, ?character:String = "bf", ?isPlayer:Bool = false)
	{
		super(x, y);

		animOffsets = new Map<String, Array<Dynamic>>();
		curCharacter = character;
		this.isPlayer = isPlayer;

		var tex:FlxAtlasFrames;
		antialiasing = true;
		barColor = FlxColor.fromRGB(255, 255, 255);

		switch (curCharacter)
		{
			/**
				case 'your-hardcoded-character':
					tex = Paths.getSparrowAtlas('characters/your/path');
					frames = tex;
					animation.addByPrefix('idle', 'IDLE', 24, false);
					animation.addByPrefix('singUP', 'UP', 24, false);
					animation.addByPrefix('singRIGHT', 'RIGHT', 24, false);
					animation.addByPrefix('singDOWN', 'DOWN', 24, false);
					animation.addByPrefix('singLEFT', 'LEFT', 24, false);
					animation.addByPrefix('stand', 'STAND', 24, false);

					loadOffsetFile(curCharacter);

					updateHitbox();
					antialiasing = false;
					iconName = 'icon';
					barColor = FlxColor.fromRGB(255, 255, 255);

					playAnim('idle');
			**/
			default:
				parseDataFile();
		}
		dance();

		if (isPlayer)
		{
			flipX = !flipX;
		}
	}

	public var POOP:Bool = false; // https://cdn.discordapp.com/attachments/902006463654936587/906412566534848542/video0-14.mov

	override function update(elapsed:Float)
	{
		if (animation == null)
		{
			super.update(elapsed);
			return;
		}
		else if (animation.curAnim == null)
		{
			super.update(elapsed);
			return;
		}
		if (!nativelyPlayable && !isPlayer)
		{
			if (animation.curAnim.name.startsWith('sing'))
			{
				holdTimer += elapsed;
			}

			var daveVar:Float = 4;

			if (holdTimer >= Conductor.stepCrochet * daveVar * 0.001)
			{
				dance(POOP);
				holdTimer = 0;
			}
		}

		if (bopDance)
		{
			if (animation.curAnim.name == 'hairFall' && animation.curAnim.finished)
				playAnim('danceRight');
		}

		super.update(elapsed);
	}

	private var danced:Bool = false;

	/**
	 * FOR DANCING SHIT
	 */
	public function dance(alt:Bool = false)
	{
		if (!debugMode && canDance)
		{
			var poopInPants:String = alt ? '-alt' : '';
			if (bopDance)
			{
				if (!animation.curAnim.name.startsWith('hair'))
				{
					danced = !danced;

					if (danced)
						playAnim('danceRight' + poopInPants, true);
					else
						playAnim('danceLeft' + poopInPants, true);
				}
			}
			else
				playAnim('idle' + poopInPants, true);
		}
	}

	public function playAnim(AnimName:String, Force:Bool = false, Reversed:Bool = false, Frame:Int = 0):Void
	{
		if (animation.getByName(AnimName) == null)
		{
			return;
		}
		if (AnimName.toLowerCase().startsWith('idle') && !canDance)
		{
			return;
		}
		animation.play(AnimName, Force, Reversed, Frame);

		var daOffset = animOffsets.get(AnimName);
		if (animOffsets.exists(AnimName))
		{
			if (isPlayer)
			{
				if (!nativelyPlayable)
				{
					offset.set((daOffset[0] * -1) + globaloffset[0], daOffset[1] + globaloffset[1]);
				}
				else
				{
					offset.set(daOffset[0] + globaloffset[0], daOffset[1] + globaloffset[1]);
				}
			}
			else
			{
				if (nativelyPlayable)
				{
					offset.set((daOffset[0] * -1), daOffset[1]);
				}
				else
				{
					offset.set(daOffset[0], daOffset[1]);
				}
			}
		}
		else
			offset.set(0, 0);

		if (bopDance)
		{
			if (AnimName == 'singLEFT')
			{
				danced = true;
			}
			else if (AnimName == 'singRIGHT')
			{
				danced = false;
			}

			if (AnimName == 'singUP' || AnimName == 'singDOWN')
			{
				danced = !danced;
			}
		}
	}

	function parseDataFile() // kadedev i love you i will do anything for you
	{
		// Load the data from JSON and cast it to a struct we can easily read.
		var path:String = Paths.json('characters/${curCharacter}');
		trace(path);
		var rawJson = Assets.getText(path);
		var jsonData:CharacterData = cast Json.parse(rawJson);
		trace(jsonData);

		var data:CharacterData = cast jsonData;
		trace(data.name, curCharacter);

		barColorArray = (data.barColor != null && data.barColor.length > 2) ? data.barColor : [161, 161, 161];
		trace(data.name, barColorArray, barColorArray[0], barColorArray[1], barColorArray[2], '1');
		var tex:FlxAtlasFrames;
		tex = Paths.getSparrowAtlas(data.asset);
		frames = tex;
		if (frames != null)
			for (anim in data.animations)
			{
				var frameRate = anim.frameRate == null ? 24 : anim.frameRate;
				var looped = anim.looped == null ? false : anim.looped;

				if (anim.frameIndices != null)
				{
					animation.addByIndices(anim.name, anim.prefix, anim.frameIndices, "", frameRate, looped, anim.flipX);
				}
				else
				{
					animation.addByPrefix(anim.name, anim.prefix, frameRate, looped, anim.flipX);
				}

				loadOffsetFile(curCharacter);
			}

		// do dances use DanceLeft / DanceRight?
		bopDance = data.bopDance == null ? false : data.bopDance;

		antialiasing = data.antialiasing == null ? true : data.antialiasing;

		nativelyPlayable = data.nativelyPlayable == null ? false : data.nativelyPlayable;

		flipX = data.flipX == null ? false : data.flipX;

		if (data.causeCameraShake)
			PlayState.shakingChars.push(curCharacter);

		floater = data.float == null ? 'false' : data.float; // add easy

		charScale = data.scale == null ? 1 : data.scale; // add normal

		noteStyle = data.noteStyle == null ? '2D' : data.noteStyle; // add hard

		if (noteStyle == '3D')
		{
			if (Note.CharactersWith3D.contains(curCharacter))
			{
				Note.CharactersWith3D.remove(curCharacter);
			}
			Note.CharactersWith3D.push(curCharacter);
		}
		if (noteStyle == 'pixel')
		{
			if (Note.CharactersWithPixel.contains(curCharacter))
			{
				Note.CharactersWithPixel.remove(curCharacter);
			}
			Note.CharactersWithPixel.push(curCharacter);
		}
		trace(data.name, noteStyle);

		iconName = data.icon;

		trace(data.name, iconName);

		switch (curCharacter) // TODO: make scaling work for the life of me
		{
			default: // furiosityScale has been deprecated!
				if (data.scaleSize)
					scale.set(charScale, charScale); // scale can be a float
				else
					setGraphicSize(Std.int(width * charScale), Std.int(height * charScale)); // setGraphicSize cannot
		}
		trace(data.scaleSize);
		trace(charScale);
		trace(Std.int(width * charScale), Std.int(height * charScale));
		updateHitbox();
		globaloffset = data.globalOffset; // mostly dependency for tha cores
		gameOffset = data.gameOffset;
		camOffset = data.camOffset;
		barColor = FlxColor.fromRGB(barColorArray[0], barColorArray[1], barColorArray[2]);

		playAnim(data.bopDance ? 'danceRight' : 'idle');
	}

	function loadOffsetFile(character:String)
	{
		var offsetStuffs:Array<String> = CoolUtil.coolTextFile(Paths.offsetFile(character));

		for (offsetText in offsetStuffs)
		{
			var offsetInfo:Array<String> = offsetText.split(' ');

			addOffset(offsetInfo[0], Std.parseFloat(offsetInfo[1]), Std.parseFloat(offsetInfo[2]));
		}
	}

	public function addOffset(name:String, x:Float = 0, y:Float = 0)
	{
		animOffsets[name] = [x, y];
	}
}
