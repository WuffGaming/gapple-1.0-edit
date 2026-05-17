package;

import flixel.group.FlxGroup;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.FlxG;
import flixel.util.FlxColor;
import BGSprite;

// Stage information

typedef StageData =
{
	var cameraZoom:Float; // Path to the character's asset.

	// Offsets are added into the current character positions.
	var bfOffset:Array<Float>;
	var gfOffset:Array<Float>;
	var opponentOffset:Array<Float>;
	var bfScroll:Array<Float>;
	var gfScroll:Array<Float>;
	var opponentScroll:Array<Float>;

	var props:Array<PropData>; // Array of all props.
}

typedef PropData =
{
	var position:Array<Float>; // Where is prop located?

	var scale:Array<Float>; // How big or small is the prop?

	var graphicSize:Null<Float>; // Uses graphicSize instead.

	var name:String; // Name of prop

	var assetPath:String; // Where prop is located

	var animations:Array<AnimatedPropData>;

	var visible:Null<Bool>; // Is prop visible?

	var flipX:Null<Bool>; // Is prop flipped by X?

	var flipY:Null<Bool>; // Is prop flipped by Y?

	var alpha:Null<Float>; // Specify the alpha of prop.

	var antialiasing:Null<Bool>; // Antialised?

	var wavy:Null<Bool>; // Does it wave?

	// TODO: MAKE IT ACTUALLY WAVE! IM TOO LAZY TO DO JACK SHIT RN
	var scroll:Array<Float>; // What is the scroll factor? x,y
}

typedef AnimatedPropData = // literally just copied from character.hx LMAO
{
	var name:String; // Name of animation
	var prefix:String; // Name of animation in XML

	var offset:Array<Float>; // Offsets for specified Animations

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

/**
 * Handles the current stage on the playing field.
 */
class StageHandler extends FlxGroup
{
	public static var objects:FlxTypedGroup<BGSprite> = new FlxTypedGroup<BGSprite>();

	public var stage = 'stage';

	public var scripted:Bool = false;

	public var cameraZoom:Float = 1.05;

	public var curbg:BGSprite;

	var namedProps:Map<String, BGSprite> = new Map<String, BGSprite>();

	public function new(name:String)
	{
		super();

		this.stage = name;
	}

	override public function update(elapsed)
	{
		if (curbg != null)
		{
			if (curbg.active) // only the furiosity background is active
			{
				var shad = cast(curbg.shader, Shaders.GlitchShader);
				shad.uTime.value[0] += elapsed;
			}
		}
	}

	public function generateStage(stage):Void
	{
		switch (stage)
		{
			case 'sugar':
				PlayState.camBeatSnap = 1;
				cameraZoom = 0.85;
				scripted = true;

				var swag:BGSprite = new BGSprite(120, -35, 'swag');
				swag.loadGraphic(Paths.image('backgrounds/3dbg/pissing_too'));
				swag.x -= 250;
				swag.setGraphicSize(Std.int(swag.width * 0.521814815));
				swag.updateHitbox();
				swag.antialiasing = false;

				objects.add(swag);

			case 'basement':
				cameraZoom = 0.9;
				scripted = true;

				var twodeez:BGSprite = new BGSprite(-1982, -707, 'twodeez');
				twodeez.loadGraphic(Paths.image('backgrounds/house/basement-2d'));
				twodeez.updateHitbox();
				var threedeez = new BGSprite(twodeez.x, twodeez.y, 'threedeez');
				threedeez.loadGraphic(Paths.image('backgrounds/house/basement-3d'));
				threedeez.active = threedeez.visible = false;
				threedeez.updateHitbox();
				threedeez.antialiasing = false;

				objects.add(twodeez);
				objects.add(threedeez);

			case 'farm':
				cameraZoom = 0.9;
				scripted = true;

				var farmsky = new BGSprite(-700, 0, 'sky');
				farmsky.loadGraphic(Paths.image('backgrounds/farm/sky'));
				farmsky.antialiasing = true;
				farmsky.scrollFactor.set(0.9, 0.9);
				farmsky.active = false;

				var thirdimension = new BGSprite(-600, -200, '3dsky');
				thirdimension.loadGraphic(Paths.image('backgrounds/farm/3d'));
				thirdimension.active = thirdimension.visible = false;
				thirdimension.antialiasing = false;
				thirdimension.scrollFactor.set(0.1, 0.1);
				var thirdhs:Shaders.GlitchEffect = new Shaders.GlitchEffect();
				thirdhs.waveAmplitude = 0.1;
				thirdhs.waveFrequency = 2;
				thirdhs.waveSpeed = 2;
				thirdimension.shader = thirdhs.shader;
				curbg = thirdimension;

				var hills:BGSprite = new BGSprite(-250, 200, 'hills');
				hills.loadGraphic(Paths.image('backgrounds/farm/orangey hills'));
				hills.antialiasing = true;
				hills.scrollFactor.set(0.9, 0.7);
				hills.active = false;

				var farm:BGSprite = new BGSprite(150, 250, 'farm');
				farm.loadGraphic(Paths.image('backgrounds/farm/funfarmhouse'));
				farm.antialiasing = true;
				farm.scrollFactor.set(1.1, 0.9);
				farm.active = false;

				var foreground:BGSprite = new BGSprite(-400, 600, 'foreground');
				foreground.loadGraphic(Paths.image('backgrounds/farm/grass lands'));
				foreground.antialiasing = true;
				foreground.active = false;

				var cornSet:BGSprite = new BGSprite(-350, 325, 'cornSet');
				cornSet.loadGraphic(Paths.image('backgrounds/farm/Cornys'));
				cornSet.antialiasing = true;
				cornSet.active = false;

				var cornSet2:BGSprite = new BGSprite(1050, 325, 'cornSet2');
				cornSet2.loadGraphic(Paths.image('backgrounds/farm/Cornys'));
				cornSet2.antialiasing = true;
				cornSet2.active = false;

				var fence:BGSprite = new BGSprite(-350, 450, 'fence');
				fence.loadGraphic(Paths.image('backgrounds/farm/crazy fences'));
				fence.antialiasing = true;
				fence.active = false;

				var sign:BGSprite = new BGSprite(0, 500, 'sign');
				sign.loadGraphic(Paths.image('backgrounds/farm/Sign'));
				sign.antialiasing = true;
				sign.active = false;

				objects.add(farmsky);
				objects.add(thirdimension);
				objects.add(hills);
				objects.add(farm);
				objects.add(foreground);
				objects.add(cornSet);
				objects.add(cornSet2);
				objects.add(fence);
				objects.add(sign);

			case 'recover':
				cameraZoom = 1.4;
				scripted = true;
				var yea = new BGSprite(-641, -222, 'yea');
				yea.loadGraphic(Paths.image('backgrounds/RECOVER_assets/q'));
				yea.setGraphicSize(2478);
				yea.updateHitbox();
				objects.add(yea);
			case 'POOP':
				cameraZoom = 0.5;
				scripted = true;
				PlayState.swagger = new Character(-300, -1200, 'bambi-piss-3d', OPPONENT);
				PlayState.altSong = Song.loadFromJson('alt-notes', 'applecore');

				var scaryBG = new BGSprite(-350, -375, 'scaryBG');
				scaryBG.loadGraphic(Paths.image('backgrounds/applecore/yeah'));
				scaryBG.scale.set(2, 2);
				var testshader3:Shaders.GlitchEffect = new Shaders.GlitchEffect();
				testshader3.waveAmplitude = 0.25;
				testshader3.waveFrequency = 10;
				testshader3.waveSpeed = 3;
				scaryBG.shader = testshader3.shader;
				scaryBG.alpha = 0.65;
				objects.add(scaryBG);
				scaryBG.active = false;

				var swagBG = new BGSprite(-600, -200, 'swagBG');
				swagBG.loadGraphic(Paths.image('backgrounds/applecore/hi'));
				// swagBG.scrollFactor.set(0, 0);
				swagBG.scale.set(1.75, 1.75);
				// swagBG.updateHitbox();
				var testshader:Shaders.GlitchEffect = new Shaders.GlitchEffect();
				testshader.waveAmplitude = 0.1;
				testshader.waveFrequency = 1;
				testshader.waveSpeed = 2;
				swagBG.shader = testshader.shader;
				objects.add(swagBG);
				curbg = swagBG;

				var unswagBG = new BGSprite(-600, -200, 'unswagBG');
				unswagBG.loadGraphic(Paths.image('backgrounds/applecore/poop'));
				unswagBG.scale.set(1.75, 1.75);
				var testshader2:Shaders.GlitchEffect = new Shaders.GlitchEffect();
				testshader2.waveAmplitude = 0.1;
				testshader2.waveFrequency = 5;
				testshader2.waveSpeed = 2;
				unswagBG.shader = testshader2.shader;
				objects.add(unswagBG);
				unswagBG.active = unswagBG.visible = false;

				PlayState.littleIdiot = new Character(200, -175, 'unfair-junker', OPPONENT);
				add(PlayState.littleIdiot);
				PlayState.littleIdiot.visible = false;
				PlayState.poipInMahPahntsIsGud = false;

				PlayState.what = new FlxTypedGroup<BGSprite>();
				// add(PlayState.what);

				for (i in 0...2)
				{
					var pizza = new BGSprite(FlxG.random.int(100, 1000), FlxG.random.int(100, 500), 'pizza');
					pizza.frames = Paths.getSparrowAtlas('backgrounds/applecore/pizza');
					pizza.animation.addByPrefix('idle', 'p', 12, true); // https://m.gjcdn.net/game-thumbnail/500/652229-crop175_110_1130_647-stnkjdtv-v4.jpg
					pizza.animation.play('idle');
					pizza.ID = i;
					pizza.visible = false;
					pizza.antialiasing = false;
					PlayState.arrowcoordinat.push([pizza.x, pizza.y, FlxG.random.int(400, 1200), FlxG.random.int(500, 700), i]);
					PlayState.gasw2.push(FlxG.random.int(800, 1200));
					PlayState.what.add(pizza);
				}

			case 'algebra':
				scripted = true;
				cameraZoom = 0.85;
				PlayState.songSpeed = 1.6;
				var bg = new BGSprite(0, 0, 'bg');
				bg.loadGraphic(Paths.image('backgrounds/algebra/algebraBg'));
				bg.setGraphicSize(Std.int(bg.width * 1.35), Std.int(bg.height * 1.35));
				bg.updateHitbox();
				bg.screenCenter();
				objects.add(bg);

				var daveJunk = new BGSprite(424, 122, 'daveJunk');
				daveJunk.loadGraphic(Paths.image('backgrounds/algebra/bgJunkers/dave'));
				var davePiss = new BGSprite(427, 94, 'davePiss');
				davePiss.frames = Paths.getSparrowAtlas('backgrounds/algebra/bgJunkers/davePiss');
				davePiss.animation.addByIndices('idle', 'GRR', [0], '', 0, false);
				davePiss.animation.addByPrefix('d', 'GRR', 24, false);
				davePiss.animation.play('idle');
				davePiss.x += 200;
				davePiss.y += 100;

				var spikeJunk = new BGSprite(237, 59, 'spikeJunk');
				spikeJunk.loadGraphic(Paths.image('backgrounds/algebra/bgJunkers/spike'));
				spikeJunk.x -= 300;
				spikeJunk.y += 120;

				var monitorJunk = new BGSprite(960, 61, 'monitorJunk');
				monitorJunk.loadGraphic(Paths.image('backgrounds/algebra/bgJunkers/monitor'));
				monitorJunk.x += 275;
				monitorJunk.y += 75;

				var diamondJunk = new BGSprite(645, 0, 'diamondJunk');
				diamondJunk.loadGraphic(Paths.image('backgrounds/algebra/bgJunkers/diamond'));
				diamondJunk.x += 75;
				diamondJunk.y += 20;

				var robotJunk = new BGSprite(-160, 225, 'robotJunk');
				robotJunk.loadGraphic(Paths.image('backgrounds/algebra/bgJunkers/robot'));
				robotJunk.x -= 250;
				robotJunk.y += 75;

				var robotUsb = new BGSprite(-160, 225, 'robotUsb');
				robotUsb.loadGraphic(Paths.image('backgrounds/algebra/bgJunkers/robot-usb'));
				robotUsb.x -= 250;
				robotUsb.y += 75;

				for (i in [diamondJunk, spikeJunk, daveJunk, davePiss, monitorJunk, robotJunk, robotUsb])
				{
					i.scale.set(1.35, 1.35);
					i.visible = false;
					i.antialiasing = false;
					objects.add(i);
				}

			case '3dbg':
				cameraZoom = 0.9;
				scripted = true;
				var bg:BGSprite = new BGSprite(-600, -200, '3dbg');
				bg.active = true;
				bg.scrollFactor.set(0.1, 0.1);

				switch (PlayState.SONG.song.toLowerCase()) // TODO: MOVE TO SEPARATE STAGES!!
				{
					case 'disruption':
						PlayState.gfSpeed = 2;
						bg.loadGraphic(Paths.image('backgrounds/3dbg/disruptor'));
					case 'origin':
						bg.loadGraphic(Paths.image('backgrounds/3dbg/heaven'));
					case 'tantalum':
						cameraZoom = 0.7;
						bg.loadGraphic(Paths.image('backgrounds/3dbg/metal'));
						bg.y -= 235;
					case 'jam':
						cameraZoom = 0.69;
						bg.loadGraphic(Paths.image('backgrounds/3dbg/strawberries'));
						bg.scrollFactor.set(0, 0);
						bg.y -= 200;
						bg.x -= 100;
					case 'keyboard':
						bg.loadGraphic(Paths.image('backgrounds/3dbg/keyboard'));
					default:
						bg.loadGraphic(Paths.image('backgrounds/3dbg/disabled'));
				}
				objects.add(bg);

				if (PlayState.SONG.song.toLowerCase() == 'disruption')
				{
					var poop = new BGSprite(-100, -100, 'lol');
					poop.makeGraphic(Std.int(1280 * 1.4), Std.int(720 * 1.4), FlxColor.BLACK);
					poop.scrollFactor.set(0, 0);
					objects.add(poop);
				}
				// below code assumes shaders are always enabled which is bad
				// i wouldnt consider this an eyesore though
				var testshader:Shaders.GlitchEffect = new Shaders.GlitchEffect();
				testshader.waveAmplitude = 0.1;
				testshader.waveFrequency = 5;
				testshader.waveSpeed = 2;
				bg.shader = testshader.shader;
				curbg = bg;
			case 'redTunnel':
				cameraZoom = 0.67;
				scripted = true;

				var stupidFuckingRedBg = new BGSprite(0, 0, 'redshit');
				stupidFuckingRedBg.makeGraphic(9999, 9999, FlxColor.fromRGB(42, 0, 0)).screenCenter();
				objects.add(stupidFuckingRedBg);

				var redTunnel = new BGSprite(-1000, -700, 'redTunnel');
				redTunnel.loadGraphic(Paths.image('backgrounds/3dbg/redTunnel'));
				redTunnel.setGraphicSize(Std.int(redTunnel.width * 1.15), Std.int(redTunnel.height * 1.15));
				redTunnel.updateHitbox();
				objects.add(redTunnel);

				var daveFuckingDies = new BGSprite(0, 0, 'piss');
				daveFuckingDies.screenCenter();
				daveFuckingDies.y = 1500;
				daveFuckingDies.frames = Paths.getSparrowAtlas('characters/dave/pissBoy');
				daveFuckingDies.animation.addByPrefix('idle', 'IDLE', 24, false);
				daveFuckingDies.animation.addByPrefix('bounceLeft', 'EDGE', 24, false);
				daveFuckingDies.animation.addByPrefix('bounceRight', 'EDGE', 24, false, true);
				daveFuckingDies.animation.play('idle');

				objects.add(daveFuckingDies);

				daveFuckingDies.visible = false;
			case 'warehouse':
				cameraZoom = 0.6;
				scripted = true;
				var warehouse = new BGSprite(-1350, -1111, 'warehouse');
				warehouse.loadGraphic(Paths.image('backgrounds/warehouse/bg'));

				objects.add(warehouse);
			case 'stage':
				cameraZoom = 0.9;
				scripted = true;
				var bg:BGSprite = new BGSprite(-600, -200, 'bg');
				bg.loadGraphic(Paths.image('backgrounds/shared/stageback'));
				bg.antialiasing = true;
				bg.scrollFactor.set(0.9, 0.9);
				bg.active = false;

				objects.add(bg);

				var stageFront:BGSprite = new BGSprite(-650, 600, 'front');
				stageFront.loadGraphic(Paths.image('backgrounds/shared/stagefront'));
				stageFront.setGraphicSize(Std.int(stageFront.width * 1.1));
				stageFront.updateHitbox();
				stageFront.antialiasing = true;
				stageFront.scrollFactor.set(0.9, 0.9);
				stageFront.active = false;

				objects.add(stageFront);

				var stageCurtains:BGSprite = new BGSprite(-500, -300, 'curtains');
				stageCurtains.loadGraphic(Paths.image('backgrounds/shared/stagecurtains'));
				stageCurtains.setGraphicSize(Std.int(stageCurtains.width * 0.9));
				stageCurtains.updateHitbox();
				stageCurtains.antialiasing = true;
				stageCurtains.scrollFactor.set(1.3, 1.3);
				stageCurtains.active = false;

				objects.add(stageCurtains);
			default:
				var jsonData:StageData = Paths.loadJSON('stages/${stage}');
				var data:StageData = cast jsonData;

				PlayState.jsonStage = true;

				cameraZoom = data.cameraZoom;
				for (prop in data.props)
				{
					var theprop:BGSprite = new BGSprite(prop.position[0], prop.position[1], prop.name);
					if (prop.animations != null)
					{
						var tex:FlxAtlasFrames = Paths.getSparrowAtlas(prop.assetPath);
						theprop.frames = tex;
						if (theprop.frames != null)
							for (anim in prop.animations)
							{
								var frameRate = anim.frameRate == null ? 24 : anim.frameRate;
								var looped = anim.looped == null ? true : anim.looped;

								if (anim.frameIndices != null)
								{
									theprop.animation.addByIndices(anim.name, anim.prefix, anim.frameIndices, "", frameRate, looped, anim.flipX);
								}
								else
								{
									theprop.animation.addByPrefix(anim.name, anim.prefix, frameRate, looped, anim.flipX);
								}
								if (anim.offset != null)
								{
									theprop.x += anim.offset[0];
									theprop.y += anim.offset[1];
								}
								theprop.animation.play(anim.name, true);
							}
					}
					else
					{
						theprop.loadGraphic(Paths.image(prop.assetPath));
					}

					if (prop.antialiasing != null)
						theprop.antialiasing = prop.antialiasing;
					else
						theprop.antialiasing = true;
					if (prop.scale != null)
						theprop.scale.set(prop.scale[0], prop.scale[1]);

					if (prop.graphicSize != null)
						theprop.setGraphicSize(theprop.width * prop.graphicSize);

					if (prop.scroll != null)
						theprop.scrollFactor.set(prop.scroll[0], prop.scroll[1]);

					if (prop.wavy != null && prop.wavy == true)
					{
						var shader:Shaders.GlitchEffect = new Shaders.GlitchEffect();
						shader.waveAmplitude = 0.1;
						shader.waveFrequency = 5;
						shader.waveSpeed = 2;
						theprop.shader = shader.shader;
						theprop.active = true;
						curbg = theprop;
					}

					if (prop.visible != null)
						theprop.visible = prop.visible;

					if (prop.flipX != null)
						theprop.flipX = prop.flipX;

					if (prop.flipY != null)
						theprop.flipY = prop.flipY;

					if (prop.alpha != null)
						theprop.alpha = prop.alpha;
					theprop.updateHitbox();
					objects.add(theprop);
				}
		}
		for (object in objects)
		{
			addProp(object, object.name);
		}
	}

	public function setStagePositions(stage):Void
	{
		if (scripted)
		{
			switch (stage)
			{
				case 'basement':
					PlayState.boyfriend.x += 125;
				case 'redTunnel':
					PlayState.opponent.x -= 150;
					PlayState.opponent.y -= 100;
					PlayState.boyfriend.x -= 150;
					PlayState.boyfriend.y -= 150;
				case 'algebra':
					PlayState.boyfriend.y += 80;
				case '3dbg':
					switch (PlayState.SONG.song.toLowerCase()) // TODO: MOVE TO SEPARATE STAGES!!
					{
						case 'origin':
							PlayState.opponent.x -= 200;
							PlayState.opponent.y -= 200;
					}
			}
		}
		else
		{
			var jsonData:StageData = Paths.loadJSON('stages/${stage}');
			var data:StageData = cast jsonData;
			// positioning for non-scripted stages
			if (data.bfOffset != null)
			{
				PlayState.boyfriend.x += data.bfOffset[0];
				PlayState.boyfriend.y += data.bfOffset[1];
			}
			if (data.gfOffset != null)
			{
				PlayState.gf.x += data.gfOffset[0];
				PlayState.gf.y += data.gfOffset[1];
			}
			if (data.opponentOffset != null)
			{
				PlayState.opponent.x += data.opponentOffset[0];
				PlayState.opponent.y += data.opponentOffset[1];
			}
			// scroll overrides
			if (data.bfScroll != null)
			{
				PlayState.boyfriend.scrollFactor.x = data.bfScroll[0];
				PlayState.boyfriend.scrollFactor.x = data.bfScroll[1];
			}
			if (data.gfScroll != null)
			{
				PlayState.gf.scrollFactor.x = data.gfScroll[0];
				PlayState.gf.scrollFactor.x = data.gfScroll[1];
			}
			if (data.opponentScroll != null)
			{
				PlayState.opponent.scrollFactor.x = data.opponentScroll[0];
				PlayState.opponent.scrollFactor.x = data.opponentScroll[1];
			}
		}
	}

	public function addProp(prop:BGSprite, ?name:String = null):Void
	{
		if (name != null)
		{
			namedProps.set(name, prop);
			prop.name = name;
		}
		this.add(prop);
	}

	public function getProp(prop):BGSprite
	{
		return this.namedProps.get(prop);
	}
}
