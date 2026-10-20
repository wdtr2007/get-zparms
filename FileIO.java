import java.io.*;

public class FileIO implements java.io.Serializable {
     String Fname = null;
     String Status = "init";
     java.io.FileOutputStream fos;
     BufferedWriter bw;

     public String setFname(String s1) {
         Fname = s1;
         return Fname;
     }
     public String getFname() {
         return Fname;
     }

     public FileIO() {
         this.fos = null;
         this.bw = null;

     }


     public void Initf(String s1) {
         Fname = s1;
         File f1 = new File(Fname);
         try {
             this.fos = new java.io.FileOutputStream(f1);
             this.bw = new java.io.BufferedWriter(new java.io.OutputStreamWriter(this.fos));
             this.Status = "Open";
         } catch (FileNotFoundException ex) {
             this.Status =  "bad create output stream";
             System.exit(16);
         }
     }

public void InitfAppend(String s1) {
         Fname = s1;
         File f1 = new File(Fname);
         try {
             this.fos = new java.io.FileOutputStream(f1,true);
             this.bw = new java.io.BufferedWriter(new java.io.OutputStreamWriter(this.fos));
             this.Status = "Open";
         } catch (FileNotFoundException ex) {
             this.Status =  "bad create output stream";
             System.exit(16);
         }
     }


     public void Writef(String s1) {
         try {
             this.bw.write(s1);
         } catch (IOException ex) {
             this.Status =  "bad writef";
             System.exit(16);
         }
     }

     public void Writefln(String s1) {
         try {
             this.bw.write(s1);
             this.bw.newLine();
         } catch (IOException ex) {
             this.Status =  "bad writefln";
             System.exit(16);
         }
     }

     public void Closef() {
         try {
             this.bw.close();
         } catch (IOException ex) {
             this.Status =  "bad closef";
             System.exit(16);
         }
     }



}

