import java.io.File;
import java.nio.file.Files;

import javax.swing.filechooser.FileSystemView;

/**
 * This class will check to see if the operating system has MuseScore installed
 * @author Brandon Dixon
 *
 */
public class MuseScoreHandle {

	/**
	 * Check if MuseScore installation exists on this system, and return the File of the Doc Directory if it does
	 * @return File containing the directory to the plugin
	 * @throws MuseScoreDoesNotExistException
	 */
	public static File doesMuseScoreExist() throws MuseScoreDoesNotExistException {
		
		String msDir = FileSystemView.getFileSystemView().getDefaultDirectory().getPath() + File.separator + "MuseScore2"+File.separator+"Plugins";
		File msDirFile = new File(msDir);
		
		if (msDirFile.exists()) {
			return msDirFile;
		} else {
			msDir = FileSystemView.getFileSystemView().getDefaultDirectory().getPath()+File.separator+"MuseScore 2"+File.separator+"Plugins";
		}
		
		throw new MuseScoreDoesNotExistException();
		
	}
	
}
