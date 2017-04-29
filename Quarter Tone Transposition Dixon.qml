//=============================================================================
//  This plugin will enable the user to adjust the pitches of all quarter
//  - tone accidentals at once
//=============================================================================

import QtQuick 2.0
import MuseScore 1.0
import QtQuick.Controls 1.0
import QtQuick.Controls.Styles 1.3
import QtQuick.Dialogs 1.1
import "./"
MuseScore {

	version: "2.0"
	description: qsTr("This plugin adjusts the pitches of all of the standard quarter tone accidentals")
	menuPath: "Plugins.Quarter Tone Plugins." +qsTr("Transpose")
	
	//user interface:
	Rectangle {
	
		color: "lightgrey"
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
	
}