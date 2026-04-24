import hxdiscord_rpc.Discord;
import hxdiscord_rpc.Types;

/**
 * Gapple:E Discord RPC crap.
 */
class DiscordRPC
{
	private static var appid:String = '1497030699633479750';

	private static var discordPresence:DiscordRichPresence = new DiscordRichPresence();

	static public function init():Void
	{
		final handlers:DiscordEventHandlers = new DiscordEventHandlers();
		handlers.ready = cpp.Function.fromStaticFunction(onReady);
		handlers.disconnected = cpp.Function.fromStaticFunction(onDisconnected);
		handlers.errored = cpp.Function.fromStaticFunction(onError);
		Discord.Initialize(appid, cpp.RawPointer.addressOf(handlers), true, null);
		changePresence();
	}

	static public function changePresence(details:String = 'In the Menus', state:String = ''):Void
	{
		discordPresence.state = state;
		discordPresence.details = details;
		discordPresence.largeImageKey = "logo";
		discordPresence.smallImageKey = "icon64";
		Discord.UpdatePresence(cpp.RawConstPointer.addressOf(discordPresence));
	}

	static function onReady(request:cpp.RawConstPointer<DiscordUser>):Void
	{
		final username:String = request[0].username;
		final globalName:String = request[0].username;
		final discriminator:Int = Std.parseInt(request[0].discriminator);

		if (discriminator != 0)
			trace('Discord: Connected to user ${username}#${discriminator} ($globalName)');
		else
			trace('Discord: Connected to user @${username} ($globalName)');
	}

	private static function onDisconnected(errorCode:Int, message:cpp.ConstCharStar):Void
	{
		trace('Discord: Disconnected ($errorCode:$message)');
	}

	private static function onError(errorCode:Int, message:cpp.ConstCharStar):Void
	{
		trace('Discord: Error ($errorCode:$message)');
	}
}
