//=============================================================================
//  This plugin will enable the user to adjust the pitches of all quarter
//  - tone accidentals at once
//=============================================================================

import QtQuick 2.0
import MuseScore 1.0

MuseScore {

	version: "2.0"
	description: qsTr("This plugin adjusts the pitches of all of the standard quarter tone accidentals")
	
	//when the plugin is first run
	onRun: {
	
		var fullScore;
		var startStaff;
		var endStaff;
		var endTic;
		
		//first, get the current score
		var cScore = curScore;
		var myCursor = cScore.newCursor();
		
		//rewind to the beginning of the selection
		cursor.rewind(1);
		
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
				
				if (fullScore) {
					myCursor.rewind();
				}
				
				//iterate through elements
				while (myCursor.segment && (fullScore || myCursor.tick < endTick)) {
					if (myCursor.element && myCursor.element.type == Element.NOTE) {
						//if the pitch is not already a quarter tone
						if (myCursor.element.pitch%100 != 50) {
							
							//check the accidental, and adjust accordingly
							if (myCursor.element.accidental == Accidental.MIRRORED_FLAT2) { //sesquiflat
								myCursor.element.pitch -= 150;
							} else if (myCursor.element.accidental == Accidental.MIRRORED_FLAT) { //semiflat
								myCursor.element.pitch -= 50;
							} else if (myCursor.element.accidental == Accidental.SHARP_SLASH) { //semisharp
								myCursor.element.pitch += 50;
							} else if (myCursor.element.accidental == Accidental.SHARP_SLASH2) {	//sesquisharp
								myCursor.element.pitch += 150;
							}
						}
					}
					myCursor.next();
				}
				
			}
		
		}

		Qt.quit();
	}
}