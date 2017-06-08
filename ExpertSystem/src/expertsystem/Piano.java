/*Copyright 2013 Meredith Myers

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.*/
package expertsystem;

import java.awt.Color;
import java.awt.Dimension;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import javax.swing.Box;
import javax.swing.BoxLayout;
import javax.swing.ImageIcon;
import javax.swing.JButton;
import javax.swing.JLayeredPane;
import javax.swing.JPanel;
import music.MusicManager;


/* BONUS WORK:
 * Made the repeat song a JTextArea so the user is not limited to 10 repeats.
 * Added the black keys.
 * Added a custom color.*/
/**
 * Constructs the GUI and handles user interaction.
 *
 * @author Kenneth Quirós N
 */
public class Piano extends JPanel implements ActionListener {

    
    private final MainGUI parent;
    /**
     * The total number of notes.
     */
    public static final int NUM_KEYS = 7;
    /**
     * How many octaves should be created.
     */
    public static final int NUM_OCTAVES = 4;
    /**
     * Holds the possible notes.
     */
    private final String[] notesEngland = {"C", "D", "E", "F", "G", "A", "B"};
    private final String[] notesItalian = {"Do", "Re", "Mi", "Fa", "Sol", "La", "Si"};
    /**
     * Holds the possible sharps.
     */
    private final String[] sharpsEngland = {"C#", "D#", "F#", "G#", "A#"};
    private final String[] sharpsItalian = {"Do#", "Re#", "Fa#", "Sol#", "La#"};
    
    /**
     * Holds the possible bemols.
     */
    private final String[] bemolsEngland = {"Db", "Eb", "Gb", "Ab", "Bb"};
    private final String[] bemolsItalian = {"Reb", "Mib", "Solb", "Lab", "Sib"};
    
    private final String[] completeItalianSharp = {"Do","Do#", "Re","Re#", "Mi", "Fa", "Fa#", "Sol","Sol#", "La","La#", "Si"};
     private final String[] completeItalianBemol = {"Do", "Reb","Re", "Mib", "Mi", "Fa", "Solb", "Sol","Lab", "La","Sib","Dob"};
    private final String[] completeEnglandSharp = {"C","C#", "D","D#", "E", "F", "F#", "G","G#", "A","A#", "B"};
    private final String[] completeEnglandBemol = {"C", "Db","D", "Eb", "E", "F", "Gb", "G","Ab", "A","Bb","Cb"};
    private final String[] octave = {"2", "3", "4", "5"};
    
    
    private String _alteracion = "#";
    private String _notacion = "1";
    private String _numero = "0";
    private int _numeroTonalidad = 0;
    
    private final MusicManager musicManager = MusicManager.getInstance();

    public Piano(MainGUI parent) {
        musicManager.setSynthInstrument(0);
        this.parent = parent;
    }
    
    /**
     * 
     * @param pAlteracion
     * @return List<String>
     */
    private List<String> obtenerNotasActuales(String pAlteracion){
        List<String> notasCompletas;
        
        if(getNotacion().equals("1")){
            if(pAlteracion.equals("#")){
                notasCompletas = Arrays.asList(completeEnglandSharp);
            }else{
                notasCompletas = Arrays.asList(completeEnglandBemol);
            }
        }else{
            if(pAlteracion.equals("#")){
                notasCompletas = Arrays.asList(completeItalianSharp);
            }else{
                notasCompletas = Arrays.asList(completeItalianBemol);
            }
        }
        return notasCompletas;
    }
    
    /**
     * 
     * @param pNotacion
     * @param pTonalidad
     * @return String[]
     */
    public String[] obtenerEscalaMayor(String pTonalidad, String pAlteracion){
         List<String> notasCompletas = obtenerNotasActuales(pAlteracion);
        
        System.out.println("TONALIDAD- " + pTonalidad);
        int indice = notasCompletas.indexOf(pTonalidad);
        ArrayList<String> notasCortadas;
        
        notasCortadas = new ArrayList<>(notasCompletas.subList(indice, notasCompletas.size()));

        List<String> primerCorte = notasCompletas.subList(0, indice);
        for (int i = 0; i < primerCorte.size(); i++) {
            notasCortadas.add(primerCorte.get(i));
        }
            
        String[] notasEscala = new String[7];
        
        notasEscala[0] = notasCortadas.get(0);
        notasEscala[1] = notasCortadas.get(2);
        notasEscala[2] = notasCortadas.get(4);
        notasEscala[3] = notasCortadas.get(5);
        notasEscala[4] = notasCortadas.get(7);
        notasEscala[5] = notasCortadas.get(9);
        notasEscala[6] = notasCortadas.get(11);
        
        return notasEscala;
    }
    
    /**
     * 
     * @param pNotacion
     * @param pAlteracion
     * @return JPanel
     */
    public JPanel initPiano(String pNotacion, String pAlteracion){
        
        // ---- Instrument and tempo panel ----
        JPanel iTpanel = new JPanel();
        iTpanel.setLayout(new BoxLayout(iTpanel, BoxLayout.X_AXIS));
        iTpanel.setForeground(Color.WHITE);
        iTpanel.setBackground(new Color(34,34,34));


        // -------- piano keys panel --------
        // Call the make keys method
        JLayeredPane pianoKeyPanel;
        if(pAlteracion.equals("#")){
            if("1".equals(pNotacion)){
                pianoKeyPanel = makeKeys(pNotacion, sharpsEngland);
            }else{
                pianoKeyPanel = makeKeys(pNotacion, sharpsItalian);
            }
        }else{
            if("1".equals(pNotacion)){
                pianoKeyPanel = makeKeys(pNotacion, bemolsEngland);
            }else{
                pianoKeyPanel = makeKeys(pNotacion, bemolsItalian);
            }
        }
        
        iTpanel.add(pianoKeyPanel);
        
        return iTpanel;
    }
    
    /**
     * Creates the panel containing all of the piano keys.
     *
     * @param pNotacion
     * @param pAlteraciones
     * @return the panel containing the keys.
     */
    public JLayeredPane makeKeys(String pNotacion, String[] pAlteraciones) {
        // Initialize
        String name;
        int x = 55;
        int y = 0;

        // Create layerPane
        JLayeredPane keyBoard = new JLayeredPane();
        keyBoard.setPreferredSize(new Dimension(900, 162));
        keyBoard.add(Box.createRigidArea(new Dimension(x, 0)));

        // Add the white key buttons
        for (int i = 0; i < NUM_OCTAVES; i++) {
            for (int j = 0; j < NUM_KEYS; j++) {
                ImageIcon img;
                ImageIcon imgPressed;
                if("1".equals(pNotacion)){
                    img = new ImageIcon("src/assets/inglesa" + "/" + notesEngland[j] + ".png");
                    imgPressed = new ImageIcon("src/assets/inglesa" + "/" + notesEngland[j] + "Pressed.png");
                    name = notesEngland[j] + ";" + octave[i];
                }else{
                    img = new ImageIcon("src/assets/italiana" + "/" + notesItalian[j] + ".png");
                    imgPressed = new ImageIcon("src/assets/italiana" + "/" + notesItalian[j] + "Pressed.png");
                    name = notesItalian[j] + ";" + octave[i];
                }
                
                JButton jb = new JButton(img);
                jb.setPressedIcon(imgPressed);
                jb.setName(name);
                jb.setActionCommand(name);
                jb.addActionListener(this);
                jb.setBounds(x, y, 35, 162);
                keyBoard.add(jb, new Integer(1));
                keyBoard.add(Box.createRigidArea(new Dimension(2, 0)));
                x += 37;
            }
        }

        // Add the black keys 
        for (int i = 0; i < NUM_OCTAVES; i++) {

            ImageIcon img = new ImageIcon("src/assets/blackKey.png");
            ImageIcon imgPressed = new ImageIcon("src/assets/blackKeyPressed.png");

            // Make 5 "keys"
            JButton jb0 = new JButton(img);
            jb0.setPressedIcon(imgPressed);
            name = pAlteraciones[0] + ";" + octave[i];
            jb0.setName(name);
            jb0.setActionCommand(name);
            jb0.addActionListener(this);

            JButton jb1 = new JButton(img);
            jb1.setPressedIcon(imgPressed);
            name = pAlteraciones[1] + ";" + octave[i];
            jb1.setName(name);
            jb1.setActionCommand(name);
            jb1.addActionListener(this);

            JButton jb2 = new JButton(img);
            jb2.setPressedIcon(imgPressed);
            name = pAlteraciones[2] + ";" + octave[i];
            jb2.setName(name);
            jb2.setActionCommand(name);
            jb2.addActionListener(this);

            JButton jb3 = new JButton(img);
            jb3.setPressedIcon(imgPressed);
            name = pAlteraciones[3] + ";" + octave[i];
            jb3.setName(name);
            jb3.setActionCommand(name);
            jb3.addActionListener(this);

            JButton jb4 = new JButton(img);
            jb4.setPressedIcon(imgPressed);
            name = pAlteraciones[4] + ";" + octave[i];
            jb4.setName(name);
            jb4.setActionCommand(name);
            jb4.addActionListener(this);

            // Place the 5 keys 
            jb0.setBounds(77 + (260 * i), y, 25, 95);
            keyBoard.add(jb0, new Integer(2));

            jb1.setBounds(115 + (260 * i), y, 25, 95);
            keyBoard.add(jb1, new Integer(2));

            jb2.setBounds(188 + (260 * i), y, 25, 95);
            keyBoard.add(jb2, new Integer(2));

            jb3.setBounds(226 + (260 * i), y, 25, 95);
            keyBoard.add(jb3, new Integer(2));

            jb4.setBounds(264 + (260 * i), y, 25, 95);
            keyBoard.add(jb4, new Integer(2));
        }
        // Return the keyboard
        return keyBoard;
    }

    @Override
    public void actionPerformed(ActionEvent e) {
        // Initialize
        String command;
        JButton jb;
        String name = "";

        // Get which object was clicked
        Object obj = e.getSource();

        // Cast the object to a JButton
        jb = (JButton) obj;
        // Get the name of the JButton
        name = jb.getName();

        // Get the action command
        command = jb.getActionCommand();
        // Add that string to the text field
        System.out.println(command + " ");

        String splitted[] = command.split(";");

        List<String> notasCompletas = obtenerNotasActuales(getAlteracion());

        int indexNota = 0;
        if(splitted[0].equals("B") && getAlteracion().equals("b")){
            indexNota = notasCompletas.indexOf("Cb");
        }else if(splitted[0].equals("Si") && getAlteracion().equals("b")){
            indexNota = notasCompletas.indexOf("Dob");
        }else{
            indexNota = notasCompletas.indexOf(splitted[0]);
        }

        System.out.println("INDEX-" + indexNota);
        musicManager.playNote(((Integer.parseInt(splitted[1]))*12) + indexNota);

        if (this.parent.getTableAcorde().getRowCount() < 3) {
            if (!esNotaRepetida(splitted)) {
                this.parent.getTableAcorde().addRow(new Object[]{splitted[0],
                    Integer.parseInt(splitted[1])});
            }
        }
    }
    
    /**
     * 
     * @param notasAcorde
     * @param alturaAcorde 
     */
    public void playChord(ArrayList<String> notasAcorde, ArrayList<Integer> alturaAcorde){
        List<String> notasCompletas = obtenerNotasActuales(getAlteracion());
        
        ArrayList<Integer> indiceNotasAcorde = new ArrayList();

        for (int i = 0; i < notasAcorde.size(); i++) {
            int indexNota = 0;
            if(notasAcorde.get(i).equals("B") && getAlteracion().equals("b")){
                indexNota = notasCompletas.indexOf("Cb");
            }else if(notasAcorde.get(i).equals("Si") && getAlteracion().equals("b")){
                indexNota = notasCompletas.indexOf("Dob");
            }else{
                indexNota = notasCompletas.indexOf(notasAcorde.get(i));
            }
            
            int indiceNota = (alturaAcorde.get(i)*12) + indexNota;
            indiceNotasAcorde.add(indiceNota);
        }
        

        musicManager.playChords(indiceNotasAcorde);
    }

    /**
     * 
     * @param pNota
     * @return boolean
     */
    private boolean esNotaRepetida(String[] pNota){
        for (int i = 0; i < parent.getTableAcorde().getRowCount(); i++) {
            String nota = parent.getTableAcorde().getValueAt(i, 0).toString();
            String altura = parent.getTableAcorde().getValueAt(i, 1).toString();
            if(pNota[0].equals(nota) && pNota[1].equals(altura)){
                return true;
            }
        }
        return false;
    }
    
    /**
     * @return the _alteracion
     */
    public String getAlteracion() {
        return _alteracion;
    }

    /**
     * @param _alteracion the _alteracion to set
     */
    public void setAlteracion(String _alteracion) {
        this._alteracion = _alteracion;
    }

    /**
     * @return the _notacion
     */
    public String getNotacion() {
        return _notacion;
    }

    /**
     * @param _notacion the _notacion to set
     */
    public void setNotacion(String _notacion) {
        this._notacion = _notacion;
    }

    /**
     * @return the _numero
     */
    public String getNumero() {
        return _numero;
    }

    /**
     * @param _numero the _numero to set
     */
    public void setNumero(String _numero) {
        this._numero = _numero;
    }

    /**
     * @return the _numeroTonalidad
     */
    public int getNumeroTonalidad() {
        return _numeroTonalidad;
    }

    /**
     * @param _numeroTonalidad the _numeroTonalidad to set
     */
    public void setNumeroTonalidad(int _numeroTonalidad) {
        this._numeroTonalidad = _numeroTonalidad;
    }

    /**
     * @return the musicManager
     */
    public MusicManager getMusicManager() {
        return musicManager;
    }

}
