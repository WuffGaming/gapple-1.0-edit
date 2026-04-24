package;

import flixel.FlxSprite;

/*
 * Adds a name variable to a prop so it can be modified in post. That's it.
 * @param name
 */
class BGSprite extends FlxSprite
{
	public var name:String;

	public function new(x:Float, y:Float, name:String)
	{
		super(x, y);

		this.name = name;
	}
}
