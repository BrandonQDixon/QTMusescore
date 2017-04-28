import java.io.File;

import javax.swing.JFrame;

public class Main {
	
	private static final String REPO_URL = "https://github.com/BrandonQDixon/QTMusescore/archive/master.zip";
	private static final String DOWN_DEST = "temp.zip";
	
	private static JFrame current = null;
	
	public static void main(String[] args) {
			
	}
	
	public static void checkStatus() {
		//close the current window if one is open
		if (current != null) {
			current.setVisible(false);
			current = null;
		}
		
		//check to see if musescore is detected
		try {
			File dir = MuseScoreHandle.doesMuseScoreExist();
			//make the current window the script installation window
		} catch (MuseScoreDoesNotExistException e) {
			//make the current window the error window
			current = new ErrorWindow();
		}
	}

}
