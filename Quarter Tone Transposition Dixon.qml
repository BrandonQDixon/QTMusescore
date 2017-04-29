//=============================================================================
//  This plugin will enable the user to adjust the pitches of all quarter
//  - tone accidentals at once
//=============================================================================
import QtQuick 2.2
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.3
import QtQuick.Layouts 1.1

import MuseScore 1.0
MuseScore {

	version: "2.0"
	description: qsTr("This plugin adjusts the pitches of all of the standard quarter tone accidentals")
	menuPath: "Plugins.Quarter Tone Plugins." +qsTr("Transpose")
	
	
	//interface values
	pluginType: "dock"
	dockArea:   "left"
	
	width: 150
	height: 75
	
	//user interface:
	Rectangle {
	
		color: "grey"
		anchors.fill: parent
		
		GridLayout {
			columns: 2
			anchors.fill: parent
			anchors.margins: 10
		
			Label {
				text: qsTr("Select the interval you would like to transpose the selected music by:")
			}
			
			ComboBox {
				id: intervalBox
				
				model: ListModel {
					id: intervalBoxList
					
					ListElement { text: "1: Semiflat Minor Second"; } 
					ListElement { text: "2: Minor Second"; }
					ListElement { text: "3: Semisharp Minor Second"; }
					ListElement { text: "4: Major Second"; }
					ListElement { text: "5: Semisharp Major Second"; }
					ListElement { text: "6: Minor Third"; } 
					ListElement { text: "7: Neutral Third"; }
					ListElement { text: "8: Major Third"; }
					ListElement { text: "9: Semisharp Major Third"; }
					ListElement { text: "10: Perfect Fourth"; }
					ListElement { text: "11: Semisharp Perfect Fourth"; }
					ListElement { text: "12: Augmented Fourth"; }
					ListElement { text: "13: Sesquisharp Perfect Fourth"; }
					ListElement { text: "14: Perfect Fifth"; }
					ListElement { text: "15: Semisharp Perfect Fifth"; }
					ListElement { text: "16: Minor Sixth"; }
					ListElement { text: "17: Semisharp Minor Sixth"; }
					ListElement { text: "18: Major Sixth"; }
					ListElement { text: "19: Semisharp Major Sixth"; }
					ListElement { text: "20: Minor Seventh"; }
					ListElement { text: "21: Semisharp Minor Seventh"; }
					ListElement { text: "22: Major Seventh"; }
					ListElement { text: "23: Semisharp Major Seventh"; }
					ListElement { text: "24: Octave"; }
				}
			}
		}
	
	}
	
	
	
	//when the plugin is first run
	onRun: {
	
		console.log("Quarter Tone Transpostiion plugin now running.")
	
	}
	
	
	function transposeSelected() {
		//vars used to scan through notes
		var fullScore;
		var startStaff;
		var endStaff;
		var endTick;
		var measure;
		
		//first, get the current score
		var cScore = curScore;
		var myCursor = cScore.newCursor();
		
		//rewind to the begininng of hte selection
		myCursor.rewind(1);
		
		if (!myCursor.segment) { //if the user has made no selection
			fullScore = true;
			startStaff = 0;
			endStacc = cScore.nstaves - 1; //end with last
		} else { //if there is a selection
			fullScore = false;
			startStaff = myCrusor.staffIdx;
			myCursor.rewind(2);
			
			if (myCursor.tick == 0) { //if the selection includes the last measure of the score
				endTick = cScore.lastSegment.tick + 1;
			} else {
				endTick = myCursor.tic;
			}
			endStaff = myCursor.staffIdx;
		}
		
		console.log(startStaff +" : "+endStaff +" : "+ endTick)
		
		//iterate through staves
		while (myCursor.segment && (fullScore || myCursor.tick < endTick)) {
			
			//if the current element is a note (or chord, technically)
			if (myCursor.element && myCursor.element.type == Element.CHORD) {
				var notes = myCursor.element.notes;
				
				//iterate through notes
				for (var i=0; i<notes.length; i++) {
					var note = notes[i];
					
					
				}
			
			}
			
		}
	}
	
	
	
}