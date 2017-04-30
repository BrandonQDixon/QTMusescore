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
			columns: 1
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
			
			ComboBox {
				id: upDown
				
				model: ListModel {
					id: upDownList
					
					ListElement { text: "Up"; }
					ListElement { text: "Down"; }
				}
			}
			
			Button {
				text: "Submit"
				onClicked: transposeSelected();
			}
		}
	
	}
	
	
	
	//when the plugin is first run
	onRun: {
	
		console.log("Quarter Tone Transpostion plugin now running.")
	
	}
	
	
	function transposeSelected() {
		
	
		//change the following when up/down is implemented (for negative value)
		var noteOffset = Math.floor((intervalBox.currentIndex+1)/4);
		var quarterOffset = (intervalBox.currentIndex+1)%4;
		
		if (upDownList.currentIndex == 1) {
			noteOffset *= -1;
			quarterOffset *= -1;
		}
		
		console.log("Transposition process started - offset = "+noteOffset +", quarter o = "+quarterOffset);
	
	
		//vars used to scan through notess
		var fullScore;
		var startStaff;
		var endStaff;
		var endTick;
		var measure;
		
		//first, get the current score
		var cScore = curScore;
		var myCursor = cScore.newCursor();
		cScore.startCmd();
		
		console.log("Got score");
		
		//rewind to the begininng of the selection
		myCursor.rewind(1);
		
		if (!myCursor.segment) { //if the user has made no selection
			fullScore = true;
			startStaff = 0;
			endStaff = cScore.nstaves - 1; //end with last
		} else { //if there is a selection
			fullScore = false;
			startStaff = myCursor.staffIdx;
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
		for (var cStaff = startStaff; cStaff <= endStaff; cStaff++) {
			
			//iterate through voices
			for (var cVoice = 0; cVoice < 4; cVoice++) {
				
				myCursor.rewind(1); //beginning of selection
				myCursor.voice = cVoice; //set the selections voice to the current one
				myCursor.staffIdx = cStaff;
				
				console.log("Current Voice: "+cVoice)
				
				if (fullScore) {
					myCursor.rewind(0);
				}
				
				console.log("Current voice: "+cVoice);
				
				//iterate through elements
				while (myCursor.segment && (fullScore || myCursor.tick < endTick)) {
					console.log("Moving through");
					
					//if the current element is a note (or chord, technically)
					if (myCursor.element && myCursor.element.type == Element.CHORD) {
						console.log("Got some notes");
						var notes = myCursor.element.notes;
						
						//iterate through notes
						for (var i=0; i<notes.length; i++) {
							var note = notes[i];
							
							adjustNote(note,noteOffset,quarterOffset);
						}

					}
					
					myCursor.next();
				}
			}
			
		}
		cScore.endCmd();
		console.log("Done");
		cScore.doLayout();
		Qt.quit();
		
	}
	
	function adjustNote(note,noteOffset,quarterOffset) {
		console.log("Adjusting note");
	
		//adjust the note
		note.pitch += noteOffset*2; //because noteOffset is measured in whole steps;
		note.tuning = 0; //temporary measure, may or may not be needed
		if (note.accidentalType == Accidental.NONE || note.accidentalType == Accidental.NATURAL) {
			note.tuning = quarterOffset * 50; //this is dealing in cents now
		} else if (note.accidentalType == Accidental.MIRRORED_FLAT2) { //sesquiflat
			handleSesquiflatAccidental(note,noteOffset,quarterOffset);
		} else if (note.accidentalType == Accidental.MIRRORED_FLAT) { //semiflat
			handleSemiflatAccidental(note,noteOffset,quarterOffset);
		} else if (note.accidentalType == Accidental.SHARP_SLASH) {
			handleSemisharpAccidental(note,noteOffset,quarterOffset);
		} else if (note.accidentalType == Accidental.SHARP_SLASH4) {
			handleSesquisharpAccidental(note,noteOffset,quarterOffset);
		}
		
		//at the end, assign accidental based on tuning, and adjust accidentals if needed (so there is no sharp+semisharp)
		adjustNoteAccidentals(note);
	
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
			note.pitch -= 1;
			note.tuning = -50;
		} else if (quarterOffset == -1) {	//semiflat + semiflat = flat
			note.pitch -= 1;
			note.tuning = 0;
		} else if (quarterOffset == 1) {	//semiflat + semisharp == 0
			note.tuning = 0;
		} else if (quarterOffset == 2) {	//semiflat + sharp = semisharp
			note.tuning = 50;
		} else if (quarterOffset == 3) {	//semiflat + sesquisharp == sharp note
			note.pitch += 1;
			note.tuning = 0;
		}
	}
	
	function handleSemisharpAccidental(note,noteOffset,quarterOffset) {
		if (quarterOffset == -3) {	//semisharp + sesquiflat = flat
			note.pitch -= 1;
			note.tuning = 0;
		} else if (quarterOffset == -2) {	//semisharp + flat = semiflat
			note.tuning = -50;
		} else if (quarterOffset == -1) {	//semiflat + semisharp = nothing
			note.tuning = 0;
		} else if (quarterOffset == 1) {	//semisharp + semisharp == sharp
			note.pitch += 1;
			note.tuning = 0;
		} else if (quarterOffset == 2) {	//semisharp + sharp == sesquisharp
			note.pitch += 1;
			note.tuning = 50;
		} else if (quarterOffset == 3) {	//semisharp + sesquisharp == next whole note above
			note.pitch += 2;
			note.tuning = 0;
		}
	}
	
	function handleSesquisharpAccidental(note,noteOffset,quarterOffset) {
		if (quarterOffset == -3) {	//sesquiflat + sesquisharp == nothing
			note.tuning = 0;
		} else if (quarterOffset == -2) {	//flat + sesquisharp == semisharp
			note.tuning = 50;
		} else if (quarterOffset == -1) {	//semiflat + sesquisharp == sharp
			note.pitch += 1;
			note.tuning = 0;
		} else if (quarterOffset == 1) {	//semisharp + sesquisharp == next whole 
			note.pitch += 2;
			note.tuning = 0;
		} else if (quarterOffset == 2) {	//sharp + semisharp == next whole + semi
			note.pitch += 2;
			note.tuning = 50;
		} else if (quarterOffset == 3) {	//sesquisharp + sesquisharp = next whole+  sharp
			note.pitch += 3;
			note.tuning = 0;
		}
	}
	
	function adjustNoteAccidentals(note) {
		//check whether the new note has any sort of accidental at all
		var relPitch = note.pitch%12;
		if (!(relPitch == 0 || relPitch == 2 || relPitch == 4 || relPitch == 5 || relPitch == 7 || relPitch == 9 || relPitch == 11)) {
			if (note.tuning == -150) { //sesquiflat against mid note
				note.pitch -= 1;
				note.tuning = -50;
			} else if (note.tuning == -50) {
				note.pitch += 1;
				note.tuning = -150;
			} else if (note.tuning == 50) {
				note.pitch -= 1;
				note.tuning = 150;
			} else if (note.tuning == 150) {
				note.pitch += 1;
				note.tuning = 50;
			} else {
				note.accidentalType = Accidental.SHARP;
			}
		}
		
		//at this point, all notes with quarter tone accidentals have their pitches set to notes with no accidentals
		//assign the appropriate accidental
		if (note.tuning == -150) {	//sesquiflat
			note.accidentalType = Accidental.MIRRORED_FLAT2;
		} else if (note.tuning == -50) {
			note.accidentalType = Accidental.MIRRORED_FLAT; 
		} else if (note.tuning == 50) {
			note.accidentalType = Accidental.SHARP_SLASH;
		} else if (note.tuning == 150) {
			note.accidentalType = Accidental.SHARP_SLASH4;
		}
		
		var tPitch = note.pitch%12;
		if (tPitch == 0) {	//C
			note.tpc1 = 14;
		} else if (tPitch == 1) {	//C#
			if (note.accidentalType == Accidental.SHARP) {
				note.tpc1 = 21;
			} else {
				note.tpc1 = 9;
			}
		} else if (tPitch == 2) {	//D
			note.tpc1 = 16;
		} else if (tPitch == 3) {	//D#
			if (note.accidentalType == Accidental.SHARP) {
				note.tpc1 = 23;
			} else {
				note.tpc1 = 11;
			}
		} else if (tPitch == 4)	{	//E
			note.tpc1 = 18;
		} else if (tPitch == 5) {	//F
			note.tpc1 = 13;
		} else if (tPitch == 6) {	//F#
			if (note.accidentalType == Accidental.SHARP) {
				note.tpc1 = 20;
			} else {
				note.tpc1 = 8;
			}
		} else if (tPitch == 7) {	//G
			note.tpc1 = 15;
		} else if (tPitch == 8) {	//G#
			if (note.accidentalType == Accidental.SHARP) {
				note.tpc1 = 22;
			} else {
				note.tpc1 = 10;
			}
		} else if (tPitch == 9) {	//A
			note.tpc1 = 17;
		} else if (tPitch == 10) {	//A#
			if (note.accidentalType == Accidental.SHARP) {
				note.tpc1 = 24;
			} else {
				note.tpc1 = 12;
			}
		} else if (tPitch == 11) {	//B
			note.tpc1 = 19;
		} else {
			console.log("Strange TPC error");
		}
	}
	
}