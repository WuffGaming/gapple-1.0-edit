package;

import Controls.KeyboardScheme;
import flixel.FlxG;
import openfl.display.FPS;
import openfl.Lib;

class Option extends MusicBeatSubstate
{
	public function new()
	{
		super();
		display = updateDisplay();
	}

	private var display:String;

	public final function getDisplay():String
	{
		return display;
	}

	// Returns whether the label is to be updated.
	public function pressEnter():Bool
	{
		return false;
	}

	public function pressLeft():Bool
	{
		return false;
	}

	public function pressRight():Bool
	{
		return false;
	}

	private function updateDisplay():String
	{
		return throw "stub!";
	}
}

class ControlOption extends Option
{
	public function new(controls:Controls)
	{
		super();
	}

	public override function pressEnter():Bool
	{
		FlxG.save.data.dfjk = !FlxG.save.data.dfjk;

		controls.setKeyboardScheme(KeyboardScheme.Solo, true);

		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return FlxG.save.data.dfjk ? "DFJK" : "WASD";
	}
}

class OffsetOption extends Option
{
	public override function pressLeft():Bool
	{
		FlxG.save.data.offset--;
		display = updateDisplay();
		return true;
	}

	public override function pressRight():Bool
	{
		FlxG.save.data.offset++;
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return "Offset: " + FlxG.save.data.offset;
	}
}

class NewInputOption extends Option
{
	public override function pressEnter():Bool
	{
		FlxG.save.data.newInput = !FlxG.save.data.newInput;
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return FlxG.save.data.newInput ? "Ghost Tapping" : "Base Tapping";
	}
}

class DownscrollOption extends Option
{
	public override function pressEnter():Bool
	{
		FlxG.save.data.downscroll = !FlxG.save.data.downscroll;
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return FlxG.save.data.downscroll ? "Downscroll" : "Upscroll";
	}
}

class AccuracyOption extends Option
{
	public override function pressEnter():Bool
	{
		FlxG.save.data.accuracyDisplay = !FlxG.save.data.accuracyDisplay;
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return "Accuracy " + (!FlxG.save.data.accuracyDisplay ? "off" : "on");
	}
}

class FPSOption extends Option
{
	public override function pressEnter():Bool
	{
		FlxG.save.data.fps = !FlxG.save.data.fps;
		(cast(Lib.current.getChildAt(0), Main)).toggleFPS(FlxG.save.data.fps);
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return "FPS Counter " + (!FlxG.save.data.fps ? "off" : "on");
	}
}

class MiddlescrollOption extends Option
{
	public override function pressEnter():Bool
	{
		FlxG.save.data.middlescroll = !FlxG.save.data.middlescroll;
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return "Middlescroll " + (!FlxG.save.data.middlescroll ? "off" : "on");
	}
}

class RatingOption extends Option
{
	public override function pressEnter():Bool
	{
		FlxG.save.data.ratingsOnCamera = !FlxG.save.data.ratingsOnCamera;
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return "Cam Ratings " + (!FlxG.save.data.ratingsOnCamera ? "off" : "on");
	}
}

class CutsceneOption extends Option
{
	public override function pressEnter():Bool
	{
		FlxG.save.data.freeplayCuts = !FlxG.save.data.freeplayCuts;
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return "Cutscenes " + (!FlxG.save.data.freeplayCuts ? "off" : "on");
	}
}

class EyesoresOption extends Option
{
	public override function pressEnter():Bool
	{
		FlxG.save.data.eyesores = !FlxG.save.data.eyesores;
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return "Eyesores " + (!FlxG.save.data.eyesores ? "false" : "true");
	}
}

class HitsoundOption extends Option
{
	public override function pressEnter():Bool
	{
		FlxG.save.data.donoteclick = !FlxG.save.data.donoteclick;
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return "Hitsounds " + (!FlxG.save.data.donoteclick ? "off" : "on");
	}
}

class InstantRespawn extends Option
{
	public override function pressEnter():Bool
	{
		FlxG.save.data.InstantRespawn = !FlxG.save.data.InstantRespawn;
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return "Instant Respawn " + (!FlxG.save.data.InstantRespawn ? "off" : "on");
	}
}
