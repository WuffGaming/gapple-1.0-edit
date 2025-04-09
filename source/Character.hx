package;

import flixel.addons.effects.chainable.FlxEffectSprite;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.animation.FlxBaseAnimation;
import flixel.graphics.frames.FlxAtlasFrames;

using StringTools;

class Character extends FlxSprite
{

	public var animOffsets:Map<String, Array<Dynamic>>;
	public var debugMode:Bool = false;

	public var isPlayer:Bool = false;
	public var curCharacter:String = 'bf';

	public var holdTimer:Float = 0;
	public var furiosityScale:Float = 1.02;
	public var canDance:Bool = true;

	public var nativelyPlayable:Bool = false;
	public var barColor:FlxColor;

	public var globaloffset:Array<Float> = [0,0];

	public function new(x:Float, y:Float, ?character:String = "bf", ?isPlayer:Bool = false)
	{
		super(x, y);

		animOffsets = new Map<String, Array<Dynamic>>();
		curCharacter = character;
		this.isPlayer = isPlayer;

		var tex:FlxAtlasFrames;
		antialiasing = true;

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

				addOffset('cheer');
				addOffset('sad', -2, -2);
				addOffset('danceLeft', 0, -9);
				addOffset('danceRight', 0, -9);

				addOffset("singUP", 0, 4);
				addOffset("singRIGHT", 0, -20);
				addOffset("singLEFT", 0, -19);
				addOffset("singDOWN", 0, -20);
				addOffset('hairBlow', 45, -8);
				addOffset('hairFall', 0, -9);

				addOffset('scared', -2, -17);

				barColor = FlxColor.fromString('#33de39');

				playAnim('danceRight');
			case 'gamingtastic':
				// GAMINGTASTIC CODE
				tex = Paths.getSparrowAtlas('characters/radical/newgaming');
				frames = tex;
				animation.addByPrefix('danceLeft', 'idlel', 24, false);
				animation.addByPrefix('danceRight', 'idler', 24, false);

				addOffset('danceLeft', 0, -9);
				addOffset('danceRight', 0, -9);

				barColor = FlxColor.fromString('#33de39');

				playAnim('danceRight');
			case 'gf-only':
				frames = Paths.getSparrowAtlas('characters/main/GF_ONLY');
				animation.addByIndices('sad', 'gf sad', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", 24, false);
				animation.addByIndices('danceLeft', 'GF Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);

				addOffset('sad');
				addOffset('danceLeft');
				addOffset('danceRight');

				barColor = FlxColor.fromString('#33de39');

				playAnim('danceRight');
			case '3d-bf':
				frames = Paths.getSparrowAtlas('characters/algebra/3D_BF');
				animation.addByPrefix('idle', 'BF idle dance', 24, false);
				animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
				animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
				animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);
				animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);

				addOffset('idle');
				addOffset("singUP", 6, 10);
				addOffset("singRIGHT", -3);
				addOffset("singLEFT", 17);
				addOffset("singDOWN");

				nativelyPlayable = flipX = true;

				antialiasing = false;

				barColor = FlxColor.fromRGB(49, 176, 209);

				playAnim('idle');
			case 'sart-producer':
				frames = Paths.getSparrowAtlas('characters/sart/sart-producer');
				animation.addByPrefix('idle', 'idle', 24, false);
				for (anim in ['left', 'down', 'up', 'right']) {
					animation.addByPrefix('sing${anim.toUpperCase()}', anim, 24, false);
				}

				addOffset('idle');
				addOffset('singLEFT');
				addOffset('singDOWN');
				addOffset('singUP');
				addOffset('singRIGHT');

				antialiasing = false;

				barColor = FlxColor.fromRGB(75, 90, 160);

				playAnim('idle');
			case 'playrobot':
				frames = Paths.getSparrowAtlas('characters/algebra/playrobot');

				animation.addByPrefix('idle', 'Idle', 24, true);
				animation.addByPrefix('singUP', 'Up', 24, false);
				animation.addByPrefix('singLEFT', 'Left', 24, false);
				animation.addByPrefix('singRIGHT', 'Right', 24, false);
				animation.addByPrefix('singDOWN', 'Down', 24, false);

				addOffset('idle');
				addOffset('singLEFT', 110, -90);
				addOffset('singDOWN', -21, -218);
				addOffset('singUP');
				addOffset('singRIGHT', -55, -96);

				antialiasing = false;

				barColor = FlxColor.fromRGB(162, 150, 188);

				playAnim('idle');
			case 'playrobot-crazy':
				frames = Paths.getSparrowAtlas('characters/algebra/ohshit');

				animation.addByPrefix('idle', 'Idle', 24, true);
				animation.addByPrefix('singUP', 'Up', 24, false);
				animation.addByPrefix('singLEFT', 'Left', 24, false);
				animation.addByPrefix('singRIGHT', 'Right', 24, false);
				animation.addByPrefix('singDOWN', 'Down', 24, false);

				addOffset('idle');
				addOffset('singLEFT', 255);
				addOffset('singDOWN', 203, -50);
				addOffset('singUP', -19);
				addOffset('singRIGHT', -20, 38);

				antialiasing = false;

				barColor = FlxColor.fromRGB(162, 150, 188);

				playAnim('idle');
			case 'hall-monitor':
				frames = Paths.getSparrowAtlas('characters/algebra/HALL_MONITOR');
				animation.addByPrefix('idle', 'gdj', 24, false);
				for (anim in ['left', 'down', 'up', 'right']) {
					animation.addByPrefix('sing${anim.toUpperCase()}', anim, 24, false);
				}

				addOffset('idle');
				addOffset('singLEFT', 436, 401);
				addOffset('singDOWN', 145, 25);
				addOffset('singUP', -150, 62);
				addOffset('singRIGHT', 201, 285);

				antialiasing = false;
				scale.set(1.5, 1.5);
				updateHitbox();

				barColor = FlxColor.fromRGB(37, 191, 55);

				playAnim('idle');
			case 'diamond-man':
				frames = Paths.getSparrowAtlas('characters/algebra/diamondMan');
				animation.addByPrefix('idle', 'idle', 24, true);
				for (anim in ['left', 'down', 'up', 'right']) {
					animation.addByPrefix('sing${anim.toUpperCase()}', anim, 24, false);
				}

				addOffset('idle');
				addOffset('singLEFT', 610);
				addOffset('singDOWN', 91, -328);
				addOffset('singUP', -12, 338);
				addOffset('singRIGHT', 4);

				scale.set(1.3, 1.3);
				updateHitbox();

				antialiasing = false;

				barColor = FlxColor.fromRGB(129, 180, 227);

				playAnim('idle');
			case 'dave-wheels':
				frames = Paths.getSparrowAtlas('characters/dave/cool');
				animation.addByIndices('danceLeft', 'idle', [0, 1, 2, 3, 4, 5, 6], '', 24, false);
				animation.addByIndices('danceRight', 'idle', [7, 8, 9, 10, 11, 12, 13], '', 24, false);
				for (anim in ['left', 'down', 'up', 'right']) {
					animation.addByPrefix('sing${anim.toUpperCase()}', anim, 24, false);
				}

				addOffset('idle');
				addOffset('singLEFT', 12, -23);
				addOffset('singDOWN', -40, -23);
				addOffset('singUP', -40, 214);
				addOffset('singRIGHT', 9, -23);

				antialiasing = false;
				scale.set(1.8, 1.8);
				updateHitbox();

				barColor = FlxColor.fromRGB(15, 95, 255);

				playAnim('danceRight');
			case 'gf-wheels':
				loadGraphic(Paths.image('characters/dave/best_gf'), true, 241, 231);
				animation.add('idle', [0], 0, false);

				scale.set(1.9, 1.9);
				antialiasing = false;
				updateHitbox();

				barColor = FlxColor.fromRGB(178, 7, 7);
				
				
				playAnim('idle');
			case 'ringi':
				frames = Paths.getSparrowAtlas('characters/oc/ringi');
				animation.addByPrefix('idle', 'IDLE', 24, false);
				for (anim in ['LEFT', 'DOWN', 'UP', 'RIGHT']) {
					animation.addByPrefix('sing${anim.toUpperCase()}', anim, 24, false);
				}

				addOffset('idle');
				addOffset('singLEFT');
				addOffset('singDOWN');
				addOffset('singUP');
				addOffset('singRIGHT');

				setGraphicSize(Std.int(width * furiosityScale),Std.int(height * furiosityScale));
				updateHitbox();

				antialiasing = false;

				barColor = FlxColor.fromRGB(199, 164, 165);

				playAnim('idle');
			case 'bambom':
				frames = Paths.getSparrowAtlas('characters/oc/bambom');
				animation.addByPrefix('idle', 'IDLE', 24, false);
				for (anim in ['LEFT', 'DOWN', 'UP', 'RIGHT']) {
					animation.addByPrefix('sing${anim.toUpperCase()}', anim, 24, false);
				}

				addOffset('idle');
				addOffset('singLEFT');
				addOffset('singDOWN');
				addOffset('singUP');
				addOffset('singRIGHT');

				furiosityScale = 0.75;

				setGraphicSize(Std.int(width * furiosityScale),Std.int(height * furiosityScale));
				updateHitbox();

				antialiasing = false;

				barColor = FlxColor.fromRGB(255, 0, 0);

				playAnim('idle');
			case 'bendu':
				frames = Paths.getSparrowAtlas('characters/oc/bendu');
				animation.addByPrefix('idle', 'IDLE', 24, false);
				for (anim in ['LEFT', 'DOWN', 'UP', 'RIGHT']) {
					animation.addByPrefix('sing${anim.toUpperCase()}', anim, 24, false);
				}

				addOffset('idle');
				addOffset('singLEFT');
				addOffset('singDOWN');
				addOffset('singUP');
				addOffset('singRIGHT');

				setGraphicSize(Std.int(width * furiosityScale),Std.int(height * furiosityScale));
				updateHitbox();

				antialiasing = false;

				barColor = FlxColor.fromRGB(253, 253, 63);

				playAnim('idle');
			case 'dave-png':
				frames = Paths.getSparrowAtlas('characters/dave/dave-png');
				animation.addByPrefix('idle', 'idle', 24, false);
				for (anim in ['left', 'down', 'up', 'right']) {
					animation.addByPrefix('sing${anim.toUpperCase()}', anim, 24, false);
				}

				addOffset('idle');
				addOffset('singLEFT', 45);
				addOffset('singDOWN', 28, -5);
				addOffset('singUP', -2, 29);
				addOffset('singRIGHT', 1);

				barColor = FlxColor.fromRGB(15, 95, 255);

				playAnim('idle');
			case 'split-dave-3d':
				// DAVE SHITE ANIMATION LOADING CODE
				tex = Paths.getSparrowAtlas('characters/dave/split_dave_3d');
				frames = tex;
				animation.addByPrefix('idle', 'IDLE', 24, false);
				animation.addByPrefix('singUP', 'UP', 24, false);
				animation.addByPrefix('singRIGHT', 'RIGHT', 24, false);
				animation.addByPrefix('singDOWN', 'DOWN', 24, false);
				animation.addByPrefix('singLEFT', 'LEFT', 24, false);
		
				addOffset('idle');
				addOffset("singUP");
				addOffset("singRIGHT");
				addOffset("singLEFT");
				addOffset("singDOWN");
				setGraphicSize(Std.int(width * furiosityScale),Std.int(height * furiosityScale));
				updateHitbox();
				antialiasing = false;

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
		
				addOffset('idle');
				addOffset("singUP", 69, -30);
				addOffset("singRIGHT", 10, -36);
				addOffset("singLEFT", -90, -10);
				addOffset("singDOWN", 80, 100);
				addOffset("cutscene", 0, -10);
				setGraphicSize(Std.int(width * furiosityScale),Std.int(height * furiosityScale));
				updateHitbox();
				antialiasing = false;
		
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
		
				addOffset('idle');
				addOffset("singUP", -90, 97);
				addOffset("singRIGHT", -129, -8);
				addOffset("singLEFT", -11, -6);
				addOffset("singDOWN", 7, -20);
				setGraphicSize(Std.int(width * furiosityScale),Std.int(height * furiosityScale));
				updateHitbox();
				antialiasing = false;

				nativelyPlayable = true;

				flipX = true;
		
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
		
				addOffset('idle');
				addOffset("singUP");
				addOffset("singRIGHT");
				addOffset("singLEFT");
				addOffset("singDOWN");
				setGraphicSize(Std.int(width * furiosityScale),Std.int(height * furiosityScale));
				updateHitbox();
				antialiasing = false;

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
		
				addOffset('idle');
				addOffset("singUP");
				addOffset("singRIGHT");
				addOffset("singLEFT");
				addOffset("singDOWN");
				setGraphicSize(Std.int(765 * furiosityScale),Std.int(903 * furiosityScale));
				updateHitbox();
				antialiasing = false;

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
		
				addOffset('idle');
				addOffset("singUP");
				addOffset("singRIGHT");
				addOffset("singLEFT");
				addOffset("singDOWN");
				setGraphicSize(Std.int(765 * furiosityScale),Std.int(903 * furiosityScale));
				updateHitbox();
				antialiasing = false;

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
		
				addOffset('idle');
				addOffset("singUP");
				addOffset("singRIGHT");
				addOffset("singLEFT");
				addOffset("singDOWN");
				setGraphicSize(Std.int(width * furiosityScale),Std.int(height * furiosityScale));
				updateHitbox();
				antialiasing = false;

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
		
				addOffset('idle');
				addOffset("singUP");
				addOffset("singRIGHT");
				addOffset("singLEFT");
				addOffset("singDOWN");
				setGraphicSize(Std.int(width * furiosityScale),Std.int(height * furiosityScale));
				updateHitbox();
				antialiasing = false;

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
		
				addOffset('idle');
				addOffset("singUP");
				addOffset("singRIGHT");
				addOffset("singLEFT");
				addOffset("singDOWN", -82, -24);
				addOffset("stand", -87, -29);

				setGraphicSize(Std.int(width * furiosityScale),Std.int(height * furiosityScale));
				updateHitbox();
				antialiasing = false;

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
		
				addOffset('idle');
				addOffset("singUP");
				addOffset("singRIGHT");
				addOffset("singLEFT");
				addOffset("singDOWN");
				addOffset("stand", -156, -45);

				setGraphicSize(Std.int(width * furiosityScale),Std.int(height * furiosityScale));
				updateHitbox();
				antialiasing = false;

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
		
				addOffset('idle');
				addOffset("singUP");
				addOffset("singRIGHT", -45, 3);
				addOffset("singLEFT");
				addOffset("singDOWN", -48, -46);
				addOffset("stand", 20);
				addOffset("scared");

				furiosityScale = 1.3;

				setGraphicSize(Std.int(width * furiosityScale),Std.int(height * furiosityScale));
				updateHitbox();
				antialiasing = false;

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

				addOffset('idle');
				addOffset("singUP", 116, 95);
				addOffset("singRIGHT", 37, -4);
				addOffset("singLEFT", -5, -1);
				addOffset("singDOWN", 107, 111);

				barColor = FlxColor.fromRGB(37, 191, 55);

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
		
				addOffset('idle');
				addOffset("singUP", -38, 135);
				addOffset("singRIGHT", -3, -4);
				addOffset("singLEFT", 37, 33);
				addOffset("singDOWN", -97, -12);
				globaloffset[0] = 150;
				globaloffset[1] = 450; //this is the y
				setGraphicSize(Std.int(width / furiosityScale));
				updateHitbox();
				antialiasing = false;

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
				
				addOffset('idle');
				addOffset("singUP", 0, 80);
				addOffset("singRIGHT", 140, -80);
				addOffset("singLEFT", 200);
				addOffset("singDOWN", 0, -30);
				
				addOffset('NOOMYPHONES');

				addOffset('idle-alt');
				addOffset("singUP-alt", 0, 100);
				addOffset("singRIGHT-alt", 30);
				addOffset("singLEFT-alt", -20, -38);
				addOffset("singDOWN-alt");

				globaloffset[0] = 150;
				globaloffset[1] = 450;

				setGraphicSize(Std.int(width / furiosityScale));
				updateHitbox();

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
				
				addOffset('idle');
				addOffset("singUP");
				addOffset("singRIGHT");
				addOffset("singLEFT");
				addOffset("singDOWN");

				setGraphicSize(Std.int(width / furiosityScale));
				updateHitbox();

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

				addOffset('danceLeft');
				addOffset('danceRight');
				addOffset("singUP");
				addOffset("singRIGHT", 120);
				addOffset("singLEFT", -63);
				addOffset("singDOWN");
				addOffset("singUP-alt");
				addOffset("singRIGHT-alt");
				addOffset("singLEFT-alt");
				addOffset("singDOWN-alt");

				setGraphicSize(Std.int(width / furiosityScale));
				updateHitbox();

				antialiasing = false;

				barColor = FlxColor.fromRGB(72, 254, 45);

				playAnim('danceLeft');
			case 'bambi-good':
				// PLACEHOLDER! !  ! !
				frames = Paths.getSparrowAtlas('characters/bambi/PLACEHOLDER_BAMBI');
				animation.addByPrefix('idle', 'Idle', 24, false);
				animation.addByPrefix('singDOWN', 'down', 24, false);
				animation.addByPrefix('singUP', 'up', 24, false);
				animation.addByPrefix('singLEFT', 'left', 24, false);
				animation.addByPrefix('singRIGHT', 'right', 24, false);

				addOffset('idle');
				addOffset("singUP", 54, 3);
				addOffset("singRIGHT", -50, 0);
				addOffset("singLEFT", 20, -7);
				addOffset("singDOWN", -5, -43);

				barColor = FlxColor.fromRGB(37, 191, 55);

				playAnim('idle');
			case 'dave-good':
				// allso uh placeholder
				tex = Paths.getSparrowAtlas('characters/dave/PLACEHOLDER_DAVE');
				frames = tex;
				animation.addByPrefix('idle', 'idleDance', 24, false);
				animation.addByPrefix('singUP', 'Up', 24, false);
				animation.addByPrefix('singRIGHT', 'Right', 24, false);
				animation.addByPrefix('singDOWN', 'Down', 24, false);
				animation.addByPrefix('singLEFT', 'Left', 24, false);
	
				addOffset('idle');
				addOffset("singUP", -18, 12);
				addOffset("singRIGHT", -5, -2);
				addOffset("singLEFT", -29, 2);
				addOffset("singDOWN", -5, 2);

				barColor = FlxColor.fromRGB(15, 95, 255);

				playAnim('idle');
			case 'unfair-junker':
				frames = Paths.getSparrowAtlas('characters/bambi/NEWER UNFAIR GUY');
				animation.addByPrefix('idle', 'idle', 24, false);
				animation.addByIndices('singUP', 'up', [0, 1, 1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2], '', 24, false);
				animation.addByIndices('singRIGHT', 'right', [0, 1, 1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2], '', 24, false);
				animation.addByIndices('singDOWN', 'down', [0, 1, 1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2], '', 24, false);
				animation.addByIndices('singLEFT', 'left', [0, 1, 1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2], '', 24, false);
				animation.addByIndices('inhale', 'inhaler', [0, 1, 2, 0, 1, 2, 0, 1, 2, 0, 1, 2, 0, 1, 2, 0, 1, 2, 0, 1, 2, 0, 1, 2, 1, 2, 1, 2, 1, 0, 0], '', 24, false);

				addOffset('idle');
				addOffset("singUP", 157, 67);
				addOffset("singRIGHT", 225, 4);
				addOffset("singLEFT", 222, 84);
				addOffset("singDOWN", 113, -104);
				addOffset('inhale', 71 -36);
				globaloffset[0] = 150 * 1.3;
				globaloffset[1] = 450 * 1.3; //this is the y
				setGraphicSize(Std.int((width * 1.3) / furiosityScale));
				updateHitbox();
				antialiasing = false;

				barColor = FlxColor.fromRGB(178, 7, 7);
		
				playAnim('idle');
				
			case 'bf':
				var tex = Paths.getSparrowAtlas('characters/main/BOYFRIEND');
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

				animation.addByPrefix('firstDeath', "BF dies", 24, false);
				animation.addByPrefix('deathLoop', "BF Dead Loop", 24, true);
				animation.addByPrefix('deathConfirm', "BF Dead confirm", 24, false);
				animation.addByPrefix('dodge', "boyfriend dodge", 24, false);
				animation.addByPrefix('scared', 'BF idle shaking', 24);
				animation.addByPrefix('hit', 'BF hit', 24, false);

				addOffset('idle', -5);
				addOffset("singUP", -29, 27);
				addOffset("singRIGHT", -38, -7);
				addOffset("singLEFT", 12, -6);
				addOffset("singDOWN", -10, -50);
				addOffset("singUPmiss", -29, 27);
				addOffset("singRIGHTmiss", -30, 21);
				addOffset("singLEFTmiss", 12, 24);
				addOffset("singDOWNmiss", -11, -19);
				addOffset("hey", 7, 4);
				addOffset('firstDeath', 37, 11);
				addOffset('deathLoop', 37, 5);
				addOffset('deathConfirm', 37, 69);
				addOffset('scared', -4);

				playAnim('idle');

				nativelyPlayable = true;

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

				addOffset('idle', -5);
				addOffset("singUP", -29, 27);
				addOffset("singRIGHT", -38, -7);
				addOffset("singLEFT", 12, -6);
				addOffset("singDOWN", -10, -50);
				addOffset("singUPmiss", -29, 27);
				addOffset("singRIGHTmiss", -30, 21);
				addOffset("singLEFTmiss", 12, 24);
				addOffset("singDOWNmiss", -11, -19);
				addOffset("hey", 7, 4);

				playAnim('idle');

				nativelyPlayable = true;

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

				addOffset('idle');
				addOffset("singUP");
				addOffset("singRIGHT");
				addOffset("singLEFT", 57);
				addOffset("singDOWN");
				addOffset('turn');

				playAnim('idle');

				barColor = FlxColor.fromRGB(49, 176, 209);

				flipX = true;

				nativelyPlayable = true;
				
			case 'afnfg-boyfriend':
				var tex = Paths.getSparrowAtlas('characters/other/afnfg_boyfriend');
				frames = tex;

				animation.addByPrefix('idle', 'idl', 60, false);
				animation.addByPrefix('singUP', 'up', 24, false);
				animation.addByPrefix('singLEFT', 'left', 24, false);
				animation.addByPrefix('singRIGHT', 'right', 24, false);
				animation.addByPrefix('singDOWN', 'down', 24, false);

				addOffset('idle');
				addOffset("singUP", 19, -17);
				addOffset("singRIGHT", -9, -20);
				addOffset("singLEFT", 38, -23);
				addOffset("singDOWN", 1, -56);

				playAnim('idle');

				barColor = FlxColor.fromRGB(49, 176, 209);

				flipX = true;

				nativelyPlayable = true;
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

				addOffset('idle');
				addOffset("singUP");
				addOffset("singLEFT");
				addOffset("singRIGHT", 13);
				addOffset("singDOWN");
				addOffset('turn');

				playAnim('idle');

				barColor = FlxColor.fromRGB(49, 176, 209);

				nativelyPlayable = true;
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

			var dadVar:Float = 4;

			if (curCharacter == 'dad')
				dadVar = 6.1;
			if (holdTimer >= Conductor.stepCrochet * dadVar * 0.001)
			{
				dance(POOP);
				holdTimer = 0;
			}
		}

		switch (curCharacter)
		{
			case 'gf':
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
			switch (curCharacter)
			{
				case 'gf' | 'gf-christmas' | 'gf-pixel' | 'bandu-candy' | 'gf-only' | 'dave-wheels':
					if (!animation.curAnim.name.startsWith('hair'))
					{
						danced = !danced;

						if (danced)
							playAnim('danceRight' + poopInPants, true);
						else
							playAnim('danceLeft' + poopInPants, true);
					}
				default:
					playAnim('idle' + poopInPants, true);
			}
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

	public function addOffset(name:String, x:Float = 0, y:Float = 0)
	{
		animOffsets[name] = [x, y];
	}
}
