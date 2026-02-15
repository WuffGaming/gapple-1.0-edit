package;

//import sys.FileSystem;
//import sys.io.File;
import haxe.io.Path;
import openfl.utils.ByteArray;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.animation.FlxBaseAnimation;
import flixel.graphics.frames.FlxAtlasFrames;
import haxe.Json;
import haxe.format.JsonParser;

using StringTools;

typedef CharacterData =
{
	var name:String;
	var asset:String;

	/**
	 * The color of this character's health bar.
	 */
	var barColor:Array<Int>;
	var globalOffset:Array<Float>;
	var gameOffset:Array<Float>;
	var camOffset:Array<Float>;

	var ?bopDance:Bool;

	var ?nativelyPlayable:Bool;

	var ?flipX:Bool;

	var ?antialiasing:Bool;

	var scale:String;

	var float:String;

	var icon:String;

	var animations:Array<AnimationData>;
}

typedef AnimationData =
{
	var name:String;
	var prefix:String;

	/**
	 * Whether this animation is looped.
	 * @default false
	 */
	var ?looped:Bool;

	var ?flipX:Bool;

	/**
	 * The frame rate of this animation.
	 		* @default 24
	 */
	var ?frameRate:Int;

	var ?frameIndices:Array<Int>;
}
class Character extends FlxSprite
{

	public var animOffsets:Map<String, Array<Dynamic>>;
	public var debugMode:Bool = false;

	public var isPlayer:Bool = false;
	public var curCharacter:String = 'bf';
	public var iconName:String = 'face';

	public var holdTimer:Float = 0;
	public var furiosityScale:Float = 1.02;
	public var canDance:Bool = true;

	public var nativelyPlayable:Bool = false;
	public var barColor:FlxColor;
	public var bopDance:Bool = false;

	public var globaloffset:Array<Float> = [0,0];
	public var gameOffset:Array<Float> = [0,0];
	public var camOffset:Array<Float> = [0,0];
	public var floater:String = 'false';

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
			case 'silly-sally':
				frames = Paths.getSparrowAtlas('characters/warehouse/sillysally');
				animation.addByPrefix('idle', 'idle', 24, false);
				animation.addByPrefix('singUP', 'up', 24, false);
				animation.addByPrefix('singLEFT', 'left', 24, false);
				animation.addByPrefix('singRIGHT', 'right', 24, false);
				animation.addByPrefix('singDOWN', 'down', 24, false);

				loadOffsetFile(curCharacter);

				setGraphicSize(Std.int(width / furiosityScale));
				updateHitbox();

				antialiasing = false;
				iconName = 'silly-sally';
				barColor = FlxColor.fromRGB(131, 246, 50);

				playAnim('idle');
			case 'playrobot':
				frames = Paths.getSparrowAtlas('characters/algebra/playrobot');

				animation.addByPrefix('idle', 'Idle', 24, true);
				animation.addByPrefix('singUP', 'Up', 24, false);
				animation.addByPrefix('singLEFT', 'Left', 24, false);
				animation.addByPrefix('singRIGHT', 'Right', 24, false);
				animation.addByPrefix('singDOWN', 'Down', 24, false);

				loadOffsetFile(curCharacter);

				antialiasing = false;
				iconName = 'playrobot';
				barColor = FlxColor.fromRGB(162, 150, 188);

				playAnim('idle');
			case 'playrobot-crazy':
				frames = Paths.getSparrowAtlas('characters/algebra/ohshit');

				animation.addByPrefix('idle', 'Idle', 24, true);
				animation.addByPrefix('singUP', 'Up', 24, false);
				animation.addByPrefix('singLEFT', 'Left', 24, false);
				animation.addByPrefix('singRIGHT', 'Right', 24, false);
				animation.addByPrefix('singDOWN', 'Down', 24, false);

				loadOffsetFile(curCharacter);

				antialiasing = false;
				iconName = 'playrobot';
				barColor = FlxColor.fromRGB(162, 150, 188);

				playAnim('idle');
			case 'hall-monitor':
				frames = Paths.getSparrowAtlas('characters/algebra/HALL_MONITOR');
				animation.addByPrefix('idle', 'gdj', 24, false);
				for (anim in ['left', 'down', 'up', 'right']) {
					animation.addByPrefix('sing${anim.toUpperCase()}', anim, 24, false);
				}

				loadOffsetFile(curCharacter);

				antialiasing = false;
				scale.set(1.5, 1.5);
				updateHitbox();
				iconName = 'green-hall-monitor';
				barColor = FlxColor.fromRGB(37, 191, 55);

				playAnim('idle');
			case 'diamond-man':
				frames = Paths.getSparrowAtlas('characters/algebra/diamondMan');
				animation.addByPrefix('idle', 'idle', 24, true);
				for (anim in ['left', 'down', 'up', 'right']) {
					animation.addByPrefix('sing${anim.toUpperCase()}', anim, 24, false);
				}

				loadOffsetFile(curCharacter);

				scale.set(1.3, 1.3);
				updateHitbox();
				iconName = 'diamond-man';
				antialiasing = false;

				barColor = FlxColor.fromRGB(129, 180, 227);

				playAnim('idle');
			case 'ringi':
				frames = Paths.getSparrowAtlas('characters/oc/ringi');
				animation.addByPrefix('idle', 'idle', 24, false);
				animation.addByPrefix('singUP', 'up', 24, false);
				animation.addByPrefix('singLEFT', 'left', 24, false);
				animation.addByPrefix('singRIGHT', 'right', 24, false);
				animation.addByPrefix('singDOWN', 'down', 24, false);

				animation.addByPrefix('catappear', 'catappear', 24, false);

				animation.addByPrefix('idle-alt', 'altidle', 24, false);
				animation.addByPrefix('singUP-alt', 'altup', 24, false);
				animation.addByPrefix('singLEFT-alt', 'altleft', 24, false);
				animation.addByPrefix('singRIGHT-alt', 'altright', 24, false);
				animation.addByPrefix('singDOWN-alt', 'altdown', 24, false);

				loadOffsetFile(curCharacter);

				setGraphicSize(Std.int(width * furiosityScale),Std.int(height * furiosityScale));
				updateHitbox();
				iconName = 'ringi';
				antialiasing = false;

				barColor = FlxColor.fromRGB(199, 164, 165);

				playAnim('idle');
			case 'bambom':
				frames = Paths.getSparrowAtlas('characters/oc/bambom');
				animation.addByPrefix('idle', 'idle', 24, false);
				for (anim in ['left', 'down', 'up', 'right']) {
					animation.addByPrefix('sing${anim.toUpperCase()}', anim, 24, false);
				}

				loadOffsetFile(curCharacter);

				//furiosityScale = 0.75;

				setGraphicSize(Std.int(width * furiosityScale),Std.int(height * furiosityScale));
				updateHitbox();

				antialiasing = false;
				iconName = 'bambom';
				barColor = FlxColor.fromRGB(255, 0, 0);

				playAnim('idle');
			case 'bendu':
				frames = Paths.getSparrowAtlas('characters/oc/bendu');
				animation.addByPrefix('idle', 'IDLE', 24, false);
				for (anim in ['LEFT', 'DOWN', 'UP', 'RIGHT']) {
					animation.addByPrefix('sing${anim.toUpperCase()}', anim, 24, false);
				}

				loadOffsetFile(curCharacter);

				setGraphicSize(Std.int(width * furiosityScale),Std.int(height * furiosityScale));
				updateHitbox();

				antialiasing = false;

				barColor = FlxColor.fromRGB(253, 253, 63);
				iconName = 'bendu';
				playAnim('idle');
			case 'garrett':
				// DAVE SHITE ANIMATION LOADING CODE
				tex = Paths.getSparrowAtlas('characters/algebra/garrett_algebra');
				frames = tex;
				animation.addByPrefix('idle', 'IDLE', 24, false);
				animation.addByPrefix('singUP', 'UP', 24, false);
				animation.addByPrefix('singRIGHT', 'RIGHT', 24, false);
				animation.addByPrefix('singDOWN', 'DOWN', 24, false);
				animation.addByPrefix('singLEFT', 'LEFT', 24, false);
				animation.addByPrefix('stand', 'STAND', 24, false);
				animation.addByPrefix('scared', 'SHOCKED', 24, false);
		
				loadOffsetFile(curCharacter);

				furiosityScale = 1.3;

				setGraphicSize(Std.int(width * furiosityScale),Std.int(height * furiosityScale));
				updateHitbox();
				antialiasing = false;
				iconName = 'garrett';
				barColor = FlxColor.fromRGB(253, 253, 63);
		
				playAnim('idle');

			case 'bandu':
				frames = Paths.getSparrowAtlas('characters/bandu/bandu');
				
				animation.addByPrefix('idle', 'idle', 24, true);
				animation.addByPrefix('singUP', 'up', 24, false);
				animation.addByPrefix('singRIGHT', 'right', 24, false);
				animation.addByPrefix('singDOWN', 'down', 24, false);
				animation.addByPrefix('singLEFT', 'left', 24, false);
				
				animation.addByIndices('idle-alt', 'phones fall', [17], '', 24, false);
				animation.addByPrefix('singUP-alt', 'sad up', 24, false);
				animation.addByPrefix('singRIGHT-alt', 'sad right', 24, false);
				animation.addByPrefix('singDOWN-alt', 'sad down', 24, false);
				animation.addByPrefix('singLEFT-alt', 'sad left', 24, false);

				animation.addByIndices('NOOMYPHONES', 'phones fall', [0, 2, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 17], '', 24, false);
				
				loadOffsetFile(curCharacter);

				globaloffset[0] = 150;
				globaloffset[1] = 450;

				setGraphicSize(Std.int(width / furiosityScale));
				updateHitbox();
				iconName = 'bandu';
				antialiasing = false;

				barColor = FlxColor.fromRGB(72, 254, 45);

				playAnim('idle');
			case 'bandu-candy':
				frames = Paths.getSparrowAtlas('characters/bandu/bandu_crazy');
				
				animation.addByIndices('danceLeft', 'IDLE', [0, 1, 2, 3, 4, 5], '', 24, false);
				animation.addByIndices('danceRight', 'IDLE', [9, 8, 7, 6, 5, 4], '', 24, false);
				animation.addByPrefix('singUP', 'UP', 24, false);
				animation.addByPrefix('singRIGHT', 'RIGHT', 24, false);
				animation.addByPrefix('singDOWN', 'DOWN', 24, false);
				animation.addByPrefix('singLEFT', 'LEFT', 24, false);
				animation.addByPrefix('singUP-alt', 'ALT-UP', 24, false);
				animation.addByPrefix('singRIGHT-alt', 'ALT-RIGHT', 24, false);
				animation.addByPrefix('singDOWN-alt', 'ALT-DOWN', 24, false);
				animation.addByPrefix('singLEFT-alt', 'ALT-LEFT', 24, false);

				loadOffsetFile(curCharacter);

				setGraphicSize(Std.int(width / furiosityScale));
				updateHitbox();
				iconName = 'bandu-sugar';
				antialiasing = false;
				bopDance = true;

				barColor = FlxColor.fromRGB(72, 254, 45);

				playAnim('danceLeft');
			default:
				parseDataFile();
			}
		dance();

		if(isPlayer)
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

		if (bopDance){
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
		if(AnimName.toLowerCase().startsWith('idle') && !canDance)
		{
			return;
		}
		animation.play(AnimName, Force, Reversed, Frame);
	
		var daOffset = animOffsets.get(AnimName);
		if (animOffsets.exists(AnimName))
		{
			if (isPlayer)
			{
				if(!nativelyPlayable)
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
				if(nativelyPlayable)
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
		var jsonData = Paths.loadJSON('characters/${curCharacter}');
		if (jsonData == null)
		{
			trace('Failed to parse JSON data for character ${curCharacter}');
			return;
		}

		var data:CharacterData = cast jsonData;
		trace(data.name);

		barColorArray = (data.barColor != null && data.barColor.length > 2) ? data.barColor : [161, 161, 161];
		trace(barColorArray, barColorArray[0], barColorArray[1], barColorArray[2], '1');

		var tex:FlxAtlasFrames = Paths.getSparrowAtlas(data.asset, 'preload');
		frames = tex;
		if (frames != null)
			for (anim in data.animations)
			{
				var frameRate = anim.frameRate == null ? 24 : anim.frameRate;
				var looped = anim.looped == null ? false : anim.looped;

				if (anim.frameIndices != null)
				{
					animation.addByIndices(anim.name, anim.prefix, anim.frameIndices, "", frameRate, looped);
					trace(anim.name, anim.prefix, 'Indices', anim.frameIndices, "", frameRate, looped);
				}
				else
				{
					animation.addByPrefix(anim.name, anim.prefix, frameRate, looped);
					trace(anim.name, anim.prefix, frameRate, looped);
				}

				loadOffsetFile(curCharacter);
			}
		
		bopDance = data.bopDance == null ? false : data.bopDance;
		antialiasing = data.antialiasing == null ? true : data.antialiasing;
		nativelyPlayable = data.nativelyPlayable == null ? false : data.nativelyPlayable;
		flipX = data.flipX == null ? false : data.flipX;
		floater = data.float == null ? 'false' : data.float; // add easy
		iconName = data.icon;
		setGraphicSize(Std.parseInt(data.scale));
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
