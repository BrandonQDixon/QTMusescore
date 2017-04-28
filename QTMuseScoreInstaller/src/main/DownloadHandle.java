package main;
import java.awt.Desktop;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.net.URI;
import java.net.URISyntaxException;
import java.net.URL;
import java.util.zip.ZipEntry;
import java.util.zip.ZipInputStream;

import javax.net.ssl.HttpsURLConnection;

/**
 * The sole purpose of this class will be to download the GitHub repository to gather the installation files from.
 * @author Brandon Dixon
 *
 */

public class DownloadHandle {
	
	/**
	 * This will download String repoUrl to String dest
	 * @param repoUrl - String url to download
	 * @param dest - String destination
	 * @param fileName - the filename of the file to keep
	 * @param execute - true if the program should be executed
	 * @throws IOException
	 */
	public static void downloadRepo(String repoUrl, String dest, String fileName) throws IOException {
		System.out.println("Opening URL: "+repoUrl);
		HttpsURLConnection url = (HttpsURLConnection) new URL(repoUrl).openConnection();
		ZipInputStream zin = new ZipInputStream(url.getInputStream());
		
		ZipEntry ze = zin.getNextEntry();
		boolean isInside = true;
		while (isInside) {
			if ((ze != null) && (new File(ze.getName()).getName().equals(fileName))) {
				BufferedOutputStream bOut = new BufferedOutputStream(new FileOutputStream(dest+File.separator+fileName));
				
				isInside = false;
				byte[] buffer = new byte[4096];
				int location;
				
				while ((location = zin.read(buffer)) != -1) {
					bOut.write(buffer,0,location);
				}
				
				bOut.close();
			}
			ze = zin.getNextEntry();
			if (ze == null) {
				isInside = false;
			}
		}
		
		
		zin.close();
	}
	
	/**
	 * Open a url in the default web browser.
	 * @param url
	 * @throws URISyntaxException 
	 * @throws IOException 
	 */
	public static void openURL(String url) throws URISyntaxException, IOException {
		URI uri = new URI(url);
		Desktop dt = Desktop.getDesktop();
		dt.browse(uri);
	}

}
