package;

import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.text.FlxText;
import flixel.sound.FlxSoundGroup;
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
	hellmo
**/
class CharacterInSelect
{
	public var names:Array<String>;

	public function new(names:Array<String>)
	{
		this.names = names;
	}
}

class CharacterSelectState extends MusicBeatState
{
	public var char:Boyfriend;
	public var current:Int = 0;
	public var curForm:Int = 0;
	public var characterText:FlxText;

	public var funnyIconMan:HealthIcon;

	var order:Array<String> = CoolUtil.coolTextFile(Paths.txt('forms/order'));

	var selectedCharacter:Bool = false;

	var currentSelectedCharacter:CharacterInSelect;

	// it goes left,right,up,down
	public var characters:Array<CharacterInSelect> = [];

	public function new()
	{
		trace('CharSelectOrder is ' + order);
		if (PlayState.SONG.song.toLowerCase() != 'dave-x-bambi-shipping-cute')
		{
			for (i in 0...order.length)
			{
				var characterList:Array<String> = CoolUtil.coolTextFile(Paths.txt('forms/${order[i]}'));
				characters.push(new CharacterInSelect(characterList));
			}
		}
		else
		{
			characters = [new CharacterInSelect(['dave-good', 'split-dave-3d', 'tunnel-dave', 'og-dave'])];
		}

		super();
	}

	override public function create():Void
	{
		super.create();
		Conductor.changeBPM(110);
		currentSelectedCharacter = characters[current];

		var end:FlxSprite = new FlxSprite(0, 0);
		FlxG.sound.playMusic(Paths.music("goodEnding"), 1, true);
		add(end);

		// create stage
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

		// create character for layering
		char = new Boyfriend(FlxG.width / 2, FlxG.height / 2, 'bf');
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

		var tutorialThing:FlxSprite = new FlxSprite(-100, -80).loadGraphic(Paths.image('ui/charSelectGuide'));
		tutorialThing.setGraphicSize(Std.int(tutorialThing.width * 1.5));
		tutorialThing.antialiasing = true;
		add(tutorialThing);

		// make sure the character is who we want!
		UpdateCharacter();
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		// FlxG.camera.focusOn(FlxG.ce);

		if (FlxG.keys.justPressed.ESCAPE || FlxG.keys.justPressed.BACKSPACE)
		{
			FlxG.sound.playMusic(Paths.music('freakyMenu'));
			LoadingState.loadAndSwitchState(new ExtraSongState());
		}
		if (controls.ACCEPT)
		{
			if (selectedCharacter)
			{
				return;
			}
			else
			{
				selectedCharacter = true;
			}
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
			UpdateCharacter();
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
			UpdateCharacter();
			FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
		}
		if (FlxG.keys.justPressed.DOWN && !selectedCharacter)
		{
			curForm--;
			if (curForm < 0)
			{
				curForm = characters[current].names.length - 1;
			}
			UpdateCharacter();
			FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
		}

		if (FlxG.keys.justPressed.UP && !selectedCharacter)
		{
			curForm++;
			if (curForm > characters[current].names.length - 1)
			{
				curForm = 0;
			}
			UpdateCharacter();
			FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
		}
	}

	public function UpdateCharacter()
	{
		funnyIconMan.color = FlxColor.WHITE;
		currentSelectedCharacter = characters[current];
		char.destroy();
		char = new Boyfriend(0, 0, currentSelectedCharacter.names[curForm]);
		char.screenCenter();
		char.updateHitbox();
		char.y += 300;
		add(char);
		characterText.text = char.name;
		funnyIconMan.animation.play(char.curCharacter);
		characterText.screenCenter(X);
	}

	override function beatHit()
	{
		super.beatHit();
		if (char != null && !selectedCharacter)
		{
			char.dance(false);
		}
	}

	public function endIt(e:FlxTimer = null)
	{
		trace("ENDING");
		trace(currentSelectedCharacter);
		PlayState.characteroverride = currentSelectedCharacter.names[0];
		PlayState.formoverride = currentSelectedCharacter.names[curForm];
		PlayState.curmult = [1, 1, 1, 1];
		LoadingState.loadAndSwitchState(new PlayState());
	}
}
