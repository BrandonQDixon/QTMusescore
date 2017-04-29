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
		//change the following when up/down is implemented (for negative value)
		var noteOffset = intervalBoxList.currentIndex/4;
		var quarterOffset = intervalBoxList.currentIndex%4;
	
	
		//vars used to scan through notess
		var fullScore;
		var startStaff;
		var endStaff;
		var endTick;
		var measure;
		
		//first, get the current score
		var cScore = curScore;
		var myCursor = cScore.newCursor();
		
		//rewind to the begininng of the selection
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
	
	function adjustNote(note,noteOffset,quarterOffset) {
		note.pitch += noteOffset*2; //because noteOffset is measured in whole steps;
		if (note.accidentalType == Accidental.NONE || note.accidentalType == Accidental.NATURAL) {
			note.tuning = quarterOffset * 50; //this is dealing in cents now
		} else if (note.accidentalType == Accidental.MIRRORED_FLAT2) { //sesquiflat
			handleSesquiflatAccidental(note,noteOffset,quarterOffset);
		} else if (note.accidentalType == Accidental.MIRRORED_FLAT) { //semiflat
			handleSemiflatAccidental(note,noteOffset,quarterOffset);
		}
		
		//at the end, assign accidental based on tuning, and adjust accidentals if needed (so there is no sharp+semisharp)
	
	}
	
	function handleSesquiflatAccidental(note,noteOffset,quarterOffset) {
		if (quarterOffset == -3) { //if we have equivalent of sesquiflat + sesquiflat, really is flat of next note down
			note.pitch -= 3;
			note.tuning = 0;
		} else if (quarterOffset == -2) { //sesquiflat + flat = semiflat of next whole note down
			note.pitch -= 2;
			note.tuning = -50;
		} else if (quarterOffset == -1) { //sesquiflat + semiflat = natural of next note down
			note.pitch -= 2;
			note.tuning = 0;
		} else if (quarterOffset == 1) { //sesquiflat + semisharp = flat of this note
			note.pitch -= 1;
			note.tuning = 0;
		} else if (quarterOffset == 2) { //sesquiflat + sharp = semiflat of this note
			note.tuning = -50;
		} else if (quarterOffset == 3) { //sesquiflat + sesquisharp = this note
			note.tuning = 0;
		}
	}
	
	function handleSemiflatAccidental(note,noteOffset,quarterOffset) {
		if (quarterOffset == -3) { //semiflat + sesquiflat = natural next whole note down
			note.pitch -= 2;
			note.tuning = 0;
		} else if (quarterOffset == -2) {	//semiflat + flat = sesquiflat
			note.pitch -=
		}
	}
	
}