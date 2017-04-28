import java.awt.GridBagConstraints;
import java.awt.GridBagLayout;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.io.IOException;
import java.net.URISyntaxException;

import javax.swing.JButton;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JPanel;

/**
 * This window will appear if the program does not think MuseScore is installed.
 * @author Brandon Dixon
 *
 */

public class ErrorWindow extends JFrame {

	//strings for the program display
	private static final String ERROR_STRING_ONE = "This program did not detect an installation of MuseScore on your system.\n\n"
			+ "If you have not yet installed MuseScore, you may do so by clicking the button below:";
	
	private static final String DOWNLOAD_BUTTON_STRING = "Download MuseScore";
	private static final String MS_URL = "www.musescore.org";
	
	private static final String ERROR_STRING_TWO = "Once you have installed MuseScore, hit the button below to try again.";
	
	//actual variables
	private JLabel errorOne;
	private JButton downloadButton;
	private JLabel errorTwo;
	private JButton retryButton;
	private JPanel mainPanel;
	
	public ErrorWindow() {
		createFrame();
	}
	
	private void createFrame() {
		mainPanel = new JPanel(new GridBagLayout());
		GridBagConstraints c = new GridBagConstraints();
		
		errorOne = new JLabel(ERROR_STRING_ONE);
		downloadButton = new JButton(DOWNLOAD_BUTTON_STRING);
		
		downloadButton.addActionListener(new ActionListener() {

			@Override
			public void actionPerformed(ActionEvent arg0) {
				try {
					DownloadHandle.openURL(MS_URL);
				} catch (URISyntaxException | IOException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
				
			}	
			
		});
		
		errorTwo = new JLabel(ERROR_STRING_TWO);
		
		retryButton.addActionListener(new ActionListener() {

			@Override
			public void actionPerformed(ActionEvent arg0) {
				Main.checkStatus();
			}	
			
		});
		
		
	}
	
}
