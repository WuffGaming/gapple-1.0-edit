package;

import flixel.graphics.FlxGraphic;
import flixel.FlxG;
import flixel.graphics.frames.FlxAtlasFrames;
import openfl.utils.AssetType;
import openfl.utils.Assets;
import openfl.display.BitmapData;
import haxe.Json;
import flash.media.Sound;
import flixel.graphics.FlxGraphic;
import openfl.display.BitmapData;
import haxe.io.Path;

@:nullSafety
class Paths
{
	inline public static var SOUND_EXT = #if web "mp3" #else "ogg" #end;

	static var currentLevel:Null<String> = null;

	public static function setCurrentLevel(name:Null<String>):Void
	{
		if (name == null)
		{
			currentLevel = null;
		}
		else
		{
			currentLevel = name.toLowerCase();
		}
	}

	public static function getLibrary(path:String):String
	{
		var parts:Array<String> = path.split(':');
		if (parts.length < 2)
			return 'preload';
		return parts[0];
	}

	static function getPath(file:String, type:AssetType, library:Null<String>):String
	{
		if (library != null)
			return getLibraryPath(file, library);

		if (currentLevel != null)
		{
			var levelPath:String = getLibraryPathForce(file, currentLevel);
			if (Assets.exists(levelPath, type))
				return levelPath;
		}

		var levelPath:String = getLibraryPathForce(file, 'shared');
		if (Assets.exists(levelPath, type))
			return levelPath;

		return getPreloadPath(file);
	}

	public static function getLibraryPath(file:String, library = 'preload'):String
	{
		return if (library == 'preload' || library == 'default') getPreloadPath(file); else getLibraryPathForce(file, library);
	}

	static inline function getLibraryPathForce(file:String, library:String):String
	{
		return '$library:assets/$library/$file';
	}

	inline static public function getPreloadPath(file:String)
	{
		return 'assets/$file';
	}

	static public function file(file:String, type:AssetType = TEXT, ?library:String)
	{
		return getPath(file, type, library);
	}

	static public function txt(key:String, ?library:String)
	{
		return getPath('data/$key.txt', TEXT, library);
	}

	static public function xml(key:String, ?library:String)
	{
		return getPath('data/$key.xml', TEXT, library);
	}

	static public function json(key:String, ?library:String)
	{
		return getPath('data/$key.json', TEXT, library);
	}

	static public function songInfojson(key:String, ?library:String)
	{
		return getPath('songs/$key/info.json', TEXT, library);
	}

	static public function loadJSON(key:String,
			?library:String):Dynamic // note: i think loading the json when we immediately find it MIGHT be causing so many crashes.. Maybe load the json when we know it exists?
	{
		var rawJson = Assets.getText(Paths.json(key, library)).trim();

		// Perform cleanup on files that have bad data at the end.
		while (!rawJson.endsWith("}"))
		{
			rawJson = rawJson.substr(0, rawJson.length - 1);
		}

		try
		{
			// Attempt to parse and return the JSON data.
			return Json.parse(rawJson);
		}
		catch (e)
		{
			trace("AN ERROR OCCURRED parsing a JSON file.");
			trace(e.message);

			// Return null.
			return null;
		}
	}

	static public function loadSongJson(song:String, ?library:String):Dynamic
	{
		var rawJson:String;
		rawJson = Assets.getText(Paths.chart(song)).trim();

		// Perform cleanup on files that have bad data at the end.
		while (!rawJson.endsWith("}"))
		{
			rawJson = rawJson.substr(0, rawJson.length - 1);
		}

		try
		{
			// Attempt to parse and return the JSON data.
			return Json.parse(rawJson);
		}
		catch (e)
		{
			trace("AN ERROR OCCURRED parsing a JSON file.");
			trace(e.message);

			// Return null.
			return null;
		}
	}

	static public function sound(key:String, ?library:String)
	{
		return getPath('sounds/$key.$SOUND_EXT', SOUND, library);
	}

	inline static public function soundRandom(key:String, min:Int, max:Int, ?library:String)
	{
		return sound(key + FlxG.random.int(min, max), library);
	}

	inline static public function music(key:String, ?library:String)
	{
		return getPath('music/$key.$SOUND_EXT', MUSIC, library);
	}

	inline static public function voices(song:String)
	{
		return 'songs:assets/songs/${song.toLowerCase()}/Voices.$SOUND_EXT';
	}

	inline static public function inst(song:String)
	{
		return 'songs:assets/songs/${song.toLowerCase()}/Inst.$SOUND_EXT';
	}

	inline static public function chart(song:String):Any
	{
		return 'songs:assets/songs/${song.toLowerCase()}.json';
	}

	inline static public function externmusic(song:String)
	{
		return 'songs:assets/songs/extern/${song.toLowerCase()}.$SOUND_EXT';
	}

	inline static public function image(key:String, ?library:String):Dynamic
	{
		return getPath('images/$key.png', IMAGE, library);
	}

	inline static public function font(key:String)
	{
		return 'assets/fonts/$key';
	}

	static public function offsetFile(character:String, ?library:String):String
	{
		if (character == null)
		{
			character = 'bf';
		} // this will be updated later
		return getPath('data/offsets/' + character + '.txt', TEXT, library); // library is useless here but idc
	}

	public static function getSparrowAtlas(key:String, ?library:String):FlxAtlasFrames
	{
		return FlxAtlasFrames.fromSparrow(image(key, library), file('images/$key.xml', library));
	}

	inline static public function getPackerAtlas(key:String, ?library:String)
	{
		return FlxAtlasFrames.fromSpriteSheetPacker(image(key, library), file('images/$key.txt', library));
	}
}
