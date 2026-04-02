package;

import lime.utils.DataView;
import flixel.math.FlxPoint;
import openfl.display.Shader;
import flixel.tweens.FlxTween;
import haxe.Log;
import flixel.input.gamepad.lists.FlxBaseGamepadList;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.text.FlxTypeText;
import flixel.graphics.frames.FlxAtlasFrames;
import ExtraSongState.SongInfo;
import flixel.group.FlxSpriteGroup;
import flixel.input.FlxKeyManager;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

typedef PortraitInfo =
{
	var dialogueSound:String;

	var soundAmount:Null<Int>;

	var antialiased:Bool;
}

class DialogueBox extends FlxSpriteGroup
{
	var box:FlxSprite;

	var blackScreen:FlxSprite;
	var blitzObject:FlxSprite;

	var curMod:String = '';
	var curCharacter:String = 'bf';
	var curDirection:String = 'right';
	

	var dialogue:Alphabet;
	var dialogueList:Array<String> = [];
	var dialogueSpeed:Float = 0.04;

	// SECOND DIALOGUE FOR THE PIXEL SHIT INSTEAD???
	var swagDialogue:FlxTypeText;

	var dropText:FlxText;

	public var finishThing:Void->Void;

	var portraitLeft:FlxSprite;
	var portraitRight:FlxSprite;

	var bfPortraitSizeMultiplier:Float = 1.5;
	var textBoxSizeFix:Float = 7;

	var handSelect:FlxSprite;
	var bgFade:FlxSprite;

	var debug:Bool = false;

	var curshader:Dynamic;

	public function new(talkingRight:Bool = true, ?dialogueList:Array<String>)
	{
		super();

		var songInfoData:SongInfo = Paths.loadSongJson('${PlayState.SONG.song.toLowerCase()}/info');
		var songInfo:SongInfo = cast songInfoData;

		if (songInfo.introMusic != null || songInfo.introMusic != '')
			{
				FlxG.sound.playMusic(Paths.music(songInfo.introMusic), 0);
				FlxG.sound.music.fadeIn(1, 0, 0.8);
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
		switch (songInfo.box)
		{
			case 'baldi':
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('ui/boxes/qualitybox');
				box.setGraphicSize(Std.int(box.width / textBoxSizeFix));
				box.updateHitbox();
				box.animation.addByPrefix('normalOpen', 'Speech Bubble Normal Open', 24, false);
				box.animation.addByPrefix('normal', 'speech bubble normal', 24, true);
				box.antialiasing = false;
			case '3d':
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
		var portraitLeftCharacter:String = 'none';
		var portraitRightCharacter:String = 'bf';

		var leftPortrait:Portrait = getPortrait(portraitLeftCharacter);
		var rightPortrait:Portrait = getPortrait(portraitRightCharacter);

		portraitLeft = new FlxSprite(0, FlxG.height * 0.9);
		portraitRight = new FlxSprite(0, FlxG.height * 0.9);
		portraitLeft.loadGraphic(Paths.image(leftPortrait.portraitPath));
		portraitRight.loadGraphic(Paths.image(rightPortrait.portraitPath));

		portraitLeft.setPosition(276.95, 170);
		portraitLeft.visible = true;
		portraitRight.visible = false;
		portraitRight.flipX = true;

		portraitLeft.updateHitbox();
		portraitRight.updateHitbox();
		
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
				switch (songInfo.box)
				{
					case '3d' | 'baldi':
						dropText = new FlxText(242, 502, Std.int(FlxG.width * 0.6), "", 32);
						dropText.font = 'Comic Sans MS Bold';
						dropText.color = 0xFFFFFFFF;
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
					
		}
		dialogue = new Alphabet(0, 80, "", false, true);
	}

	var dialogueOpened:Bool = false;
	var dialogueStarted:Bool = false;

	override function update(elapsed:Float)
	{
		var jsonData:PortraitInfo = Paths.loadJSON('dialogue/portraits/${curCharacter}');
		var data:PortraitInfo = cast jsonData;
		if (curshader != null)
		{
			curshader.shader.uTime.value[0] += elapsed;
		}

		dropText.text = swagDialogue.text;
		if (data.dialogueSound != null || data.dialogueSound != '')
			if (data.soundAmount != null || data.soundAmount >= 1)
				swagDialogue.sounds = [FlxG.sound.load(Paths.soundRandom('dialogue/${data.dialogueSound}', 1, data.soundAmount), 0.6)];
			else
				swagDialogue.sounds = [FlxG.sound.load(Paths.sound('dialogue/${data.dialogueSound}'), 0.6)];	
		else
			swagDialogue.sounds = [FlxG.sound.load(Paths.sound('dialogue/pixelText'), 0.6)];	

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
		swagDialogue.resetText(dialogueList[0]);
		swagDialogue.start(dialogueSpeed, true);
		var charPath:String = 'ui/dialogue/' + curCharacter;
		curshader = null;
		if (curCharacter != 'generic')
		{
			var portrait:Portrait = getPortrait(curCharacter);

			var jsonData:PortraitInfo = Paths.loadJSON('dialogue/portraits/${curCharacter}');
			var data:PortraitInfo = cast jsonData;

			portraitLeft.setPosition(220, 220);
			portraitRight.setPosition(770, 220);

			portraitLeft.loadGraphic(Paths.image(charPath));
			portraitRight.loadGraphic(Paths.image(charPath));

			if (portrait.left)
			{
				box.flipX = true;
				portraitLeft.x -= 150;
				portraitLeft.alpha = 0;
				FlxTween.tween(portraitLeft, {x: portraitLeft.x + 150, alpha: 1}, 0.15);
				portraitRight.visible = false;
				if (!portraitLeft.visible)
				{
					portraitLeft.visible = true;
				}
			}
			else
			{
				box.flipX = false;
				portraitRight.x += 150;
				portraitRight.alpha = 0;
				FlxTween.tween(portraitRight, {x: portraitRight.x - 150, alpha: 1}, 0.15);
				portraitLeft.visible = false;
				if (!portraitRight.visible)
				{
					portraitRight.visible = true;
				}
			}
			portraitLeft.antialiasing = data.antialiased;
			portraitRight.antialiasing = data.antialiased;
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
			case 'droptext_green':
				dropText.color = FlxColor.GREEN;
			case 'droptext_white':
				dropText.color = FlxColor.WHITE;
			case 'droptext_blue':
				dropText.color = FlxColor.BLUE;
			case 'slowDialogueSpeed':
				dialogueSpeed = 0.08;
			case 'fastDialogueSpeed':
				dialogueSpeed = 0.02;
			case 'normalDialogueSpeed':
				dialogueSpeed = 0.04;
		}
	}
	function getPortrait(character:String):Portrait
	{
		var portrait:Portrait = new Portrait('', '', true);
		var charPath:String = 'ui/dialogue/' + character;
		switch (curDirection)
		{
			case 'right': // all portraitlefts
				portrait.portraitPath = charPath;
				portrait.left = false;
			default:
				portrait.portraitPath = charPath;
				portrait.left = true;
		}
		return portrait;
	}

	function cleanDialog():Void
	{
		var splitName:Array<String> = dialogueList[0].split(":");
		var splitNameName:Array<String> = splitName[1].split(",");
		curMod = splitName[0];
		curCharacter = splitNameName[0];
		curDirection = splitNameName[1];
		dialogueList[0] = dialogueList[0].substr(splitName[1].length + splitName[0].length + 2).trim();
	}
}
class Portrait
{
	public var portraitPath:String;
	public var portraitLibraryPath:String = '';
	public var left:Bool;
	public function new (portraitPath:String, portraitLibraryPath:String = '', left:Bool)
	{
		this.portraitPath = portraitPath;
		this.portraitLibraryPath = portraitLibraryPath;
		this.left = left;
	}
}