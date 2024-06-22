package backend;

class AssetManager {
	public static function reloadSourceAssets(onComplete:Void->Void) {
		var gameAssets = 'assets';
		var sourceAssets = '../../../../assets'; // this is stupid but fuck it we ball

		trace('[FILE RELOAD STARTING]');

		if (!FileSystem.exists(sourceAssets) && !FileSystem.exists(sourceAssets + '/source'))
			return;

		var fullSource = FileSystem.fullPath(sourceAssets);
		var fullGame = FileSystem.fullPath(gameAssets);

		copyFolder(fullSource, fullGame);

		trace('[FILE RELOAD COMPLETE]');

		onComplete();
	}

	public static function copyFolder(source:String, dest:String) {
		var SRCentries = FileSystem.readDirectory(source);
		var gameEntries = FileSystem.readDirectory(dest);

		// handle source files

		for (entry in SRCentries) {
			var sourceEntry = source + '/$entry';
			var destEntry = dest + '/$entry';

			if (FileSystem.isDirectory(sourceEntry) && !FileSystem.exists(destEntry)) {
				trace('[FOLDER CREATE] | $destEntry');
				FileSystem.createDirectory(destEntry);
			}

			if (FileSystem.isDirectory(sourceEntry)) {
				copyFolder(sourceEntry, destEntry);
			} else {
				copyFile(sourceEntry, destEntry);
			}
		}

		// handle game files that aren't used anymore!

		for (entry in gameEntries) {
			var sourceEntry = source + '/$entry';
			var destEntry = dest + '/$entry';

			if (!FileSystem.exists(sourceEntry)) {
				if (FileSystem.isDirectory(destEntry)) {
					deleteFolder(destEntry);
				} else {
					trace('[FILE DELETE]: $destEntry');

					FileSystem.deleteFile(destEntry);
				}
			}
		}
	}

	public static function copyFile(source, dest) {
		var input = File.read(source, true);
		var bytes = input.readAll();

		if (!FileSystem.exists(dest)) {
			trace('[FILE CREATE] | $dest');

			var emptFile = File.write(dest, true);
			emptFile.close();
		}

		var output = File.write(dest, true);
		output.writeFullBytes(bytes, 0, bytes.length);

		input.close();
		output.close();
	}

	public static function deleteFolder(folder) {
		var entries = FileSystem.readDirectory(folder);

		trace('[FOLDER DELETE] | $folder');

		for (entry in entries) {
			var entryPath = folder + '/$entry';
			if (FileSystem.isDirectory(entryPath)) {
				deleteFolder(entryPath);
			} else {
				trace('[FILE DELETE] | $entryPath');

				FileSystem.deleteFile(entryPath);
			}
		}
		FileSystem.deleteDirectory(folder);
	}
}
