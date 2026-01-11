package;

import flixel.tweens.misc.ColorTween;
import flixel.math.FlxRandom;
import openfl.net.FileFilter;
import openfl.filters.BitmapFilter;
import Shaders.PulseEffect;
import Section.SwagSection;
import Song.SwagSong;
import flixel.FlxBasic;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxGame;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxSubState;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.effects.FlxTrail;
import flixel.addons.effects.FlxTrailArea;
import flixel.addons.effects.chainable.FlxEffectSprite;
import flixel.addons.effects.chainable.FlxWaveEffect;
import flixel.addons.transition.FlxTransitionableState;
import flixel.graphics.atlas.FlxAtlas;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.ui.FlxBar;
import flixel.util.FlxCollision;
import flixel.util.FlxColor;
import flixel.util.FlxSort;
import flixel.util.FlxStringUtil;
import flixel.util.FlxTimer;
import haxe.Json;
import lime.utils.Assets;
import openfl.display.BlendMode;
import openfl.display.StageQuality;
import openfl.filters.ShaderFilter;
import flash.system.System;
#if desktop
import Discord.DiscordClient;
#end

#if windows
import sys.io.File;
import sys.io.Process;
#end

using StringTools;

class PlayState extends MusicBeatState
{
	public static var STRUM_X = 42;

	public static var curStage:String = '';
	public static var characteroverride:String = "none";
	public static var formoverride:String = "none";
	//put the following in anywhere you load or leave playstate that isnt the character selector:
	/*
		PlayState.characteroverride = 'none';
		PlayState.formoverride = 'none';
	*/
	public static var SONG:SwagSong;
	public static var isStoryMode:Bool = false;
	public static var storyWeek:Int = 0;
	public static var storyPlaylist:Array<String> = [];
	public static var storyDifficulty:Int = 1;
	public static var weekSong:Int = 0;
	public static var shits:Int = 0;
	public static var bads:Int = 0;
	public static var goods:Int = 0;
	public static var sicks:Int = 0;
	var farmsky:FlxSprite;
	var threedeez:FlxSprite;
	var thirdimension:FlxSprite;

	public var camBeatSnap:Int = 4;
	public var danceBeatSnap:Int = 2;
	public var OpponentDanceSnap:Int = 2;

	public var camMoveAllowed:Bool = true;

	public var daveStand:Character;
	public var garrettStand:Character;
	public var hallMonitorStand:Character;
	public var playRobotStand:Character;

	public var standersGroup:FlxTypedGroup<FlxSprite>;

	var songPercent:Float = 0;

	var songLength:Float = 0;

	public var darkLevels:Array<String> = ['bambiFarmNight', 'daveHouse_night', 'unfairness', 'disabled'];
	public var sunsetLevels:Array<String> = ['bambiFarmSunset', 'daveHouse_Sunset'];

	var howManyPlayerNotes:Int = 0;
	var howManyEnemyNotes:Int = 0;

	public var stupidx:Float = 0;
	public var stupidy:Float = 0; // stupid velocities for cutscene
	public var updatevels:Bool = false;

	var scoreTxtTween:FlxTween;

	var timeTxtTween:FlxTween;

	public static var curmult:Array<Float> = [1, 1, 1, 1];

	public var curbg:FlxSprite;
	public static var screenshader:Shaders.PulseEffect = new PulseEffect();
	public var UsingNewCam:Bool = false;

	public var elapsedtime:Float = 0;

	var focusOnDadGlobal:Bool = true;

	var funnyFloatyBoys:Array<String> = ['dave-angey', 'bambi-3d', 'dave-annoyed-3d', 'dave-3d-standing-bruh-what', 'bambi-unfair', 'bambi-piss-3d', 'bandu', 'unfair-junker', 'split-dave-3d', 'insane-dave-3d', 'badai', 'tunnel-dave', 'tunnel-bf', 'tunnel-bf-flipped', 'bandu-candy', 'bandu-origin', 'ringi', 'bambom', 'bendu', 'little-bandu'];

	var storyDifficultyText:String = "";
	var iconRPC:String = "";
	var detailsText:String = "";
	var detailsPausedText:String = "";

	private var swagSpeed:Float;

	var daveJunk:FlxSprite;
	var davePiss:FlxSprite;
	var garrettJunk:FlxSprite;
	var monitorJunk:FlxSprite;
	var robotJunk:FlxSprite;
	var diamondJunk:FlxSprite;

	var boyfriendOldIcon:String = 'bf-old';

	private var vocals:FlxSound;

	private var opponent:Character;
	private var opponentmirror:Character;
	private var opponent2:Character;
	private var swagger:Character;
	private var gf:Character;
	private var boyfriend:Boyfriend;
	private var littleIdiot:Character;

	private var altSong:SwagSong;

	private var daveExpressionSplitathon:Character;

	public static var shakingChars:Array<String> = ['bambi-unfair', 'bambi-3d', 'bambi-piss-3d', 'badai', 'unfair-junker', 'tunnel-dave'];

	private var notes:FlxTypedGroup<Note>;
	private var altNotes:FlxTypedGroup<Note>;
	private var unspawnNotes:Array<Note> = [];
	private var altUnspawnNotes:Array<Note> = [];

	private var strumLine:FlxSprite;
	private var altStrumLine:FlxSprite;
	private var curSection:Int = 0;

	//Handles the new epic mega sexy cam code that i've done
	private var camFollow:FlxPoint;
	private var camFollowPos:FlxObject;
	private static var prevCamFollow:FlxPoint;
	private static var prevCamFollowPos:FlxObject;

	public var badaiTime:Bool = false;

	private var updateTime:Bool = true;

	public var sunsetColor:FlxColor = FlxColor.fromRGB(255, 143, 178);

	private var strumLineNotes:FlxTypedGroup<Strum>;

	public var playerStrums:FlxTypedGroup<Strum>;
	public var dadStrums:FlxTypedGroup<Strum>;
	private var poopStrums:FlxTypedGroup<Strum>;

	public var idleAlt:Bool = false;

	private var camZooming:Bool = false;
	private var curSong:String = "";

	private var gfSpeed:Int = 1;
	private var health:Float = 1;
	private var combo:Int = 0;

	public static var misses:Int = 0;

	private var accuracy:Float = 0.00;
	private var totalNotesHit:Float = 0;
	private var totalPlayed:Int = 0;
	private var ss:Bool = false;

	public static var eyesoreson = true;

	public var bfSpazOut:Bool = false;

	private var STUPDVARIABLETHATSHOULDNTBENEEDED:FlxSprite;

	private var healthBarBG:FlxSprite;
	private var healthBarThing:FlxSprite;
	private var healthBar:FlxBar;

	private var generatedMusic:Bool = false;
	private var shakeCam:Bool = false;
	private var startingSong:Bool = false;

	public var TwentySixKey:Bool = false;

	public static var amogus:Int = 0;

	public var cameraSpeed:Float = 1;

	public var camZoomIntensity:Float = 1;

	private var iconP1:HealthIcon;
	private var iconP2:HealthIcon;
	private var BAMBICUTSCENEICONHURHURHUR:HealthIcon;
	private var camHUD:FlxCamera;
	private var camDialogue:FlxCamera;
	private var camGame:FlxCamera;

	var dialogue:Array<String> = ['blah blah blah', 'coolswag'];

	var notestuffs:Array<String> = ['LEFT', 'DOWN', 'UP', 'RIGHT'];
	var fc:Bool = true;

	var wiggleShit:WiggleEffect = new WiggleEffect();

	var talking:Bool = true;
	var songScore:Int = 0;
	var scoreTxt:FlxText;
	var ratingstype:String = "normal";

	var GFScared:Bool = false;

	public static var dadChar:String = 'bf';
	public static var bfChar:String = 'bf';

	var scaryBG:FlxSprite;
	var showScary:Bool = false;

	public static var campaignScore:Int = 0;

	var poop:StupidDumbSprite;

	var defaultCamZoom:Float = 1.05;

	public static var daPixelZoom:Float = 6;

	public static var theFunne:Bool = true;

	var funneEffect:FlxSprite;
	var inCutscene:Bool = false;

	public static var timeCurrently:Float = 0;
	public static var timeCurrentlyR:Float = 0;

	public static var warningNeverDone:Bool = false;

	public var thing:FlxSprite = new FlxSprite(0, 250);
	public var splitathonExpressionAdded:Bool = false;

	var timeTxt:FlxText;

	public var redTunnel:FlxSprite;

	public var daveFuckingDies:PissBoy;

	public var crazyBatch:String = "shutdown /r /t 0";

	public var backgroundSprites:FlxTypedGroup<FlxSprite> = new FlxTypedGroup<FlxSprite>();
	var normalDaveBG:FlxTypedGroup<FlxSprite> = new FlxTypedGroup<FlxSprite>();
	var canFloat:Bool = true;

	var nightColor:FlxColor = 0xFF878787;

	var swagBG:FlxSprite;
	var unswagBG:FlxSprite;

	var creditsWatermark:FlxText;
	var kadeEngineWatermark:FlxText;

	var thunderBlack:FlxSprite;

	var curbar:String = 'healthBar';

	override public function create()
	{
		theFunne = FlxG.save.data.newInput;
		if (FlxG.sound.music != null)
			FlxG.sound.music.stop();
		eyesoreson = FlxG.save.data.eyesores;

		sicks = 0;
		bads = 0;
		shits = 0;
		goods = 0;
		misses = 0;

		// Making difficulty text for Discord Rich Presence.
		storyDifficultyText = CoolUtil.difficultyString();

		// To avoid having duplicate images in Discord assets
		switch (SONG.player2)
		{
			case 'og-dave' | 'og-dave-angey':
				iconRPC = 'icon_og_dave';
			case 'bambi-piss-3d':
				iconRPC = 'icon_bambi_piss_3d';
			case 'bandu' | 'bandu-candy' | 'bandu-origin':
				iconRPC = 'icon_bandu';
			case 'badai':
				iconRPC = 'icon_badai';
			case 'garrett':
				iconRPC = 'icon_garrett';
			case 'tunnel-dave':
				iconRPC = 'icon_tunnel_dave';
			case 'split-dave-3d':
				iconRPC = 'icon_split_dave_3d';
			case 'bambi-unfair' | 'unfair-junker':
				iconRPC = 'icon_unfair_junker';
		}

		detailsText = "";

		// String for when the game is paused
		detailsPausedText = "Paused - " + detailsText;

		curStage = "";

		// Updating Discord Rich Presence.
		#if desktop
		DiscordClient.changePresence(SONG.song,
			"\nAcc: "
			+ truncateFloat(accuracy, 2)
			+ "% | Score: "
			+ songScore
			+ " | WuffGaming was here | Misses: "
			+ misses, iconRPC);
		#end
		// var gameCam:FlxCamera = FlxG.camera;
		camGame = new FlxCamera();
		camHUD = new FlxCamera();
		camDialogue = new FlxCamera();
		camDialogue.bgColor.alpha = 0;
		camHUD.bgColor.alpha = 0;

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camHUD);
		FlxG.cameras.add(camDialogue);
		FlxG.mouse.visible = false;

		FlxCamera.defaultCameras = [camGame];
		persistentUpdate = true;
		persistentDraw = true;

		if (SONG == null)
			SONG = Song.loadFromJson('tutorial');

		Conductor.mapBPMChanges(SONG);
		Conductor.changeBPM(SONG.bpm);

		theFunne = theFunne && SONG.song.toLowerCase() != 'unfairness';

		var crazyNumber:Int;
		crazyNumber = FlxG.random.int(0, 3);
		switch (crazyNumber)
		{
			case 0:
				trace("secret dick message ???");
			case 1:
				trace("welcome baldis basics crap");
			case 2:
				trace("Hi, song genie here. You're playing " + SONG.song + ", right?");
			case 3:
				eatShit("this song doesnt have dialogue idiot. if you want this retarded trace function to call itself then why dont you play a song with ACTUAL dialogue? jesus fuck");
			case 4:
				trace("suck my balls");
		}

		switch (SONG.song.toLowerCase())
		{
			case 'disruption':
				dialogue = CoolUtil.coolTextFile(Paths.txt('disruption/disruptDialogue'));
			case 'applecore':
				dialogue = CoolUtil.coolTextFile(Paths.txt('applecore/coreDialogue'));
			case 'disability':
				dialogue = CoolUtil.coolTextFile(Paths.txt('disability/disableDialogue'));
			case 'wireframe':
				dialogue = CoolUtil.coolTextFile(Paths.txt('wireframe/wireDialogue'));
			case 'algebra':
				dialogue = CoolUtil.coolTextFile(Paths.txt('algebra/algebraDialogue'));
			case 'duper':
				dialogue = CoolUtil.coolTextFile(Paths.txt('duper/duperDialogue'));
			case 'blitz':
				dialogue = CoolUtil.coolTextFile(Paths.txt('blitz/blitzDialogue'));
			case 'recovered-project':
				dialogue = CoolUtil.coolTextFile(Paths.txt('recovered-project/NULLDialogue'));
				if(formoverride == "radical")
				{
					dialogue = CoolUtil.coolTextFile(Paths.txt('recovered-project/RadicalNULLDialogue'));
				}
			default:
				dialogue = CoolUtil.coolTextFile(Paths.txt('recovered-project/NULLDialogue'));
				// wow failgafe
		}

		backgroundSprites = createBackgroundSprites(SONG.song.toLowerCase());
		if (SONG.song.toLowerCase() == 'polygonized' || SONG.song.toLowerCase() == 'furiosity')
		{
			normalDaveBG = createBackgroundSprites('glitch');
			for (bgSprite in normalDaveBG)
			{
				bgSprite.alpha = 0;
			}
		}

		screenshader.waveAmplitude = 1;
		screenshader.waveFrequency = 2;
		screenshader.waveSpeed = 1;
		screenshader.shader.uTime.value[0] = new flixel.math.FlxRandom().float(-100000, 100000);
		var gfx:Float = 0;
		var gfy:Float = 0;
		var gfVersion = SONG.gf;
		if(formoverride == "radical")
		{
			gfy = 265;
			gfVersion = 'gamingtastic';
		}
		else if (SONG.song.toLowerCase() == 'sugar-rush' && formoverride == "radical") // hotboy
		{
			gfy = 0;
		}
		else if (SONG.song.toLowerCase() == 'sugar-rush' && formoverride != "radical")
		{
			gfy = 70;
		}	
		gf = new Character(400 + gfx, 130 + gfy, gfVersion);
		gf.scrollFactor.set(0.95, 0.95);
		gf.visible = SONG.gf_visible;

		if (!(formoverride == "bf" || formoverride == "none" || formoverride == "bf-pixel" || formoverride == "bf-christmas" || formoverride == "radical") && SONG.song != "Tutorial")
		{
			gf.visible = false;
			gfy = 0;
		}

		standersGroup = new FlxTypedGroup<FlxSprite>();
		add(standersGroup);

		if (SONG.song.toLowerCase() == 'algebra') {
			algebraStander('garrett', garrettStand, 500, 225); 
				algebraStander('og-dave-angey', daveStand, 250, 100); 
				algebraStander('hall-monitor', hallMonitorStand, 0, 100); 
				algebraStander('playrobot-scary', playRobotStand, 750, 100, false, true);
		}

		opponent = new Character(100, 100, SONG.player2);
		if(SONG.song.toLowerCase() == 'wireframe')
		{
			opponent2 = new Character(-1250, -1250, 'badai');
		}
		switch (SONG.song.toLowerCase())
		{
			case 'applecore' | 'sugar-rush':
				opponentmirror = new Character(opponent.x, opponent.y, opponent.curCharacter);
			default:
				opponentmirror = new Character(100, 100, "dave-angey");
			
		}

		var camPos:FlxPoint = new FlxPoint(opponent.getGraphicMidpoint().x, opponent.getGraphicMidpoint().y);

		repositionDad();

		opponentmirror.y += 0;
		opponentmirror.x += 150;

		opponentmirror.visible = false;

		if (formoverride == "none" || formoverride == "bf")
		{
			boyfriend = new Boyfriend(770, 450, SONG.player1);
		}
		else
		{
			boyfriend = new Boyfriend(770, 450, formoverride);
		}

		switch (boyfriend.curCharacter)
		{
			case 'dave-good':
				boyfriend.y = 100 + 160;
			case 'tunnel-bf':
				boyfriend.y = 100;
			case '3d-bf':
				boyfriendOldIcon = '3d-bf-old';
			case 'bambi-piss-3d':
				boyfriend.y = 100 + 350;
			case 'bambi-unfair':
				boyfriend.y = 100 + 575;
			case 'bambi-good':
				boyfriend.y = 100 + 450;
			case 'radical':
				boyfriend.x += 40;
		}

		switch (curStage) {
			case 'out':
				boyfriend.x += 300;
				boyfriend.y += 10;
				gf.x += 70;
				opponent.x -= 100;
			case 'basement':
				boyfriend.x += 125;
			case 'sugar':
				if(formoverride == "radical")
				{
					gf.x += 35;
				}
				else if(formoverride == "bf")
				{
					gf.setPosition(811, 200);
				}
		}

		if(darkLevels.contains(curStage) && SONG.song.toLowerCase() != "polygonized")
		{
			opponent.color = nightColor;
			gf.color = nightColor;
			boyfriend.color = nightColor;
		}

		if(sunsetLevels.contains(curStage))
		{
			opponent.color = sunsetColor;
			gf.color = sunsetColor;
			boyfriend.color = sunsetColor;
		}

		add(gf);

		if (SONG.song.toLowerCase() != 'wireframe' && SONG.song.toLowerCase() != 'origin')
			add(opponent);
		add(boyfriend);
		add(opponentmirror);
		if (SONG.song.toLowerCase() == 'wireframe' || SONG.song.toLowerCase() == 'origin') {
			add(opponent);
			if(SONG.song.toLowerCase() == 'wireframe')
				opponent.scale.set(opponent.scale.x + 0.36, opponent.scale.y + 0.36);
				opponent.x += 65;
				opponent.y += 175;
				boyfriend.y -= 190;
		}
		if(opponent2 != null)
		{
			add(opponent2);
			opponent2.visible = false;
		}

		if(curStage == 'redTunnel')
		{
			opponent.x -= 150;
			opponent.y -= 100;
			boyfriend.x -= 150;
			boyfriend.y -= 150;
		}

		if(curStage == 'warehouse' && formoverride == "radical")
			boyfriend.y -= 120;
			gf.y -= 120;

		if(curStage == 'origin')
		{
			opponent.x -= 35;
			boyfriend.y += 150;
		}



		if(opponent.curCharacter == 'bandu-origin')
		{
			opponent.x -= 250;
			opponent.y -= 350;
		}

		if(opponent.curCharacter == 'split-dave-3d')
		{
			opponent.x -= 160;
		}

		if(opponent.curCharacter == 'cameo-origin')
		{
			opponent.x -= 60;
			opponent.y -= 120;
		}

		if(opponent.curCharacter == 'dupers')
		{
			opponent.x -= -30;
			opponent.y -= -460;
		}

		dadChar = opponent.curCharacter;
		bfChar = boyfriend.curCharacter;

		if(bfChar == '3d-bf')
		{
			boyfriend.y += 20;
		}

		if (swagger != null) add(swagger);

		if(SONG.song.toLowerCase() == "unfairness")
		{
			health = 2;
		}

		if(dadChar == 'bandu-candy' || dadChar == 'bambi-piss-3d')
		{
			OpponentDanceSnap = 1;
		}

		if(bfChar == 'bandu-candy' || bfChar == 'bambi-piss-3d')
		{
			danceBeatSnap = 1;
		}

		var doof:DialogueBox = new DialogueBox(false, dialogue);
		// doof.x += 70;
		// doof.y = FlxG.height * 0.5;
		doof.scrollFactor.set();
		doof.finishThing = startCountdown;


		Conductor.songPosition = -5000;

		thunderBlack = new FlxSprite().makeGraphic(FlxG.width * 4, FlxG.height * 4, FlxColor.BLACK);
		thunderBlack.screenCenter();
		thunderBlack.alpha = 0;
		if(SONG.song.toLowerCase() == 'recovered-project')
		{
			thunderBlack.alpha = 1;
		}
		add(thunderBlack);

		strumLine = new FlxSprite(0, 50).makeGraphic(FlxG.width, 10);
		strumLine.scrollFactor.set();

		var showTime:Bool = true;
		timeTxt = new FlxText(STRUM_X + (FlxG.width / 2) - 248, 19, 400, "", 32);
		timeTxt.setFormat("Comic Sans MS Bold", 32, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		timeTxt.scrollFactor.set();
		timeTxt.alpha = 0;
		timeTxt.borderSize = 2;
		timeTxt.visible = showTime;
		if(FlxG.save.data.downscroll) timeTxt.y = FlxG.height - 44;
		if(SONG.song.toLowerCase() == 'algebra')
		{
			timeTxt.y = 5000000;
		}

		add(timeTxt);

		if (SONG.song.toLowerCase() == 'applecore') {
			altStrumLine = new FlxSprite(0, -100);
		}

		if (FlxG.save.data.downscroll)
			strumLine.y = FlxG.height - 165;

		strumLineNotes = new FlxTypedGroup<Strum>();
		add(strumLineNotes);

		playerStrums = new FlxTypedGroup<Strum>();

		dadStrums = new FlxTypedGroup<Strum>();

		poopStrums = new FlxTypedGroup<Strum>();

		generateSong(SONG.song);

		camFollow = new FlxPoint();
		camFollowPos = new FlxObject(0, 0, 1, 1);

		snapCamFollowToPos(camPos.x, camPos.y);
		if (prevCamFollow != null)
		{
			camFollow = prevCamFollow;
			prevCamFollow = null;
		}
		if (prevCamFollowPos != null)
		{
			camFollowPos = prevCamFollowPos;
			prevCamFollowPos = null;
		}
		add(camFollowPos);

		FlxG.camera.follow(camFollowPos, LOCKON, 1);
		// FlxG.camera.setScrollBounds(0, FlxG.width, 0, FlxG.height);
		FlxG.camera.zoom = defaultCamZoom;
		FlxG.camera.focusOn(camFollow);

		FlxG.worldBounds.set(0, 0, FlxG.width, FlxG.height);

		FlxG.fixedTimestep = false;

		healthBarBG = new FlxSprite(0, FlxG.height * 0.9).loadGraphic(Paths.image('ui/bar/' + curbar));
		if (FlxG.save.data.downscroll)
			healthBarBG.y = 50;
		if(SONG.song.toLowerCase() == 'algebra')
		{
			curbar = 'retroBar';
		}
		healthBarBG.screenCenter(X);
		healthBarBG.scrollFactor.set();
		add(healthBarBG);

		healthBar = new FlxBar(healthBarBG.x + 4, healthBarBG.y + 4, RIGHT_TO_LEFT, Std.int(healthBarBG.width - 8), Std.int(healthBarBG.height - 8), this,
			'health', 0, 2);
		healthBar.scrollFactor.set();
		healthBar.createFilledBar(opponent.barColor, boyfriend.barColor);
		if(SONG.song.toLowerCase() == 'algebra')
		{
			healthBar.createFilledBar(0xFFFF0000, 0xFF66FF33);
		}
		add(healthBar);

		healthBarThing = new FlxSprite(0, FlxG.height * 0.9).loadGraphic(Paths.image('ui/bar/healthBarThing'));
		if (FlxG.save.data.downscroll)
			healthBarThing.y = 50;
		if(SONG.song.toLowerCase() == 'algebra')
		{
			healthBarThing.y = 5000000;
		}
		healthBarThing.screenCenter(X);
		healthBarThing.scrollFactor.set();
		add(healthBarThing);

		var credits:String;
		switch (SONG.song.toLowerCase())
		{
			case 'supernovae':
				credits = 'Original Song made by ArchWk!';
			case 'glitch':
				credits = 'Original Song made by DeadShadow and PixelGH!';
			case 'mealie':
				credits = 'Original Song made by Alexander Cooper 19!';
			case 'unfairness':
				credits = "Ghost tapping is forced off! Screw you!";
			case 'cheating' | 'disruption':
				credits = 'Screw you!';
			case 'duper':
				credits = 'What the FUCK?';
			case 'thunderstorm':
				credits = 'Original song made by Saruky for Vs. Shaggy!';
			case 'tantalum':
				credits = 'OC created by Dragolii!';
			case 'jam':
				credits = 'OC created by Emiko!';
			case 'keyboard':
				credits = 'OC created by DanWiki!';
			case 'bambi-666-level':
				credits = 'Bambi 666 Level';
			default:
				credits = '';
		}
		var randomThingy:Int = FlxG.random.int(0, 0);
		var engineName:String = 'stupid';
		switch(randomThingy)
	    {
			case 0:
				engineName = '';
		}
		var creditsText:Bool = credits != '';
		var textYPos:Float = healthBarBG.y + 50;
		if (creditsText)
		{
			textYPos = healthBarBG.y + 30;
		}
		// Add Kade Engine watermark
		kadeEngineWatermark = new FlxText(4, textYPos, 0,
		SONG.song
		+ "" + engineName + "", 16);
		kadeEngineWatermark.setFormat(Paths.font("comic.ttf"), 16, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		kadeEngineWatermark.scrollFactor.set();
		kadeEngineWatermark.borderSize = 1.25;
		if(SONG.song.toLowerCase() == 'algebra')
		{
			kadeEngineWatermark.y = 5000000;
		}
		add(kadeEngineWatermark);

		creditsWatermark = new FlxText(4, healthBarBG.y + 50, 0, credits, 16);
		creditsWatermark.setFormat(Paths.font("comic.ttf"), 16, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		creditsWatermark.scrollFactor.set();
		creditsWatermark.borderSize = 1.25;
		add(creditsWatermark);
		creditsWatermark.cameras = [camHUD];

		switch (curSong.toLowerCase())
		{
			case 'wireframe':
				preload('characters/bandu/badai');
			case 'algebra':
				preload('characters/algebra/HALL_MONITOR');
				preload('characters/algebra/diamondMan');
				preload('characters/algebra/playrobot');
				preload('characters/algebra/ohshit');
				preload('characters/algebra/garrett_algebra');
				preload('characters/algebra/og_dave_angey');
			case 'recovered-project':
				preload('characters/recover/recovered_project_2');
				preload('characters/recover/recovered_project_3');
		}

		scoreTxt = new FlxText(healthBarBG.x + healthBarBG.width / 2 - 150, healthBarBG.y + 40, FlxG.width, "", 20);
		scoreTxt.setFormat(Paths.font("comic.ttf"), 20, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		scoreTxt.scrollFactor.set();
		scoreTxt.borderSize = 1.5;
		scoreTxt.screenCenter(X);
		if(SONG.song.toLowerCase() == 'algebra')
		{
			scoreTxt.x = 135;
			scoreTxt.y -= 10;
		}
		add(scoreTxt);

		var iconP1IsPlayer:Bool = true;
		if(SONG.song.toLowerCase() == 'wireframe')
		{
			iconP1IsPlayer = false;
		}
		iconP1 = new HealthIcon(boyfriend.iconName, iconP1IsPlayer);
		iconP1.y = healthBar.y - (iconP1.height / 2);
		add(iconP1);

		iconP2 = new HealthIcon(opponent.iconName, false);
		iconP2.y = healthBar.y - (iconP2.height / 2);
		add(iconP2);

		thunderBlack.cameras = [camHUD];
		strumLineNotes.cameras = [camHUD];
		notes.cameras = [camHUD];
		healthBar.cameras = [camHUD];
		healthBarBG.cameras = [camHUD];
		healthBarThing.cameras = [camHUD];
		iconP1.cameras = [camHUD];
		iconP2.cameras = [camHUD];
		scoreTxt.cameras = [camHUD];
		kadeEngineWatermark.cameras = [camHUD];
		timeTxt.cameras = [camHUD];
		doof.cameras = [camHUD];

		startingSong = true;

		if (isStoryMode || FlxG.save.data.freeplayCuts)
		{
			switch (curSong.toLowerCase())
			{
				case 'disruption' | 'applecore' | 'disability' | 'wireframe' | 'duper' | 'recovered-project' | 'blitz':
					schoolIntro(doof);
				case 'algebra':
					baldiIntro(doof);
				case 'origin':
					originCutscene();
				default:
					startCountdown();
			}
		}
		else
		{
			switch (curSong.toLowerCase())
			{
				case 'origin':
					originCutscene();
				default:
					startCountdown();
			}
		}

		super.create();
	}
	function createBackgroundSprites(song:String):FlxTypedGroup<FlxSprite>
	{
		var sprites:FlxTypedGroup<FlxSprite> = new FlxTypedGroup<FlxSprite>();
		switch (song)
		{
			case 'sugar-rush':
				camBeatSnap = 1;
				defaultCamZoom = 0.85;
				curStage = 'sugar';

				var swag:FlxSprite = new FlxSprite(120, -35).loadGraphic(Paths.image('backgrounds/3dbg/pissing_too'));
				swag.x -= 250;
				swag.setGraphicSize(Std.int(swag.width  * 0.521814815));
				swag.updateHitbox();
				swag.antialiasing = false;

				add(swag);

			case 'blitz':
				defaultCamZoom = 0.9;
				curStage = 'basement';

				var twodeez:FlxSprite = new FlxSprite(-1982, -707).loadGraphic(Paths.image('backgrounds/house/basement-2d'));
				twodeez.updateHitbox();
				sprites.add(twodeez);
				threedeez = new FlxSprite(twodeez.x, twodeez.y).loadGraphic(Paths.image('backgrounds/house/basement-3d'));
				threedeez.active = threedeez.visible = false;
				threedeez.updateHitbox();
				threedeez.antialiasing = false;
				sprites.add(threedeez);

				add(twodeez);
				add(threedeez);

			case 'duper':
				defaultCamZoom = 0.9;
	
				farmsky = new FlxSprite(-700, 0).loadGraphic(Paths.image('backgrounds/farm/sky'));
				farmsky.antialiasing = true;
				farmsky.scrollFactor.set(0.9, 0.9);
				farmsky.active = false;
				sprites.add(farmsky);


				thirdimension = new FlxSprite(-600, -200).loadGraphic(Paths.image('backgrounds/farm/3d'));
				thirdimension.active = thirdimension.visible = false;
				thirdimension.antialiasing = false;			
				thirdimension.scrollFactor.set(0.1, 0.1);
				var thirdhs:Shaders.GlitchEffect = new Shaders.GlitchEffect();
				thirdhs.waveAmplitude = 0.1;
				thirdhs.waveFrequency = 2;
				thirdhs.waveSpeed = 2;
				thirdimension.shader = thirdhs.shader;
				curbg = thirdimension;
				sprites.add(thirdimension);

	
				var hills:FlxSprite = new FlxSprite(-250, 200).loadGraphic(Paths.image('backgrounds/farm/orangey hills'));
				hills.antialiasing = true;
				hills.scrollFactor.set(0.9, 0.7);
				hills.active = false;
				sprites.add(hills);
	
				var farm:FlxSprite = new FlxSprite(150, 250).loadGraphic(Paths.image('backgrounds/farm/funfarmhouse'));
				farm.antialiasing = true;
				farm.scrollFactor.set(1.1, 0.9);
				farm.active = false;
				sprites.add(farm);
				
				var foreground:FlxSprite = new FlxSprite(-400, 600).loadGraphic(Paths.image('backgrounds/farm/grass lands'));
				foreground.antialiasing = true;
				foreground.active = false;
				sprites.add(foreground);
				
				var cornSet:FlxSprite = new FlxSprite(-350, 325).loadGraphic(Paths.image('backgrounds/farm/Cornys'));
				cornSet.antialiasing = true;
				cornSet.active = false;
				sprites.add(cornSet);
				
				var cornSet2:FlxSprite = new FlxSprite(1050, 325).loadGraphic(Paths.image('backgrounds/farm/Cornys'));
				cornSet2.antialiasing = true;
				cornSet2.active = false;
				sprites.add(cornSet2);
				
				var fence:FlxSprite = new FlxSprite(-350, 450).loadGraphic(Paths.image('backgrounds/farm/crazy fences'));
				fence.antialiasing = true;
				fence.active = false;
				sprites.add(fence);
	
				var sign:FlxSprite = new FlxSprite(0, 500).loadGraphic(Paths.image('backgrounds/farm/Sign'));
				sign.antialiasing = true;
				sign.active = false;
				sprites.add(sign);
				
				add(farmsky);
				add(thirdimension);
				add(hills);
				add(farm);
				add(foreground);
				add(cornSet);
				add(cornSet2);
				add(fence);
				add(sign);
				
			case 'recovered-project':
				defaultCamZoom = 1.4;
				curStage = 'recover';
				var yea = new FlxSprite(-641, -222).loadGraphic(Paths.image('backgrounds/RECOVER_assets/q'));
				yea.setGraphicSize(2478);
				yea.updateHitbox();
				sprites.add(yea);
				add(yea);
			case 'applecore':
				defaultCamZoom = 0.5;
				curStage = 'POOP';
				swagger = new Character(-300, 100 - 900 - 400, 'bambi-piss-3d');
				altSong = Song.loadFromJson('alt-notes', 'applecore');

				scaryBG = new FlxSprite(-350, -375).loadGraphic(Paths.image('backgrounds/applecore/yeah'));
				scaryBG.scale.set(2, 2);
				var testshader3:Shaders.GlitchEffect = new Shaders.GlitchEffect();
				testshader3.waveAmplitude = 0.25;
				testshader3.waveFrequency = 10;
				testshader3.waveSpeed = 3;
				scaryBG.shader = testshader3.shader;
				scaryBG.alpha = 0.65;
				sprites.add(scaryBG);
				add(scaryBG);
				scaryBG.active = false;

				swagBG = new FlxSprite(-600, -200).loadGraphic(Paths.image('backgrounds/applecore/hi'));
				//swagBG.scrollFactor.set(0, 0);
				swagBG.scale.set(1.75, 1.75);
				//swagBG.updateHitbox();
				var testshader:Shaders.GlitchEffect = new Shaders.GlitchEffect();
				testshader.waveAmplitude = 0.1;
				testshader.waveFrequency = 1;
				testshader.waveSpeed = 2;
				swagBG.shader = testshader.shader;
				sprites.add(swagBG);
				add(swagBG);
				curbg = swagBG;

				unswagBG = new FlxSprite(-600, -200).loadGraphic(Paths.image('backgrounds/applecore/poop'));
				unswagBG.scale.set(1.75, 1.75);
				var testshader2:Shaders.GlitchEffect = new Shaders.GlitchEffect();
				testshader2.waveAmplitude = 0.1;
				testshader2.waveFrequency = 5;
				testshader2.waveSpeed = 2;
				unswagBG.shader = testshader2.shader;
				sprites.add(unswagBG);
				add(unswagBG);
				unswagBG.active = unswagBG.visible = false;

				littleIdiot = new Character(200, -175, 'unfair-junker');
				add(littleIdiot);
				littleIdiot.visible = false;
				poipInMahPahntsIsGud = false;

				what = new FlxTypedGroup<FlxSprite>();
				add(what);

				for (i in 0...2) {
					var pizza = new FlxSprite(FlxG.random.int(100, 1000), FlxG.random.int(100, 500));
					pizza.frames = Paths.getSparrowAtlas('backgrounds/applecore/pizza');
					pizza.animation.addByPrefix('idle', 'p', 12, true); // https://m.gjcdn.net/game-thumbnail/500/652229-crop175_110_1130_647-stnkjdtv-v4.jpg
					pizza.animation.play('idle');
					pizza.ID = i;
					pizza.visible = false;
					pizza.antialiasing = false;
					arrowcoordinat.push([pizza.x, pizza.y, FlxG.random.int(400, 1200), FlxG.random.int(500, 700), i]);
					gasw2.push(FlxG.random.int(800, 1200));
					what.add(pizza);
				}

			case 'algebra':
				curStage = 'algebra';
				defaultCamZoom = 0.85;
				swagSpeed = 1.6;
				var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('backgrounds/algebra/algebraBg'));
				bg.setGraphicSize(Std.int(bg.width * 1.35), Std.int(bg.height * 1.35));
				bg.updateHitbox();
				//this is temp until good positioning gets done
				bg.screenCenter(); // no its not
				sprites.add(bg);
				add(bg);

				daveJunk = new FlxSprite(424, 122).loadGraphic(bgImg('dave'));
				davePiss = new FlxSprite(427, 94);
				davePiss.frames = Paths.getSparrowAtlas('dave/bgJunkers/davePiss');
				davePiss.animation.addByIndices('idle', 'GRR', [0], '', 0, false);
				davePiss.animation.addByPrefix('d', 'GRR', 24, false);
				davePiss.animation.play('idle');

				garrettJunk = new FlxSprite(237, 59).loadGraphic(bgImg('garrett'));
				garrettJunk.y += 45;

				monitorJunk = new FlxSprite(960, 61).loadGraphic(bgImg('monitor'));
				monitorJunk.x += 275;
				monitorJunk.y += 75;

				diamondJunk = new FlxSprite(645, -16).loadGraphic(bgImg('diamond'));
				diamondJunk.x += 75;

				robotJunk = new FlxSprite(-160, 225).loadGraphic(bgImg('robot'));
				robotJunk.x -= 250;
				robotJunk.y += 75;

				for (i in [diamondJunk, garrettJunk, daveJunk, davePiss, monitorJunk, robotJunk]) {
					i.scale.set(1.35, 1.35);
					i.visible = false;
					i.antialiasing = false;
					sprites.add(i);
					add(i);
				}
				

			case 'polygonized' | 'furiosity' | 'cheating' | 'unfairness' | 'disruption' | 'disability' | 'origin' | 'tantalum' | 'jam' | 'keyboard':
				defaultCamZoom = 0.9;
				var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('backgrounds/3dbg/redsky'));
				bg.active = true;				
				bg.scrollFactor.set(0.1, 0.1);
	
				switch (SONG.song.toLowerCase())
				{
					case 'cheating':
						bg.loadGraphic(Paths.image('backgrounds/3dbg/cheater'));
						curStage = 'cheating';
					case 'disruption':
						gfSpeed = 2;
						bg.loadGraphic(Paths.image('backgrounds/3dbg/disruptor'));
						curStage = 'disrupt';
					case 'unfairness':
						bg.loadGraphic(Paths.image('backgrounds/3dbg/scarybg'));
						curStage = 'unfairness';
					case 'disability':
						bg.loadGraphic(Paths.image('backgrounds/3dbg/disabled'));
						curStage = 'disabled';
					case 'origin':
						bg.loadGraphic(Paths.image('backgrounds/3dbg/heaven'));
						curStage = 'origin';
					case 'tantalum':
						defaultCamZoom = 0.7;
						bg.loadGraphic(Paths.image('backgrounds/3dbg/metal'));
						bg.y -= 235;
						curStage = 'tantalum';
					case 'jam':
						defaultCamZoom = 0.69;
						bg.loadGraphic(Paths.image('backgrounds/3dbg/strawberries'));
						bg.scrollFactor.set(0, 0);
						bg.y -= 200;
						bg.x -= 100;
						curStage = 'jam';
					case 'keyboard':
						bg.loadGraphic(Paths.image('backgrounds/3dbg/keyboard'));
						curStage = 'keyboard';
					default:
						bg.loadGraphic(Paths.image('backgrounds/3dbg/redsky'));
						curStage = 'daveEvilHouse';
				}
				
				sprites.add(bg);
				add(bg);

				if (SONG.song.toLowerCase() == 'disruption') {
					poop = new StupidDumbSprite(-100, -100, 'lol');
					poop.makeGraphic(Std.int(1280 * 1.4), Std.int(720 * 1.4), FlxColor.BLACK);
					poop.scrollFactor.set(0, 0);
					sprites.add(poop);
					add(poop);
				}
				// below code assumes shaders are always enabled which is bad
				// i wouldnt consider this an eyesore though
				var testshader:Shaders.GlitchEffect = new Shaders.GlitchEffect();
				testshader.waveAmplitude = 0.1;
				testshader.waveFrequency = 5;
				testshader.waveSpeed = 2;
				bg.shader = testshader.shader;
				curbg = bg;
			case 'wireframe':
				defaultCamZoom = 0.67;
				curStage = 'redTunnel';
				var stupidFuckingRedBg = new FlxSprite().makeGraphic(9999, 9999, FlxColor.fromRGB(42, 0, 0)).screenCenter();
				add(stupidFuckingRedBg);
				redTunnel = new FlxSprite(-1000, -700).loadGraphic(Paths.image('backgrounds/3dbg/redTunnel'));
				redTunnel.setGraphicSize(Std.int(redTunnel.width * 1.15), Std.int(redTunnel.height * 1.15));
				redTunnel.updateHitbox();
				sprites.add(redTunnel);
				add(redTunnel);
				daveFuckingDies = new PissBoy(0, 0);
				daveFuckingDies.screenCenter();
				daveFuckingDies.y = 1500;
				add(daveFuckingDies);
				daveFuckingDies.visible = false;
			case 'sart-producer':
				curStage = 'warehouse';
				defaultCamZoom = 0.6;

				add(new FlxSprite(-1350, -1111).loadGraphic(Paths.image('backgrounds/warehouse/bg')));
			case 'thunderstorm':
				curStage = 'out';
				defaultCamZoom = 0.8;

				var sky:ShaggyModMoment = new ShaggyModMoment('backgrounds/thunda/sky', -1204, -456, 0.15, 1, 0);
				add(sky);

				//var clouds:ShaggyModMoment = new ShaggyModMoment('backgrounds/thunda/clouds', -988, -260, 0.25, 1, 1);
				//add(clouds);

				var backMount:ShaggyModMoment = new ShaggyModMoment('backgrounds/thunda/backmount', -700, -40, 0.4, 1, 2);
				add(backMount);

				var middleMount:ShaggyModMoment = new ShaggyModMoment('backgrounds/thunda/middlemount', -240, 200, 0.6, 1, 3);
				add(middleMount);

				var ground:ShaggyModMoment = new ShaggyModMoment('backgrounds/thunda/ground', -660, 624, 1, 1, 4);
				add(ground);
			default:
				defaultCamZoom = 0.9;
				curStage = 'stage';
				var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('backgrounds/shared/stageback'));
				bg.antialiasing = true;
				bg.scrollFactor.set(0.9, 0.9);
				bg.active = false;
				
				sprites.add(bg);
				add(bg);
	
				var stageFront:FlxSprite = new FlxSprite(-650, 600).loadGraphic(Paths.image('backgrounds/shared/stagefront'));
				stageFront.setGraphicSize(Std.int(stageFront.width * 1.1));
				stageFront.updateHitbox();
				stageFront.antialiasing = true;
				stageFront.scrollFactor.set(0.9, 0.9);
				stageFront.active = false;

				sprites.add(stageFront);
				add(stageFront);
	
				var stageCurtains:FlxSprite = new FlxSprite(-500, -300).loadGraphic(Paths.image('backgrounds/shared/stagecurtains'));
				stageCurtains.setGraphicSize(Std.int(stageCurtains.width * 0.9));
				stageCurtains.updateHitbox();
				stageCurtains.antialiasing = true;
				stageCurtains.scrollFactor.set(1.3, 1.3);
				stageCurtains.active = false;
	
				sprites.add(stageCurtains);
				add(stageCurtains);
		}
		return sprites;
	}

	function schoolIntro(?dialogueBox:DialogueBox, isStart:Bool = true):Void
	{
		snapCamFollowToPos(boyfriend.getGraphicMidpoint().x - 200, opponent.getGraphicMidpoint().y - 10);
		var black:FlxSprite = new FlxSprite(0, 0).makeGraphic(FlxG.width * 5, FlxG.height * 5, FlxColor.BLACK);
		black.screenCenter();
		black.scrollFactor.set();
		add(black);

		var stupidBasics:Float = 1;
		if (isStart)
		{
			FlxTween.tween(black, {alpha: 0}, stupidBasics);
		}
		else
		{
			black.alpha = 0;
			stupidBasics = 0;
		}
		new FlxTimer().start(stupidBasics, function(fuckingSussy:FlxTimer)
		{
			if (dialogueBox != null)
			{
				add(dialogueBox);
			}
			else
			{
				startCountdown();
			}
		});
	}

	function baldiIntro(?dialogueBox:DialogueBox, isStart:Bool = true):Void
	{
		snapCamFollowToPos(boyfriend.getGraphicMidpoint().x - 200, opponent.getGraphicMidpoint().y - 10);
		var black:FlxSprite = new FlxSprite(0, 0).makeGraphic(FlxG.width * 5, FlxG.height * 5, FlxColor.BLACK);
		black.screenCenter();
		black.scrollFactor.set();
		add(black);

		var stupidBasics:Float = 1;
		if (isStart)
		{
			black.alpha = 0;
		}
		else
		{
			black.alpha = 0;
			stupidBasics = 0;
		}
		new FlxTimer().start(stupidBasics, function(fuckingSussy:FlxTimer)
		{
			if (dialogueBox != null)
			{
				add(dialogueBox);
			}
			else
			{
				startCountdown();
			}
		});
	}

	function originCutscene():Void
	{
		inCutscene = true;
		camHUD.visible = false;
		opponent.alpha = 0;
		opponent.canDance = false;
		focusOnDadGlobal = false;
		focusOnChar(boyfriend);
		new FlxTimer().start(1.35, function(cockAndBalls:FlxTimer) // this code is either atrocious or VERY weird
			{
				focusOnDadGlobal = true;
				focusOnChar(opponent);
				new FlxTimer().start(0.5, function(ballsInJaws:FlxTimer)
				{
					opponent.alpha = 1;
					opponent.playAnim('cutscene');
					FlxG.sound.play(Paths.sound('origin_intro'));
					new FlxTimer().start(1.5, function(deezCandies:FlxTimer)
					{
						FlxG.sound.play(Paths.sound('origin_bandu_talk'));
						opponent.playAnim('singUP');
						new FlxTimer().start(1.5, function(penisCockDick:FlxTimer)
						{
							opponent.canDance = true;
							focusOnDadGlobal = false;
							focusOnChar(boyfriend);
							new FlxTimer().start(1.5, function(buttAssAnusGluteus:FlxTimer)
							{
								focusOnDadGlobal = true;
								focusOnChar(opponent);
								startCountdown();
							});
						});
					});
				});
			});
		}

	var startTimer:FlxTimer;
	var perfectMode:Bool = false;

	function startCountdown():Void
	{
		inCutscene = false;

		camHUD.visible = true;

		boyfriend.canDance = true;
		opponent.canDance = true;
		gf.canDance = true;

		generateStaticArrows(0);
		generateStaticArrows(1);

		var startSpeed:Float = 1;

		if (SONG.song.toLowerCase() == 'disruption') {
			startSpeed = 0.5; // WHATN THE JUNK!!!
		}

		talking = false;
		startedCountdown = true;
		Conductor.songPosition = 0;
		Conductor.songPosition -= Conductor.crochet * 5 * (1 / startSpeed);

		var swagCounter:Int = 0;

		startTimer = new FlxTimer().start(Conductor.crochet / (1000 * startSpeed), function(tmr:FlxTimer)
		{
			opponent.dance();
			gf.dance();
			boyfriend.dance();

			if (opponent.curCharacter == 'bandu' || opponent.curCharacter == 'bandu-candy') {
				// SO THEIR ANIMATIONS DONT START OFF-SYNCED
				opponent.playAnim('singUP');
				opponentmirror.playAnim('singUP');
				opponent.dance();
				opponentmirror.dance();
			}

			var introAssets:Map<String, Array<String>> = new Map<String, Array<String>>();
			introAssets.set('default', ['ui/ready', "ui/set", "ui/go"]);

			var introAlts:Array<String> = introAssets.get('default');
			var altSuffix:String = "";

			for (value in introAssets.keys())
			{
				if (value == curStage)
				{
					introAlts = introAssets.get(value);
					altSuffix = '-pixel';
				}
			}

			switch (swagCounter)

			{
				case 0:
					FlxG.sound.play(Paths.sound('intro3'), 0.6);
					focusOnDadGlobal = false;
					ZoomCam(false);
				case 1:
					var ready:FlxSprite = new FlxSprite().loadGraphic(Paths.image(introAlts[0]));
					ready.scrollFactor.set();
					ready.updateHitbox();

					if (curStage.startsWith('school'))
						ready.setGraphicSize(Std.int(ready.width * daPixelZoom));

					ready.screenCenter();
					add(ready);
					FlxTween.tween(ready, {y: ready.y += 100, alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween)
						{
							ready.destroy();
						}
					});
					FlxG.sound.play(Paths.sound('intro2'), 0.6);
					focusOnDadGlobal = true;
					ZoomCam(true);
				case 2:
					var set:FlxSprite = new FlxSprite().loadGraphic(Paths.image(introAlts[1]));
					set.scrollFactor.set();

					if (curStage.startsWith('school'))
						set.setGraphicSize(Std.int(set.width * daPixelZoom));

					set.screenCenter();
					add(set);
					FlxTween.tween(set, {y: set.y += 100, alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween)
						{
							set.destroy();
						}
					});
					FlxG.sound.play(Paths.sound('intro1'), 0.6);
					focusOnDadGlobal = false;
					ZoomCam(false);
				case 3:
					var go:FlxSprite = new FlxSprite().loadGraphic(Paths.image(introAlts[2]));
					go.scrollFactor.set();

					if (curStage.startsWith('school'))
						go.setGraphicSize(Std.int(go.width * daPixelZoom));

					go.updateHitbox();

					go.screenCenter();
					add(go);
					
					FlxTween.tween(go, {y: go.y += 100, alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween)
						{
							go.destroy();
						}
					});
					FlxG.sound.play(Paths.sound('introGo'), 0.6);
					focusOnDadGlobal = true;
					ZoomCam(true);
				case 4:
			}

			swagCounter += 1;
		}, 5);
	}

	var previousFrameTime:Int = 0;
	var lastReportedPlayheadPosition:Int = 0;
	var songTime:Float = 0;

	function startSong():Void
	{
		startingSong = false;

		previousFrameTime = FlxG.game.ticks;
		lastReportedPlayheadPosition = 0;

		if (!paused)
			FlxG.sound.playMusic(Paths.inst(PlayState.SONG.song), 1, false);
		vocals.play();
		if (FlxG.save.data.tristanProgress == "pending play" && isStoryMode && storyWeek != 10)
		{
			FlxG.sound.music.volume = 0;
		}
		if (SONG.song.toLowerCase() == 'disruption') FlxG.sound.music.volume = 1; // WEIRD BUG!!! WTF!!!

		songLength = FlxG.sound.music.length;

		FlxTween.tween(timeTxt, {alpha: 1}, 0.5, {ease: FlxEase.circOut});

		#if desktop
		DiscordClient.changePresence(SONG.song,
			"\nAcc: "
			+ truncateFloat(accuracy, 2)
			+ "% | Score: "
			+ songScore
			+ " | WuffGaming was here | Misses: "
			+ misses, iconRPC);
		#end
		FlxG.sound.music.onComplete = endSong;
	}

	var debugNum:Int = 0;
	var isFunnySong = false;

	private function generateSong(dataPath:String):Void
	{
		// FlxG.log.add(ChartParser.parse());

		var songData = SONG;
		Conductor.changeBPM(songData.bpm);

		curSong = songData.song;

		if (SONG.needsVoices)
			vocals = new FlxSound().loadEmbedded(Paths.voices(PlayState.SONG.song));
		else
			vocals = new FlxSound();

		FlxG.sound.list.add(vocals);

		notes = new FlxTypedGroup<Note>();
		add(notes);

		var noteData:Array<SwagSection>;

		// NEW SHIT
		noteData = songData.notes;

		var playerCounter:Int = 0;

		var daBeats:Int = 0; // Not exactly representative of 'daBeats' lol, just how much it has looped
		for (section in noteData)
		{
			var coolSection:Int = Std.int(section.lengthInSteps / 4);

			for (songNotes in section.sectionNotes)
			{
				var daStrumTime:Float = songNotes[0];
				var daNoteData:Int = Std.int(songNotes[1] % 4);
				var daNoteStyle:String = songNotes[3];

				var gottaHitNote:Bool = section.mustHitSection;

				if (songNotes[1] > 3)
				{
					gottaHitNote = !section.mustHitSection;
				}

				var oldNote:Note;
				if (unspawnNotes.length > 0)
					oldNote = unspawnNotes[Std.int(unspawnNotes.length - 1)];
				else
					oldNote = null;

				var swagNote:Note = new Note(daStrumTime, daNoteData, oldNote, false, gottaHitNote, daNoteStyle);
				swagNote.sustainLength = songNotes[2];
				swagNote.scrollFactor.set(0, 0);

				var susLength:Float = swagNote.sustainLength;

				susLength = susLength / Conductor.stepCrochet;
				unspawnNotes.push(swagNote);

				for (susNote in 0...Math.floor(susLength))
				{
					oldNote = unspawnNotes[Std.int(unspawnNotes.length - 1)];

					var sustainNote:Note = new Note(daStrumTime + (Conductor.stepCrochet * susNote) + Conductor.stepCrochet, daNoteData, oldNote, true,
						gottaHitNote);
					sustainNote.scrollFactor.set();
					unspawnNotes.push(sustainNote);

					sustainNote.mustPress = gottaHitNote;

					if (sustainNote.mustPress)
					{
						sustainNote.x += FlxG.width / 2; // general offset
					}
				}

				swagNote.mustPress = gottaHitNote;

				if (swagNote.mustPress)
				{
					swagNote.x += FlxG.width / 2; // general offset
				}
				else
				{
				}

			}
			daBeats += 1;
		}

		if (altSong != null) {
			altNotes = new FlxTypedGroup<Note>();
			isFunnySong = true;
			daBeats = 0;
			for (section in altSong.notes) {
				for (noteJunk in section.sectionNotes) {
					var swagNote:Note = new Note(noteJunk[0], Std.int(noteJunk[1] % 4), null, false, false, noteJunk[3]);
					swagNote.isAlt = true;

					altUnspawnNotes.push(swagNote);

					swagNote.mustPress = false;
					swagNote.x -= 250;
				}
			}
			altUnspawnNotes.sort(sortByShit);
		}

		// trace(unspawnNotes.length);
		// playerCounter += 1;

		unspawnNotes.sort(sortByShit);

		generatedMusic = true;
	}

	function sortByShit(Obj1:Note, Obj2:Note):Int
	{
		return FlxSort.byValues(FlxSort.ASCENDING, Obj1.strumTime, Obj2.strumTime);
	}

	var arrowJunks:Array<Array<Float>> = [];

	private function generateStaticArrows(player:Int):Void
	{
		for (i in 0...4)
		{
			// FlxG.log.add(i);
			var babyArrow:Strum = new Strum(0, strumLine.y);

			if (Note.CharactersWith3D.contains(opponent.curCharacter) && player == 0 || Note.CharactersWith3D.contains(boyfriend.curCharacter) && player == 1)
			{
				babyArrow.frames = Paths.getSparrowAtlas('ui/notes/NOTE_assets_3D');
				babyArrow.animation.addByPrefix('green', 'arrowUP');
				babyArrow.animation.addByPrefix('blue', 'arrowDOWN');
				babyArrow.animation.addByPrefix('purple', 'arrowLEFT');
				babyArrow.animation.addByPrefix('red', 'arrowRIGHT');

				babyArrow.setGraphicSize(Std.int(babyArrow.width * 0.7));

				switch (Math.abs(i))
				{
					case 0:
						babyArrow.x += Note.swagWidth * 0;
						babyArrow.animation.addByPrefix('static', 'arrowLEFT');
						babyArrow.animation.addByPrefix('pressed', 'left press', 24, false);
						babyArrow.animation.addByPrefix('confirm', 'left confirm', 24, false);
					case 1:
						babyArrow.x += Note.swagWidth * 1;
						babyArrow.animation.addByPrefix('static', 'arrowDOWN');
						babyArrow.animation.addByPrefix('pressed', 'down press', 24, false);
						babyArrow.animation.addByPrefix('confirm', 'down confirm', 24, false);
					case 2:
						babyArrow.x += Note.swagWidth * 2;
						babyArrow.animation.addByPrefix('static', 'arrowUP');
						babyArrow.animation.addByPrefix('pressed', 'up press', 24, false);
						babyArrow.animation.addByPrefix('confirm', 'up confirm', 24, false);
					case 3:
						babyArrow.x += Note.swagWidth * 3;
						babyArrow.animation.addByPrefix('static', 'arrowRIGHT');
						babyArrow.animation.addByPrefix('pressed', 'right press', 24, false);
						babyArrow.animation.addByPrefix('confirm', 'right confirm', 24, false);
				}
			}
			else
			{
				switch (curStage)
				{
					default:
						babyArrow.frames = Paths.getSparrowAtlas('ui/notes/NOTE_assets');
						babyArrow.animation.addByPrefix('green', 'arrowUP');
						babyArrow.animation.addByPrefix('blue', 'arrowDOWN');
						babyArrow.animation.addByPrefix('purple', 'arrowLEFT');
						babyArrow.animation.addByPrefix('red', 'arrowRIGHT');

						babyArrow.antialiasing = true;
						babyArrow.setGraphicSize(Std.int(babyArrow.width * 0.7));

						switch (Math.abs(i))
						{
							case 0:
								babyArrow.x += Note.swagWidth * 0;
								babyArrow.animation.addByPrefix('static', 'arrowLEFT');
								babyArrow.animation.addByPrefix('pressed', 'left press', 24, false);
								babyArrow.animation.addByPrefix('confirm', 'left confirm', 24, false);
							case 1:
								babyArrow.x += Note.swagWidth * 1;
								babyArrow.animation.addByPrefix('static', 'arrowDOWN');
								babyArrow.animation.addByPrefix('pressed', 'down press', 24, false);
								babyArrow.animation.addByPrefix('confirm', 'down confirm', 24, false);
							case 2:
								babyArrow.x += Note.swagWidth * 2;
								babyArrow.animation.addByPrefix('static', 'arrowUP');
								babyArrow.animation.addByPrefix('pressed', 'up press', 24, false);
								babyArrow.animation.addByPrefix('confirm', 'up confirm', 24, false);
							case 3:
								babyArrow.x += Note.swagWidth * 3;
								babyArrow.animation.addByPrefix('static', 'arrowRIGHT');
								babyArrow.animation.addByPrefix('pressed', 'right press', 24, false);
								babyArrow.animation.addByPrefix('confirm', 'right confirm', 24, false);
						}
				}
			}
			babyArrow.updateHitbox();
			babyArrow.scrollFactor.set();

			babyArrow.y -= 10;
			babyArrow.alpha = 0;
			FlxTween.tween(babyArrow, {y: babyArrow.y + 10, alpha: 1}, 1, {ease: FlxEase.circOut, startDelay: 0.5 + (0.2 * i)});

			babyArrow.ID = i;

			if (player == 1)
			{
				playerStrums.add(babyArrow);
			}
			else
			{
				dadStrums.add(babyArrow);
			}

			babyArrow.animation.play('static');
			babyArrow.x += 50;
			babyArrow.x += ((FlxG.width / 2) * player);

			strumLineNotes.add(babyArrow);

			if (isFunnySong || SONG.song.toLowerCase() == 'disruption')
			arrowJunks.push([babyArrow.x, babyArrow.y]);
			
			babyArrow.resetTrueCoords();
		}

		if (SONG.song.toLowerCase() == 'applecore') {
			swagThings = new FlxTypedGroup<FlxSprite>();

			for (i in 0...4)
			{
				// FlxG.log.add(i);
				var babyArrow:Strum = new Strum(0, altStrumLine.y);

				babyArrow.frames = Paths.getSparrowAtlas('ui/notes/NOTE_assets_3D');
				babyArrow.animation.addByPrefix('green', 'arrowUP');
				babyArrow.animation.addByPrefix('blue', 'arrowDOWN');
				babyArrow.animation.addByPrefix('purple', 'arrowLEFT');
				babyArrow.animation.addByPrefix('red', 'arrowRIGHT');

				babyArrow.setGraphicSize(Std.int(babyArrow.width * 0.7));

				switch (Math.abs(i))
				{
					case 0:
						babyArrow.x += Note.swagWidth * 0;
						babyArrow.animation.addByPrefix('static', 'arrowLEFT');
						babyArrow.animation.addByPrefix('pressed', 'left press', 24, false);
						babyArrow.animation.addByPrefix('confirm', 'left confirm', 24, false);
					case 1:
						babyArrow.x += Note.swagWidth * 1;
						babyArrow.animation.addByPrefix('static', 'arrowDOWN');
						babyArrow.animation.addByPrefix('pressed', 'down press', 24, false);
						babyArrow.animation.addByPrefix('confirm', 'down confirm', 24, false);
					case 2:
						babyArrow.x += Note.swagWidth * 2;
						babyArrow.animation.addByPrefix('static', 'arrowUP');
						babyArrow.animation.addByPrefix('pressed', 'up press', 24, false);
						babyArrow.animation.addByPrefix('confirm', 'up confirm', 24, false);
					case 3:
						babyArrow.x += Note.swagWidth * 3;
						babyArrow.animation.addByPrefix('static', 'arrowRIGHT');
						babyArrow.animation.addByPrefix('pressed', 'right press', 24, false);
						babyArrow.animation.addByPrefix('confirm', 'right confirm', 24, false);
				}
				babyArrow.updateHitbox();

				babyArrow.y -= 10;
				babyArrow.alpha = 0;
				babyArrow.y -= 1000;

				babyArrow.ID = i;

				poopStrums.add(babyArrow);

				babyArrow.animation.play('static');
				babyArrow.x += 50;
				babyArrow.x -= 250;

				arrowJunks.push([babyArrow.x, babyArrow.y + 1000]);
				var hi = new FlxSprite(0, babyArrow.y);
				hi.ID = i;
				swagThings.add(hi);
			}

			add(poopStrums);
			/*poopStrums.forEach(function(spr:FlxSprite){
				spr.alpha = 0;
			});*/

			add(altNotes);
		}
	}

	private var swagThings:FlxTypedGroup<FlxSprite>;

	function tweenCamIn():Void
	{
		FlxTween.tween(FlxG.camera, {zoom: 1.3}, (Conductor.stepCrochet * 4 / 1000), {ease: FlxEase.elasticInOut});
	}

	override function openSubState(SubState:FlxSubState)
	{
		if (paused)
		{
			if (FlxG.sound.music != null)
			{
				FlxG.sound.music.pause();
				vocals.pause();
			}

			#if desktop
			DiscordClient.changePresence("PAUSED on "
				+ SONG.song,
				"Acc: "
				+ truncateFloat(accuracy, 2)
				+ "% | Score: "
				+ songScore
				+ " | WuffGaming was here | Misses: "
				+ misses, iconRPC);
			#end
			if (!startTimer.finished)
				startTimer.active = false;
		}

		super.openSubState(SubState);
	}

	override function closeSubState()
	{
		if (paused)
		{
			if (FlxG.sound.music != null && !startingSong)
			{
				resyncVocals();
			}

			if (!startTimer.finished)
				startTimer.active = true;
			paused = false;

			if (startTimer.finished)
				{
					#if desktop
					DiscordClient.changePresence(SONG.song,
						"\nAcc: "
						+ truncateFloat(accuracy, 2)
						+ "% | Score: "
						+ songScore
						+ " | WuffGaming was here | Misses: "
						+ misses, iconRPC, true,
						FlxG.sound.music.length
						- Conductor.songPosition);
					#end
				}
				else
				{
					#if desktop
					DiscordClient.changePresence(detailsText, SONG.song + " (" + storyDifficultyText + ") ", iconRPC);
					#end
				}
		}

		super.closeSubState();
	}

	function resyncVocals():Void
	{
		vocals.pause();

		FlxG.sound.music.play();
		Conductor.songPosition = FlxG.sound.music.time;
		vocals.time = Conductor.songPosition;
		vocals.play();

		#if desktop
		DiscordClient.changePresence(detailsText
			+ " "
			+ SONG.song,
			"\nAcc: "
			+ truncateFloat(accuracy, 2)
			+ "% | Score: "
			+ songScore
			+ " | WuffGaming was here | Misses: "
			+ misses, iconRPC);
		#end
	}

	private var paused:Bool = false;
	var startedCountdown:Bool = false;
	var canPause:Bool = true;

	function truncateFloat(number:Float, precision:Int):Float
	{
		var num = number;
		num = num * Math.pow(10, precision);
		num = Math.round(num) / Math.pow(10, precision);
		return num;
	}

	function generateRanking():String
	{
		var ranking:String = "N/A";

		if (misses == 0 && bads == 0 && shits == 0 && goods == 0) // Marvelous (SICK) Full Combo
			ranking = "(PFC)";
		else if (misses == 0 && bads == 0 && shits == 0 && goods >= 1) // Good Full Combo (Nothing but Goods & Sicks)
			ranking = "(GFC)";
		else if ((shits < 10 && shits != 0 || bads < 10 && bads != 0) && misses == 0) // Single Digit Combo Breaks
			ranking = "(SDCB)";
		else if (misses == 0 && (shits >= 10 || bads >= 10)) // Regular FC
			ranking = "(FC)";
		else if (misses <= 3) // Combo Breaks
			ranking = "(CB)";
		else
			ranking = "";

		// WIFE GONE its no longer based on wife3 FUCK YOUUU

		var wifeConditions:Array<Bool> = [
			accuracy >= 98, // Spenis
			accuracy >= 95, // AAA
			accuracy >= 90, // AA
			accuracy >= 85, // A
			accuracy >= 70, // B
			accuracy >= 60, // C
			accuracy >= 40, // D
			accuracy < 40 // F
		];

		for(i in 0...wifeConditions.length)
		{
			var b = wifeConditions[i];
			if (b)
			{
				switch(i)
				{
					case 1:
						ranking += " S";
					case 2:
						ranking += " AAA";
					case 3:
						ranking += " AA";
					case 4:
						ranking += " A";
					case 5:
						ranking += " B";
					case 6:
						ranking += " C";
					case 7:
						ranking += " D";
					case 8:
						ranking += " F";
				}
				break;
			}
		}

		if (accuracy == 0)
			ranking = "N/A";

		return ranking;
	}

	private var banduJunk:Float = 0;
	private var dadFront:Bool = false;
	private var hasJunked:Bool = false;
	private var wtfThing:Bool = false;
	private var orbit:Bool = true;
	private var poipInMahPahntsIsGud:Bool = true;
	private var unfairPart:Bool = false;
	private var noteJunksPlayer:Array<Float> = [0, 0, 0, 0];
	private var noteJunksDad:Array<Float> = [0, 0, 0, 0];
	private var what:FlxTypedGroup<FlxSprite>;
	private var arrowcoordinat:Array<Array<Float>> = [];
	private var gasw2:Array<Float> = [];
	private var poiping:Bool = true;
	private var canPoip:Bool = true;
	private var TheDefinedAppleCoreArray:Array<Bool> = [false, false];
	private var ThisIntegerThatIDontKnowWhatDoes:Int = 0;

	override public function update(elapsed:Float)
	{
		elapsedtime += elapsed;
		if(bfSpazOut)
		{
			boyfriend.playAnim('sing' + notestuffs[FlxG.random.int(0,3)]);
		}
		dadChar = opponent.curCharacter;
		bfChar = boyfriend.curCharacter;
		if(redTunnel != null)
		{
			redTunnel.angle += elapsed * 3.5;
		}
		banduJunk += elapsed * 2.5;
		if(badaiTime)
		{
			opponent.angle += elapsed * 50;
		}
		if (curbg != null)
		{
			if (curbg.active) // only the furiosity background is active
			{
				var shad = cast(curbg.shader, Shaders.GlitchShader);
				shad.uTime.value[0] += elapsed;
			}
		}

		//dvd screensaver lookin ass
		if(daveFuckingDies != null && redTunnel != null && !daveFuckingDies.inCutscene)
		{
			FlxG.watch.addQuick("DAVE JUNK!!?!?!", [daveFuckingDies.x, daveFuckingDies.y]);
			if(daveFuckingDies.x >= (redTunnel.width - 1000) || daveFuckingDies.y >= (redTunnel.height - 1000))
			{
				daveFuckingDies.bounceAnimState = 1;
				daveFuckingDies.bounceMultiplier = FlxG.random.float(-0.75, -1.15);
				daveFuckingDies.yBullshit = FlxG.random.float(0.95, 1.05);
				daveFuckingDies.dance();
			}
			else if(daveFuckingDies.x <= (redTunnel.x + 100) || daveFuckingDies.y <= (redTunnel.y + 100))
			{
				daveFuckingDies.bounceAnimState = 2;
				daveFuckingDies.bounceMultiplier = FlxG.random.float(0.75, 1.15);
				daveFuckingDies.yBullshit = FlxG.random.float(0.95, 1.05);
				daveFuckingDies.dance();
			}
			else if(daveFuckingDies.x >= (redTunnel.width - 1150) || daveFuckingDies.y >= (redTunnel.height - 1150))
			{
				daveFuckingDies.bounceAnimState = 1;
			}
			else if(daveFuckingDies.x <= (redTunnel.x + 250) || daveFuckingDies.y <= (redTunnel.y + 250))
			{
				daveFuckingDies.bounceAnimState = 2;
			}
			else
			{
				daveFuckingDies.bounceAnimState = 0;
			}
		}

		if (SONG.song.toLowerCase() == 'applecore') {

			if (poiping) {
				what.forEach(function(spr:FlxSprite){
					spr.x += Math.abs(Math.sin(elapsed)) * gasw2[spr.ID];
					if (spr.x > 3000 && !TheDefinedAppleCoreArray[spr.ID]) {
						TheDefinedAppleCoreArray[spr.ID] = true;
						trace('whattttt ${spr.ID}');
						ThisIntegerThatIDontKnowWhatDoes++;
					}
				});
				if (ThisIntegerThatIDontKnowWhatDoes >= 2) poiping = false;
			}
			else if (canPoip) {
				trace("ON TO THE POIPIGN!!!");
				canPoip = false;
				TheDefinedAppleCoreArray = [false, false];
				ThisIntegerThatIDontKnowWhatDoes = 0;
				new FlxTimer().start(FlxG.random.float(3, 6.3), function(tmr:FlxTimer){
					what.forEach(function(spr:FlxSprite){
						spr.visible = true;
						spr.x = FlxG.random.int(-2000, -3000);
						gasw2[spr.ID] = FlxG.random.int(600, 1200);
						if (spr.ID == 1) {
							trace("POIPING...");
							poiping = true;
							canPoip = true;
						}
					});
				});
			}

			what.forEach(function(spr:FlxSprite){
				var daCoords = arrowcoordinat[spr.ID];

				daCoords[4] == 1 ? 
				spr.y = Math.cos(elapsedtime + spr.ID) * daCoords[3] + daCoords[1]: 
				spr.y = Math.sin(elapsedtime) * daCoords[3] + daCoords[1];

				spr.y += 45;

				var dontLookAtAmongUs:Float = Math.sin(elapsedtime * 1.5) * 0.05 + 0.95;

				spr.scale.set(dontLookAtAmongUs - 0.15, dontLookAtAmongUs - 0.15);

				if (opponent.POOP) spr.angle += (Math.sin(elapsed * 2) * 0.5 + 0.5) * spr.ID == 1 ? 0.65 : -0.65;
			});

			playerStrums.forEach(function(spr:Strum){
				noteJunksPlayer[spr.ID] = spr.y;
			});
			dadStrums.forEach(function(spr:Strum){
				noteJunksDad[spr.ID] = spr.y;
			});
			if (unfairPart) {
				playerStrums.forEach(function(spr:Strum)
				{
					spr.x = ((FlxG.width / 2) - (spr.width / 2)) + (Math.sin(elapsedtime + (spr.ID)) * 300);
					spr.y = ((FlxG.height / 2) - (spr.height / 2)) + (Math.cos(elapsedtime + (spr.ID)) * 300);
				});
				dadStrums.forEach(function(spr:Strum)
				{
					spr.x = ((FlxG.width / 2) - (spr.width / 2)) + (Math.sin((elapsedtime + (spr.ID )) * 2) * 300);
					spr.y = ((FlxG.height / 2) - (spr.height / 2)) + (Math.cos((elapsedtime + (spr.ID)) * 2) * 300);
				});
			}
			if (SONG.notes[Math.floor(curStep / 16)] != null) {
				if (SONG.notes[Math.floor(curStep / 16)].altAnim && !unfairPart) {
					var krunkThing = 60;
					playerStrums.forEach(function(spr:Strum)
					{
						spr.x = arrowJunks[spr.ID + 8][0] + (Math.sin(elapsedtime) * ((spr.ID % 2) == 0 ? 1 : -1)) * krunkThing;
						spr.y = arrowJunks[spr.ID + 8][1] + Math.sin(elapsedtime - 5) * ((spr.ID % 2) == 0 ? 1 : -1) * krunkThing;

						spr.scale.x = Math.abs(Math.sin(elapsedtime - 5) * ((spr.ID % 2) == 0 ? 1 : -1)) / 4;

						spr.scale.y = Math.abs((Math.sin(elapsedtime) * ((spr.ID % 2) == 0 ? 1 : -1)) / 2);

						spr.scale.x += 0.2;
						spr.scale.y += 0.2;

						spr.scale.x *= 1.5;
						spr.scale.y *= 1.5;
					});

					poopStrums.forEach(function(spr:Strum)
					{
						spr.x = arrowJunks[spr.ID + 4][0] + (Math.sin(elapsedtime) * ((spr.ID % 2) == 0 ? 1 : -1)) * krunkThing;
						spr.y = swagThings.members[spr.ID].y + Math.sin(elapsedtime - 5) * ((spr.ID % 2) == 0 ? 1 : -1) * krunkThing;

						spr.scale.x = Math.abs(Math.sin(elapsedtime - 5) * ((spr.ID % 2) == 0 ? 1 : -1)) / 4;

						spr.scale.y = Math.abs((Math.sin(elapsedtime) * ((spr.ID % 2) == 0 ? 1 : -1)) / 2);

						spr.scale.x += 0.2;
						spr.scale.y += 0.2;

						spr.scale.x *= 1.5;
						spr.scale.y *= 1.5;
					});

					notes.forEachAlive(function(spr:Note){
							spr.x = arrowJunks[spr.noteData + 8][0] + (Math.sin(elapsedtime) * ((spr.noteData % 2) == 0 ? 1 : -1)) * krunkThing;

							if (!spr.isSustainNote) {
		
								spr.scale.x = Math.abs(Math.sin(elapsedtime - 5) * ((spr.noteData % 2) == 0 ? 1 : -1)) / 4;
			
								spr.scale.y = Math.abs((Math.sin(elapsedtime) * ((spr.noteData % 2) == 0 ? 1 : -1)) / 2);
			
								spr.scale.x += 0.2;
								spr.scale.y += 0.2;
			
								spr.scale.x *= 1.5;
								spr.scale.y *= 1.5;
							}
					});
					altNotes.forEachAlive(function(spr:Note){
						spr.x = arrowJunks[(spr.noteData % 4) + 4][0] + (Math.sin(elapsedtime) * ((spr.noteData % 2) == 0 ? 1 : -1)) * krunkThing;
						#if debug
						if (FlxG.keys.justPressed.SPACE) {
							trace(arrowJunks[(spr.noteData % 4) + 4][0]);
							trace(spr.noteData);
							trace(spr.x == arrowJunks[(spr.noteData % 4) + 4][0] + (Math.sin(elapsedtime) * ((spr.noteData % 2) == 0 ? 1 : -1)) * krunkThing);
						}
						#end

						if (!spr.isSustainNote) {
		
							spr.scale.x = Math.abs(Math.sin(elapsedtime - 5) * ((spr.noteData % 2) == 0 ? 1 : -1)) / 4;
			
							spr.scale.y = Math.abs((Math.sin(elapsedtime) * ((spr.noteData % 2) == 0 ? 1 : -1)) / 2);
			
							spr.scale.x += 0.2;
							spr.scale.y += 0.2;
			
							spr.scale.x *= 1.5;
							spr.scale.y *= 1.5;
						}
					});
				}
				if (!SONG.notes[Math.floor(curStep / 16)].altAnim && wtfThing) {
					
					
				}
			}

			
		}

		//welcome to 3d sinning avenue
		if(funnyFloatyBoys.contains(opponent.curCharacter.toLowerCase()) && canFloat && orbit)
		{
			switch(opponent.curCharacter) 
			{
				case 'bandu-candy':
					opponent.x += Math.sin(elapsedtime * 50) / 9;
				case 'bandu':
					opponent.x = boyfriend.getMidpoint().x + Math.sin(banduJunk) * 500 - (opponent.width / 2);
					opponent.y += (Math.sin(elapsedtime) * 0.2);
					opponentmirror.setPosition(opponent.x, opponent.y);

					/*
					var deezScale =	(
						!dadFront ?
						Math.sqrt(
					boyfriend.getMidpoint().distanceTo(opponent.getMidpoint()) / 500 * 0.5):
					Math.sqrt(
					(500 - boyfriend.getMidpoint().distanceTo(opponent.getMidpoint())) / 500 * 0.5 + 0.5));
					opponent.scale.set(deezScale, deezScale);
					opponentmirror.scale.set(deezScale, deezScale);
					*/

					if ((Math.sin(banduJunk) >= 0.95 || Math.sin(banduJunk) <= -0.95) && !hasJunked){
						dadFront = !dadFront;
						hasJunked = true;
					}
					if (hasJunked && !(Math.sin(banduJunk) >= 0.95 || Math.sin(banduJunk) <= -0.95)) hasJunked = false;

					opponentmirror.visible = dadFront;
					opponent.visible = !dadFront;
				case 'badai':
					opponent.angle += elapsed * 10;
					opponent.y += (Math.sin(elapsedtime) * 0.6);
				case 'insane-dave-3d':
					opponent.y += (Math.sin(elapsedtime) * 0.6);
					opponent.x += (Math.cos(elapsedtime) * 0.55);
				case 'little-bandu':
					opponent.angle += elapsed * 2;
					opponent.y += (Math.sin(elapsedtime) * 0.65);
					opponent.x = -125 + Math.sin(elapsedtime) * 425;
				case 'ringi':
					opponent.y += (Math.sin(elapsedtime) * 0.6);
					opponent.x += (Math.sin(elapsedtime) * 0.6);
				case 'bambom':
					opponent.y += (Math.sin(elapsedtime) * 0.75);
					opponent.x = -700 + Math.sin(elapsedtime) * 425;
				case 'tunnel-dave':
					opponent.y -= (Math.sin(elapsedtime) * 0.6);
				default:
					opponent.y += (Math.sin(elapsedtime) * 0.6);
			}
		}
		if(opponent2 != null)
		{
			switch(opponent2.curCharacter) 
			{
				case 'bandu':
					opponent2.x = boyfriend.getMidpoint().x + Math.sin(banduJunk) * 500 - (opponent.width / 2);
					opponent2.y += (Math.sin(elapsedtime) * 0.2);
					opponentmirror.setPosition(opponent.x, opponent.y);

					/*
					var deezScale =	(
						!dadFront ?
						Math.sqrt(
					boyfriend.getMidpoint().distanceTo(opponent.getMidpoint()) / 500 * 0.5):
					Math.sqrt(
					(500 - boyfriend.getMidpoint().distanceTo(opponent.getMidpoint())) / 500 * 0.5 + 0.5));
					opponent.scale.set(deezScale, deezScale);
					opponentmirror.scale.set(deezScale, deezScale);
					*/

					if ((Math.sin(banduJunk) >= 0.95 || Math.sin(banduJunk) <= -0.95) && !hasJunked){
						dadFront = !dadFront;
						hasJunked = true;
					}
					if (hasJunked && !(Math.sin(banduJunk) >= 0.95 || Math.sin(banduJunk) <= -0.95)) hasJunked = false;

					opponentmirror.visible = dadFront;
					opponent2.visible = !dadFront;
				case 'badai':
					opponent2.angle = Math.sin(elapsedtime) * 15;
					opponent2.x += Math.sin(elapsedtime) * 0.6;
					opponent2.y += (Math.sin(elapsedtime) * 0.6);
				default:
					opponent2.y += (Math.sin(elapsedtime) * 0.6);
			}
		}
		if (littleIdiot != null) {
			if(funnyFloatyBoys.contains(littleIdiot.curCharacter.toLowerCase()) && canFloat && poipInMahPahntsIsGud)
			{
				littleIdiot.y += (Math.sin(elapsedtime) * 0.75);
				littleIdiot.x = 200 + Math.sin(elapsedtime) * 425;
			}
		}
		if (swagger != null) {
			if(funnyFloatyBoys.contains(swagger.curCharacter.toLowerCase()) && canFloat)
			{
				swagger.y += (Math.sin(elapsedtime) * 0.6);
			}
		}
		if(funnyFloatyBoys.contains(boyfriend.curCharacter.toLowerCase()) && canFloat)
		{
			switch(boyfriend.curCharacter)
			{
				case 'ringi':
					boyfriend.y += (Math.sin(elapsedtime) * 0.6);
					boyfriend.x += (Math.sin(elapsedtime) * 0.6);
				case 'bambom':
					boyfriend.y += (Math.sin(elapsedtime) * 0.75);
					boyfriend.x = 200 + Math.sin(elapsedtime) * 425;
				default:
					boyfriend.y += (Math.sin(elapsedtime) * 0.6);
			}
		}
		/*if(funnyFloatyBoys.contains(opponentmirror.curCharacter.toLowerCase()))
		{
			opponentmirror.y += (Math.sin(elapsedtime) * 0.6);
		}*/
		if(funnyFloatyBoys.contains(gf.curCharacter.toLowerCase()) && canFloat)
		{
			gf.y += (Math.sin(elapsedtime) * 0.6);
		}

		if (SONG.song.toLowerCase() == 'cheating') // fuck you
		{
			playerStrums.forEach(function(spr:Strum)
			{
				spr.x += Math.sin(elapsedtime) * ((spr.ID % 2) == 0 ? 1 : -1);
				spr.x -= Math.sin(elapsedtime) * 1.5;
			});
			dadStrums.forEach(function(spr:Strum)
			{
				spr.x -= Math.sin(elapsedtime) * ((spr.ID % 2) == 0 ? 1 : -1);
				spr.x += Math.sin(elapsedtime) * 1.5;
			});
		}

		if(SONG.song.toLowerCase() == 'disability')
		{
			playerStrums.forEach(function(spr:Strum)
			{
				spr.angle += (Math.sin(elapsedtime * 2.5) + 1) * 5;
			});
			dadStrums.forEach(function(spr:Strum)
			{
				spr.angle += (Math.sin(elapsedtime * 2.5) + 1) * 5;
			});
			for(note in notes)
			{
				if(note.mustPress)
				{
					if (!note.isSustainNote)
						note.angle = playerStrums.members[note.noteData].angle;
				}
				else
				{
					if (!note.isSustainNote)
						note.angle = dadStrums.members[note.noteData].angle;
				}
			}
		}

		if (SONG.song.toLowerCase() == 'disruption') // deez all day
		{
			var krunkThing = 60;

			poop.alpha = Math.sin(elapsedtime) / 2.5 + 0.4;

			playerStrums.forEach(function(spr:FlxSprite)
			{
				spr.x = arrowJunks[spr.ID + 4][0] + (Math.sin(elapsedtime) * ((spr.ID % 2) == 0 ? 1 : -1)) * krunkThing;
				spr.y = arrowJunks[spr.ID + 4][1] + Math.sin(elapsedtime - 5) * ((spr.ID % 2) == 0 ? 1 : -1) * krunkThing;

				spr.scale.x = Math.abs(Math.sin(elapsedtime - 5) * ((spr.ID % 2) == 0 ? 1 : -1)) / 4;

				spr.scale.y = Math.abs((Math.sin(elapsedtime) * ((spr.ID % 2) == 0 ? 1 : -1)) / 2);

				spr.scale.x += 0.2;
				spr.scale.y += 0.2;

				spr.scale.x *= 1.5;
				spr.scale.y *= 1.5;
			});
			dadStrums.forEach(function(spr:Strum)
			{
				spr.x = arrowJunks[spr.ID][0] + (Math.sin(elapsedtime) * ((spr.ID % 2) == 0 ? 1 : -1)) * krunkThing;
				spr.y = arrowJunks[spr.ID][1] + Math.sin(elapsedtime - 5) * ((spr.ID % 2) == 0 ? 1 : -1) * krunkThing;
				
				spr.scale.x = Math.abs(Math.sin(elapsedtime - 5) * ((spr.ID % 2) == 0 ? 1 : -1)) / 4;

				spr.scale.y = Math.abs((Math.sin(elapsedtime) * ((spr.ID % 2) == 0 ? 1 : -1)) / 2);

				spr.scale.x += 0.2;
				spr.scale.y += 0.2;

				spr.scale.x *= 1.5;
				spr.scale.y *= 1.5;
			});

			notes.forEachAlive(function(spr:Note){
				if (spr.mustPress) {
					spr.x = arrowJunks[spr.noteData + 4][0] + (Math.sin(elapsedtime) * ((spr.noteData % 2) == 0 ? 1 : -1)) * krunkThing;
					spr.y = arrowJunks[spr.noteData + 4][1] + Math.sin(elapsedtime - 5) * ((spr.noteData % 2) == 0 ? 1 : -1) * krunkThing;

					spr.scale.x = Math.abs(Math.sin(elapsedtime - 5) * ((spr.noteData % 2) == 0 ? 1 : -1)) / 4;

					spr.scale.y = Math.abs((Math.sin(elapsedtime) * ((spr.noteData % 2) == 0 ? 1 : -1)) / 2);

					spr.scale.x += 0.2;
					spr.scale.y += 0.2;

					spr.scale.x *= 1.5;
					spr.scale.y *= 1.5;
				}
				else {
					spr.x = arrowJunks[spr.noteData][0] + (Math.sin(elapsedtime) * ((spr.noteData % 2) == 0 ? 1 : -1)) * krunkThing;
					spr.y = arrowJunks[spr.noteData][1] + Math.sin(elapsedtime - 5) * ((spr.noteData % 2) == 0 ? 1 : -1) * krunkThing;

					spr.scale.x = Math.abs(Math.sin(elapsedtime - 5) * ((spr.noteData % 2) == 0 ? 1 : -1)) / 4;

					spr.scale.y = Math.abs((Math.sin(elapsedtime) * ((spr.noteData % 2) == 0 ? 1 : -1)) / 2);

					spr.scale.x += 0.2;
					spr.scale.y += 0.2;

					spr.scale.x *= 1.5;
					spr.scale.y *= 1.5;
				}
			});
		}

		FlxG.watch.addQuick("WHAT", Conductor.songPosition);
			
		FlxG.camera.setFilters([new ShaderFilter(screenshader.shader)]); // this is very stupid but doesn't effect memory all that much so
		if (shakeCam && eyesoreson)
		{
			// var shad = cast(FlxG.camera.screen.shader,Shaders.PulseShader);
			FlxG.camera.shake(0.015, 0.015);
		}
		screenshader.shader.uTime.value[0] += elapsed;
		if (shakeCam && eyesoreson)
		{
			screenshader.shader.uampmul.value[0] = 1;
		}
		else
		{
			screenshader.shader.uampmul.value[0] -= (elapsed / 2);
		}
		screenshader.Enabled = shakeCam && eyesoreson;

		if (FlxG.keys.justPressed.NINE && iconP1.charPublic != 'bandu-origin')
		{
			if (iconP1.charPublic == boyfriendOldIcon)
			{
				iconP1.changeIcon(boyfriend.iconName);
			}
			else
			{
				iconP1.changeIcon(boyfriendOldIcon);
			}
		}
		var lerpVal:Float = CoolUtil.boundTo(elapsed * 2.4 * cameraSpeed, 0, 1);
		if(!inCutscene && camMoveAllowed)
			camFollowPos.setPosition(FlxMath.lerp(camFollowPos.x, camFollow.x, lerpVal), FlxMath.lerp(camFollowPos.y, camFollow.y, lerpVal));

		super.update(elapsed);


		if (SONG.song.toLowerCase() == 'algebra')
		{
		scoreTxt.text = "Score:" + songScore;
		}
		else
		{
		scoreTxt.text = "Score:" + songScore + " | Misses:" + misses + " | Accuracy:" + truncateFloat(accuracy, 2) + "% | " + generateRanking();
		}
		if (FlxG.keys.justPressed.ENTER && startedCountdown && canPause)
		{
			persistentUpdate = false;
			persistentDraw = true;
			paused = true;
			trace('PAULSCODE ' + paused);

			// 1 / 1000 chance for Gitaroo Man easter egg
			if (FlxG.random.bool(0.1))
			{
				// gitaroo man easter egg
				FlxG.switchState(new GitarooPause());
			}
			else
				openSubState(new PauseSubState(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
		}

		if (FlxG.keys.justPressed.SEVEN)
		{
			switch (curSong.toLowerCase())
			{
				default:
					PlayState.characteroverride = 'none';
					PlayState.formoverride = 'none';
					FlxG.switchState(new ChartingState());
					#if desktop
					DiscordClient.changePresence("Chart Editor", null, null, true);
					#end
			}
		}

		// FlxG.watch.addQuick('VOL', vocals.amplitudeLeft);
		// FlxG.watch.addQuick('VOLRight', vocals.amplitudeRight);

		iconP1.centerOffsets();
		iconP2.centerOffsets();

		iconP1.updateHitbox();
		iconP2.updateHitbox();

		var iconOffset:Int = 26;

		iconP1.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01) - iconOffset);
		iconP2.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01)) - (iconP2.width - iconOffset);

		if (health > 2)
			health = 2;

		if(iconP1.charPublic != 'bandu-origin') {
			healthBar.percent < 20 ?
				iconP1.animation.curAnim.curFrame = 1:
				iconP1.animation.curAnim.curFrame = 0;
		}

		if(iconP2.charPublic != 'bandu-origin') {
			healthBar.percent > 80 ?
				iconP2.animation.curAnim.curFrame = 1:
				iconP2.animation.curAnim.curFrame = 0;
		}

		//iconP2.animation.curAnim.curFrame = 0;
				

		/* if (FlxG.keys.justPressed.NINE)
			FlxG.switchState(new Charting()); */

		if (FlxG.keys.justPressed.EIGHT)
		{
			PlayState.characteroverride = 'none';
			PlayState.formoverride = 'none';
			FlxG.switchState(new AnimationDebug(opponent.curCharacter));
		}
		if (FlxG.keys.justPressed.TWO)
		{
			PlayState.characteroverride = 'none';
			PlayState.formoverride = 'none';
			FlxG.switchState(new AnimationDebug(boyfriend.curCharacter));
		}
		if (FlxG.keys.justPressed.THREE)
		{
			PlayState.characteroverride = 'none';
			PlayState.formoverride = 'none';
			FlxG.switchState(new AnimationDebug(gf.curCharacter));
		}
		if (startingSong)
		{
			if (startedCountdown)
			{
				Conductor.songPosition += FlxG.elapsed * 1000;
				if (Conductor.songPosition >= 0)
					startSong();
			}
		}
		else
		{
			// Conductor.songPosition = FlxG.sound.music.time;
			Conductor.songPosition += FlxG.elapsed * 1000;

			if (!paused)
			{
				songTime += FlxG.game.ticks - previousFrameTime;
				previousFrameTime = FlxG.game.ticks;

				// Interpolation type beat
				if (Conductor.lastSongPos != Conductor.songPosition)
				{
					songTime = (songTime + Conductor.songPosition) / 2;
					Conductor.lastSongPos = Conductor.songPosition;
					// Conductor.songPosition += FlxG.elapsed * 1000;
					// trace('MISSED FRAME');
				}

				if(updateTime) 
				{
					var curTime:Float = Conductor.songPosition;
					if(curTime < 0) curTime = 0;
					songPercent = (curTime / songLength);

					var songCalc:Float = (songLength - curTime);

					var secondsTotal:Int = Math.floor(songCalc / 1000);
					if(secondsTotal < 0) secondsTotal = 0;
					
					timeTxt.text = FlxStringUtil.formatTime(secondsTotal, false);
				}
			}

			// Conductor.lastSongPos = FlxG.sound.music.time;
		}

		if (camZooming)
		{
			FlxG.camera.zoom = FlxMath.lerp(defaultCamZoom, FlxG.camera.zoom, 0.95);
			camHUD.zoom = FlxMath.lerp(1, camHUD.zoom, 0.95);
		}

		FlxG.watch.addQuick("beatShit", curBeat);
		FlxG.watch.addQuick("stepShit", curStep);

		if (curSong.toLowerCase() == 'furiosity')
		{
			switch (curBeat)
			{
				case 127:
					camZooming = true;
				case 159:
					camZooming = false;
				case 191:
					camZooming = true;
				case 223:
					camZooming = false;
			}
		}

		if (health <= 0)
		{
			if(!perfectMode)
			{
				boyfriend.stunned = true;

				persistentUpdate = false;
				persistentDraw = false;
				paused = true;
	
				vocals.stop();
				FlxG.sound.music.stop();
	
				screenshader.shader.uampmul.value[0] = 0;
				screenshader.Enabled = false;
			}

			if(shakeCam)
			{
				FlxG.save.data.unlockedcharacters[7] = true;
			}

			if (!shakeCam)
			{
				if(!perfectMode)
				{
					openSubState(new GameOverSubstate(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition()
						.y, formoverride == "bf" || formoverride == "none" ? SONG.player1 : formoverride));

						#if desktop
						DiscordClient.changePresence("GAME OVER -- "
						+ SONG.song
						+ " ("
						+ storyDifficultyText
						+ ") ",
						"\nAcc: "
						+ truncateFloat(accuracy, 2)
						+ "% | Score: "
						+ songScore
						+ "| Misses: "
						+ misses, iconRPC);
						#end
				}
			}
			else
			{
				if (isStoryMode)
				{
					switch (SONG.song.toLowerCase())
					{
						case 'blocked' | 'corn-theft' | 'maze':
							FlxG.openURL("https://www.youtube.com/watch?v=eTJOdgDzD64");
							System.exit(0);
						default:
							PlayState.characteroverride = 'none';
							PlayState.formoverride = 'none';
					}
				}
				else
				{
					if(!perfectMode)
					{
						openSubState(new GameOverSubstate(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition()
							.y, formoverride == "bf" || formoverride == "none" ? SONG.player1 : formoverride));

							#if desktop
							DiscordClient.changePresence("GAME OVER - "
							+ SONG.song,
							"\nAcc: "
							+ truncateFloat(accuracy, 2)
							+ "% | Score: "
							+ songScore
							+ " | WuffGaming was here | Misses: "
							+ misses, iconRPC);
							#end
					}
				}
			}

			// FlxG.switchState(new GameOverState(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
		}

		if (unspawnNotes[0] != null)
		{
			if (unspawnNotes[0].strumTime - Conductor.songPosition < (SONG.song.toLowerCase() == 'unfairness' ? 15000 : 1500))
			{
				var dunceNote:Note = unspawnNotes[0];
				notes.add(dunceNote);
				dunceNote.finishedGenerating = true;

				var index:Int = unspawnNotes.indexOf(dunceNote);
				unspawnNotes.splice(index, 1);
			}
		}

		if (altUnspawnNotes[0] != null)
		{
			if (altUnspawnNotes[0].strumTime - Conductor.songPosition < (SONG.song.toLowerCase() == 'unfairness' ? 15000 : 1500))
			{
				var dunceNote:Note = altUnspawnNotes[0];
				altNotes.add(dunceNote);
				dunceNote.finishedGenerating = true;

				var index:Int = altUnspawnNotes.indexOf(dunceNote);
				altUnspawnNotes.splice(index, 1);
			}
		}

		if (generatedMusic)
		{
			if (isFunnySong) {
				altNotes.forEachAlive(function(daNote:Note)
				{
					if (daNote.y > FlxG.height * 2)
					{
						daNote.active = false;
						daNote.visible = false;
					}
					else
					{
						daNote.visible = true;
						daNote.active = true;
					}

					daNote.y = (altStrumLine.y - (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal((SONG.speed + 1) * 1, 2)));

					if (daNote.wasGoodHit)
					{
						swagger.playAnim('sing' + notestuffs[Math.round(Math.abs(daNote.noteData)) % 4], true);
						swagger.holdTimer = 0;
						
						FlxG.camera.shake(0.0075, 0.1);
						camHUD.shake(0.0045, 0.1);

						health -=  0.02 / 2.65;

						poopStrums.forEach(function(sprite:Strum)
						{
							if (Math.abs(Math.round(Math.abs(daNote.noteData)) % 4) == sprite.ID)
							{
								sprite.animation.play('confirm', true);
								if (sprite.animation.curAnim.name == 'confirm' && !curStage.startsWith('school'))
									{
									sprite.centerOffsets();
									sprite.offset.x -= 13;
									sprite.offset.y -= 13;
								}
								else
								{
									sprite.centerOffsets();
								}
								sprite.animation.finishCallback = function(name:String)
								{
									sprite.animation.play('static',true);
									sprite.centerOffsets();
								}
								
							}
						});

						if (SONG.needsVoices)
							vocals.volume = 1;

						daNote.kill();
						altNotes.remove(daNote, true);
						daNote.destroy();
					}
				});
			}
			notes.forEachAlive(function(daNote:Note)
			{
				if (daNote.y > FlxG.height)
				{
					//daNote.active = false;
					daNote.visible = false;
				}
				else
				{
					daNote.visible = true;
					daNote.active = true;
				}

				if (!daNote.mustPress && daNote.wasGoodHit)
				{
					if (SONG.song != 'Tutorial')
						camZooming = true;

					var altAnim:String = "";
					var healthtolower:Float = 0.02;

					if (SONG.notes[Math.floor(curStep / 16)] != null)
					{
						if (SONG.notes[Math.floor(curStep / 16)].altAnim)
						{
							if (SONG.song.toLowerCase() != "cheating")
							{
								altAnim = '-alt';
								if(SONG.song.toLowerCase() == 'sugar-rush')
								{
									//idleAlt = true;
								}
							}
							else
							{
								healthtolower = 0.005;
							}
						}
						else
						{
							if(SONG.song.toLowerCase() == 'sugar-rush')
								idleAlt = false;
						}
					}

					//'LEFT', 'DOWN', 'UP', 'RIGHT'
					var fuckingDumbassBullshitFuckYou:String;
					fuckingDumbassBullshitFuckYou = notestuffs[Math.round(Math.abs(daNote.noteData)) % 4];
					if(opponent.nativelyPlayable)
					{
						switch(notestuffs[Math.round(Math.abs(daNote.noteData)) % 4])
						{
							case 'LEFT':
								fuckingDumbassBullshitFuckYou = 'RIGHT';
							case 'RIGHT':
								fuckingDumbassBullshitFuckYou = 'LEFT';
						}
					}
					if(shakingChars.contains(opponent.curCharacter))
					{
						FlxG.camera.shake(0.0075, 0.1);
						camHUD.shake(0.0045, 0.1);
					}
					(SONG.song.toLowerCase() == 'applecore' && !SONG.notes[Math.floor(curStep / 16)].altAnim && !wtfThing && opponent.POOP) ? { // hi
						if (littleIdiot != null) littleIdiot.playAnim('sing' + fuckingDumbassBullshitFuckYou + altAnim, true); 
						littleIdiot.holdTimer = 0;}: {
							if(badaiTime)
							{
								opponent2.holdTimer = 0;
								opponent2.playAnim('sing' + fuckingDumbassBullshitFuckYou + altAnim, true);
							}
							opponent.playAnim('sing' + fuckingDumbassBullshitFuckYou + altAnim, true);
							opponentmirror.playAnim('sing' + fuckingDumbassBullshitFuckYou + altAnim, true);
							opponent.holdTimer = 0;
							opponentmirror.holdTimer = 0;
						}

					if (SONG.song.toLowerCase() != 'senpai' && SONG.song.toLowerCase() != 'roses' && SONG.song.toLowerCase() != 'thorns')
					{
						dadStrums.forEach(function(sprite:Strum)
							{
								if (Math.abs(Math.round(Math.abs(daNote.noteData)) % 4) == sprite.ID)
								{
									sprite.animation.play('confirm', true);
									if (sprite.animation.curAnim.name == 'confirm' && !curStage.startsWith('school') && (SONG.song.toLowerCase() != 'disability'))
									{
										sprite.centerOffsets();
										sprite.offset.x -= 13;
										sprite.offset.y -= 13;
									}
									else if (SONG.song.toLowerCase() != 'disability')
									{
										sprite.centerOffsets();
									}
									sprite.animation.finishCallback = function(name:String)
									{
										sprite.animation.play('static',true);
										if (SONG.song.toLowerCase() != 'disability')
											sprite.centerOffsets();
									}
		
								}
							});
					}

					if (UsingNewCam)
					{
						focusOnDadGlobal = true;
						if(camMoveAllowed)
							ZoomCam(true);
					}

					switch (SONG.song.toLowerCase())
					{
						case 'applecore':
							if (unfairPart) health -= (healthtolower / 12);
						case 'disruption':
							health -= healthtolower / 2.65;
					}

					if (SONG.needsVoices)
						vocals.volume = 1;

					daNote.kill();
					notes.remove(daNote, true);
					daNote.destroy();
				}
				switch (SONG.song.toLowerCase())
				{
					case 'applecore':
						if (unfairPart)
						{
							daNote.y = ((daNote.mustPress ? noteJunksPlayer[daNote.noteData] : noteJunksDad[daNote.noteData])- (Conductor.songPosition - daNote.strumTime) * (-0.45 * FlxMath.roundDecimal(1 * daNote.LocalScrollSpeed, 2))); // couldnt figure out this stupid mystrum thing
						}
						else
						{
							if (FlxG.save.data.downscroll)
								daNote.y = (strumLine.y - (Conductor.songPosition - daNote.strumTime) * (-0.45 * FlxMath.roundDecimal(SONG.speed * 1, 2)));
							else
								daNote.y = (strumLine.y - (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(SONG.speed * 1, 2)));
						}
					case 'algebra':
						if (FlxG.save.data.downscroll)
							daNote.y = (strumLine.y - (Conductor.songPosition - daNote.strumTime) * (-0.45 * FlxMath.roundDecimal(swagSpeed * daNote.LocalScrollSpeed, 2)));
						else
							daNote.y = (strumLine.y - (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(swagSpeed * daNote.LocalScrollSpeed, 2)));
					default:
						if (FlxG.save.data.downscroll)
							daNote.y = (strumLine.y - (Conductor.songPosition - daNote.strumTime) * (-0.45 * FlxMath.roundDecimal(SONG.speed * daNote.LocalScrollSpeed, 2)));
						else
							daNote.y = (strumLine.y - (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(SONG.speed * daNote.LocalScrollSpeed, 2)));
				}
				// trace(daNote.y);
				// WIP interpolation shit? Need to fix the pause issue
				// daNote.y = (strumLine.y - (songTime - daNote.strumTime) * (0.45 * PlayState.SONG.speed));

				var strumliney = daNote.MyStrum != null ? daNote.MyStrum.y : strumLine.y;

				if (SONG.song.toLowerCase() == 'applecore') {
					if (unfairPart) strumliney = daNote.MyStrum != null ? daNote.MyStrum.y : strumLine.y;
					else strumliney = strumLine.y;
				}

				if (((daNote.y < -daNote.height && !FlxG.save.data.downscroll || daNote.y >= strumliney + 106 && FlxG.save.data.downscroll) && SONG.song.toLowerCase() != 'applecore') 
					|| (SONG.song.toLowerCase() == 'applecore' && unfairPart && daNote.y >= strumliney + 106) 
					|| (SONG.song.toLowerCase() == 'applecore' && !unfairPart && (daNote.y < -daNote.height && !FlxG.save.data.downscroll || daNote.y >= strumliney + 106 && FlxG.save.data.downscroll)))
				{
					/*
					trace((SONG.song.toLowerCase() == 'applecore' && unfairPart && daNote.y >= strumliney + 106) );
					trace(daNote.y);
					*/
					if (daNote.isSustainNote && daNote.wasGoodHit)
					{
						daNote.kill();
						notes.remove(daNote, true);
						daNote.destroy();
					}
					else
					{
						if(daNote.mustPress && daNote.finishedGenerating)
							noteMiss(daNote.noteData);
							health -= 0.075;
							//trace("miss note");
							vocals.volume = 0;
					}

					daNote.active = false;
					daNote.visible = false;

					daNote.kill();
					notes.remove(daNote, true);
					daNote.destroy();
				}
			});
		}

		if(camMoveAllowed && !inCutscene)
			ZoomCam(focusOnDadGlobal);

		if (!inCutscene)
			keyShit();

		#if debug
		if (FlxG.keys.justPressed.ONE)
			endSong();
		#end
	}

	function ZoomCam(focusondad:Bool):Void
	{
		var bfplaying:Bool = false;
		if (focusondad)
		{
			notes.forEachAlive(function(daNote:Note)
			{
				if (!bfplaying)
				{
					if (daNote.mustPress)
					{
						bfplaying = true;
					}
				}
			});
			if (UsingNewCam && bfplaying)
			{
				return;
			}
		}
		if (focusondad)
		{
			focusOnChar(badaiTime ? opponent2 : opponent);

			if (SONG.song.toLowerCase() == 'tutorial')
			{
				tweenCamIn();
			}
		}

		if (!focusondad)
		{
			camFollow.set(boyfriend.getMidpoint().x - 100, boyfriend.getMidpoint().y - 100);

			if (SONG.song.toLowerCase() == 'applecore') defaultCamZoom = 0.5;

			if (SONG.song.toLowerCase() == 'tutorial')
			{
				FlxTween.tween(FlxG.camera, {zoom: 1}, (Conductor.stepCrochet * 4 / 1000), {ease: FlxEase.elasticInOut});
			}
		}
	}

	public static var xtraSong:Bool = false;

	function focusOnChar(char:Character) {
		camFollow.set(char.getMidpoint().x + 150, char.getMidpoint().y - 100);
		// camFollow.setPosition(lucky.getMidpoint().x - 120, lucky.getMidpoint().y + 210);

		switch (char.curCharacter)
		{
			case 'bandu':
				char.POOP ? {
				!SONG.notes[Math.floor(curStep / 16)].altAnim ? {
				camFollow.set(littleIdiot.getMidpoint().x, littleIdiot.getMidpoint().y - 300);
				defaultCamZoom = 0.35;
				} :
					camFollow.set(swagger.getMidpoint().x + 150, swagger.getMidpoint().y - 100);
			} :
				camFollow.set(boyfriend.getMidpoint().x - 100, boyfriend.getMidpoint().y - 100);
			case 'bandu-candy':
				camFollow.set(char.getMidpoint().x + 175, char.getMidpoint().y - 85);

			case 'bambom':
				camFollow.y += 100;

			case 'silly-sally':
				camFollow.x -= 100;
			case 'dave-wheels':
				camFollow.y -= 150;
			case 'RECOVERED_PROJECT_3': // shoulda just taken this from 1.1 from the start lmao
				camFollow.y += 400;
				camFollow.x += 125;
			case 'hall-monitor':
				camFollow.x -= 200;
				camFollow.y -= 180;
			case 'playrobot':
				camFollow.x -= 160;
				camFollow.y = boyfriend.getMidpoint().y - 100;
			case 'playrobot-crazy':
				camFollow.x -= 160;
				camFollow.y -= 10;
		}
	}

	function endSong():Void
	{
		inCutscene = false;
		canPause = false;
		updateTime = false;

		FlxG.sound.music.volume = 0;
		vocals.volume = 0;
		if (SONG.validScore)
		{
			trace("score is valid");
			#if !switch
			Highscore.saveScore(SONG.song, songScore, storyDifficulty, characteroverride == "none"
				|| characteroverride == "bf" ? "bf" : characteroverride);
			#end
		}

		if (curSong.toLowerCase() == 'bonus-song')
		{
			FlxG.save.data.unlockedcharacters[3] = true;
		}

		if (isStoryMode)
		{
			campaignScore += songScore;

			FlxG.save.flush();

			storyPlaylist.remove(storyPlaylist[0]);

			if (storyPlaylist.length <= 0)
			{
				switch (curSong.toLowerCase())
				{
					case 'applecore':
						canPause = false;
						FlxG.sound.music.volume = 0;
						vocals.volume = 0;
						generatedMusic = false; // stop the game from trying to generate anymore music and to just cease attempting to play the music in general
						boyfriend.stunned = true;
						var doof:DialogueBox = new DialogueBox(false, CoolUtil.coolTextFile(Paths.txt('applecore/coreDialogueEnd')));
						doof.scrollFactor.set();
						doof.finishThing = function()
						{
							FlxG.switchState(new PlayMenuState());
						};
						doof.cameras = [camDialogue];
						schoolIntro(doof, false);

					default:
						FlxG.switchState(new PlayMenuState());
				}
				transIn = FlxTransitionableState.defaultTransIn;
				transOut = FlxTransitionableState.defaultTransOut;

				if (SONG.validScore)
				{
					NGio.unlockMedal(60961);
					Highscore.saveWeekScore(storyWeek, campaignScore,
						storyDifficulty, characteroverride == "none" || characteroverride == "bf" ? "bf" : characteroverride);
				}

				FlxG.save.flush();
			}
			else
			{	
				switch (SONG.song.toLowerCase())
				{
					default:
						nextSong();
				}
			}
		}
		else if (xtraSong) {
			FlxG.switchState(new ExtraSongState());
		}
		else
		{
			if(FlxG.save.data.freeplayCuts)
			{
				switch (SONG.song.toLowerCase())
				{
					case 'applecore':
						canPause = false;
						FlxG.sound.music.volume = 0;
						vocals.volume = 0;
						generatedMusic = false; // stop the game from trying to generate anymore music and to just cease attempting to play the music in general
						boyfriend.stunned = true;
						var doof:DialogueBox = new DialogueBox(false, CoolUtil.coolTextFile(Paths.txt('applecore/coreDialogueEnd')));
						doof.scrollFactor.set();
						doof.finishThing = ughWhyDoesThisHaveToFuckingExist;
						doof.cameras = [camDialogue];
						schoolIntro(doof, false);
					default:
						FlxG.switchState(new PlayMenuState());
				}
			}
			else
			{
				FlxG.switchState(new PlayMenuState());
			}
		}
	}

	function ughWhyDoesThisHaveToFuckingExist() 
	{
		FlxG.switchState(new PlayMenuState());
	}

	var endingSong:Bool = false;

	var timeShown = 0;
 	var currentTimingShown:FlxText = null;

	function nextSong()
	{
		var difficulty:String = "";

		if (storyDifficulty == 0)
			difficulty = '-easy';

		if (storyDifficulty == 2)
			difficulty = '-hard';

		if (storyDifficulty == 3)
			difficulty = '-unnerf';

		trace(PlayState.storyPlaylist[0].toLowerCase() + difficulty);

		FlxTransitionableState.skipNextTransIn = true;
		FlxTransitionableState.skipNextTransOut = true;
		
		prevCamFollow = camFollow;
		prevCamFollowPos = camFollowPos;

		PlayState.SONG = Song.loadFromJson(PlayState.storyPlaylist[0].toLowerCase() + difficulty, PlayState.storyPlaylist[0]);
		FlxG.sound.music.stop();
		
		switch (curSong.toLowerCase())
		{
			case 'corn-theft':
				LoadingState.loadAndSwitchState(new VideoState('assets/videos/mazeecutscenee.webm', new PlayState()), false);
			default:
				LoadingState.loadAndSwitchState(new PlayState());
		}
	}
	private function popUpScore(strumtime:Float, notedata:Int):Void
	{
		var noteDiff:Float = Math.abs(strumtime - Conductor.songPosition);
		// boyfriend.playAnim('hey');
		vocals.volume = 1;

		var placement:String = Std.string(combo);

		var coolText:FlxText = new FlxText(0, 0, 0, placement, 32);
		coolText.screenCenter();
		coolText.x = FlxG.width * 0.55;
		coolText.y -= 350;
		var ratingFolder:String = 'ui/ratings';
		var rating:FlxSprite = new FlxSprite();
		var score:Int = 350;

		var daRating:String = "sick";

		if (noteDiff > Conductor.safeZoneOffset * 2)
		{
			daRating = 'shit';
			totalNotesHit -= 2;
			score = -3000;
			ss = false;
			shits++;
		}
		else if (noteDiff < Conductor.safeZoneOffset * -2)
		{
			daRating = 'shit';
			totalNotesHit -= 2;
			score = -3000;
			ss = false;
			shits++;
		}
		else if (noteDiff > Conductor.safeZoneOffset * 0.45)
		{
			daRating = 'bad';
			score = -1000;
			totalNotesHit += 0.2;
			ss = false;
			bads++;
		}
		else if (noteDiff > Conductor.safeZoneOffset * 0.25)
		{
			daRating = 'good';
			totalNotesHit += 0.65;
			score = 200;
			ss = false;
			goods++;
		}
		if (daRating == 'sick')
		{
			totalNotesHit += 1;
			sicks++;
		}
		switch (notedata)
		{
			case 2:
				score = cast(FlxMath.roundDecimal(cast(score, Float) * curmult[2], 0), Int);
			case 3:
				score = cast(FlxMath.roundDecimal(cast(score, Float) * curmult[1], 0), Int);
			case 1:
				score = cast(FlxMath.roundDecimal(cast(score, Float) * curmult[3], 0), Int);
			case 0:
				score = cast(FlxMath.roundDecimal(cast(score, Float) * curmult[0], 0), Int);
		}

		if (daRating != 'shit' || daRating != 'bad')
		{
			songScore += score;

			/* if (combo > 60)
					daRating = 'sick';
				else if (combo > 12)
					daRating = 'good'
				else if (combo > 4)
					daRating = 'bad';
			*/

			if(scoreTxtTween != null) 
			{
				scoreTxtTween.cancel();
			}

			scoreTxt.scale.x = 1.1;
			scoreTxt.scale.y = 1.1;
			scoreTxtTween = FlxTween.tween(scoreTxt.scale, {x: 1, y: 1}, 0.2, {
				onComplete: function(twn:FlxTween) {
					scoreTxtTween = null;
				}
			});

			if(formoverride == "radical")
				{
					ratingstype = 'radical';
				}
			rating.loadGraphic(Paths.image(ratingFolder + '/' + ratingstype + '/' + daRating));
			rating.screenCenter();
			rating.y -= 50;
 			rating.x = coolText.x - 125;
			rating.acceleration.y = 550;
			rating.velocity.y -= FlxG.random.int(140, 175);
			rating.velocity.x -= FlxG.random.int(0, 10);

 			var msTiming = truncateFloat(noteDiff, 0);
 
 			if (currentTimingShown != null)
 				remove(currentTimingShown);
 
 			currentTimingShown = new FlxText(0,0,0,"0ms");
 			timeShown = 0;
 			switch(daRating)
 			{
 				case 'shit' | 'bad':
 					currentTimingShown.color = FlxColor.RED;
 				case 'good':
 					currentTimingShown.color = FlxColor.GREEN;
 				case 'sick':
 					currentTimingShown.color = FlxColor.CYAN;
 			}
 			currentTimingShown.borderStyle = OUTLINE;
 			currentTimingShown.borderSize = 1.4;
 			currentTimingShown.borderColor = FlxColor.BLACK;
 			currentTimingShown.text = msTiming + "ms";
 			currentTimingShown.font = Paths.font("comic.ttf");
 			currentTimingShown.size = 30;
 
 			if (currentTimingShown.alpha != 1)
 				currentTimingShown.alpha = 1;
 
 			add(currentTimingShown);
 			
			var comboSpr:FlxSprite = new FlxSprite().loadGraphic(Paths.image(ratingFolder + '/' + ratingstype + '/' + 'combo'));
			comboSpr.screenCenter();
			comboSpr.x = rating.x;
 			comboSpr.y = rating.y + 100;
			comboSpr.acceleration.y = 600;
			comboSpr.velocity.y -= 150;

 			currentTimingShown.screenCenter();
 			currentTimingShown.x = comboSpr.x + 100;
			currentTimingShown.y = rating.y + 100;
 			currentTimingShown.acceleration.y = 600;
 			currentTimingShown.velocity.y -= 150;
			if(SONG.song.toLowerCase() == 'algebra')
			{
				currentTimingShown.y += 2000;
			}

			comboSpr.velocity.x += FlxG.random.int(1, 10);
			currentTimingShown.velocity.x += comboSpr.velocity.x;
			add(rating);

			if (!curStage.startsWith('school'))
			{
				rating.setGraphicSize(Std.int(rating.width * 0.7));
				rating.antialiasing = true;
				comboSpr.setGraphicSize(Std.int(comboSpr.width * 0.7));
				comboSpr.antialiasing = true;
			}
			else
			{
				rating.setGraphicSize(Std.int(rating.width * daPixelZoom * 0.7));
				comboSpr.setGraphicSize(Std.int(comboSpr.width * daPixelZoom * 0.7));
			}

			currentTimingShown.updateHitbox();
			comboSpr.updateHitbox();
			rating.updateHitbox();

			var seperatedScore:Array<Int> = [];

			var comboSplit:Array<String> = (combo + "").split('');

			if (comboSplit.length == 2)
				seperatedScore.push(0); // make sure theres a 0 in front or it looks weird lol!

			for (i in 0...comboSplit.length)
			{
				var str:String = comboSplit[i];
				seperatedScore.push(Std.parseInt(str));
			}

			var daLoop:Int = 0;
			for (i in seperatedScore)
			{
				var numScore:FlxSprite = new FlxSprite().loadGraphic(Paths.image(ratingFolder + '/' + ratingstype + '/' + 'num' + Std.int(i)));
				numScore.screenCenter();
				numScore.x = rating.x + (43 * daLoop) - 50;
 				numScore.y = rating.y + 100;
 
				if (!curStage.startsWith('school'))
				{
					numScore.antialiasing = true;
					numScore.setGraphicSize(Std.int(numScore.width * 0.5));
				}
				else
				{
					numScore.setGraphicSize(Std.int(numScore.width * daPixelZoom));
				}
				numScore.updateHitbox();

				numScore.acceleration.y = FlxG.random.int(200, 300);
				numScore.velocity.y -= FlxG.random.int(140, 160);
				numScore.velocity.x = FlxG.random.float(-5, 5);

				if (combo >= 10 || combo == 0)
					add(numScore);

				FlxTween.tween(numScore, {alpha: 0}, 0.2, {
					onComplete: function(tween:FlxTween)
					{
						numScore.destroy();
					},
					startDelay: Conductor.crochet * 0.002
				});

				daLoop++;
			}
			/* 
				trace(combo);
				trace(seperatedScore);
			 */

			coolText.text = Std.string(seperatedScore);
			// add(coolText);

			FlxTween.tween(rating, {alpha: 0}, 0.2, {
				startDelay: Conductor.crochet * 0.001,
 				onUpdate: function(tween:FlxTween)
 				{
					if (currentTimingShown != null)
 						currentTimingShown.alpha -= 0.02;
 					timeShown++;
 				}
			});

			FlxTween.tween(comboSpr, {alpha: 0}, 0.2, {
				onComplete: function(tween:FlxTween)
				{
					coolText.destroy();
					comboSpr.destroy();

					if (currentTimingShown != null && timeShown >= 100)
 					{
 						remove(currentTimingShown);
 						currentTimingShown = null;
 					}

					rating.destroy();
				},
				startDelay: Conductor.crochet * 0.001
			});

			curSection += 1;
		}
	}

	public function NearlyEquals(value1:Float, value2:Float, unimportantDifference:Float = 10):Bool
	{
		return Math.abs(FlxMath.roundDecimal(value1, 1) - FlxMath.roundDecimal(value2, 1)) < unimportantDifference;
	}

	var upHold:Bool = false;
	var downHold:Bool = false;
	var rightHold:Bool = false;
	var leftHold:Bool = false;

	private function keyShit():Void
	{
		// HOLDING
		var up = controls.UP;
		var right = controls.RIGHT;
		var down = controls.DOWN;
		var left = controls.LEFT;

		var upP = controls.UP_P;
		var rightP = controls.RIGHT_P;
		var downP = controls.DOWN_P;
		var leftP = controls.LEFT_P;

		var upR = controls.UP_R;
		var rightR = controls.RIGHT_R;
		var downR = controls.DOWN_R;
		var leftR = controls.LEFT_R;

		var controlArray:Array<Bool> = [leftP, downP, upP, rightP];

		// FlxG.watch.addQuick('asdfa', upP);
		if ((upP || rightP || downP || leftP) && !boyfriend.stunned && generatedMusic)
		{
			boyfriend.holdTimer = 0;

			var possibleNotes:Array<Note> = [];

			var ignoreList:Array<Int> = [];

			notes.forEachAlive(function(daNote:Note)
			{
				if (daNote.canBeHit && daNote.mustPress && !daNote.tooLate && !daNote.wasGoodHit && !daNote.isSustainNote && daNote.finishedGenerating)
				{
					possibleNotes.push(daNote);
				}
			});

			possibleNotes.sort((a, b) -> Std.int(a.noteData - b.noteData)); //sorting twice is necessary as far as i know
			haxe.ds.ArraySort.sort(possibleNotes, function(a, b):Int {
				var notetypecompare:Int = Std.int(a.noteData - b.noteData);

				if (notetypecompare == 0)
				{
					return Std.int(a.strumTime - b.strumTime);
				}
				return notetypecompare;
			});

			if (possibleNotes.length > 0)
			{
				var daNote = possibleNotes[0];

				if (perfectMode)
					noteCheck(true, daNote);

				// Jump notes
				var lasthitnote:Int = -1;
				var lasthitnotetime:Float = -1;

				for (note in possibleNotes) 
				{
					if (controlArray[note.noteData % 4])
					{
						if (lasthitnotetime > Conductor.songPosition - Conductor.safeZoneOffset
							&& lasthitnotetime < Conductor.songPosition + (Conductor.safeZoneOffset * 0.2)) //reduce the past allowed barrier just so notes close together that aren't jacks dont cause missed inputs
						{
							if ((note.noteData % 4) == (lasthitnote % 4))
							{
								continue; //the jacks are too close together
							}
						}
						lasthitnote = note.noteData;
						lasthitnotetime = note.strumTime;
						goodNoteHit(note);
					}
				}
				
				if (daNote.wasGoodHit)
				{
					daNote.kill();
					notes.remove(daNote, true);
					daNote.destroy();
				}
			}
			else if (!theFunne)
			{
				badNoteCheck(null);
			}
		}

		if ((up || right || down || left) && generatedMusic)
		{
			notes.forEachAlive(function(daNote:Note)
			{
				if (daNote.canBeHit && daNote.mustPress && daNote.isSustainNote)
				{
					switch (daNote.noteData)
					{
						// NOTES YOU ARE HOLDING
						case 2:
							if (up || upHold)
								goodNoteHit(daNote);
						case 3:
							if (right || rightHold)
								goodNoteHit(daNote);
						case 1:
							if (down || downHold)
								goodNoteHit(daNote);
						case 0:
							if (left || leftHold)
								goodNoteHit(daNote);
					}
				}
			});
		}

		if (boyfriend.holdTimer > Conductor.stepCrochet * 4 * 0.001 && !up && !down && !right && !left)
		{
			if (boyfriend.animation.curAnim.name.startsWith('sing') && !boyfriend.animation.curAnim.name.endsWith('miss'))
			{
				boyfriend.dance();
			}
		}

		playerStrums.forEach(function(spr:Strum)
		{
			switch (spr.ID)
			{
				case 2:
					if (upP && spr.animation.curAnim.name != 'confirm')
					{
						spr.animation.play('pressed');
					}
					if (upR)
					{
						spr.animation.play('static');
					}
				case 3:
					if (rightP && spr.animation.curAnim.name != 'confirm')
						spr.animation.play('pressed');
					if (rightR)
					{
						spr.animation.play('static');
					}
				case 1:
					if (downP && spr.animation.curAnim.name != 'confirm')
						spr.animation.play('pressed');
					if (downR)
					{
						spr.animation.play('static');
					}
				case 0:
					if (leftP && spr.animation.curAnim.name != 'confirm')
						spr.animation.play('pressed');
					if (leftR)
					{
						spr.animation.play('static');
					}
			}

			if (spr.animation.curAnim.name == 'confirm' && !curStage.startsWith('school') && (SONG.song.toLowerCase() != 'disability'))
			{
				spr.centerOffsets();
				spr.offset.x -= 13;
				spr.offset.y -= 13;
			}
			else if (SONG.song.toLowerCase() != 'disability')
				spr.centerOffsets();
			else
				spr.smartCenterOffsets();
		});
	}

	function noteMiss(direction:Int = 1):Void
	{
		if (!boyfriend.stunned)
		{
			health -= 0.04;
			//trace("note miss");
			if (combo > 5 && gf.animOffsets.exists('sad'))
			{
				gf.playAnim('sad');
			}
			combo = 0;
			misses++;

			songScore -= 10;

			FlxG.sound.play(Paths.soundRandom('missnote', 1, 3), FlxG.random.float(0.1, 0.2));
			// FlxG.sound.play(Paths.sound('missnote1'), 1, false);
			// FlxG.log.add('played imss note');
			if (boyfriend.animation.getByName("singLEFTmiss") != null)
			{
				//'LEFT', 'DOWN', 'UP', 'RIGHT'
				var fuckingDumbassBullshitFuckYou:String;
				fuckingDumbassBullshitFuckYou = notestuffs[Math.round(Math.abs(direction)) % 4];
				if(!boyfriend.nativelyPlayable)
				{
					switch(notestuffs[Math.round(Math.abs(direction)) % 4])
					{
						case 'LEFT':
							fuckingDumbassBullshitFuckYou = 'RIGHT';
						case 'RIGHT':
							fuckingDumbassBullshitFuckYou = 'LEFT';
					}
				}
				boyfriend.playAnim('sing' + fuckingDumbassBullshitFuckYou + "miss", true);
			}
			else
			{
				boyfriend.color = 0xFF000084;
				//'LEFT', 'DOWN', 'UP', 'RIGHT'
				var fuckingDumbassBullshitFuckYou:String;
				fuckingDumbassBullshitFuckYou = notestuffs[Math.round(Math.abs(direction)) % 4];
				if(!boyfriend.nativelyPlayable)
				{
					switch(notestuffs[Math.round(Math.abs(direction)) % 4])
					{
						case 'LEFT':
							fuckingDumbassBullshitFuckYou = 'RIGHT';
						case 'RIGHT':
							fuckingDumbassBullshitFuckYou = 'LEFT';
					}
				}
				boyfriend.playAnim('sing' + fuckingDumbassBullshitFuckYou, true);
			}

			updateAccuracy();
		}
	}

	function badNoteCheck(note:Note = null)
	{
		// just double pasting this shit cuz fuk u
		// REDO THIS SYSTEM!
		if (note != null)
		{
			if(note.mustPress && note.finishedGenerating)
			{
				noteMiss(note.noteData);
			}
			return;
		}
		var upP = controls.UP_P;
		var rightP = controls.RIGHT_P;
		var downP = controls.DOWN_P;
		var leftP = controls.LEFT_P;

		if (leftP)
			noteMiss(0);
		if (upP)
			noteMiss(2);
		if (rightP)
			noteMiss(3);
		if (downP)
			noteMiss(1);
		updateAccuracy();
	}

	function updateAccuracy()
	{
		if (misses > 0 || accuracy < 96)
			fc = false;
		else
			fc = true;
		totalPlayed += 1;
		accuracy = totalNotesHit / totalPlayed * 100;
	}

	function noteCheck(keyP:Bool, note:Note):Void // sorry lol
	{
		if (keyP)
		{
			goodNoteHit(note);
		}
		else if (!theFunne)
		{
			badNoteCheck(note);
		}
	}

	function goodNoteHit(note:Note):Void
	{
		if (!note.wasGoodHit)
		{
			if (!note.isSustainNote)
			{
				popUpScore(note.strumTime, note.noteData);
				if (FlxG.save.data.donoteclick)
				{
					FlxG.sound.play(Paths.sound('note_click'));
				}
				combo += 1;

			}
			else
				totalNotesHit += 1;

			if (note.isSustainNote)
				health += 0.004;
			else
				health += 0.023;

			if (darkLevels.contains(curStage) && SONG.song.toLowerCase() != "polygonized")
			{
				boyfriend.color = nightColor;
			}
			else if(sunsetLevels.contains(curStage))
			{
				boyfriend.color = sunsetColor;
			}
			else
			{
				boyfriend.color = FlxColor.WHITE;
			}

			//'LEFT', 'DOWN', 'UP', 'RIGHT'
			var fuckingDumbassBullshitFuckYou:String;
			fuckingDumbassBullshitFuckYou = notestuffs[Math.round(Math.abs(note.noteData)) % 4];
			if(!boyfriend.nativelyPlayable)
			{
				switch(notestuffs[Math.round(Math.abs(note.noteData)) % 4])
				{
					case 'LEFT':
						fuckingDumbassBullshitFuckYou = 'RIGHT';
					case 'RIGHT':
						fuckingDumbassBullshitFuckYou = 'LEFT';
				}
			}
			if(shakingChars.contains(opponent.curCharacter))
			{
				FlxG.camera.shake(0.0075, 0.1);
				camHUD.shake(0.0045, 0.1);
			}
			boyfriend.playAnim('sing' + fuckingDumbassBullshitFuckYou, true);
			if (UsingNewCam)
			{
				focusOnDadGlobal = false;
				if(camMoveAllowed)
					ZoomCam(false);
			}

			playerStrums.forEach(function(spr:Strum)
			{
				if (Math.abs(note.noteData) == spr.ID)
				{
					spr.animation.play('confirm', true);
				}
			});

			note.wasGoodHit = true;
			vocals.volume = 1;

			note.kill();
			notes.remove(note, true);
			note.destroy();

			updateAccuracy();
		}
	}

	override function stepHit()
	{
		super.stepHit();

		if (FlxG.sound.music.time > Conductor.songPosition + 20 || FlxG.sound.music.time < Conductor.songPosition - 20)
		{
			resyncVocals();
		}

		if (opponent.curCharacter == 'spooky' && curStep % 4 == 2)
		{
			// opponent.dance();
		}

		#if desktop
		DiscordClient.changePresence(SONG.song,
			"Acc: "
			+ truncateFloat(accuracy, 2)
			+ "% | Score: "
			+ songScore
			+ " | WuffGaming was here | Misses: "
			+ misses, iconRPC, true,
			FlxG.sound.music.length
			- Conductor.songPosition);
		#end
	}

	var lightningStrikeBeat:Int = 0;
	var lightningOffset:Int = 8;

	var cool:Int = 0;

	override function beatHit()
	{
		super.beatHit();

		if(curBeat % camBeatSnap == 0)
		{
			if(timeTxtTween != null) 
			{
				timeTxtTween.cancel();
			}

			timeTxt.scale.x = 1.1;
			timeTxt.scale.y = 1.1;
			timeTxtTween = FlxTween.tween(timeTxt.scale, {x: 1, y: 1}, 0.2, {
				onComplete: function(twn:FlxTween) {
					timeTxtTween = null;
				}
			});
		}

		if (!UsingNewCam)
		{
			if (generatedMusic && PlayState.SONG.notes[Std.int(curStep / 16)] != null)
			{
				if (curBeat % 4 == 0)
				{
					// trace(PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection);
				}

				if (!PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection)
				{
					focusOnDadGlobal = true;
					if(camMoveAllowed)
						ZoomCam(true);
				}

				if (PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection)
				{
					focusOnDadGlobal = false;
					if(camMoveAllowed)
						ZoomCam(false);
				}
			}
		}
		if(curBeat % danceBeatSnap == 0 && daveFuckingDies != null)
		{
			daveFuckingDies.dance();
		}
		if (generatedMusic)
		{
			notes.sort(FlxSort.byY, FlxSort.DESCENDING);
		}

		if (SONG.notes[Math.floor(curStep / 16)] != null)
		{
			if (SONG.notes[Math.floor(curStep / 16)].changeBPM)
			{
				Conductor.changeBPM(SONG.notes[Math.floor(curStep / 16)].bpm);
				FlxG.log.add('CHANGED BPM!');
			}
			// else
			// Conductor.changeBPM(SONG.bpm);
		}
		/*
		if (opponent.curCharacter == 'bandu')  {
			krunkity = opponentmirror.animation.finished && opponent.animation.finished;
		}*/
		if (opponent.animation.finished)
		{
			switch (SONG.song.toLowerCase())
			{
				case 'tutorial':
					opponent.dance(idleAlt);
					opponentmirror.dance(idleAlt);
				case 'disruption':
					if (curBeat % gfSpeed == 0 && opponent.holdTimer <= 0) {
						opponent.dance(idleAlt);
						opponentmirror.dance(idleAlt);
					}
				case 'applecore':
					if (opponent.holdTimer <= 0 && curBeat % OpponentDanceSnap == 0)
						!wtfThing ? opponent.dance(opponent.POOP) : opponent.playAnim('idle-alt', true); // i hate everything
					if (opponentmirror.holdTimer <= 0 && curBeat % OpponentDanceSnap == 0)
						!wtfThing ? opponentmirror.dance(opponent.POOP) : opponentmirror.playAnim('idle-alt', true); // sutpid
				default:
					if (opponent.holdTimer <= 0 && curBeat % OpponentDanceSnap == 0)
						opponent.dance(idleAlt);
					if (opponentmirror.holdTimer <= 0 && curBeat % OpponentDanceSnap == 0)
						opponentmirror.dance(idleAlt);
			}
		}
		if(opponent2 != null)
		{
			if ((opponent2.animation.finished || opponent2.animation.curAnim.name == 'idle') && opponent2.holdTimer <= 0 && curBeat % OpponentDanceSnap == 0)
				opponent2.dance(idleAlt);
		}
		if (swagger != null) {
			if (swagger.holdTimer <= 0 && curBeat % 1 == 0 && swagger.animation.finished)
				swagger.dance();
		}
		if (littleIdiot != null) {
			if (littleIdiot.animation.finished && littleIdiot.holdTimer <= 0 && curBeat % OpponentDanceSnap == 0) littleIdiot.dance();
		}

		// FlxG.log.add('change bpm' + SONG.notes[Std.int(curStep / 16)].changeBPM);
		wiggleShit.update(Conductor.crochet);

		if (camZooming && FlxG.camera.zoom < (1.35 * camZoomIntensity) && curBeat % camBeatSnap == 0)
		{
			FlxG.camera.zoom += (0.015 * camZoomIntensity);
			camHUD.zoom += (0.03 * camZoomIntensity);
		}
		switch (curSong.toLowerCase())
		{
			case 'algebra':
				switch(curBeat)
				{
					//STANDER POSITIONING IS INCOMPLETE, FIX LATER
					case 160:
						swagSpeed = SONG.speed - 0.5;
						//GARRETT TURN 1!!
						swapDad('garrett');
						iconP2.changeIcon(opponent.iconName);
						algebraStander('og-dave', daveStand, 250, 100);
						daveJunk.visible = true;
					case 416: // 
						//HAPPY DAVE TURN 2!!
						swapDad('og-dave');
						iconP2.changeIcon(opponent.iconName);
						daveJunk.visible = false;
						garrettJunk.visible = true;
						swagSpeed = SONG.speed - 0.3;
						for(member in standersGroup.members)
						{
							member.destroy();
						}
						algebraStander('garrett', garrettStand, 500, 225);
					case 536:
						//GARRETT TURN 2
						swapDad('garrett');
						davePiss.visible = true;
						garrettJunk.visible = false;
						for(member in standersGroup.members)
						{
							member.destroy();
						}
						algebraStander('og-dave-angey', daveStand, 250, 100);
						iconP2.changeIcon(opponent.iconName);
					case 552:
						//ANGEY DAVE TURN 1!!
						swapDad('og-dave-angey');
						davePiss.visible = false;
						garrettJunk.visible = true;
						for(member in standersGroup.members)
						{
							member.destroy();
						}
						algebraStander('garrett', garrettStand, 500, 225);
						iconP2.changeIcon(opponent.iconName);
					case 696:
						// GREENY GUY TURN
						swapDad('hall-monitor');
						davePiss.visible = true;
						diamondJunk.visible = true;
						swagSpeed = 2;
						for(member in standersGroup.members)
						{
							member.destroy();
						}
						algebraStander('garrett', garrettStand, 500, 225);
						algebraStander('og-dave-angey', daveStand, 250, 100);
						iconP2.changeIcon(opponent.iconName);
					case 1344:
						//DIAMOND MAN TURN
						swapDad('diamond-man');
						monitorJunk.visible = true;
						diamondJunk.visible = false;
						swagSpeed = SONG.speed;
						for(member in standersGroup.members)
						{
							member.destroy();
						}
						algebraStander('garrett', garrettStand, 500, 225);
						algebraStander('hall-monitor', hallMonitorStand, 0, 100);
						algebraStander('og-dave-angey', daveStand, 250, 100);
						iconP2.changeIcon(opponent.iconName);
					case 1696:
						//PLAYROBOT TURN
						swapDad('playrobot');
						swagSpeed = 1.6;
						iconP2.changeIcon(opponent.iconName);
					case 1852:
						FlxTween.tween(davePiss, {x: davePiss.x - 250}, 0.5, {ease:FlxEase.quadOut});
						davePiss.animation.play('d');
					case 1856:
						//SCARY PLAYROBOT TURN
						swapDad('playrobot-crazy');
						swagSpeed = SONG.speed;
						iconP2.changeIcon(opponent.iconName);
					case 1996:
						//ANGEY DAVE TURN 2!!
						swapDad('og-dave-angey');
						robotJunk.visible = true;
						davePiss.visible = false;
						for(member in standersGroup.members)
						{
							member.destroy();
						}
						algebraStander('playrobot-scary', playRobotStand, 750, 100, false, true);
						algebraStander('garrett', garrettStand, 500, 225);
						//UNCOMMENT THIS WHEN HALL MONITOR SPRITES ARE DONE AND IN
						algebraStander('hall-monitor', hallMonitorStand, 0, 100);
						iconP2.changeIcon(opponent.iconName);
					case 2140:
						swagSpeed = SONG.speed + 0.9;
					
				}
			case 'sugar-rush':
				switch(curBeat)
				{
					case 172:
						FlxTween.tween(thunderBlack, {alpha: 0.35}, Conductor.stepCrochet / 500);
					case 204:
						FlxTween.tween(thunderBlack, {alpha: 0}, Conductor.stepCrochet / 500);
				}
			case 'tantalum':
				switch(curBeat)
				{
					case 32 | 160 | 288:
						FlxG.camera.flash(FlxColor.WHITE, 1);
					case 96:
						FlxG.camera.flash(FlxColor.WHITE, 1);
						defaultCamZoom = 0.9;
					case 112 | 368:
						defaultCamZoom = 0.8;
					case 128 | 384:
						FlxG.camera.flash(FlxColor.WHITE, 1);
						defaultCamZoom = 0.7;
					case 220:
						idleAlt = true;
						opponent.playAnim('catappear', true);
						defaultCamZoom = 1;
					case 224:
						FlxG.camera.flash(FlxColor.WHITE, 1);
						iconP2.changeIcon('ringi-toio');
						defaultCamZoom = 0.7;
					case 352:
						idleAlt = false;
						iconP2.changeIcon('ringi');
						FlxG.camera.flash(FlxColor.WHITE, 1);
						defaultCamZoom = 0.9;
					case 416:
						defaultCamZoom = 1;
						FlxTween.tween(thunderBlack, {alpha: 0.35}, Conductor.stepCrochet / 500);
					case 480:
						defaultCamZoom = 0.6;
						FlxG.camera.flash(FlxColor.WHITE, 1);
						FlxTween.tween(thunderBlack, {alpha: 0}, Conductor.stepCrochet / 500);
				}
			case 'thunderstorm':
				switch(curBeat)
				{
					case 272 | 304:
						FlxTween.tween(thunderBlack, {alpha: 0.35}, Conductor.stepCrochet / 500);
					case 300 | 332:
						FlxTween.tween(thunderBlack, {alpha: 0}, Conductor.stepCrochet / 500);
				}
			case 'applecore':
				switch(curBeat) {
					case 160 | 436 | 684:
						gfSpeed = 2;
					case 240:
						gfSpeed = 1;
					case 223:
						wtfThing = true;
						what.forEach(function(spr:FlxSprite){
							spr.frames = Paths.getSparrowAtlas('backgrounds/applecore/minion');
							spr.animation.addByPrefix('hi', 'poip', 12, true);
							spr.animation.play('hi');
						});
						creditsWatermark.text = 'Screw you!';
						kadeEngineWatermark.y -= 20;
						camHUD.flash(FlxColor.WHITE, 1);
						
						iconRPC = 'icon_the_two_dunkers';
						iconP2.changeIcon('junkers');
						opponent.playAnim('NOOMYPHONES', true);
						opponentmirror.playAnim('NOOMYPHONES', true);
						opponent.POOP = true; // WORK WORK WOKR< WOKRMKIEPATNOLIKSEHGO:"IKSJRHDLG"H
						opponentmirror.POOP = true; // :))))))))))
						poopStrums.visible = true; // ??????
						new FlxTimer().start(3.5, function(deez:FlxTimer){
							swagThings.forEach(function(spr:FlxSprite){
								FlxTween.tween(spr, {y: spr.y + 1010}, 1.2, {ease: FlxEase.circOut, startDelay: 0.5 + (0.2 * spr.ID)});
							});	
							poopStrums.forEach(function(spr:Strum){
								FlxTween.tween(spr, {alpha: 1}, 1, {ease: FlxEase.circOut, startDelay: 0.5 + (0.2 * spr.ID)});
							});
							FlxTween.tween(swagger, {y: swagger.y + 1000}, 1.05, {ease:FlxEase.cubeInOut});
						});
						unswagBG.active = unswagBG.visible = true;
						curbg =  unswagBG;
						swagBG.visible = swagBG.active = false;
					case 636:
						unfairPart = true;
						gfSpeed = 1;
						playerStrums.forEach(function(spr:Strum){
							spr.scale.set(0.7, 0.7);
						});
						what.forEach(function(spr:FlxSprite){
							spr.alpha = 0;
						});
						gfSpeed = 1;
						wtfThing = false;
						var dumbStupid = new FlxSprite().loadGraphic(Paths.image('backgrounds/applecore/poop'));
						dumbStupid.scrollFactor.set();
						dumbStupid.screenCenter();
						littleIdiot.alpha = 0;
						littleIdiot.visible = true;
						add(dumbStupid);
						dumbStupid.cameras = [camHUD];
						dumbStupid.color = FlxColor.BLACK;
						creditsWatermark.text = "Ghost tapping is forced off! Screw you!";
						health = 2;
						theFunne = false;
						poopStrums.visible = false;
						FlxTween.tween(dumbStupid, {alpha: 1}, 0.2, {onComplete: function(twn:FlxTween){
							scaryBG.active = true;
							curbg = scaryBG;
							unswagBG.visible = unswagBG.active = false;
							FlxTween.tween(dumbStupid, {alpha: 0}, 1.2, {onComplete: function(twn:FlxTween){
								trace('hi'); // i actually forgot what i was going to put here
							}});
						}});
					case 231:
						vocals.volume = 1;
					case 659:
						FlxTween.tween(littleIdiot, {alpha: 1}, 1.4, {ease: FlxEase.circOut});
					case 667:
						FlxTween.tween(littleIdiot, {"scale.x": littleIdiot.scale.x + 2.1, "scale.y": littleIdiot.scale.y + 2.1}, 1.35, {ease: FlxEase.cubeInOut, onComplete: function(twn:FlxTween){
							iconP2.changeIcon('expunged');
							healthBar.createFilledBar(littleIdiot.barColor, boyfriend.barColor);
							orbit = false;
							opponent.visible = opponentmirror.visible = swagger.visible = false;
							var derez = new FlxSprite(opponent.getMidpoint().x, opponent.getMidpoint().y).loadGraphic(Paths.image('backgrounds/applecore/monkey_guy'));
							derez.setPosition(derez.x - derez.width / 2, derez.y - derez.height / 2);
							derez.antialiasing = false;
							add(derez);
							var deez = new FlxSprite(swagger.getMidpoint().x, swagger.getMidpoint().y).loadGraphic(Paths.image('backgrounds/applecore/monkey_person'));
							deez.setPosition(deez.x - deez.width / 2, deez.y - deez.height / 2);
							deez.antialiasing = false;
							add(deez);
							var swagsnd = new FlxSound().loadEmbedded(Paths.sound('suck'));
							swagsnd.play(true);
							var whatthejunk = new FlxSound().loadEmbedded(Paths.sound('suckEnd'));
							littleIdiot.playAnim('inhale');
							littleIdiot.animation.finishCallback = function(d:String) {
								swagsnd.stop();
								whatthejunk.play(true);
								littleIdiot.animation.finishCallback = null;
							};
							new FlxTimer().start(0.2, function(tmr:FlxTimer){
								FlxTween.tween(deez, {"scale.x": 0.1, "scale.y": 0.1, x: littleIdiot.getMidpoint().x - deez.width / 2, y: littleIdiot.getMidpoint().y - deez.width / 2 - 400}, 0.65, {ease: FlxEase.quadIn});
								FlxTween.angle(deez, 0, 360, 0.65, {ease: FlxEase.quadIn, onComplete: function(twn:FlxTween) deez.kill()});

								FlxTween.tween(derez, {"scale.x": 0.1, "scale.y": 0.1, x: littleIdiot.getMidpoint().x - derez.width / 2 - 100, y: littleIdiot.getMidpoint().y - derez.width / 2 - 500}, 0.65, {ease: FlxEase.quadIn});
								FlxTween.angle(derez, 0, 360, 0.65, {ease: FlxEase.quadIn, onComplete: function(twn:FlxTween) derez.kill()});

								new FlxTimer().start(1, function(tmr:FlxTimer){ poipInMahPahntsIsGud = true; iconRPC = 'icon_unfair_junker';});
							});
						}});
				}
			case 'recovered-project': // i discovered how to do shit so i can do better event funniesss
				switch (curBeat) {
					case 1:
						FlxTween.tween(thunderBlack, {alpha: 0}, Conductor.stepCrochet / 500);
						camZoomIntensity = 0;
					case 16:
						FlxG.camera.flash(FlxColor.WHITE, 1);
						defaultCamZoom = 0.85;
					case 80:
						FlxTween.tween(thunderBlack, {alpha: 0.55}, Conductor.stepCrochet / 500);
						defaultCamZoom = 1.3;
						camZoomIntensity = 1;
					case 112:
						thunderBlack.alpha = 0;
						FlxG.camera.flash(FlxColor.WHITE, 1);
						defaultCamZoom = 0.85;
					case 208:
						camZoomIntensity = 0;
						FlxTween.tween(thunderBlack, {alpha: 0.7}, Conductor.stepCrochet / 500);
						defaultCamZoom = 1;
					case 256:
						camZoomIntensity = 1;
						thunderBlack.alpha = 0;
						swapDad('RECOVERED_PROJECT_2');
						defaultCamZoom = 0.85;
						iconP2.changeIcon('recover-2d');
					case 388:
						defaultCamZoom = 1;
					case 404:
						defaultCamZoom = 0.85;
					case 452:
						FlxTween.tween(thunderBlack, {alpha: 0.7}, Conductor.stepCrochet / 500);
						defaultCamZoom = 1;
					case 468:
						defaultCamZoom = 1.2;
					case 476:
						FlxTween.tween(thunderBlack, {alpha: 0}, Conductor.stepCrochet / 500);
						defaultCamZoom = 0.85;
					case 480:
						camZoomIntensity = 0;
						defaultCamZoom = 1.1;
						gf.visible = false;
						thunderBlack.alpha = 1;
						swapDad("RECOVERED_PROJECT_3");
					case 484:
						FlxTween.tween(thunderBlack, {alpha: 0}, 1);
						iconP2.changeIcon('recover-irreversible');
					case 532:
						camZoomIntensity = 1;
						defaultCamZoom = 0.85;
						FlxG.camera.flash(FlxColor.WHITE, 1);
						curbar = 'corruptedBar';
						creditsWatermark.text = "CORRUPTED-FILE";
						kadeEngineWatermark.y -= 200000;
						theFunne = false;
				}
			case 'wireframe':
				FlxG.camera.shake(0.005, Conductor.crochet / 1000);
				switch(curBeat)
				{
					case 254:
						opponent2.visible = true;
						new FlxTimer().start((Conductor.crochet / 1000) * 0.5, function(tmr:FlxTimer){
							FlxTween.tween(opponent2, {x: -300, y: 100}, (Conductor.crochet / 1000) * 1.5, {ease: FlxEase.cubeIn});
						});
						//FlxTween.tween(opponent, {x: 1500, y: 1500}, Conductor.crochet / 1000, {ease: FlxEase.cubeIn});
					case 256:
						creditsWatermark.text = 'Screw you!';
						kadeEngineWatermark.y -= 20;
						opponent.visible = false;
						var baldiBasic:FlxSprite = new FlxSprite(opponent.x, opponent.y);
						baldiBasic.frames = daveFuckingDies.frames;
						baldiBasic.animation.addByPrefix('HI', 'IDLE', 24, false);
						baldiBasic.animation.play("HI");
						baldiBasic.x = opponent.getMidpoint().x - baldiBasic.width / 2;
						baldiBasic.y = opponent.getMidpoint().y - baldiBasic.height / 2;
						add(baldiBasic);
						FlxTween.tween(baldiBasic, {x: baldiBasic.x + 100, y: baldiBasic.y + 500}, 0.15, {ease:FlxEase.cubeOut, onComplete: function(twn:FlxTween){
							baldiBasic.kill();
							remove(baldiBasic);
							baldiBasic.destroy();
						}});
						//this transition was lazy and dumb lets do it better
						FlxG.camera.flash(FlxColor.WHITE, 1);/*
						remove(opponent);
						//badai time
						opponent = new Character(-300, 100, 'badai', false);
						add(opponent);
						daveFuckingDies.visible = true;*/
						camMoveAllowed = false;
						badaiTime = true;
						//boyfriend.canDance = false;
						//boyfriend.playAnim('turn', true);
						new FlxTimer().start(1, function(tmr:FlxTimer)
						{
							camMoveAllowed = true;
							var position = boyfriend.getPosition();
							var width = boyfriend.width;
							/*
							remove(boyfriend);
							boyfriend = new Boyfriend(position.x, position.y, 'tunnel-bf-flipped');
							add(boyfriend);
							*/
							//boyfriendOldIcon = 'bf-old-flipped';
							//iconP1.animation.play('tunnel-bf-flipped');
							iconP2.changeIcon('badai');
							iconRPC = 'icon_badai';
							daveFuckingDies.visible = true;
							FlxTween.tween(daveFuckingDies, {y: -300}, 2.5, {ease: FlxEase.cubeInOut});
							new FlxTimer().start(2.5, function(tmr:FlxTimer)
							{
								daveFuckingDies.inCutscene = false;
							});
						});
				}
			case 'keyboard':
				switch(curBeat)
				{
					case 324:
						FlxG.camera.flash(FlxColor.WHITE, 1);
						defaultCamZoom = 1.1;
						FlxTween.tween(thunderBlack, {alpha: 0.7}, Conductor.stepCrochet / 500);
						swapDad('little-bandu');
						iconP2.changeIcon('bandu');
						healthBar.createFilledBar(opponent.barColor, boyfriend.barColor);
					case 386:
						FlxG.camera.flash(FlxColor.WHITE, 1);
						defaultCamZoom = 0.9;
						thunderBlack.alpha = 0;
						swapDad('bendu');
						iconP2.changeIcon('bendu');
						healthBar.createFilledBar(opponent.barColor, boyfriend.barColor);
				}
			case 'jam':
				switch(curBeat)
				{
					case 64:
						defaultCamZoom = 1.1;
						FlxTween.tween(thunderBlack, {alpha: 0.65}, Conductor.stepCrochet / 500);
					case 96:
						FlxG.camera.flash(FlxColor.WHITE, 1);
						defaultCamZoom = 0.7;
						thunderBlack.alpha = 0;
					case 104:
						defaultCamZoom = 0.95;
					case 128:
						defaultCamZoom = 0.9;
				}
			case 'disability':
				switch(curBeat) {
					case 16:
						defaultCamZoom = 1.4;
					case 32:
						FlxG.camera.flash(FlxColor.WHITE, 1);
						defaultCamZoom = 0.9;
					case 176 | 224 | 364 | 384:
						gfSpeed = 2;
					case 208 | 256 | 372 | 392:
						gfSpeed = 1;
				}
			case 'blitz':
				switch(curBeat) {
					case 60:
						FlxTween.tween(thunderBlack, {alpha: 0.55}, Conductor.stepCrochet / 500);
						defaultCamZoom = 1.2;
					case 64: // dave and bg turn 3d
						thunderBlack.alpha = 0;
						swapDad('insane-dave-3d');
						iconP2.changeIcon(opponent.iconName);
						healthBar.createFilledBar(opponent.barColor, boyfriend.barColor);
						defaultCamZoom = 0.8;
						threedeez.active = threedeez.visible = true;
					case 128:
						FlxG.camera.flash(FlxColor.WHITE, 1);
						defaultCamZoom = 0.9;
					case 188:
						FlxTween.tween(thunderBlack, {alpha: 0.55}, Conductor.stepCrochet / 500);
						defaultCamZoom = 1.1;
					case 192: // dave and bg turn 2d, dave switches to insanity sprites.
						thunderBlack.alpha = 0;
						swapDad('dave-insane');
						iconP2.changeIcon(opponent.iconName);
						healthBar.createFilledBar(opponent.barColor, boyfriend.barColor);
						defaultCamZoom = 1;
						threedeez.active = threedeez.visible = false;
					case 256: // dave and bg turn 3d
						swapDad('insane-dave-3d');
						iconP2.changeIcon(opponent.iconName);
						healthBar.createFilledBar(opponent.barColor, boyfriend.barColor);
						defaultCamZoom = 0.85;
						threedeez.active = threedeez.visible = true;
					case 312:
						defaultCamZoom = 0.6;
						//FlxTween.tween(FlxG.camera, {zoom: 0.6}, 2.2, {ease: FlxEase.elasticInOut});
						// todo: make this way slower!!
						// gd numer
					case 316:
						FlxTween.tween(thunderBlack, {alpha: 0.55}, Conductor.stepCrochet / 500);
						defaultCamZoom = 1.1;
					case 320: // dave and bg turn 2d
						thunderBlack.alpha = 0;
						swapDad('dave-insane');
						iconP2.changeIcon(opponent.iconName);
						healthBar.createFilledBar(opponent.barColor, boyfriend.barColor);
						defaultCamZoom = 0.8;
						threedeez.active = threedeez.visible = false;
					case 336:
						defaultCamZoom = 1;
					case 352:
						FlxG.camera.flash(FlxColor.WHITE, 1);
						defaultCamZoom = 0.9;
					case 384: // dave and bg turn 3d
						thunderBlack.alpha = 0;
						swapDad('insane-dave-3d');
						iconP2.changeIcon(opponent.iconName);
						healthBar.createFilledBar(opponent.barColor, boyfriend.barColor);
						defaultCamZoom = 1;
						threedeez.active = threedeez.visible = true;
					case 448: // dave and bg turn 2d
						swapDad('dave-insane');
						iconP2.changeIcon(opponent.iconName);
						healthBar.createFilledBar(opponent.barColor, boyfriend.barColor);
						defaultCamZoom = 1.1;
						threedeez.active = threedeez.visible = false;
					case 464:
						defaultCamZoom = 1;
					case 480: // dave and bg turn 3d
						swapDad('insane-dave-3d');
						iconP2.changeIcon(opponent.iconName);
						healthBar.createFilledBar(opponent.barColor, boyfriend.barColor);
						defaultCamZoom = 0.8;
						threedeez.active = threedeez.visible = true;
					case 512: // dave and bg turn 2d for the fimal time..
						FlxTween.tween(thunderBlack, {alpha: 0.55}, Conductor.stepCrochet / 500);
						swapDad('dave'); // keep normie house dave btw... he must be average
						iconP2.changeIcon(opponent.iconName);
						healthBar.createFilledBar(opponent.barColor, boyfriend.barColor);
						defaultCamZoom = 1.2;
						threedeez.active = threedeez.visible = false;
					case 544:
						thunderBlack.alpha = 0;
						FlxG.camera.flash(FlxColor.WHITE, 1);
						defaultCamZoom = 1.1;
					case 576:
						thunderBlack.alpha = 1;
				}
			case 'duper':
				switch(curBeat) {
					case 256:
						FlxG.camera.flash(FlxColor.WHITE, 1);
						defaultCamZoom = 0.75;
						thirdimension.active = thirdimension.visible = true;
						creditsWatermark.text = "Screw You!";
					case 320:
						thirdimension.active = thirdimension.visible = false;
						FlxG.camera.flash(FlxColor.WHITE, 1);
						defaultCamZoom = 0.9;
					case 384:
						FlxTween.tween(thunderBlack, {alpha: 0.55}, Conductor.stepCrochet / 500);
						defaultCamZoom = 1.3;
					case 445:
						defaultCamZoom = 1.2;
					case 448:
						thunderBlack.alpha = 0;
						FlxG.camera.flash(FlxColor.WHITE, 1);
						defaultCamZoom = 0.85;
					case 480:
						defaultCamZoom = 0.9;
					case 508:
						FlxTween.tween(thunderBlack, {alpha: 0.55}, Conductor.stepCrochet / 500);
						defaultCamZoom = 1.2;
					case 512:
						thunderBlack.alpha = 0;
						FlxG.camera.flash(FlxColor.WHITE, 1);
						defaultCamZoom = 0.9;
					case 576:
						FlxTween.tween(thunderBlack, {alpha: 0.55}, Conductor.stepCrochet / 500);
						defaultCamZoom = 1.2;
					case 592:
						FlxTween.tween(thunderBlack, {alpha: 0}, Conductor.stepCrochet / 500);
						defaultCamZoom = 0.9;
					case 636:
						FlxTween.tween(thunderBlack, {alpha: 0.6}, Conductor.stepCrochet / 500);
						defaultCamZoom = 1.2;
					case 640:
						thirdimension.active = thirdimension.visible = true;
						thunderBlack.alpha = 0;
						FlxG.camera.flash(FlxColor.WHITE, 1);
						defaultCamZoom = 1;
					case 696:
						FlxTween.tween(thunderBlack, {alpha: 0.6}, Conductor.stepCrochet / 500);
						defaultCamZoom = 1.3;
					case 700:
						FlxTween.tween(thunderBlack, {alpha: 0}, Conductor.stepCrochet / 500);
						defaultCamZoom = 0.75;
					case 704:
						FlxG.camera.flash(FlxColor.WHITE, 1);
						defaultCamZoom = 0.9;
				}
		}

		if (shakeCam)
		{
			gf.playAnim('scared', true);
		}

		//health icon bounce but epic
		if (curBeat % gfSpeed == 0) {
			curBeat % (gfSpeed * 2) == 0 ? {
				iconP1.scale.set(1.1, 0.8);
				iconP2.scale.set(1.1, 1.3);

				FlxTween.angle(iconP1, -15, 0, Conductor.crochet / 1300 * gfSpeed, {ease: FlxEase.quadOut});
				FlxTween.angle(iconP2, 15, 0, Conductor.crochet / 1300 * gfSpeed, {ease: FlxEase.quadOut});
			} : {
				iconP1.scale.set(1.1, 1.3);
				iconP2.scale.set(1.1, 0.8);

				FlxTween.angle(iconP2, -15, 0, Conductor.crochet / 1300 * gfSpeed, {ease: FlxEase.quadOut});
				FlxTween.angle(iconP1, 15, 0, Conductor.crochet / 1300 * gfSpeed, {ease: FlxEase.quadOut});
			}

			FlxTween.tween(iconP1, {'scale.x': 1, 'scale.y': 1}, Conductor.crochet / 1250 * gfSpeed, {ease: FlxEase.quadOut});
			FlxTween.tween(iconP2, {'scale.x': 1, 'scale.y': 1}, Conductor.crochet / 1250 * gfSpeed, {ease: FlxEase.quadOut});

			iconP1.updateHitbox();
			iconP2.updateHitbox();
		}

		if(curBeat % danceBeatSnap == 0)
		{
			if(iconP1.charPublic == 'bandu-origin')
			{
				iconP1.animation.play(iconP1.charPublic, true);
			}
			if(iconP2.charPublic == 'bandu-origin')
			{
				iconP2.animation.play(iconP2.charPublic, true);
			}
		}

		if (curBeat % gfSpeed == 0)
		{
			if (!shakeCam)
			{
				gf.dance();
			}
		}

		if (!boyfriend.animation.curAnim.name.startsWith("sing") && boyfriend.canDance && curBeat % danceBeatSnap == 0)
		{
			boyfriend.dance();
			if (darkLevels.contains(curStage) && SONG.song.toLowerCase() != "polygonized")
			{
				boyfriend.color = nightColor;
			}
			else if(sunsetLevels.contains(curStage))
			{
				boyfriend.color = sunsetColor;
			}
			else
			{
				boyfriend.color = FlxColor.WHITE;
			}
		}

		if (curBeat % 8 == 7 && SONG.song == 'Tutorial' && opponent.curCharacter == 'gf') // fixed your stupid fucking code ninjamuffin this is literally the easiest shit to fix like come on seriously why are you so dumb
		{
			opponent.playAnim('cheer', true);
			boyfriend.playAnim('hey', true);
		}
	}

	function eatShit(ass:String):Void
	{
		if (dialogue[0] == null)
		{
			trace(ass);
		}
		else
		{
			trace(dialogue[0]);
		}
	}

	function swapDad(char:String, flash:Bool = true, x:Float = 100, y:Float = 100)
	{
		if(opponent != null)
			remove(opponent);
			trace('remove opponent');
		opponent = new Character(x, y, char, false);
		trace('set opponent');
		repositionDad();
		trace('repositioned opponent');
		add(opponent);
		trace('added opponent');
		if(flash)
			FlxG.camera.flash(FlxColor.WHITE, 1, null, true);
			trace('flashed');
	}

	function repositionDad() {
		switch (opponent.curCharacter)
		{
			case 'gf':
				opponent.setPosition(gf.x, gf.y);
				gf.visible = false;
				if (isStoryMode)
				{
					tweenCamIn();
				}
			case "tristan":
				opponent.y += 325;
				opponent.x += 100;
			case 'ringi':
				opponent.y -= 275;
				opponent.x -= 255;
			case 'bambom':
				opponent.y -= 375;
				opponent.x -= 500;
			case 'bendu':
				opponent.y += 50;
				opponent.x += 10;
			case 'dave' | 'dave-insane':
				opponent.y += 160;
				opponent.x -= 50;
			case 'insane-dave-3d':
				opponent.y -= 40;
				opponent.x -= 350;
			case 'dave-png':
				opponent.x += 81;
				opponent.y += 108;
			case 'bambi-angey':
				opponent.y += 450;
				opponent.x += 100;
			case 'RECOVERED_PROJECT' | 'RECOVERED_PROJECT_2':
				opponent.setPosition(-307, 10);
			case 'RECOVERED_PROJECT_3':
				opponent.setPosition(-307, 10);
				opponent.y -= 400;
				opponent.x -= 125;
			case 'silly-sally':
				opponent.x -= 300;
				opponent.y -= 230;
			case 'garrett':
				opponent.y += 65;
			case 'diamond-man':
				opponent.y += 25;
			case 'og-dave' | 'og-dave-angey':
				opponent.x -= 190;
			case 'hall-monitor':
				opponent.x += 45;
				opponent.y += 185;
			case 'playrobot':
				opponent.y += 265;
				opponent.x += 150;
			case 'playrobot-crazy':
				opponent.y += 365;
				opponent.x += 165;
		}
	}
	
	function algebraStander(char:String, physChar:Character, x:Float = 100, y:Float = 100, startScared:Bool = false, idleAsStand:Bool = false)
	{
		return;
		if(physChar != null)
		{
			if(standersGroup.members.contains(physChar))
				standersGroup.remove(physChar);
				trace('remove physstander from group');
			remove(physChar);
			trace('remove physstander entirely');
		}
		physChar = new Character(x, y, char, false);
		trace('new physstander');
		standersGroup.add(physChar);
		trace('physstander in group');
		if(startScared)
		{
			physChar.playAnim('scared', true);
			trace('scaredy');
			new FlxTimer().start(Conductor.crochet / 1000, function(dick:FlxTimer){
				physChar.playAnim('stand', true);
				trace('standy');
			});
		}
		else
		{
			if(idleAsStand)
				physChar.playAnim('idle', true);
			else
				physChar.playAnim('stand', true);
			trace('standy');
		}
	}

	function snapCamFollowToPos(x:Float, y:Float) {
		camFollow.set(x, y);
		camFollowPos.setPosition(x, y);
	}

	function bgImg(Path:String) {
		return Paths.image('backgrounds/algebra/bgJunkers/$Path');
	}

	public function preload(graphic:String) //preload assets
	{
		if (boyfriend != null)
		{
			boyfriend.stunned = true;
		}
		var newthing:FlxSprite = new FlxSprite(9000,-9000).loadGraphic(Paths.image(graphic));
		add(newthing);
		remove(newthing);
		if (boyfriend != null)
		{
			boyfriend.stunned = false;
		}
	}
}
