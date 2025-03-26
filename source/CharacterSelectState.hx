package;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.text.FlxText;
import flixel.system.FlxSoundGroup;
import flixel.math.FlxPoint;
import openfl.geom.Point;
import flixel.*;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.math.FlxMath;
import flixel.util.FlxStringUtil;
 /**
 hey you fun commiting people, 
 i don't know about the rest of the mod but since this is basically 99% my code 
 i do not give you guys permission to grab this specific code and re-use it in your own mods without asking me first.
 the secondary dev, ben
*/

/**

	hi

**/

class CharacterInSelect
{
	public var names:Array<String>;
	public var polishedNames:Array<String>;

	public function new(names:Array<String>, polishedNames:Array<String>)
	{
		this.names = names;
		this.polishedNames = polishedNames;
	}
}
class CharacterSelectState extends MusicBeatState
{
	public var char:Boyfriend;
	public var current:Int = 0;
	public var curForm:Int = 0;
	public var characterText:FlxText;

	public var funnyIconMan:HealthIcon;

	var notestuffs:Array<String> = ['LEFT', 'DOWN', 'UP', 'RIGHT'];

	public var isDebug:Bool = false; //CHANGE THIS TO FALSE BEFORE YOU COMMIT RETARDS

	public var PressedTheFunny:Bool = false;

	var selectedCharacter:Bool = false;

	var currentSelectedCharacter:CharacterInSelect;

	var noteMsTexts:FlxTypedGroup<FlxText> = new FlxTypedGroup<FlxText>();

	//it goes left,right,up,down
	
	public var characters:Array<CharacterInSelect> = 
	[
		new CharacterInSelect(['bf', '3d-bf', 'afnfg-boyfriend'], ["Boyfriend", '3D Boyfriend', 'AFNFG Boyfriend']),
		new CharacterInSelect(['split-dave-3d', 'tunnel-dave', 'og-dave', 'dave-wheels'], ['Disability Dave', 'Decimated Dave', 'Algebra Dave', 'Dave but Awesome']),
		new CharacterInSelect(['bambi-piss-3d'], ['Angry 3D Bambi']),
		new CharacterInSelect(['unfair-junker'], ['Unfair Expunged (Facing Forward)']),
		new CharacterInSelect(['bandu', 'badai', 'bandu-origin'], ['Bandu', 'Badai', 'Bandu (Origin)'])
	];
	public function new() 
	{
		super();
	}
	
	override public function create():Void 
	{
		super.create();
		Conductor.changeBPM(110);
		if(PlayState.SONG.song.toLowerCase() == 'dave-x-bambi-shipping-cute')
		{
			characters = [new CharacterInSelect(['dave-good','split-dave-3d', 'tunnel-dave', 'og-dave', 'dave-wheels'], ['Dave (Dave x Bambi)', 'Disability Dave', 'Wireframe Dave', 'Algebra Dave', 'Dave but Awesome'])];
		}
		currentSelectedCharacter = characters[current];

		FlxG.save.data.unlockedcharacters = [true,true,true,true,true,true,true,true]; //unlock everyone hi

		var end:FlxSprite = new FlxSprite(0, 0);
		FlxG.sound.playMusic(Paths.music("goodEnding"),1,true);
		add(end);
		
		//create stage
		var bg:FlxSprite = new FlxSprite(-700, -250).loadGraphic(Paths.image('backgrounds/farm/sky'));
		bg.antialiasing = true;
		bg.scrollFactor.set(0.9, 0.9);
		bg.active = false;
	
		var hills:FlxSprite = new FlxSprite(-250, 200).loadGraphic(Paths.image('backgrounds/farm/orangey hills'));
		hills.antialiasing = true;
		hills.scrollFactor.set(0.9, 0.7);
		hills.active = false;
	
		var farm:FlxSprite = new FlxSprite(150, 250).loadGraphic(Paths.image('backgrounds/farm/funfarmhouse'));
		farm.antialiasing = true;
		farm.scrollFactor.set(1.1, 0.9);
		farm.active = false;
				
		var foreground:FlxSprite = new FlxSprite(-400, 600).loadGraphic(Paths.image('backgrounds/farm/grass lands'));
		foreground.antialiasing = true;
		foreground.active = false;
				
		var cornSet:FlxSprite = new FlxSprite(-350, 325).loadGraphic(Paths.image('backgrounds/farm/Cornys'));
		cornSet.antialiasing = true;
		cornSet.active = false;
				
		var cornSet2:FlxSprite = new FlxSprite(1050, 325).loadGraphic(Paths.image('backgrounds/farm/Cornys'));
		cornSet2.antialiasing = true;
		cornSet2.active = false;
				
		var fence:FlxSprite = new FlxSprite(-350, 450).loadGraphic(Paths.image('backgrounds/farm/crazy fences'));
		fence.antialiasing = true;
		fence.active = false;
	
		var sign:FlxSprite = new FlxSprite(0, 500).loadGraphic(Paths.image('backgrounds/farm/Sign'));
		sign.antialiasing = true;
		sign.active = false;

		add(bg);
		add(hills);
		add(farm);
		add(foreground);
		add(cornSet);
		add(cornSet2);
		add(fence);
		add(sign);

		FlxG.camera.zoom = 0.75;

		//create character
		char = new Boyfriend(FlxG.width / 2, FlxG.height / 2, "bf");
		char.screenCenter();
		char.y = 350;
		add(char);
		
		characterText = new FlxText((FlxG.width / 9) - 50, (FlxG.height / 8) - 225, "Boyfriend");
		characterText.font = 'Comic Sans MS Bold';
		characterText.setFormat(Paths.font("comic.ttf"), 90, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		characterText.autoSize = false;
		characterText.fieldWidth = 1080;
		characterText.borderSize = 7;
		characterText.screenCenter(X);
		add(characterText);

		funnyIconMan = new HealthIcon('bf', true);
		funnyIconMan.sprTracker = characterText;
		funnyIconMan.visible = false;
		add(funnyIconMan);

		var tutorialThing:FlxSprite = new FlxSprite(-100, -80).loadGraphic(Paths.image('charSelectGuide'));
		tutorialThing.setGraphicSize(Std.int(tutorialThing.width * 1.5));
		tutorialThing.antialiasing = true;
		add(tutorialThing);
	}

	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		//FlxG.camera.focusOn(FlxG.ce);

		if (FlxG.keys.justPressed.ESCAPE)
		{
			LoadingState.loadAndSwitchState(new PlayMenuState());
		}

		if(controls.LEFT_P && !PressedTheFunny)
		{
			if(!char.nativelyPlayable)
			{
				char.playAnim('singRIGHT', true);
			}
			else
			{
				char.playAnim('singLEFT', true);
			}

		}
		if(controls.RIGHT_P && !PressedTheFunny)
		{
			if(!char.nativelyPlayable)
			{
				char.playAnim('singLEFT', true);
			}
			else
			{
				char.playAnim('singRIGHT', true);
			}
		}
		if(controls.UP_P && !PressedTheFunny)
		{
			char.playAnim('singUP', true);
		}
		if(controls.DOWN_P && !PressedTheFunny)
		{
			char.playAnim('singDOWN', true);
		}
		if (controls.ACCEPT)
		{
			if (PressedTheFunny)
			{
				return;
			}
			else
			{
				PressedTheFunny = true;
			}
			selectedCharacter = true;
			var heyAnimation:Bool = char.animation.getByName("hey") != null; 
			char.playAnim(heyAnimation ? 'hey' : 'singUP', true);
			FlxG.sound.music.stop();
			FlxG.sound.play(Paths.music('gameOverEnd'));
			new FlxTimer().start(1.9, endIt);
		}
		if (FlxG.keys.justPressed.LEFT && !selectedCharacter)
		{
			curForm = 0;
			current--;
			if (current < 0)
			{
				current = characters.length - 1;
			}
			UpdateBF();
			FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
		}

		if (FlxG.keys.justPressed.RIGHT && !selectedCharacter)
		{
			curForm = 0;
			current++;
			if (current > characters.length - 1)
			{
				current = 0;
			}
			UpdateBF();
			FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
		}
		if (FlxG.keys.justPressed.DOWN && !selectedCharacter)
		{
			curForm--;
			if (curForm < 0)
			{
				curForm = characters[current].names.length - 1;
			}
			UpdateBF();
			FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
		}

		if (FlxG.keys.justPressed.UP && !selectedCharacter)
		{
			curForm++;
			if (curForm > characters[current].names.length - 1)
			{
				curForm = 0;
			}
			UpdateBF();
			FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
		}
	}

	public function UpdateBF()
	{
		funnyIconMan.color = FlxColor.WHITE;
		currentSelectedCharacter = characters[current];
		characterText.text = currentSelectedCharacter.polishedNames[curForm];
		char.destroy();
		char = new Boyfriend(FlxG.width / 2, FlxG.height / 2, currentSelectedCharacter.names[curForm]);
		char.screenCenter();
		char.y = 450;

		switch (char.curCharacter)
		{
			case "tristan" | 'tristan-beta' | 'tristan-golden':
				char.y = 100 + 325;
			case 'dave' | 'dave-annoyed' | 'dave-splitathon':
				char.y = 100 + 160;
			case 'dave-old':
				char.y = 100 + 270;
			case 'dave-angey' | 'dave-annoyed-3d' | 'dave-3d-standing-bruh-what':
				char.y = 100;
			case 'bambi-3d' | 'bambi-piss-3d' | 'bandu' | 'bandu-candy' | 'unfair-junker':
				char.y = 100 + 350;
			case 'bambi-unfair':
				char.y = 100 + 575;
			case 'bambi' | 'bambi-old' | 'bambi-bevel' | 'what-lmao':
				char.y = 100 + 400;
			case 'bambi-new' | 'bambi-farmer-beta':
				char.y = 100 + 450;
			case 'bambi-splitathon':
				char.y = 100 + 400;
			case 'bambi-angey':
				char.y = 100 + 450;
			case 'bf' | '3d-bf' | 'bf-pixel' | 'bf-christmas' | 'afnfg-boyfriend':
				//dont do anything
			default: char.y = 100;
		}
		add(char);
		funnyIconMan.animation.play(char.curCharacter);
		characterText.screenCenter(X);
	}

	override function beatHit()
	{
		super.beatHit();
		if (char != null && !selectedCharacter)
		{
			char.playAnim('idle');
		}
	}
	
	
	public function endIt(e:FlxTimer = null)
	{
		trace("ENDING");
		PlayState.characteroverride = currentSelectedCharacter.names[0];
		PlayState.formoverride = currentSelectedCharacter.names[curForm];
		PlayState.curmult = [1, 1, 1, 1];
		LoadingState.loadAndSwitchState(new PlayState());
	}
	
}