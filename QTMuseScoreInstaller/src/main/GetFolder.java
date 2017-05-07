/**
 * This class will house the method that will prompt the user to get a folder.
 * It will also store a global string for that folder
 */

package main;

import java.io.File;

import javax.swing.JFileChooser;

public class GetFolder {

	private static String folder = "";
	
	/**
	 * This will prompt the user to select a directory.
	 */
	public static void getFolder() {
		JFileChooser jF = new JFileChooser();
		jF.setCurrentDirectory(new File("."));
		jF.setFileSelectionMode(JFileChooser.DIRECTORIES_ONLY);
		int value = jF.showSaveDialog(null);
		if (value == JFileChooser.APPROVE_OPTION) {
			folder  = jF.getSelectedFile().getAbsolutePath();
		}
		
	}
	
	/**
	 * Get the last directory the user selected.
	 * @return String
	 */
	public static String getFolderPath() {
		return folder;
	}
	
}
