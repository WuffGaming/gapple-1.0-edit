package;

import sys.FileSystem;
import sys.io.File;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.animation.FlxBaseAnimation;
import flixel.graphics.frames.FlxAtlasFrames;
import haxe.Json;
import haxe.format.JsonParser;

using StringTools;

typedef CharacterFile =
{
	var animations:Array<Anim>;
	var barcolor:RGB;
    var	antialiasing:Bool;
	var characterImage:String;
    var icon:String;
	var flipX:Bool;
	var updateHitbox:Bool;
	var setGraphicSize:String;
	var nativelyPlayable:Bool;
	var bopDance:Bool;
}

typedef Anim = 
{
	var animName:String;
	var anim:String;
	var fps:Int;
	var loop:Bool;
}

typedef RGB = 
{
	var red:Int;
	var green:Int;
	var blue:Int;
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

	public var rawJsonCustom:String;
	public var charJson:CharacterFile;

	public var globaloffset:Array<Float> = [0,0];

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
			case 'gf':
				// GIRLFRIEND CODE
				tex = Paths.getSparrowAtlas('characters/main/GF_assets');
				frames = tex;
				animation.addByPrefix('cheer', 'GF Cheer', 24, false);
				animation.addByPrefix('singLEFT', 'GF left note', 24, false);
				animation.addByPrefix('singRIGHT', 'GF Right Note', 24, false);
				animation.addByPrefix('singUP', 'GF Up Note', 24, false);
				animation.addByPrefix('singDOWN', 'GF Down Note', 24, false);
				animation.addByIndices('sad', 'gf sad', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", 24, false);
				animation.addByIndices('danceLeft', 'GF Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
				animation.addByIndices('hairBlow', "GF Dancing Beat Hair blowing", [0, 1, 2, 3], "", 24);
				animation.addByIndices('hairFall', "GF Dancing Beat Hair Landing", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11], "", 24, false);
				animation.addByPrefix('scared', 'GF FEAR', 24);

				loadOffsetFile(curCharacter);

				iconName = 'gf';
				barColor = FlxColor.fromString('#B50154');
				bopDance = true;

				playAnim('danceRight');
			case 'gamingtastic':
				// GAMINGTASTIC CODE
				tex = Paths.getSparrowAtlas('characters/radical/newgaming');
				frames = tex;
				animation.addByPrefix('danceLeft', 'idlel', 24, false);
				animation.addByPrefix('danceRight', 'idler', 24, false);

				loadOffsetFile(curCharacter);
				// offsets for radical and gamingtastic were stolen from 1.5... sorry!

				barColor = FlxColor.fromString('#33de39');
				bopDance = true;

				playAnim('danceRight');
			case 'gf-only':
				frames = Paths.getSparrowAtlas('characters/main/GF_ONLY');
				animation.addByIndices('sad', 'gf sad', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", 24, false);
				animation.addByIndices('danceLeft', 'GF Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);

				loadOffsetFile(curCharacter);
				iconName = 'gf';
				barColor = FlxColor.fromString('#33de39');
				bopDance = true;

				playAnim('danceRight');
			case '3d-bf':
				frames = Paths.getSparrowAtlas('characters/main/3D_BF');
				animation.addByPrefix('idle', 'idle', 24, false);
				animation.addByPrefix('singUP', 'up', 24, false);
				animation.addByPrefix('singLEFT', 'left', 24, false);
				animation.addByPrefix('singRIGHT', 'right', 24, false);
				animation.addByPrefix('singDOWN', 'down', 24, false);
				animation.addByPrefix('singUPmiss', 'missedup', 24, false);
				animation.addByPrefix('singLEFTmiss', 'missedleft', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'missedright', 24, false);
				animation.addByPrefix('singDOWNmiss', 'misseddown', 24, false);
				animation.addByPrefix('hey', 'BF HEY', 24, false);

				loadOffsetFile(curCharacter);

				nativelyPlayable = flipX = true;

				antialiasing = false;
				iconName = 'bf-3d';
				barColor = FlxColor.fromRGB(49, 176, 209);

				playAnim('idle');
			case '3d-gf':
				frames = Paths.getSparrowAtlas('characters/main/3D_GF');
				animation.addByPrefix('danceLeft', 'danceLeft', 24, false);
				animation.addByPrefix('danceRight', 'danceRight', 24, false);

				loadOffsetFile(curCharacter);

				antialiasing = false;
				iconName = 'gf';
				barColor = FlxColor.fromString('#33de39');
				bopDance = true;

				playAnim('danceRight');
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
			case 'dave-png':
				frames = Paths.getSparrowAtlas('characters/dave/dave-png');
				animation.addByPrefix('idle', 'idle', 24, false);
				for (anim in ['left', 'down', 'up', 'right']) {
					animation.addByPrefix('sing${anim.toUpperCase()}', anim, 24, false);
				}

				loadOffsetFile(curCharacter);

				iconName = 'dave';
				barColor = FlxColor.fromRGB(15, 95, 255);

				playAnim('idle');
			case 'split-dave-3d':
				// DAVE SHITE ANIMATION LOADING CODE
				tex = Paths.getSparrowAtlas('characters/dave/split_dave_3d');
				frames = tex;
				animation.addByPrefix('idle', 'idle', 24, false);
				animation.addByPrefix('singUP', 'up', 24, false);
				animation.addByPrefix('singRIGHT', 'right', 24, false);
				animation.addByPrefix('singDOWN', 'down', 24, false);
				animation.addByPrefix('singLEFT', 'left', 24, false);
		
				loadOffsetFile(curCharacter);
				setGraphicSize(Std.int(width * furiosityScale),Std.int(height * furiosityScale));
				updateHitbox();
				antialiasing = false;
				iconName = 'dave-3d';
				barColor = FlxColor.fromRGB(255, 203, 230);
		
				playAnim('idle');

			case 'insane-dave-3d':
				// DAVE SHITE ANIMATION LOADING CODE
				tex = Paths.getSparrowAtlas('characters/dave/insane_dave_3d');
				frames = tex;
				animation.addByPrefix('idle', 'idle', 24, false);
				animation.addByPrefix('singUP', 'up', 24, false);
				animation.addByPrefix('singRIGHT', 'right', 24, false);
				animation.addByPrefix('singDOWN', 'down', 24, false);
				animation.addByPrefix('singLEFT', 'left', 24, false);
		
				loadOffsetFile(curCharacter);
				setGraphicSize(Std.int(width * furiosityScale),Std.int(height * furiosityScale));
				updateHitbox();
				antialiasing = false;
				iconName = 'dave-3d';
				barColor = FlxColor.fromRGB(255, 203, 230);
		
				playAnim('idle');


			case 'bandu-origin':
				tex = Paths.getSparrowAtlas('characters/bandu/bandu_origin');
				frames = tex;
				animation.addByPrefix('idle', 'IDLE', 24, false);
				animation.addByPrefix('singUP', 'UP', 24, false);
				animation.addByPrefix('singRIGHT', 'RIGHT', 24, false);
				animation.addByPrefix('singDOWN', 'DOWN', 24, false);
				animation.addByPrefix('singLEFT', 'LEFT', 24, false);
				animation.addByPrefix('cutscene', 'CUTSCENE', 24, false);
		
				loadOffsetFile(curCharacter);
				setGraphicSize(Std.int(width * furiosityScale),Std.int(height * furiosityScale));
				updateHitbox();
				antialiasing = false;
				iconName = 'bandu-origin';
				barColor = FlxColor.fromRGB(255, 255, 179);

				playAnim('idle');

			case 'cameo-origin':
				tex = Paths.getSparrowAtlas('characters/bandu/cameo_origin');
				frames = tex;
				animation.addByPrefix('idle', 'idle', 24, false);
				animation.addByPrefix('singUP', 'up', 24, false);
				animation.addByPrefix('singRIGHT', 'right', 24, false);
				animation.addByPrefix('singDOWN', 'down', 24, false);
				animation.addByPrefix('singLEFT', 'left', 24, false);
		
				loadOffsetFile(curCharacter);
				setGraphicSize(Std.int(width * furiosityScale),Std.int(height * furiosityScale));
				updateHitbox();
				antialiasing = false;

				nativelyPlayable = true;

				flipX = true;
				iconName = 'cameo';
				barColor = FlxColor.fromRGB(251, 247, 50);

				playAnim('idle');


			case 'RECOVERED_PROJECT':
				tex = Paths.getSparrowAtlas('characters/recover/RECOVERED_PROJECT_01');
				frames = tex;
				animation.addByPrefix('idle', 'idle', 24, false);
				animation.addByPrefix('singUP', 'up', 24, false);
				animation.addByPrefix('singRIGHT', 'right', 24, false);
				animation.addByPrefix('singDOWN', 'down', 24, false);
				animation.addByPrefix('singLEFT', 'left', 24, false);
		
				loadOffsetFile(curCharacter);
				setGraphicSize(Std.int(width * furiosityScale),Std.int(height * furiosityScale));
				updateHitbox();
				antialiasing = false;
				iconName = 'recover';
				barColor = FlxColor.fromRGB(201, 191, 183);
		
				playAnim('idle');

			case 'RECOVERED_PROJECT_2':
				tex = Paths.getSparrowAtlas('characters/recover/recovered_project_2');
				frames = tex;
				animation.addByPrefix('idle', 'IDLE', 24, true);
				animation.addByPrefix('singUP', 'UP', 24, false);
				animation.addByPrefix('singRIGHT', 'RIGHT', 24, false);
				animation.addByPrefix('singDOWN', 'DOWN', 24, false);
				animation.addByPrefix('singLEFT', 'LEFT', 24, false);
		
				loadOffsetFile(curCharacter);
				setGraphicSize(Std.int(765 * furiosityScale),Std.int(903 * furiosityScale));
				updateHitbox();
				antialiasing = false;
				iconName = 'recover-2d';
				barColor = FlxColor.fromRGB(201, 191, 183);
		
				playAnim('idle');

			case 'RECOVERED_PROJECT_3':
				tex = Paths.getSparrowAtlas('characters/recover/recovered_project_3');
				frames = tex;
				animation.addByPrefix('idle', 'IDLE', 24, false);
				animation.addByPrefix('singUP', 'UP', 24, false);
				animation.addByPrefix('singRIGHT', 'RIGHT', 24, false);
				animation.addByPrefix('singDOWN', 'DOWN', 24, false);
				animation.addByPrefix('singLEFT', 'LEFT', 24, false);
		
				loadOffsetFile(curCharacter);
				setGraphicSize(Std.int(765 * furiosityScale),Std.int(903 * furiosityScale));
				updateHitbox();
				antialiasing = false;
				iconName = 'recover-irreversible';
				barColor = FlxColor.fromRGB(201, 191, 183);
		
				playAnim('idle');

			case 'badai':
				// BADAI SHITE ANIMATION LOADING CODE
				tex = Paths.getSparrowAtlas('characters/bandu/badai');
				frames = tex;
				animation.addByPrefix('idle', 'IDLE', 24, false);
				animation.addByPrefix('singUP', 'UP', 24, false);
				animation.addByPrefix('singRIGHT', 'RIGHT', 24, false);
				animation.addByPrefix('singDOWN', 'DOWN', 24, false);
				animation.addByPrefix('singLEFT', 'LEFT', 24, false);
		
				loadOffsetFile(curCharacter);
				setGraphicSize(Std.int(width * furiosityScale),Std.int(height * furiosityScale));
				updateHitbox();
				antialiasing = false;
				iconName = 'badai';
				barColor = FlxColor.fromRGB(218, 46, 138);
		
				playAnim('idle');

			case 'tunnel-dave':
				// DAVE SHITE ANIMATION LOADING CODE
				tex = Paths.getSparrowAtlas('characters/dave/tunnel_chase_dave');
				frames = tex;
				animation.addByPrefix('idle', 'IDLE', 24, false);
				animation.addByPrefix('singUP', 'UP', 24, false);
				animation.addByPrefix('singRIGHT', 'RIGHT', 24, false);
				animation.addByPrefix('singDOWN', 'DOWN', 24, false);
				animation.addByPrefix('singLEFT', 'LEFT', 24, false);
		
				loadOffsetFile(curCharacter);
				setGraphicSize(Std.int(width * furiosityScale),Std.int(height * furiosityScale));
				updateHitbox();
				antialiasing = false;
				iconName = 'dave-3d-suit';
				barColor = FlxColor.fromRGB(230, 62, 61);
		
				playAnim('idle');

			case 'og-dave':
				// DAVE SHITE ANIMATION LOADING CODE
				tex = Paths.getSparrowAtlas('characters/algebra/og_dave');
				frames = tex;
				animation.addByPrefix('idle', 'IDLE', 24, false);
				animation.addByPrefix('singUP', 'UP', 24, false);
				animation.addByPrefix('singRIGHT', 'RIGHT', 24, false);
				animation.addByPrefix('singDOWN', 'DOWN', 24, false);
				animation.addByPrefix('singLEFT', 'LEFT', 24, false);
				animation.addByPrefix('stand', 'STAND', 24, false);
		
				loadOffsetFile(curCharacter);

				setGraphicSize(Std.int(width * furiosityScale),Std.int(height * furiosityScale));
				updateHitbox();
				antialiasing = false;
				iconName = 'og-dave';
				barColor = FlxColor.fromRGB(181, 255, 255);
		
				playAnim('idle');

			case 'og-dave-angey':
				// DAVE SHITE ANIMATION LOADING CODE
				tex = Paths.getSparrowAtlas('characters/algebra/og_dave_angey');
				frames = tex;
				animation.addByPrefix('idle', 'IDLE', 24, false);
				animation.addByPrefix('singUP', 'UP', 24, false);
				animation.addByPrefix('singRIGHT', 'RIGHT', 24, false);
				animation.addByPrefix('singDOWN', 'DOWN', 24, false);
				animation.addByPrefix('singLEFT', 'LEFT', 24, false);
				animation.addByPrefix('stand', 'STAND', 24, false);
		
				loadOffsetFile(curCharacter);

				setGraphicSize(Std.int(width * furiosityScale),Std.int(height * furiosityScale));
				updateHitbox();
				antialiasing = false;
				iconName = 'og-dave';
				barColor = FlxColor.fromRGB(181, 255, 255);
		
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

			case 'dupers':
				// fucking Dupered out
				frames = Paths.getSparrowAtlas('characters/bambi/duperbamb');
				animation.addByPrefix('idle', 'Idle', 24, false);
				animation.addByPrefix('singDOWN', 'down', 24, false);
				animation.addByPrefix('singUP', 'up', 24, false);
				animation.addByPrefix('singLEFT', 'left', 24, false);
				animation.addByPrefix('singRIGHT', 'right', 24, false);

				loadOffsetFile(curCharacter);

				barColor = FlxColor.fromRGB(37, 191, 55);
				iconName = 'bambi-mad';
				playAnim('idle');

			case 'bambi-piss-3d':
				// BAMBI SHITE ANIMATION LOADING CODE
				tex = Paths.getSparrowAtlas('characters/bambi/bambi_pissyboy');
				frames = tex;
				animation.addByPrefix('idle', 'idle', 24, false);
				animation.addByPrefix('singDOWN', 'down', 24, false);
				animation.addByPrefix('singUP', 'up', 24, false);
				animation.addByPrefix('singLEFT', 'left', 24, false);
				animation.addByPrefix('singRIGHT', 'right', 24, false);
		
				loadOffsetFile(curCharacter);
				globaloffset[0] = 60;
				globaloffset[1] = 450; //this is the y
				setGraphicSize(Std.int(width / furiosityScale));
				updateHitbox();
				antialiasing = false;
				iconName = 'bambi-disrupt';
				barColor = FlxColor.fromRGB(37, 191, 55);
		
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
			case 'little-bandu':
				frames = Paths.getSparrowAtlas('characters/bandu/litt le bandu');
				
				animation.addByPrefix('idle', 'idle', 24, true);
				animation.addByPrefix('singUP', 'up', 24, false);
				animation.addByPrefix('singRIGHT', 'right', 24, false);
				animation.addByPrefix('singDOWN', 'down', 24, false);
				animation.addByPrefix('singLEFT', 'left', 24, false);
				
				loadOffsetFile(curCharacter);

				setGraphicSize(Std.int(width / furiosityScale));
				updateHitbox();

				antialiasing = false;
				iconName = 'bandu';
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
			case 'bambi-good':
				// ships my cute
				frames = Paths.getSparrowAtlas('characters/bambi/PLACEHOLDER_BAMBI');
				animation.addByPrefix('idle', 'Idle', 24, false);
				animation.addByPrefix('singDOWN', 'down', 24, false);
				animation.addByPrefix('singUP', 'up', 24, false);
				animation.addByPrefix('singLEFT', 'left', 24, false);
				animation.addByPrefix('singRIGHT', 'right', 24, false);

				loadOffsetFile(curCharacter);
				iconName = 'bambi';
				barColor = FlxColor.fromRGB(37, 191, 55);

				playAnim('idle');
			case 'dave-good':
				// not a placeholder
				tex = Paths.getSparrowAtlas('characters/dave/PLACEHOLDER_DAVE');
				frames = tex;
				animation.addByPrefix('idle', 'idleDance', 24, false);
				animation.addByPrefix('singUP', 'Up', 24, false);
				animation.addByPrefix('singRIGHT', 'Right', 24, false);
				animation.addByPrefix('singDOWN', 'Down', 24, false);
				animation.addByPrefix('singLEFT', 'Left', 24, false);
	
				loadOffsetFile(curCharacter);
				iconName = 'dave';
				barColor = FlxColor.fromRGB(15, 95, 255);

				playAnim('idle');

			case 'dave':
				// maybe a placeholder
				tex = Paths.getSparrowAtlas('characters/dave/PLACEHOLDER_DAVE');
				frames = tex;
				animation.addByPrefix('idle', 'idleDance', 24, false);
				animation.addByPrefix('singUP', 'Up', 24, false);
				animation.addByPrefix('singRIGHT', 'Right', 24, false);
				animation.addByPrefix('singDOWN', 'Down', 24, false);
				animation.addByPrefix('singLEFT', 'Left', 24, false);
	
				loadOffsetFile(curCharacter);
				iconName = 'dave';
				barColor = FlxColor.fromRGB(15, 95, 255);

				playAnim('idle');


			case 'dave-insane':
				// ji
				tex = Paths.getSparrowAtlas('characters/dave/INSANE_DAVE');
				frames = tex;
				animation.addByPrefix('idle', 'Idle', 24, false);
				animation.addByPrefix('singUP', 'Up', 24, false);
				animation.addByPrefix('singRIGHT', 'Right', 24, false);
				animation.addByPrefix('singDOWN', 'Down', 24, false);
				animation.addByPrefix('singLEFT', 'Left', 24, false);
	
				loadOffsetFile(curCharacter);
				iconName = 'dave';
				barColor = FlxColor.fromRGB(15, 95, 255);
				playAnim('idle');
			case 'unfair-junker':
				frames = Paths.getSparrowAtlas('characters/bambi/NEWER UNFAIR GUY');
				animation.addByPrefix('danceLeft', 'danceLeft', 24, false);
				animation.addByPrefix('danceRight', 'danceRight', 24, false);
				animation.addByPrefix('singUP', 'up', 24, false);
				animation.addByPrefix('singLEFT', 'left', 24, false);
				animation.addByPrefix('singRIGHT', 'right', 24, false);
				animation.addByPrefix('singDOWN', 'down', 24, false);
				animation.addByPrefix('inhale', 'inhale', 24, false);


				loadOffsetFile(curCharacter);
				globaloffset[0] = 150 * 1.3;
				globaloffset[1] = 450 * 1.3; //this is the y
				setGraphicSize(Std.int((width * 1.3) / furiosityScale));
				updateHitbox();
				antialiasing = false;
				iconName = 'expunged';
				barColor = FlxColor.fromRGB(178, 7, 7);
				bopDance = true;
		
				playAnim('danceLeft');
				
			case 'bf':
				var tex = Paths.getSparrowAtlas('characters/main/Boyfriend_Main');
				frames = tex;
				animation.addByPrefix('idle', 'BF idle dance', 24, false);
				animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
				animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
				animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);
				animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
				animation.addByPrefix('singUPmiss', 'BF NOTE UP MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BF NOTE LEFT MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF NOTE RIGHT MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS', 24, false);
				animation.addByPrefix('hey', 'BF HEY', 24, false);


				loadOffsetFile(curCharacter);

				playAnim('idle');

				nativelyPlayable = true;
				iconName = 'bf';
				barColor = FlxColor.fromRGB(49, 176, 209);

				flipX = true;

			case 'bf-dead':
				var tex = Paths.getSparrowAtlas('characters/main/Boyfriend_Dead');
				frames = tex;

				animation.addByPrefix('firstDeath', "BF dies", 24, false);
				animation.addByPrefix('deathLoop', "BF Dead Loop", 24, true);
				animation.addByPrefix('deathConfirm', "BF Dead confirm", 24, false);

				loadOffsetFile(curCharacter);

				playAnim('firstDeath');

				nativelyPlayable = true;
				iconName = 'bf';
				barColor = FlxColor.fromRGB(49, 176, 209);

				flipX = true;


			case 'radical':
				var tex = Paths.getSparrowAtlas('characters/radical/radical');
				frames = tex;
				animation.addByPrefix('idle', 'idle', 24, false);
				animation.addByPrefix('singUP', 'up', 24, false);
				animation.addByPrefix('singLEFT', 'left', 24, false);
				animation.addByPrefix('singRIGHT', 'right', 24, false);
				animation.addByPrefix('singDOWN', 'down', 24, false);
				animation.addByPrefix('singUPmiss', 'MISS up', 24, false);
				animation.addByPrefix('singLEFTmiss', 'MISS left', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'MISS right', 24, false);
				animation.addByPrefix('singDOWNmiss', 'MISS down', 24, false);
				animation.addByPrefix('hey', 'hey', 24, false);

				loadOffsetFile(curCharacter);

				playAnim('idle');

				nativelyPlayable = true;
				iconName = 'radical';
				barColor = FlxColor.fromRGB(188, 70, 70);

				flipX = true;


			case 'tunnel-bf':
				var tex = Paths.getSparrowAtlas('characters/dave/tunnel_bf');
				frames = tex;

				animation.addByPrefix('idle', 'IDLE', 24, false);
				animation.addByPrefix('singUP', 'UP', 24, false);
				animation.addByPrefix('singLEFT', 'LEFT', 24, false);
				animation.addByPrefix('singRIGHT', 'RIGHT', 24, false);
				animation.addByPrefix('singDOWN', 'DOWN', 24, false);
				animation.addByPrefix('turn', 'TURN', 24, false);

				loadOffsetFile(curCharacter);

				playAnim('idle');

				barColor = FlxColor.fromRGB(49, 176, 209);
				iconName = 'bf';
				flipX = true;

				nativelyPlayable = true;
				
			/**
			case 'afnfg-boyfriend':
				var tex = Paths.getSparrowAtlas('characters/other/afnfg_boyfriend');
				frames = tex;

				animation.addByPrefix('idle', 'idl', 60, false);
				animation.addByPrefix('singUP', 'up', 24, false);
				animation.addByPrefix('singLEFT', 'left', 24, false);
				animation.addByPrefix('singRIGHT', 'right', 24, false);
				animation.addByPrefix('singDOWN', 'down', 24, false);

				loadOffsetFile(curCharacter);

				playAnim('idle');
				iconName = 'bf-3d';
				barColor = FlxColor.fromRGB(49, 176, 209);

				flipX = true;

				nativelyPlayable = true;
			**/
			//tunnel-bf-flipped cuz im STUPID
			case 'tunnel-bf-flipped':
				var tex = Paths.getSparrowAtlas('characters/dave/tunnel_bf');
				frames = tex;

				animation.addByPrefix('idle', 'IDLE', 24, false);
				animation.addByPrefix('singUP', 'UP', 24, false);
				animation.addByPrefix('singRIGHT', 'LEFT', 24, false);
				animation.addByPrefix('singLEFT', 'RIGHT', 24, false);
				animation.addByPrefix('singDOWN', 'DOWN', 24, false);
				animation.addByPrefix('turn', 'TURN', 24, false);

				loadOffsetFile(curCharacter + '-flipped');
				iconName = 'bf';
				playAnim('idle');

				barColor = FlxColor.fromRGB(49, 176, 209);

				nativelyPlayable = true;
			default:
				// THANX DAVE AND BAMBI MODDABLE BY CamLikesKirby I USED IT AS A REFERENCE FOR A LOT OF THIS!!
				var customPath:String = '';
				if (FileSystem.exists('data/characters/${curCharacter}.json'))
				{
					customPath = 'data/characters/${curCharacter}.json';
					rawJsonCustom = File.getContent(customPath);
			    	charJson = cast Json.parse(rawJsonCustom);

					if (charJson.characterImage != null) {
						tex = Paths.getCustomSparrowAtlas(charJson.characterImage);

					frames = tex;

					for (i in charJson.animations) {
						animation.addByPrefix(i.animName, i.anim, i.fps, i.loop);
					}

					barColor = FlxColor.fromRGB(charJson.barcolor.red, charJson.barcolor.green, charJson.barcolor.blue);
					bopDance = charJson.bopDance;
					loadOffsetFile(curCharacter);
					iconName = charJson.icon;
					nativelyPlayable = charJson.nativelyPlayable;
					flipX = charJson.flipX;
					antialiasing = charJson.antialiasing;

					if (charJson.setGraphicSize != null)
						setGraphicSize(Std.parseInt(charJson.setGraphicSize));
					if (charJson.updateHitbox)
						updateHitbox;
					playAnim(charJson.bopDance ? 'danceRight' : 'idle');
				}
			}
		dance();

		if(isPlayer)
		{
			flipX = !flipX;
		}
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
			//WHY THE FUCK WAS THIS TRACE HERE
			//trace(AnimName);
			return; //why wasn't this a thing in the first place
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
	
		if (curCharacter == 'gf')
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
