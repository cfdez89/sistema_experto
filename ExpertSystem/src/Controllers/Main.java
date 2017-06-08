/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Controllers;

import java.io.IOException;

/**
 *
 * @author Mariano
 */
public class Main {

    
    /**
     * @param args the command line arguments
     */
    
    public static void main(String[] args) {
        Connection connection= new Connection();
        connection.createConnection2Clips();
        //Linea del clear no es necesaria
        connection.sendMessage("(clear)");
        connection.loadCPL();
//        connection.sendMessage(connection.DUMMY_STOP);
        //connection.sendMessage("(load src\\clips_files\\main.clp)");
        //Cargamos la respuesta despues de cargar el .CPL
//        connection.printResponse();
        connection.sendMessage("(reset)");
        connection.sendMessage("(run) \n\n");
        System.out.println("run");
        connection.sendMessage("2");
        
        connection.sendMessage("1");
        
        
        connection.sendMessage("Do");
        
        connection.sendMessage("Do");
        connection.sendMessage("3");
        connection.sendMessage("Mi");
        connection.sendMessage("4");
        connection.sendMessage("Sol");
        connection.sendMessage("5");
        connection.sendMessage("(facts)");
        
        connection.printResponse();
        //Recordar matar el proceso mediante el taskmngr si no llega a la
        //siguiente linea nombre cl.exe
//        connection.killConnection2Clips();
    }
    
    public static void excCommand() throws IOException{
        
        /*
        try{
            String line;
    OutputStream stdin = null;
    InputStream stderr = null;
    InputStream stdout = null;

      // launch EXE and grab stdin/stdout and stderr
      Process process = Runtime.getRuntime ().exec ("C:\\Users\\Mariano\\Desktop\\clips_windows_executables_630\\cl.exe");
      
      stdin = process.getOutputStream ();
      stderr = process.getErrorStream ();
      stdout = process.getInputStream ();
      
      
     
      // "write" the parms into stdin
      line = "(load src\\clips_files\\main.clp)";
      stdin.write(line.getBytes() );
      stdin.flush();

      line = "(reset)" + "\n";
      stdin.write(line.getBytes() );
      stdin.flush();

      line = "(run)" + "\n";
      stdin.write(line.getBytes() );
      stdin.flush();
      //No se cierra el input para que no se encicle
      //stdin.close();
      //stdout.close();
      // clean up if any output in stdout
      BufferedReader brCleanUp =
        new BufferedReader (new InputStreamReader (stdout));
            System.out.println();
            
            //  System.exit(0);
      while ((line = brCleanUp.readLine ()) != null) {
          
        System.out.println ("[Stdout] " + line);
      }
      brCleanUp.close();
      // clean up if any output in stderr
      brCleanUp =
        new BufferedReader (new InputStreamReader (stderr));
      while ((line = brCleanUp.readLine ()) != null ) {
        System.out.println ("[Stderr] " + line);
      }
      brCleanUp.close();
    } catch (Exception e) {
        System.out.println(e);
        // TODO Auto-generated catch block
        e.printStackTrace();
    }
        
        */
    }
}
