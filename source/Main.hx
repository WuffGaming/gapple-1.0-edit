	package; // hey btw the entire class is a bit to the right.

	import flixel.FlxG;
	import flixel.FlxGame;
	import flixel.FlxState;
	import openfl.Assets;
	import openfl.filters.GlowFilter;
	import openfl.Lib;
	import openfl.display.FPS;
	import openfl.text.TextFormat;
	import openfl.display.Sprite;
	import openfl.events.Event;

	class Main extends Sprite
	{
		public static final game = {
		width: 1280, // WINDOW width
		height: 720, // WINDOW height
		initialState: TitleState, // initial game state
		framerate: 144, // default framerate
		skipSplash: true, // if the default flixel splash screen should be skipped
		startFullscreen: false // if the game should start at fullscreen mode
		};

		// You can pretty much ignore everything from here on - your code should go in your states.

		public static function main():Void
		{
			Lib.current.addChild(new Main());
		}

		public function new()
		{
			super();

			if (stage != null)
			{
				init();
			}
			else
			{
				addEventListener(Event.ADDED_TO_STAGE, init);
			}
		}

		private function init(?E:Event):Void
		{
			if (hasEventListener(Event.ADDED_TO_STAGE))
			{
				removeEventListener(Event.ADDED_TO_STAGE, init);
			}

			setupGame();
		}

		private function setupGame():Void
		{

			#if !debug
			game.initialState = TitleState;
			#end

			Paths.getModFolders();
			addChild(new FlxGame(game.width, game.height, game.initialState, game.framerate, game.framerate, game.skipSplash, game.startFullscreen));

			var ourSource:String = "assets/videos/DO NOT DELETE OR GAME WILL CRASH/dontDelete.webm";

		#if web
		var str1:String = "HTML CRAP";
		var vHandler = new VideoHandler();
		vHandler.init1();
		vHandler.video.name = str1;
		addChild(vHandler.video);
		vHandler.init2();
		GlobalVideo.setVid(vHandler);
		vHandler.source(ourSource);
		#elseif desktop
		var str1:String = "WEBM SHIT"; 
		var webmHandle = new WebmHandler();
		webmHandle.source(ourSource);
		webmHandle.makePlayer();
		webmHandle.webm.name = str1;
		addChild(webmHandle.webm);
		GlobalVideo.setWebm(webmHandle);
		#end

		#if !mobile
		fpsCounter = new FPS(10, 3, 0xFFFFFF);
		fpsCounter.defaultTextFormat = new TextFormat("Comic Sans MS Bold", 12, 0xFFFFFF, true);
		fpsCounter.filters = [new GlowFilter(0x000000, 0.5, 2, 2, 2, 1)]; // makes it stand out
		addChild(fpsCounter);
		toggleFPS(FlxG.save.data.fps);
		#end
	}

	var fpsCounter:FPS;

	public function toggleFPS(fpsEnabled:Bool):Void {
		fpsCounter.visible = fpsEnabled;
		}
	}
