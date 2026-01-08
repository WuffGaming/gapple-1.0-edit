package;

import flixel.math.FlxPoint;
import openfl.display.Shader;
import flixel.tweens.FlxTween;
import haxe.Log;
import flixel.input.gamepad.lists.FlxBaseGamepadList;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.text.FlxTypeText;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxSpriteGroup;
import flixel.input.FlxKeyManager;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

using StringTools;

class DialogueBox extends FlxSpriteGroup
{
	var box:FlxSprite;

	var blackScreen:FlxSprite;
	var blitzObject:FlxSprite;

	var curCharacter:String = '';
	var curMod:String = '';

	var dialogue:Alphabet;
	var dialogueList:Array<String> = [];

	// SECOND DIALOGUE FOR THE PIXEL SHIT INSTEAD???
	var swagDialogue:FlxTypeText;

	var dropText:FlxText;

	public var finishThing:Void->Void;

	public var noAa:Array<String> = ["ui/dialogue/dave_furiosity", "ui/dialogue/3d_bamb", "ui/dialogue/unfairnessPortrait", 'ui/dialogue/3d_bambi_disruption_portrait', 
	'ui/dialogue/bandu_portrait', 'ui/dialogue/3d_splitathon_dave_port', 'ui/dialogue/3d_dave_wireframe_portrait', 'ui/dialogue/3d_dave_og_portrait', 'dialogue/EXPUNGED'
, 'ui/dialogue/RECOVERED_PORT', 'ui/dialogue/RECOVERED_PORT_WEEP'];

	var portraitLeft:FlxSprite;
	var portraitRight:FlxSprite;

	var bfPortraitSizeMultiplier:Float = 1.5;
	var textBoxSizeFix:Float = 7;

	var handSelect:FlxSprite;
	var bgFade:FlxSprite;

	var debug:Bool = false;

	var curshader:Dynamic;

	public static var randomNumber:Int;

	public function new(talkingRight:Bool = true, ?dialogueList:Array<String>)
	{
		super();

		if (FlxG.save.data.freeplayCuts) {
			switch (PlayState.SONG.song.toLowerCase())
			{
				case 'blitz' | 'disability' | 'applecore':
					FlxG.sound.playMusic(Paths.music('DaveDialogue'), 0);
					FlxG.sound.music.fadeIn(1, 0, 0.8);
				case 'disruption' | 'wireframe' | 'duper' | 'recovered-project':
					FlxG.sound.playMusic(Paths.music('scaryAmbience'), 0);
					FlxG.sound.music.fadeIn(1, 0, 0.8);
			}
		}

		bgFade = new FlxSprite(-200, -200).makeGraphic(Std.int(FlxG.width * 1.3), Std.int(FlxG.height * 1.3), 0xFFB3DFd8);
		bgFade.scrollFactor.set();
		bgFade.alpha = 0;
		add(bgFade);

		FlxTween.tween(bgFade, {alpha: 0.7}, 4.15);

		box = new FlxSprite(-20, 400);

		blackScreen = new FlxSprite(0, 0).makeGraphic(5000, 5000, FlxColor.BLACK);
		blackScreen.screenCenter();
		blackScreen.alpha = 0;
		add(blackScreen);

		blitzObject = new FlxSprite(0, 0).loadGraphic(Paths.image('backgrounds/house/blitzshow'));
		blitzObject.screenCenter();
		blitzObject.alpha = 0;
		add(blitzObject);
		
		var hasDialog = false;
		switch (PlayState.SONG.song.toLowerCase())
		{
			case 'algebra':
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('ui/boxes/qualitybox');
				box.setGraphicSize(Std.int(box.width / textBoxSizeFix));
				box.updateHitbox();
				box.animation.addByPrefix('normalOpen', 'Speech Bubble Normal Open', 24, false);
				box.animation.addByPrefix('normal', 'speech bubble normal', 24, true);
				box.antialiasing = false;
			case 'disruption' | 'applecore' | 'disability' | 'wireframe':
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('ui/boxes/3dbox');
				box.setGraphicSize(Std.int(box.width / textBoxSizeFix));
				box.updateHitbox();
				box.animation.addByPrefix('normalOpen', 'Speech Bubble Normal Open', 24, false);
				box.animation.addByPrefix('normal', 'speech bubble normal', 24, true);
				box.antialiasing = false;
			default:
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('ui/boxes/speech_bubble_talking');
				box.setGraphicSize(Std.int(box.width / textBoxSizeFix));
				box.updateHitbox();
				box.animation.addByPrefix('normalOpen', 'Speech Bubble Normal Open', 24, false);
				box.animation.addByPrefix('normal', 'speech bubble normal', 24, true);
				box.antialiasing = true;
		}

		this.dialogueList = dialogueList;
		
		if (!hasDialog)
			return;
		var portraitLeftCharacter:String = '';
		var portraitRightCharacter:String = 'bf';

		portraitLeft = new FlxSprite();
		portraitRight = new FlxSprite();

		switch (PlayState.SONG.song.toLowerCase())
		{
			case 'algebra':
				portraitLeftCharacter = 'olddave';
			case 'recovered-project':
				portraitLeftCharacter = 'recover';
			case 'blocked' | 'corn-theft' | 'maze' | 'supernovae' | 'glitch' | 'splitathon' | 'cheating' | 'unfairness' | 'disruption' | 'duper':
				portraitLeftCharacter = 'bambi';
			case 'applecore':
				portraitLeftCharacter = 'bandu';
			default:
				portraitLeftCharacter = 'dave';
		}

		var leftPortrait:Portrait = getPortrait(portraitLeftCharacter);

		portraitLeft.frames = Paths.getSparrowAtlas(leftPortrait.portraitPath);
		portraitLeft.animation.addByPrefix('enter', leftPortrait.portraitPrefix, 24, false);
		portraitLeft.updateHitbox();
		portraitLeft.scrollFactor.set();

		var rightPortrait:Portrait = getPortrait(portraitRightCharacter);
		
		portraitRight.frames = Paths.getSparrowAtlas(rightPortrait.portraitPath);
		portraitRight.animation.addByPrefix('enter', rightPortrait.portraitPrefix, 24, false);
		portraitRight.updateHitbox();
		portraitRight.scrollFactor.set();
		
		portraitRight.visible = false;

		portraitLeft.setPosition(276.95, 170);
		portraitLeft.visible = true;
		
		add(portraitLeft);
		add(portraitRight);

		box.animation.play('normalOpen');
		box.setGraphicSize(Std.int(box.width * PlayState.daPixelZoom * 0.9));
		box.updateHitbox();
		add(box);

		box.screenCenter(X);
		portraitLeft.screenCenter(X);

		switch (PlayState.SONG.song.toLowerCase())
		{
			case 'furiosity' | 'polygonized' | 'cheating' | 'unfairness' | 'disruption' | 'applecore' | 'disability' | 'wireframe' | 'algebra' | 'recovered-project':
				dropText = new FlxText(242, 502, Std.int(FlxG.width * 0.6), "", 32);
				dropText.font = 'Comic Sans MS Bold';
				dropText.color = 0xFFFFFFFF;
				add(dropText);
			
				swagDialogue = new FlxTypeText(240, 500, Std.int(FlxG.width * 0.6), "", 32);
				swagDialogue.font = 'Comic Sans MS Bold';
				swagDialogue.color = 0xFF000000;
				swagDialogue.sounds = [FlxG.sound.load(Paths.sound('pixelText'), 0.6)];
				add(swagDialogue);
			case 'duper':
				dropText = new FlxText(242, 502, Std.int(FlxG.width * 0.6), "", 32);
				dropText.font = 'Comic Sans MS Bold';
				dropText.color = FlxColor.GREEN;
				add(dropText);
		
				swagDialogue = new FlxTypeText(240, 500, Std.int(FlxG.width * 0.6), "", 32);
				swagDialogue.font = 'Comic Sans MS Bold';
				swagDialogue.color = 0xFF000000;
				swagDialogue.sounds = [FlxG.sound.load(Paths.sound('pixelText'), 0.6)];
				add(swagDialogue);
			case 'blitz':
				dropText = new FlxText(242, 502, Std.int(FlxG.width * 0.6), "", 32);
				dropText.font = 'Comic Sans MS Bold';
				dropText.color = FlxColor.BLUE;
				add(dropText);
		
				swagDialogue = new FlxTypeText(240, 500, Std.int(FlxG.width * 0.6), "", 32);
				swagDialogue.font = 'Comic Sans MS Bold';
				swagDialogue.color = 0xFF000000;
				swagDialogue.sounds = [FlxG.sound.load(Paths.sound('pixelText'), 0.6)];
				add(swagDialogue);
			default:
				dropText = new FlxText(242, 502, Std.int(FlxG.width * 0.6), "", 32);
				dropText.font = 'Comic Sans MS Bold';
				dropText.color = 0xFF00137F;
				add(dropText);
		
				swagDialogue = new FlxTypeText(240, 500, Std.int(FlxG.width * 0.6), "", 32);
				swagDialogue.font = 'Comic Sans MS Bold';
				swagDialogue.color = 0xFF000000;
				swagDialogue.sounds = [FlxG.sound.load(Paths.sound('pixelText'), 0.6)];
				add(swagDialogue);
		}
		dialogue = new Alphabet(0, 80, "", false, true);
		// dialogue.x = 90;
		// add(dialogue);
	}

	var dialogueOpened:Bool = false;
	var dialogueStarted:Bool = false;

	override function update(elapsed:Float)
	{
		if (curshader != null)
		{
			curshader.shader.uTime.value[0] += elapsed;
		}

		dropText.text = swagDialogue.text;
		switch (curCharacter)
		{
			case 'dave' | '3ddave' | 'wiredave':
				swagDialogue.sounds = [FlxG.sound.load(Paths.sound('dialogue/daveDialogue'), 0.9)];
			case 'olddave':
				swagDialogue.sounds = [FlxG.sound.load(Paths.soundRandom('dialogue/retroDialogue', 1, 3), 0.6)];
			case 'recover' | 'recoverweep':
				swagDialogue.sounds = [FlxG.sound.load(Paths.sound('dialogue/RECOVER'), 0.9)];
			case 'bambi' | 'bambimad' | '3dbambi':
				swagDialogue.sounds = [FlxG.sound.load(Paths.soundRandom('dialogue/bambDialogue', 1, 3), 0.6)];
			case 'bandu':
				swagDialogue.sounds = [FlxG.sound.load(Paths.sound('dialogue/banduDialogue'), 0.9)];
			case 'bf' | 'bfconfuse' | 'radical':
				swagDialogue.sounds = [FlxG.sound.load(Paths.sound('dialogue/bfDialogue'), 0.6)];		
			case 'gf' | 'gfcasual' | 'gfconfuse' | 'gfwhat':
				swagDialogue.sounds = [FlxG.sound.load(Paths.sound('dialogue/gfDialogue'), 0.6)];
			case 'expunged':
				swagDialogue.sounds = [FlxG.sound.load(Paths.sound('dialogue/expungedDialogue'), 0.9)];	
			default:
				swagDialogue.sounds = [FlxG.sound.load(Paths.sound('dialogue/pixelText'), 0.6)];	
		}

		if (box.animation.curAnim != null)
		{
			if (box.animation.curAnim.name == 'normalOpen' && box.animation.curAnim.finished)
			{
				box.animation.play('normal');
				dialogueOpened = true;
			}
		}

		if (dialogueOpened && !dialogueStarted)
		{
			startDialogue();
			dialogueStarted = true;
		}

		if (FlxG.keys.justPressed.ANY  && dialogueStarted)
		{
			remove(dialogue);
			
			switch (PlayState.SONG.song.toLowerCase())
			{
				default:
					FlxG.sound.play(Paths.sound('textclickmodern'), 0.8);
			}

			if (dialogueList[1] == null && dialogueList[0] != null)
			{
				if (!isEnding)
				{
					isEnding = true;
						
					FlxG.sound.music.fadeOut(2.2, 0);

					FlxTween.tween(box, {alpha: 0}, 1.2);
					FlxTween.tween(bgFade, {alpha: 0}, 1.2);
					FlxTween.tween(portraitLeft, {alpha: 0}, 1.2);
					FlxTween.tween(portraitRight, {alpha: 0}, 1.2);
					FlxTween.tween(swagDialogue, {alpha: 0}, 1.2);
					FlxTween.tween(dropText, {alpha: 0}, 1.2);

					new FlxTimer().start(1.2, function(tmr:FlxTimer)
					{
						finishThing();
						kill();
					});
				}
			}
			else
			{
				dialogueList.remove(dialogueList[0]);
				startDialogue();
			}
		}
		
		super.update(elapsed);
	}

	var isEnding:Bool = false;

	function startDialogue():Void
	{
		cleanDialog();
		// var theDialog:Alphabet = new Alphabet(0, 70, dialogueList[0], false, true);
		// dialogue = theDialog;
		// add(theDialog);

		// swagDialogue.text = ;
		swagDialogue.resetText(dialogueList[0]);
		swagDialogue.start(0.04, true);
		curshader = null;
		if (curCharacter != 'generic')
		{
			var portrait:Portrait = getPortrait(curCharacter);
			if (portrait.left)
			{
				portraitLeft.frames = Paths.getSparrowAtlas(portrait.portraitPath);
				portraitLeft.animation.addByPrefix('enter', portrait.portraitPrefix, 24, false);
				portraitLeft.updateHitbox();
				portraitLeft.scrollFactor.set();
				portraitRight.visible = false;
				if (!portraitLeft.visible)
				{
					portraitLeft.visible = true;
				}
			}
			else
			{
				portraitRight.frames = Paths.getSparrowAtlas(portrait.portraitPath);
				portraitRight.animation.addByPrefix('enter', portrait.portraitPrefix, 24, false);
				portraitLeft.updateHitbox();
				portraitLeft.scrollFactor.set();
				portraitLeft.visible = false;
				if (!portraitRight.visible)
				{
					portraitRight.visible = true;
				}
			}
			switch (curCharacter)
			{
				case 'dave' | '3ddave' | 'wiredave' | 'bambi' | 'bambimad' | '3dbambi' | 'olddave' | 'bandu' | 'recover' | 'recoverweep' | 'expunged' | 'none':
					portraitLeft.setPosition(220, 220);
				case 'bf' | 'bfconfuse' | 'gf' | 'gfcasual' | 'gfconfuse' | 'gfwhat' | 'radical': //create boyfriend, genderbent boyfriend, and gay boyfriend
					portraitRight.setPosition(570, 220);
			}
			box.flipX = portraitLeft.visible;
			portraitLeft.x -= 150;
			//portraitRight.x += 100;
			portraitLeft.antialiasing = !noAa.contains(portrait.portraitPath);
			portraitRight.antialiasing = true;
			portraitLeft.animation.play('enter',true);
			portraitRight.animation.play('enter',true);
		}
		else
		{
			portraitLeft.visible = false;
			portraitRight.visible = false;
		}
		switch (curMod)
		{
			case 'setfont_normal':
				dropText.font = 'Comic Sans MS Bold';
				swagDialogue.font = 'Comic Sans MS Bold';
			case 'setfont_code':
				dropText.font = Paths.font("barcode.ttf");
				swagDialogue.font = Paths.font("barcode.ttf");
			case 'black':
				blackScreen.alpha = 1;
			case 'no_black':
				blackScreen.alpha = 0;
			case 'to_black':
				FlxTween.tween(blackScreen, {alpha:1}, 0.25);
			case 'off_black':
				FlxTween.tween(blackScreen, {alpha:0}, 0.25);
			case 'showblitz':
				FlxTween.tween(blitzObject, {alpha:1}, 0.25);
			case 'noblitz':
				FlxTween.tween(blitzObject, {alpha:0}, 0.25);
			case 'algebrah':
				blackScreen.alpha = 0;
				FlxG.sound.playMusic(Paths.music('Algebrah'), 0.7);
			case 'droptext_green':
				dropText.color = FlxColor.GREEN;
			case 'droptext_white':
				dropText.color = FlxColor.WHITE;
			case 'droptext_blue':
				dropText.color = FlxColor.BLUE;
		}
	}
	function getPortrait(character:String):Portrait
	{
		var portrait:Portrait = new Portrait('', '', '', true);
		switch (character)
		{
			case 'none':
				switch (PlayState.SONG.song.toLowerCase())
				{
					default:
						portrait.portraitPath = 'ui/dialogue/none';
						portrait.portraitPrefix = 'dave house portrait';
				}
			case 'dave':
				switch (PlayState.SONG.song.toLowerCase())
				{
					default:
						portrait.portraitPath = 'ui/dialogue/dave_house';
						portrait.portraitPrefix = 'dave house portrait';
				}
			case '3ddave':
				switch (PlayState.SONG.song.toLowerCase())
				{
					default:
						portrait.portraitPath = 'ui/dialogue/3d_splitathon_dave_port';
						portrait.portraitPrefix = 'dave 3d splitathon portrait';
				}
			case 'wiredave':
				switch (PlayState.SONG.song.toLowerCase())
				{
					default:
						portrait.portraitPath = 'ui/dialogue/3d_dave_wireframe_portrait';
						portrait.portraitPrefix = 'dave 3d wireframe portrait';
				}
			case 'olddave':
				switch (PlayState.SONG.song.toLowerCase())
				{
					default:
						portrait.portraitPath = 'ui/dialogue/3d_dave_og_portrait';
						portrait.portraitPrefix = 'dave 3d algebra portrait';
				}
			case 'recover':
				switch (PlayState.SONG.song.toLowerCase())
				{
					default:
						portrait.portraitPath = 'ui/dialogue/RECOVERED_PORT';
						portrait.portraitPrefix = 'recovered';
				}
			case 'recoverweep':
				switch (PlayState.SONG.song.toLowerCase())
				{
					default:
						portrait.portraitPath = 'ui/dialogue/RECOVERED_PORT_WEEP';
						portrait.portraitPrefix = 'recovered';
				}
			case 'bambi':
				switch (PlayState.SONG.song.toLowerCase())
				{
					default:
						portrait.portraitPath = 'ui/dialogue/bambi_corntheft';
						portrait.portraitPrefix = 'bambi corntheft portrait';
				}
			case 'bambimad':
				switch (PlayState.SONG.song.toLowerCase())
				{
					default:
						portrait.portraitPath = 'ui/dialogue/bambi_blocked';
						portrait.portraitPrefix = 'bambi blocked portrait';
				}
			case '3dbambi':
				switch (PlayState.SONG.song.toLowerCase())
				{
					default:
						portrait.portraitPath = 'ui/dialogue/3d_bambi_disruption_portrait';
						portrait.portraitPrefix = '3d bambi disruption portrait';
				}
			case 'bandu':
				switch (PlayState.SONG.song.toLowerCase())
				{
					default:
						portrait.portraitPath = 'ui/dialogue/bandu_portrait';
						portrait.portraitPrefix = 'bandu portrait';
				}
			case 'expunged':
				switch (PlayState.SONG.song.toLowerCase())
				{
					default:
						portrait.portraitPath = 'ui/dialogue/EXPUNGED';
						portrait.portraitPrefix = 'EXPUNGED';
				}
			case 'bf':
				switch (PlayState.SONG.song.toLowerCase())
				{
					default:
						portrait.portraitPath = 'ui/dialogue/bf_insanity_splitathon';
						portrait.portraitPrefix = 'bf insanity & splitathon portrait';
				}
				portrait.left = false;
			case 'bfconfuse':
				switch (PlayState.SONG.song.toLowerCase())
				{
					default:
						portrait.portraitPath = 'ui/dialogue/bf_furiosity_corntheft';
						portrait.portraitPrefix = 'bf furiosity & corntheft portrait';
				}
				portrait.left = false;
			case 'gf':
				switch (PlayState.SONG.song.toLowerCase())
				{
					default:
						portrait.portraitPath = 'ui/dialogue/gf_splitathon';
						portrait.portraitPrefix = 'gf splitathon portrait';
				}
				portrait.left = false;
			case 'gfcasual':
				switch (PlayState.SONG.song.toLowerCase())
				{
					default:
						portrait.portraitPath = 'ui/dialogue/gf_blocked';
						portrait.portraitPrefix = 'gf blocked portrait';
				}
				portrait.left = false;
			case 'gfconfuse':
				switch (PlayState.SONG.song.toLowerCase())
				{
					default:
						portrait.portraitPath = 'ui/dialogue/gf_corntheft';
						portrait.portraitPrefix = 'gf corntheft portrait';
				}
				portrait.left = false;
			case 'gfwhat':
				switch (PlayState.SONG.song.toLowerCase())
				{
					default:
						portrait.portraitPath = 'ui/dialogue/gf_maze';
						portrait.portraitPrefix = 'gf maze portrait';
				}
				portrait.left = false;
			case 'tristan':
				portrait.portraitPath = 'ui/dialogue/tristanPortrait';
				portrait.portraitPrefix = 'tristan portrait';
			case 'radical':
				switch (PlayState.SONG.song.toLowerCase())
				{
					default:
						portrait.portraitPath = 'ui/dialogue/radical';
						portrait.portraitPrefix = 'radical';
				}
				portrait.left = false;
			default:
				portrait.portraitPath = 'ui/dialogue/dave_house';
				portrait.portraitPrefix = 'dave house portrait';
		}
		return portrait;
	}

	function cleanDialog():Void
	{
		var splitName:Array<String> = dialogueList[0].split(":");
		curCharacter = splitName[1];
		curMod = splitName[0];
		dialogueList[0] = dialogueList[0].substr(splitName[1].length + splitName[0].length + 2).trim();
	}
}
class Portrait
{
	public var portraitPath:String;
	public var portraitLibraryPath:String = '';
	public var portraitPrefix:String;
	public var left:Bool;
	public function new (portraitPath:String, portraitLibraryPath:String = '', portraitPrefix:String, left:Bool)
	{
		this.portraitPath = portraitPath;
		this.portraitLibraryPath = portraitLibraryPath;
		this.portraitPrefix = portraitPrefix;
		this.left = left;
	}
}