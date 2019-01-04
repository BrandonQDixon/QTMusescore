const moduleImports = require('electron').remote.getGlobal('moduleImports');
const app = moduleImports.app;
const fs = moduleImports.fs;

/**
 * This object will handle stage presentation
 * @type {{_currentStage: null, _tagName: string, _defaultDisplay: string, setStage: Stage.setStage}}
 */
var Stage = {
    _currentStage: null,
    _tagName: "stage",
    _defaultDisplay: "block",
    /**
     * Set the stage the window should show, and make all other stages hidden
     * @param id
     */
    setStage: function(id) {
        if (Stage._currentStage !== id) {
            let allStages = document.getElementsByTagName(Stage._tagName);
            for (let i = 0; i < allStages.length; i++) {
                allStages[i].style.display = "none";
            }

            let stage = document.getElementById(id);
            stage.style.display = Stage._defaultDisplay;
            Stage._currentStage = id;
        }
    },
    /**
     * Get the id of the default stage
     * @returns {*}
     */
    getDefaultStageId: function() {
        let def = null;
        let allStages = document.getElementsByTagName(Stage._tagName);
        for (let i = 0; i < allStages.length; i++) {
            if (allStages[i].dataset.default === "default") {
                def = allStages[i].id;
                break;
            }
        }

        return def;
    }
};

/**
 * Set the default stage, if it is specified, upon document load
 */
document.addEventListener("DOMContentLoaded", function() {
    let id = Stage.getDefaultStageId();
    if (id !== null) {
        Stage.setStage(id);
    }
});