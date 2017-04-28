import java.awt.FlowLayout;
import java.awt.Font;
import java.awt.GridBagConstraints;
import java.awt.GridBagLayout;
import java.awt.Toolkit;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.io.IOException;
import java.net.URISyntaxException;

import javax.swing.ImageIcon;
import javax.swing.JButton;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.SwingConstants;

/**
 * This window will appear if the program does not think MuseScore is installed.
 * @author Brandon Dixon
 *
 */

public class ErrorWindow extends JFrame {

	//strings for the program display
	
	private static final String ERROR_STRING_ONE = "<html>This program did not detect the MuseScore folder in your Documents folder.<br>"
			+ "If you have not yet installed MuseScore, you may do so by clicking the button below.<br>"
			+ "If you have already installed MuseScore, try starting or restarting the program, then click the retry button below.</html>";
	
	private static final String DOWNLOAD_BUTTON_STRING = "Download MuseScore";
	private static final String MS_URL = "www.musescore.org";
	
	private static final String ERROR_STRING_TWO = "Once you have installed MuseScore, hit the button below to try again.";
	
	private static final String RETRY_STRING = "Retry";
	private static final String MANUAL_STRING = "<html>If you have tried the options above, and this program still does not detect MuseScore, click the button below to install the plugin manually.<br>It will take you to a website with instructions on how to install the plugin.</html>";
	private static final String MANUAL_BUTTON_STRING = "Manual Install";
	
	//actual variables
	private JLabel header;
	private JLabel errorOne;
	private JButton downloadButton;
	private JLabel errorTwo;
	private JButton retryButton;
	private JPanel mainPanel;
	private JLabel manual;
	private JButton manualB;
	
	public ErrorWindow() {
		createFrame();
	}
	
	private void createFrame() {
		this.setIconImage(Main.ICON_IMAGE);
		this.setTitle(Main.WINDOW_TITLE);
		this.setResizable(false);
		
		mainPanel = new JPanel(new GridBagLayout());
		GridBagConstraints c = new GridBagConstraints();
		
		c.gridx = 0;
		c.gridy = 0;
		
		header = new JLabel(Main.HEADER,SwingConstants.CENTER);
		header.setFont(new Font(header.getFont().getName(),Font.BOLD,28));
		mainPanel.add(header,c);
		
		c.anchor = GridBagConstraints.WEST;
		c.gridy++;
		errorOne = new JLabel(ERROR_STRING_ONE);//,SwingConstants.CENTER);
		mainPanel.add(errorOne, c);
		
		c.gridy++;
		downloadButton = new JButton(DOWNLOAD_BUTTON_STRING);
		mainPanel.add(downloadButton, c);
		
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
		
		c.gridy++;
		errorTwo = new JLabel(ERROR_STRING_TWO);//,SwingConstants.CENTER);
		mainPanel.add(errorTwo, c);
		
		c.gridy++;
		retryButton = new JButton(RETRY_STRING);
		mainPanel.add(retryButton,c);
		retryButton.addActionListener(new ActionListener() {

			@Override
			public void actionPerformed(ActionEvent arg0) {
				Main.checkStatus();
			}	
			
		});
		
		c.gridy++;
		manual = new JLabel(MANUAL_STRING);//,SwingConstants.CENTER);
		mainPanel.add(manual,c);
		
		c.gridy++;
		manualB = new JButton(MANUAL_BUTTON_STRING);
		mainPanel.add(manualB,c);
		manualB.addActionListener(new ActionListener() {

			@Override
			public void actionPerformed(ActionEvent arg0) {
				try {
					DownloadHandle.openURL(Main.REPO_PUBLIC_URL);
				} catch (URISyntaxException | IOException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
				System.exit(1);
			}
			
		});
		
		this.add(mainPanel);
		this.pack();
		this.setVisible(true);
		this.setDefaultCloseOperation(EXIT_ON_CLOSE);
		
		
	}
	
}
