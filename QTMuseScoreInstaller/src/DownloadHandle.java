import java.awt.Desktop;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.net.MalformedURLException;
import java.net.URI;
import java.net.URISyntaxException;
import java.net.URL;
import java.nio.channels.Channels;
import java.nio.channels.ReadableByteChannel;

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
	 * @param execute - true if the program should be executed
	 * @throws IOException
	 */
	public static void downloadRepo(String repoUrl, String dest) throws IOException {
		//download the actual file
		URL website = new URL(repoUrl);
		ReadableByteChannel rbc = Channels.newChannel(website.openStream());
		FileOutputStream out = new FileOutputStream(dest);
		out.getChannel().transferFrom(rbc, 0, Long.MAX_VALUE);
		out.close();
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
