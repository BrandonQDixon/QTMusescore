/**
 * Wrapper to handle basic filesystem access
 * @type {{dirs: {documents: *}, dirExists: FileManager.dirExists}}
 */
var FileManager = {
    //this is the user's document path
    dirs: {
        documents: app.getPath('documents'),
    },
    /**
     * Wrapper function to check if a directory exists
     * @param dir (string)
     * @returns {boolean}
     */
    dirExists: function(dir) {
        try {
            fs.accessSync(dir);
            return true;
        } catch (e) {
            return false;
        }
    },
    getUrl: function(url,callback) {
        let request = new XMLHttpRequest();
        request.open('Get',url);
        request.responseType = 'text';
        request.onload = function() {
            let contents = request.response;
            callback(contents);
        };
        request.send();
    }
};

/**
 * Class which holds data for MuseScore info
 * @type {{version: number, dirs: {musescore: string, plugins: string}}}
 */
var MuseScore = {
    //indicate the version of musescure this is intended for
    version: 2,
    //denote the important directories used by MuseScore (as indicated in its own documentation)
    dirs: {
        musescore: FileManager.dirs.documents + "/MuseScore" + version,
        plugins: MuseScore.dirs.musescore + "/Plugins",
    },
};

/**
 * Class which holds data for Repository info
 * @type {{plugins: {accidentals: {url: string}}}}
 */
var Repository = {
    plugins: {
        accidentals: {
            url: "https://raw.githubusercontent.com/BrandonQDixon/QTMusescore/master/Quarter%20Tone%20Accidentals%20Dixon.qml",
        }
    }
};