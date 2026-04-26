package;

import Options;
import Controls.Control;
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.keyboard.FlxKey;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.utils.Assets;

class OptionsMenu extends MusicBeatState
{
	var selector:FlxText;
	var curSelected:Int = 0;

	var options:Array<Option> = [
		new ControlOption(controls),
		new NewInputOption(),
		new DownscrollOption(),
		new MiddlescrollOption(),
		new RatingOption(),
		new AccuracyOption(),
		new HitsoundOption(),
		new CutsceneOption(),
		new EyesoresOption(),
		new InstantRespawn(),
		#if !mobile
		new FPSOption(),
		#end
		new OffsetOption(),
	];

	private var grpControls:FlxTypedGroup<Alphabet>;
	var versionShit:FlxText;

	override function create()
	{
		DiscordRPC.changePresence('In the Options');

		var menuBG:FlxSprite = new FlxSprite().loadGraphic(MainMenuState.randomizeBG());

		menuBG.color = 0xFFea71fd;
		menuBG.setGraphicSize(Std.int(menuBG.width * 1.1));
		menuBG.updateHitbox();
		menuBG.screenCenter();
		menuBG.antialiasing = true;
		add(menuBG);

		grpControls = new FlxTypedGroup<Alphabet>();
		add(grpControls);

		for (i in 0...options.length)
		{
			var controlLabel:Alphabet = new Alphabet(0, (70 * i) + 30, options[i].getDisplay(), true, false);
			controlLabel.isMenuItem = true;
			controlLabel.targetY = i;
			grpControls.add(controlLabel);
			// DONT PUT X IN THE FIRST PARAMETER OF new ALPHABET() !!
		}

		super.create();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (controls.BACK)
			FlxG.switchState(() -> new MainMenuState());
		if (controls.UI_UP_P)
			changeSelection(-1);
		if (controls.UI_DOWN_P)
			changeSelection(1);

		if (controls.UI_RIGHT_R)
		{
			if (options[curSelected].pressRight())
			{
				grpControls.remove(grpControls.members[curSelected]);
				var ctrl:Alphabet = new Alphabet(0, (70 * curSelected) + 30, options[curSelected].getDisplay(), true, false);
				ctrl.isMenuItem = true;
				grpControls.add(ctrl);
			}
		}

		if (controls.UI_LEFT_R)
		{
			if (options[curSelected].pressLeft())
			{
				grpControls.remove(grpControls.members[curSelected]);
				var ctrl:Alphabet = new Alphabet(0, (70 * curSelected) + 30, options[curSelected].getDisplay(), true, false);
				ctrl.isMenuItem = true;
				grpControls.add(ctrl);
			}
		}

		if (controls.ACCEPT)
		{
			if (options[curSelected].pressEnter())
			{
				grpControls.remove(grpControls.members[curSelected]);
				var ctrl:Alphabet = new Alphabet(0, (70 * curSelected) + 30, options[curSelected].getDisplay(), true, false);
				ctrl.isMenuItem = true;
				grpControls.add(ctrl);
			}
		}
		FlxG.save.flush();
	}

	var isSettingControl:Bool = false;

	function changeSelection(change:Int = 0)
	{
		#if !switch
		// NGio.logEvent("Fresh");
		#end

		FlxG.sound.play(Paths.sound("scrollMenu"), 0.4);

		curSelected += change;

		if (curSelected < 0)
			curSelected = grpControls.length - 1;
		if (curSelected >= grpControls.length)
			curSelected = 0;

		// selector.y = (70 * curSelected) + 30;

		var bullShit:Int = 0;

		for (item in grpControls.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;
			// item.setGraphicSize(Std.int(item.width * 0.8));

			if (item.targetY == 0)
			{
				item.alpha = 1;
				// item.setGraphicSize(Std.int(item.width));
			}
		}
	}
}
