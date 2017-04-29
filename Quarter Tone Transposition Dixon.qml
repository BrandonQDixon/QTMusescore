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
		var fullScore;
		var startStaff;
		var endStaff;
		var endTick;
		var measure;
		var prevA = []
		//var prevAInfo = []; //accidentals ind 0 is pitch, 1 is the current accidental.
		
		//first, get the current score
		var cScore = curScore;
		var myCursor = cScore.newCursor();
		
		//rewind to the beginning of the selection
		myCursor.rewind(1);
		
		if (!myCursor.segment) { //if the user has made no selection
			fullScore = true;
			startStaff = 0; //start with 1st one
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
				
				//iterate through elements
				while (myCursor.segment && (fullScore || myCursor.tick < endTick)) {
						
						if (myCursor.measure != measure) {
							measure = myCursor.measure;

							prevA = [];
						
						}
						
						if (myCursor.element && myCursor.element.type == Element.CHORD) {
							var notes = myCursor.element.notes;
							
							//iterate through notes
							for (var i=0; i<notes.length; i++) {
								var note = notes[i];
								
								//if the note has an accidental
								if (note.accidentalType != Accidental.NONE) {
									var isFound = false;
									console.log("Current Note has accidental");
									
									for (var j=0; j<prevA.length; j++) {
										var accidentalInfo = prevA[j];
										
											//if we are dealing with the same note, check to see if accidental exists
											if (accidentalInfo[0] == note.pitch) {
												if (accidentalInfo[1] == note.accidentalType) {
											
													adjustTuning(note,accidentalInfo[1]);
												} else { //if this is reached, this note has a new accidental here
													console.log("Accidental change");
													accidentalInfo[1] = note.accidentalType;
													adjustTuning(note,accidentalInfo[1]);
													
												}
													
												isFound = true;
											}
									}
									
									if (!isFound) { //if this is the first instance of the note
										console.log("1st instance of accidental");
									
										var accidentalInfo = [];
										accidentalInfo[0] = note.pitch;
										accidentalInfo[1] = note.accidentalType;
										prevA.push(accidentalInfo);
										isFound = true;
										adjustTuning(note,accidentalInfo[1]);
									}
								} else { //if it doesn't have an accidental, see if it has a carryover
									var isFound = false;
									
									for (var j=0; j<prevA.length; j++) {
										var accidentalInfo = prevA[j];
										
										if (accidentalInfo[0] == note.pitch) {
											adjustTuning(note,accidentalInfo[1]);
											
											isFound = true;
											break;
										}
									}
									
									if (!isFound) {
										note.tuning = 0;
									}
								
								}
							}
						
						}
						
						myCursor.next();
					}
						
				}
				
			}
	}
	
	//adjust the tuning of a note, and transpose it based on the selected interval
	function adjustTuning(note,accidental,invterval) {
		if (accidental == Accidental.MIRRORED_FLAT2) {
			note.tuning = -150;
		} else if (accidental == Accidental.MIRRORED_FLAT) {
			note.tuning = -50;
		} else if (accidental == Accidental.NATURAL) {
			note.tuning = 0;
		} else if (accidental == Accidental.SHARP_SLASH) {
			note.tuning = 50;
		} else if (accidental == Accidental.SHARP_SLASH4) {
			note.tuning = 150;
		}
	}
	
	
	
}