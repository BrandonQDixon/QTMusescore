import java.awt.Image;
import java.io.File;
import java.io.IOException;
import java.nio.file.CopyOption;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;

import javax.swing.Icon;
import javax.swing.ImageIcon;
import javax.swing.JFrame;
import javax.swing.JOptionPane;

public class Main {
	
	private static final String REPO_URL = "https://github.com/BrandonQDixon/QTMusescore/archive/master.zip";
	private static final String DOWN_DEST = "temp.zip";
	
	public static final String REPO_PUBLIC_URL = "https://github.com/BrandonQDixon/QTMusescore";
	public static final String HEADER = "Quarter Tone Accidental Plugin for MuseScore";
	public static final String FILE_NAME = "Quarter Tone Accidentals Dixon.qml";
	
	public static final String WINDOW_TITLE = "Quarter Tone Saxophone";
	public static final Image ICON_IMAGE = new ImageIcon(Main.class.getResource("/icon.png")).getImage();
	
	
	private static JFrame current = null;
	private static File dir = null;
	
	public static void main(String[] args) {
		checkStatus();
	}
	
	public static void checkStatus() {
		//close the current window if one is open
		if (current != null) {
			current.setVisible(false);
			current = null;
		}
		
		//check to see if musescore is detected
		try {
			dir = MuseScoreHandle.doesMuseScoreExist();
			System.out.println(dir.getAbsolutePath());
			current = new ScriptWindow();
		} catch (MuseScoreDoesNotExistException e) {
			//make the current window the error window
			current = new ErrorWindow();
		}
	}
	
	public static void downloadAndPlace() {
		try {
			DownloadHandle.downloadRepo(REPO_URL,dir.getAbsolutePath(),FILE_NAME);
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

}
