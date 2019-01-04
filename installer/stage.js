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
            let tstage = allStages[i];
            if (tstage.dataset.default === "default") {
                def = tstage.id;
            }
            if (typeof tstage.dataset.align !== 'undefined') {
                tstage.style.textAlign = tstage.dataset.align;
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

    //make links open in browser
    let a = document.getElementsByTagName("a");
    for (let i=0; i<a.length; i++) {
        let ael = a[i];
        if (ael.target === "_browser") {
            ael.addEventListener('click',function(e) {
                e.preventDefault();
                let url = ael.href;
                require("electron").shell.openExternal(url);
            });
        }
    }

    //adjust content size
    window.addEventListener('resize',function(e) {
        let content = document.getElementsByTagName('content')[0];
        let banner =  document.getElementsByTagName('banner')[0];

        let bannerHeight = banner.getBoundingClientRect().height;
        let windowHeight = Math.max(document.documentElement.clientHeight, window.innerHeight || 0);

        let contentHeight = windowHeight - bannerHeight;
        content.style.height = contentHeight + "px";
    });

    window.dispatchEvent(new Event('resize'));
});