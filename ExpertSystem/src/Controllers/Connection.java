/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Controllers;

import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.util.ArrayList;

/**
 *
 * @author Mariano
 */
public class Connection {

    private static final String URL_ROOT = "src\\clips_files\\";
    private static final String URL_CLIPS_EXE = URL_ROOT + "cl.exe";
    private static final String URL_CLIPS_MAIN_PROGRAM = URL_ROOT + "main.clp";
    private static final String LOAD_FUNCTION_WITH_MAIN = "(load " + URL_CLIPS_MAIN_PROGRAM + ")";
    public static final String DUMMY_STOP="DUMMY_STOP";
    private Process process = null;
    private OutputStream stdin = null;
    private InputStream stderr = null;
    private InputStream stdout = null;

    //Llamada para inicializar la pega a CLIPS
    public boolean createConnection2Clips() {
        try {
            //Comenzamos a ejecutar CLIPS
            process = Runtime.getRuntime().exec(URL_CLIPS_EXE);
            
            stdin = process.getOutputStream();
            stderr = process.getErrorStream();
            stdout = process.getInputStream();
            System.out.println("Iniciado la invocación de clips con éxito");
            return true;
        } catch (Exception e) {
            //Si retorna false la url muy probablemente está mal
            return false;
        }
    }

    //Terminar el proceso de clips para que la compu no se pegue
    public void killConnection2Clips() {
        try {
            if (process.isAlive()) {
                stderr.close();
                stdin.close();
                stdout.close();
                process.destroy();
                process.destroyForcibly();
            }
        } catch (Exception e) {
        }
    }

    public void loadCPL() {
        try {
            String strToLoad = LOAD_FUNCTION_WITH_MAIN + " \n";
            stdin.write(strToLoad.getBytes());
            stdin.flush();
            System.out.println("Cargado el CPL");          
            
        } catch (Exception e) {
            System.out.println("Error enviando input: \n" + e.toString());
        }
    }

    /*Envio de datos al proceso
     Ejemplos de uso 
     (load src\\clips_files\\main.clp)
     (reset)
     (run)
     **/
    public void sendMessage(String input) {
        try {
            input += " \n";
            stdin.write(input.getBytes());
            stdin.flush();
        } catch (Exception e) {
            System.out.println("Error enviando input: \n" + e.toString());
        }
    }

    public String printResponse() {
        
        try {
          
            BufferedReader brCleanUp
                    = new BufferedReader(new InputStreamReader(stdout));
            int contador=0;
            String line;
            String result = "";
            while ((line = brCleanUp.readLine()) != null) {
                contador++;
                if(line.contains(DUMMY_STOP) && contador!=2){
                    System.out.println("console.log(Dummy STOP)");
                    return result;
                }else{
                    result = line;
                }
                System.out.println("LINE: "+line);
            }            
        } catch (Exception e) {
            System.out.println(e.toString());
        }
        return "";
    }
    //Get Last Input Send
    //Get Last Output Received

    /**
     * try { String line; Process process = null; OutputStream stdin = null;
     * InputStream stderr = null; InputStream stdout = null;
     *
     * // launch EXE and grab stdin/stdout and stderr process =
     * Runtime.getRuntime().exec("src\\clips_files\\cl.exe"); stdin =
     * process.getOutputStream(); stderr = process.getErrorStream(); stdout =
     * process.getInputStream(); // "write" the parms into stdin line =
     * "(clear)" + "\n"; stdin.write(line.getBytes()); stdin.flush();
     *
     * line = "(load main.CLP)" + "\n"; stdin.write(line.getBytes());
     * stdin.flush();
     *
     * line = "(reset)" + "\n"; stdin.write(line.getBytes()); stdin.flush();
     *
     * line = "(run)" + "\n"; stdin.write(line.getBytes()); stdin.flush();
     *
     * stdin.close();
     *
     * // clean up if any output in stdout BufferedReader brCleanUp = new
     * BufferedReader(new InputStreamReader(stdout)); while ((line =
     * brCleanUp.readLine()) != null) { System.out.println("[Stdout] " + line);
     * } brCleanUp.close();
     *
     * // clean up if any output in stderr brCleanUp = new BufferedReader(new
     * InputStreamReader(stderr)); while ((line = brCleanUp.readLine()) != null)
     * { //System.out.println ("[Stderr] " + line); } brCleanUp.close();
     * //process.destroy(); //process.destroyForcibly(); } catch (Exception e) {
     * System.out.println(e); // TODO Auto-generated catch block
     * e.printStackTrace(); }
     */
}
