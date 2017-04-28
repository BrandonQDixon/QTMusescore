import java.awt.Font;
import java.awt.GridBagConstraints;
import java.awt.GridBagLayout;
import java.awt.Toolkit;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.net.URL;

import javax.swing.ImageIcon;
import javax.swing.JButton;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JOptionPane;
import javax.swing.JPanel;
import javax.swing.SwingConstants;

/**
 * This will be the window that appears if MuseScore is installed to place the plugin in the appropriate place 
 * @author Brandon Dixon
 *
 */

public class ScriptWindow extends JFrame {
	
	//declare window strings
	private static final String SUCCESS_STRING = "The plugin has successfully been installed.  If MuseScore is currently running, you will need to restart it to use the plugin.";
	private static final String MS_EXISTS_STRING = "This program has detected that MuseScore is installed on your system.";
	private static final String ATTEMPT_STRING = "Click on the button below to install the plugin to MuseScore.  This will require an internet connection.";
	private static final String INSTALL_STRING = "Install the Plugin";
	
	//declare actual variables
	private JPanel mainPanel;
	private JLabel header;
	private JLabel exists;
	private JLabel attempt;
	private JButton install;

	public ScriptWindow() {
		createWindow();
	}
	
	
	private void createWindow() {
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
		exists = new JLabel(MS_EXISTS_STRING);//,SwingConstants.CENTER);
		mainPanel.add(exists,c);
		
		c.gridy++;
		attempt = new JLabel(ATTEMPT_STRING);//,SwingConstants.CENTER);
		mainPanel.add(attempt,c);
		
		c.gridy++;
		install = new JButton(INSTALL_STRING);
		mainPanel.add(install,c);
		install.addActionListener(new ActionListener() {

			@Override
			public void actionPerformed(ActionEvent arg0) {
				Main.downloadAndPlace();
				JOptionPane.showMessageDialog(null,SUCCESS_STRING);
				System.exit(0);
			}
			
		});
		
		this.add(mainPanel);
		this.pack();
		this.setVisible(true);
		this.setDefaultCloseOperation(EXIT_ON_CLOSE);
	}
	
}
