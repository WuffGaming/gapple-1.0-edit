package;

import Controls.KeyboardScheme;
import flixel.FlxG;
import openfl.display.FPS;
import openfl.Lib;

class Option
{
	public function new()
	{
		display = updateDisplay();
	}

	private var display:String;
	public final function getDisplay():String
	{
		return display;
	}

	// Returns whether the label is to be updated.
	public function press():Bool { return throw "stub!"; }
	private function updateDisplay():String { return throw "stub!"; }
}

class DFJKOption extends Option
{
	private var controls:Controls;

	public function new(controls:Controls)
	{
		super();
		this.controls = controls;
	}

	public override function press():Bool
	{
		FlxG.save.data.dfjk = !FlxG.save.data.dfjk;
		
		if (FlxG.save.data.dfjk)
			controls.setKeyboardScheme(KeyboardScheme.Solo, true);
		else
			controls.setKeyboardScheme(KeyboardScheme.Duo(true), true);

		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return  FlxG.save.data.dfjk ? "DFJK" : "WASD";
	}
}

class NewInputOption extends Option
{
	public override function press():Bool
	{
		FlxG.save.data.newInput = !FlxG.save.data.newInput;
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return FlxG.save.data.newInput ? "New input" : "Old Input";
	}
}

class DownscrollOption extends Option
{
	public override function press():Bool
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
	public override function press():Bool
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
	public override function press():Bool
	{
		FlxG.save.data.fps = !FlxG.save.data.fps;
		(cast (Lib.current.getChildAt(0), Main)).toggleFPS(FlxG.save.data.fps);
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return "FPS Counter " + (!FlxG.save.data.fps ? "off" : "on");
	}
}

class CutsceneOption extends Option
{
	public override function press():Bool
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
	public override function press():Bool
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
	public override function press():Bool
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