package;

import flixel.FlxG;

class Highscore
{
	#if (haxe >= "4.0.0")
	public static var songScores:Map<String, Int> = new Map();
	public static var songChars:Map<String, String> = new Map();
	#else
	public static var songScores:Map<String, Int> = new Map<String, Int>();
	public static var songChars:Map<String, String> = new Map<String, String>();
	#end

	public static function saveScore(song:String, score:Int = 0, ?char:String = "bf"):Void
	{
		var daSong:String = formatSong(song);
		trace("saveScore" + daSong);

		if (songScores.exists(daSong))
		{
			if (songScores.get(daSong) < score)
			{
				setScore(daSong, score, char);
			}
		}
		else
		{
			setScore(daSong, score, char);
		}
	}

	/**
	 * YOU SHOULD FORMAT SONG WITH formatSong() BEFORE TOSSING IN SONG VARIABLE
	 */
	public static function setScore(song:String, score:Int, char:String):Void
	{
		trace("setscore " + song);
		// Reminder that I don't need to format this song, it should come formatted!
		songScores.set(song, score);
		songChars.set(song, char);
		FlxG.save.data.songScores = songScores;
		FlxG.save.data.songNames = songChars;
		FlxG.save.flush();
	}

	static function setChar(song:String, char:String):Void
	{
		trace("setchar " + song + ":" + char);
		songChars.set(song, char);
		FlxG.save.data.songNames = songChars;
		FlxG.save.flush();
	}

	public static function formatSong(song:String):String
	{
		var daSong:String = song;

		return daSong;
	}

	public static function getScore(song:String, diff:Int):Int
	{
		if (!songScores.exists(formatSong(song)))
		{
			setScore(formatSong(song), 0, "bf");
		}
		return songScores.get(formatSong(song));
	}

	public static function load():Void
	{
		if (FlxG.save.data.songScores != null)
		{
			songScores = FlxG.save.data.songScores;
		}
		if (FlxG.save.data.songNames != null)
		{
			songChars = FlxG.save.data.songNames;
		}
	}
}
