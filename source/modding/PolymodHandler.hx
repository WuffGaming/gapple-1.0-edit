package modding;

import polymod.fs.ZipFileSystem;
import polymod.backends.PolymodAssets.PolymodAssetType;
import polymod.format.ParseRules.TextFileFormat;
import polymod.Polymod;
import modding.PolymodErrorHandler;

/**
 * A class for interacting with Polymod, the atomic modding framework for Haxe.
 * This is practically all skidded from FunkinCrew https://github.com/FunkinCrew/Funkin/blob/main/source/funkin/modding/PolymodHandler.hx with minor changes.
 */
class PolymodHandler
{
  /**
   * The API version that mods should comply with.
   * Format this with Semantic Versioning; <MAJOR>.<MINOR>.<PATCH>.
   * Bug fixes increment the patch version, new features increment the minor version.
   * Changes that break old mods increment the major version.
   */
  static final API_VERSION:String = '1.0.0';

  /**
   * Where relative to the executable that mods are located.
   */
  static final MOD_FOLDER:String = 'mods';

  static final CORE_FOLDER:Null<String> = null;

  public static var loadedModIds:Array<String> = [];

  // Use SysZipFileSystem on desktop and MemoryZipFilesystem on web.
  static var modFileSystem:Null<ZipFileSystem> = null;

  public static function doesFileExist(path:String):Bool
  {
    #if sys
    return sys.FileSystem.exists(path);
    #else
    return false;
    #end
  }

  /**
   * Create a directory if it doesn't already exist.
   * Only works on desktop.
   *
   * @param dir The path to the directory.
   */
  public static function createDirIfNotExists(dir:String):Void
  {
    #if sys
    if (!doesFileExist(dir))
    {
      sys.FileSystem.createDirectory(dir);
    }
    #end
  }

  /**
   * If the mods folder doesn't exist, create it.
   */
  public static function createModRoot():Void
  {
    createDirIfNotExists(MOD_FOLDER);
  }

  /**
   * Loads the game with ALL mods enabled with Polymod.
   */
  public static function loadMods():Void
  {
    // Create the mod root if it doesn't exist.
    createModRoot();
    trace('Initializing Polymod (using all mods)...');
    loadModsById(getAllModIds());
  }

  /**
   * Load all the mods with the given ids.
   * @param ids The ORDERED list of mod ids to load.
   */
  public static function loadModsById(ids:Array<String>):Void
  {
    if (ids.length == 0)
    {
      trace('You attempted to load zero mods.');
    }
    else
    {
      trace('Attempting to load ${ids.length} mods...');
    }

    buildImports();

    if (modFileSystem == null) modFileSystem = buildFileSystem();

    var loadedModList:Array<ModMetadata> = polymod.Polymod.init(
      {
        // Root directory for all mods.
        modRoot: MOD_FOLDER,
        // The directories for one or more mods to load.
        dirs: ids,
        // Framework being used to load assets.
        framework: OPENFL,
        // The current version of our API.
        apiVersionRule: API_VERSION,
        // Call this function any time an error occurs.
        errorCallback: PolymodErrorHandler.onPolymodError,
        // Enforce semantic version patterns for each mod.
        // modVersions: null,
        // A map telling Polymod what the asset type is for unfamiliar file extensions.
        // extensionMap: [],

        customFilesystem: modFileSystem,

        frameworkParams: buildFrameworkParams(),

        // List of filenames to ignore in mods. Use the default list to ignore the metadata file, etc.
        ignoredFiles: buildIgnoreList(),

        // Parsing rules for various data formats.
        parseRules: buildParseRules(),

        // Parse hxc files and register the scripted classes in them.
        useScriptedClasses: false,
        loadScriptsAsync: #if html5 true #else false #end,
      });

    if (loadedModList == null)
    {
      trace('An error occurred! Failed when loading mods!');
    }
    else
    {
      if (loadedModList.length == 0)
      {
        trace('Mod loading complete. We loaded no mods / ${ids.length} mods.');
      }
      else
      {
        trace('Mod loading complete. We loaded ${loadedModList.length} / ${ids.length} mods.');
      }
    }

    loadedModIds = [];
    for (mod in loadedModList)
    {
      trace('  * ${mod.title} v${mod.modVersion} [${mod.id}]');
      loadedModIds.push(mod.id);
    }

    #if debug
    var fileList:Array<String> = Polymod.listModFiles(PolymodAssetType.IMAGE);
    trace('Installed mods have replaced ${fileList.length} images.');
    for (item in fileList)
    {
      trace('  * $item');
    }

    fileList = Polymod.listModFiles(PolymodAssetType.TEXT);
    trace('Installed mods have added/replaced ${fileList.length} text files.');
    for (item in fileList)
    {
      trace('  * $item');
    }

    fileList = Polymod.listModFiles(PolymodAssetType.AUDIO_MUSIC);
    trace('Installed mods have replaced ${fileList.length} music files.');
    for (item in fileList)
    {
      trace('  * $item');
    }

    fileList = Polymod.listModFiles(PolymodAssetType.AUDIO_SOUND);
    trace('Installed mods have replaced ${fileList.length} sound files.');
    for (item in fileList)
    {
      trace('  * $item');
    }

    fileList = Polymod.listModFiles(PolymodAssetType.AUDIO_GENERIC);
    trace('Installed mods have replaced ${fileList.length} generic audio files.');
    for (item in fileList)
    {
      trace('  * $item');
    }
    #end
  }

  static function buildFileSystem():polymod.fs.ZipFileSystem
  {
    polymod.Polymod.onError = PolymodErrorHandler.onPolymodError;
    return new ZipFileSystem({
      modRoot: MOD_FOLDER,
      autoScan: true
    });
  }

  static function buildParseRules():polymod.format.ParseRules
  {
    var output:polymod.format.ParseRules = polymod.format.ParseRules.getDefault();
    // Ensure TXT files have merge support.
    output.addType('txt', TextFileFormat.LINES);

    // You can specify the format of a specific file, with file extension.
    // output.addFile("data/introText.txt", TextFileFormat.LINES)
    return output;
  }

static function buildImports():Void
  {
    // Add default imports for common classes.
    static final DEFAULT_IMPORTS:Array<Class<Dynamic>> = [Paths, flixel.FlxG];

    for (cls in DEFAULT_IMPORTS)
    {
      Polymod.addDefaultImport(cls);
    }
  }

  /**
   * Build a list of file paths that will be ignored in mods.
   */
  static function buildIgnoreList():Array<String>
  {
    var result = Polymod.getDefaultIgnoreList();

    result.push('.vscode');
    result.push('.idea');
    result.push('.git');
    result.push('.gitignore');
    result.push('.gitattributes');
    result.push('README.md');

    return result;
  }

  static inline function buildFrameworkParams():polymod.Polymod.FrameworkParams
  {
    return {
      assetLibraryPaths: [
        'default' => 'preload', 'shared' => 'shared', 'songs' => 'songs', 'videos' => 'videos',
      ],
      coreAssetRedirect: CORE_FOLDER,
    }
  }

  /**
   * Retrieve a list of metadata for ALL installed mods, including disabled mods.
   * @return An array of mod metadata
   */
  public static function getAllMods():Array<ModMetadata>
  {
    trace('Scanning the mods folder...');

    if (modFileSystem == null) modFileSystem = buildFileSystem();

    var modMetadata:Array<ModMetadata> = Polymod.scan(
      {
        modRoot: MOD_FOLDER,
        apiVersionRule: API_VERSION,
        fileSystem: modFileSystem,
        errorCallback: PolymodErrorHandler.onPolymodError
      });
    trace('Found ${modMetadata.length} mods when scanning.');
    return modMetadata;
  }

  /**
   * Retrieve a list of ALL mod IDs, including disabled mods.
   * @return An array of mod IDs
   */
  public static function getAllModIds():Array<String>
  {
    var modIds:Array<String> = [for (i in getAllMods()) i.id];
    return modIds;
  }

  /**
   * Clear and reload from disk all data assets.
   * Useful for "hot reloading" for fast iteration!
   */
  public static function forceReloadAssets():Void
  {
    Polymod.clearScripts();
    modding.PolymodHandler.loadMods();
    Polymod.registerAllScriptClasses();
  }
}
