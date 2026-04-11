package;

import Controls.Control;
import flixel.FlxG;
import flixel.FlxSprite;
import ExtraSongState.SongInfo;
import flixel.FlxSubState;
import flixel.addons.transition.FlxTransitionableState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.keyboard.FlxKey;
import flixel.sound.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;

class PauseSubState extends MusicBeatSubstate
{
	var grpMenuShit:FlxTypedGroup<Alphabet>;

	var credits:Array<String> = [];
	var menuItems:Array<String> = ['Resume', 'Restart Song', 'Exit to menu'];
	var curSelected:Int = 0;

	var pauseMusic:FlxSound;

	public function new(x:Float, y:Float)
	{
		super();

		var songInfoData:SongInfo = Paths.loadSongJson('${PlayState.SONG.song.toLowerCase()}/info');
		var songInfo:SongInfo = cast songInfoData;

		if (songInfo.credits != null)
		{
			for (credit in songInfo.credits)
			{
				if (credit.artists != null)
					credits.push('Artists: ' + credit.artists);
				if (credit.composers != null)
					credits.push('Composers: ' + credit.composers);
				if (credit.coders != null)
					credits.push('Coders: ' + credit.coders);
				if (credit.charters != null)
					credits.push('Charters: ' + credit.charters);
				if (credit.contributors != null)
					credits.push('Contributors: ' + credit.contributors);
				if (credit.misc != null)
					credits.push('Misc: ' + credit.misc);
			}
		}

		pauseMusic = new FlxSound().loadEmbedded(Paths.music('breakfast'), true, true);
		pauseMusic.volume = 0;
		pauseMusic.play(false, FlxG.random.int(0, Std.int(pauseMusic.length / 2)));

		FlxG.sound.list.add(pauseMusic);

		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		bg.alpha = 0;
		bg.scrollFactor.set();
		add(bg);

		var levelInfo:FlxText = new FlxText(20, 20, 0, "", 32);
		levelInfo.alpha = 0;
		levelInfo.text += CoolUtil.formatString(PlayState.SONG.song);
		levelInfo.scrollFactor.set();
		levelInfo.antialiasing = true;
		levelInfo.setFormat(Paths.font("comic.ttf"), 32);
		levelInfo.updateHitbox();
		add(levelInfo);

		var creditsInfo:FlxText = new FlxText(20, 40, 0, "", 32);
		creditsInfo.scale.set(0.65, 0.65);
		creditsInfo.alpha = 0;
		for (c in credits)
		{
			creditsInfo.text += c + '\n';
		}
		creditsInfo.scrollFactor.set();
		creditsInfo.antialiasing = true;
		creditsInfo.setFormat(Paths.font("comic.ttf"), 32, FlxColor.WHITE, RIGHT);
		creditsInfo.updateHitbox();
		add(creditsInfo);

		levelInfo.x = FlxG.width - (levelInfo.width + 20);
		creditsInfo.x = FlxG.width - (creditsInfo.width + 20);

		FlxTween.tween(bg, {alpha: 0.6}, 0.4, {ease: FlxEase.quartInOut});
		FlxTween.tween(levelInfo, {alpha: 1, y: 20}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.3});
		FlxTween.tween(creditsInfo, {alpha: 1, y: 60}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.6});

		grpMenuShit = new FlxTypedGroup<Alphabet>();
		add(grpMenuShit);

		for (i in 0...menuItems.length)
		{
			var songText:Alphabet = new Alphabet(0, (70 * i) + 30, menuItems[i], true, false);
			songText.isMenuItem = true;
			songText.targetY = i;
			grpMenuShit.add(songText);
		}

		changeSelection();

		cameras = [FlxG.cameras.list[FlxG.cameras.list.length - 1]];
	}

	override function update(elapsed:Float)
	{
		if (pauseMusic.volume < 0.5)
			pauseMusic.volume += 0.01 * elapsed;

		super.update(elapsed);

		var upP = controls.UP_P;
		var downP = controls.DOWN_P;
		var accepted = controls.ACCEPT;

		if (upP)
		{
			changeSelection(-1);
		}
		if (downP)
		{
			changeSelection(1);
		}

		if (accepted)
		{
			var daSelected:String = menuItems[curSelected];

			switch (daSelected)
			{
				case "Resume":
					close();
				case "Restart Song":
					// FlxG.resetState();
					FlxG.switchState(() -> new PlayState());
				case "Exit to menu":
					PlayState.characteroverride = 'none';
					PlayState.formoverride = 'none';
					FlxG.switchState(() -> new MainMenuState());
			}
		}

		if (FlxG.keys.justPressed.J)
		{
			// for reference later!
			// PlayerSettings.player1.controls.replaceBinding(Control.LEFT, Keys, FlxKey.J, null);
		}
	}

	override function destroy()
	{
		pauseMusic.destroy();

		super.destroy();
	}

	function changeSelection(change:Int = 0):Void
	{
		curSelected += change;

		if (curSelected < 0)
			curSelected = menuItems.length - 1;
		if (curSelected >= menuItems.length)
			curSelected = 0;

		var bullShit:Int = 0;

		for (item in grpMenuShit.members)
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
