package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.tweens.FlxTween;

typedef SongInfo =
{
	var songName:String;

	var bgColor:Array<Int>;

	var songIcon:String;

	var hasDialogue:Bool;

	var dialogue:String;

	var introMusic:String;

	var box:String;
}

class ExtraSongState extends MusicBeatState
{
	var songs:Array<SongMetadata> = [];

	var songList:Array<String> = CoolUtil.coolTextFile(Paths.txt('songList'));

	var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('ui/backgrounds/SUSSUS AMOGUS'));
	var curSelected:Int = 0;

	private var iconArray:Array<HealthIcon> = [];

	var hasDialogue:Bool = false;
	var dialogue:String = "";

	var swagText:FlxText = new FlxText(0, 0, 0, 'my poop is brimming', 85);

	private var grpSongs:FlxTypedGroup<Alphabet>;

	override function create()
	{
		if (!FlxG.sound.music.playing)
		{
			FlxG.sound.playMusic(Paths.music('freakyMenu'));
		}

		bg.loadGraphic(MainMenuState.randomizeBG());
		bg.color = 0xFF4965FF;
		add(bg);

		getSongs();

		grpSongs = new FlxTypedGroup<Alphabet>();
		add(grpSongs);

		swagText.setFormat(Paths.font("comic.ttf"), 47, FlxColor.BLACK, LEFT);
		swagText.screenCenter(X);
		swagText.y += 50;
		add(swagText);

		for (i in 0...songs.length)
		{
			var songText:Alphabet = new Alphabet(0, (70 * i) + 30, songs[i].songName, true, false);
			songText.isMenuItem = true;
			songText.targetY = i;
			grpSongs.add(songText);

			var icon:HealthIcon = new HealthIcon(songs[i].songCharacter);
			icon.sprTracker = songText;
			if (songs[i].blackoutIcon)
			{
				icon.color = FlxColor.BLACK;
			}

			iconArray.push(icon);
			add(icon);
		}

		changeSelection();

		super.create();
	}

	public function addSong(songName:String, weekNum:Array<Int>, songCharacter:String, blackoutIcon:Bool = false)
	{
		var songMeta = new SongMetadata(songName, weekNum, songCharacter, blackoutIcon);
		songs.push(songMeta);
		return songMeta;
	}

	override function update(p:Float)
	{
		if (FlxG.sound.music.volume < 0.7)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		super.update(p);

		if (controls.UP_P)
			changeSelection(-1);

		if (controls.DOWN_P)
			changeSelection(1);

		if (controls.BACK)
			FlxG.switchState(() -> new PlayMenuState());

		if (FlxG.keys.pressed.ENTER)
		{
			if (!Assets.exists(Paths.chart('${songs[curSelected].songName.toLowerCase()}/info'))
				&& Assets.exists(Paths.chart('${songs[curSelected].songName.toLowerCase()}/${songs[curSelected].songName.toLowerCase()}'))) // failsafe
				FlxG.sound.play(Paths.sound('cancelMenu'), 0.5);
			else
				switch (songs[curSelected].songName.toLowerCase())
				{
					case 'unknown' | 'no-song-found' | 'data-is-null':
						FlxG.sound.play(Paths.sound('cancelMenu'), 0.5);
					default:
						var poop:String = Highscore.formatSong(songs[curSelected].songName.toLowerCase());

						trace(poop);

						PlayState.SONG = Song.loadFromJson(poop, songs[curSelected].songName.toLowerCase());
						PlayState.xtraSong = true;

						PlayState.formoverride = 'none';

						if (songs[curSelected].songName.toLowerCase() == 'origin')
						{
							LoadingState.loadAndSwitchState(new PlayState());
						}
						else
						{
							LoadingState.loadAndSwitchState(new CharacterSelectState());
						}
				}
		}
	}

	function changeSelection(change:Int = 0)
	{
		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
		curSelected += change;

		if (curSelected < 0)
			curSelected = songs.length - 1;

		if (curSelected >= songs.length)
			curSelected = 0;

		if (!Assets.exists(Paths.chart('${songs[curSelected].songName.toLowerCase()}/info'))
			&& Assets.exists(Paths.chart('${songs[curSelected].songName.toLowerCase()}/${songs[curSelected].songName.toLowerCase()}')))
		{
			swagText.text = 'No info file exists but chart does!';
			swagText.visible = true;
		}
		else
			switch (songs[curSelected].songName.toLowerCase())
			{
				case 'data-is-null':
					swagText.text = "Song file doesn't exist!";
					swagText.visible = true;
				case 'unknown':
					swagText.text = 'A secret is required to unlock this song!';
					swagText.visible = true;
				default:
					swagText.visible = false;
			}
		var bullShit:Int = 0;

		for (i in 0...iconArray.length)
		{
			iconArray[i].alpha = 0.6;
		}

		iconArray[curSelected].alpha = 1;

		for (item in grpSongs.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;

			if (item.targetY == 0)
			{
				item.alpha = 1;
			}
		}
		FlxTween.color(bg, 0.25, bg.color, FlxColor.fromRGB(songs[curSelected].week[0], songs[curSelected].week[1], songs[curSelected].week[2]));
	}

	function getSongs() // thank john
	{
		if (Assets.exists(Paths.txt('songList'))) // check if songlist exists
		{
			trace(songList); // trace all songs in songlist
			for (i in 0...songList.length)
			{
				if (Assets.exists(Paths.chart('${songList[i]}/info'))) // check if the song exists
				{
					var jsonData:SongInfo = Paths.loadSongJson('${songList[i]}/info');
					var data:SongInfo = cast jsonData;
					trace(songList[i] + ' ' + data);

					for (songName in songList)
					{
						if (data.songName.toLowerCase() == songName)
						{
							if ((songName.toLowerCase() == 'dave-x-bambi-shipping-cute' && !FlxG.save.data.shipUnlocked)
								|| (songName.toLowerCase() == 'recovered-project' && !FlxG.save.data.foundRecoveredProject))
								addSong('unknown', [0, 0, 0], data.songIcon, true);
							else if (data.songName == songList[i])
								addSong(data.songName, data.bgColor, data.songIcon, false);
							else
								addSong(songList[i], data.bgColor, data.songIcon, false);
						}
					}
				}
				else if (Assets.exists(Paths.chart('${songList[i]}/${songList[i]}')))
				{
					trace(songList[i]);
					addSong(songList[i], [255, 255, 255], 'dave-3d', true); // incase only info is null
				}
				else
					addSong('data-is-null', [0, 0, 0], 'dave-3d', true); // incase entire song is null
			}
		}
		else
		{
			addSong('no-songs-found', [0, 0, 0], 'dave-3d', true); // incase songlist is null somehow
		}
	}
}

class SongMetadata
{
	public var songName:String = "";
	public var week:Array<Int> = [0, 0, 0];
	public var songCharacter:String = "";
	public var blackoutIcon:Bool = false;

	public function new(song:String, week:Array<Int>, songCharacter:String, blackoutIcon:Bool)
	{
		this.songName = song;
		this.week = week;
		this.songCharacter = songCharacter;
		this.blackoutIcon = blackoutIcon;
	}
}
