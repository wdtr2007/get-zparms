//
// Compile: the utility file and the source file with:
//		javac Util.java
//		javac <filename>.java
//
// Run: java <filename> [<db_name>] <username> <pwd>
//	or
//     java <filename> [<db_name>] <server_name> <port_num> <username> <pwd> <grp> <member> <file-out-name>
//
// OUTPUT FILE: SpClient.out (available in the online documentation)
// Output will vary depending on the JDBC driver connectivity used.
//*************************************************************************
//


import java.sql.*;            // JDBC classes           
import java.math.BigDecimal;  // BigDecimal support for packed decimal type

class GetZparm
{
  static double outMedian = 0;
  static Db db;
  static FileIO f1 = new FileIO();


  public static void main(String argv[])
  {
    
      if (argv.length != 7 ) {
         System.out.println("Usage: program hostname port username pwd db2-grp db2-member file-out-name \n");
         System.exit(16);
      }
      Connection con = null;
      String grp  = argv[4];
      String member = argv[5];
      String fout = "D:\\powershell\\all-zparms\\" + argv[6] + "-out.raw";
      // f1 = new FileIO();
      f1.InitfAppend(fout);
      
      try
      { 
        int prt=Integer.parseInt(argv[1]);

        
        javax.sql.DataSource ds=null;
        ds=new com.ibm.db2.jcc.DB2SimpleDataSource();
        ((com.ibm.db2.jcc.DB2BaseDataSource) ds).setServerName(argv[0]);
        ((com.ibm.db2.jcc.DB2BaseDataSource) ds).setPortNumber(prt);
        ((com.ibm.db2.jcc.DB2BaseDataSource) ds).setDatabaseName(grp);
        ((com.ibm.db2.jcc.DB2BaseDataSource) ds).setDriverType(4);
        // ((com.ibm.db2.jcc.DB2BaseDataSource) ds).setTraceFile("jcctrace.txt");
        ((com.ibm.db2.jcc.DB2BaseDataSource) ds).setEnableNamedParameterMarkers(1);
        System.out.println("about to connect " + grp + "-" + member);
        con = ds.getConnection(argv[2],argv[3]);
	System.out.println("  Connect to  database using JDBC Universal type 4 driver.");
        con.setAutoCommit(false);
      }
      catch (Exception e)
      {
        System.out.println("  Error loading DB2 Driver...\n");
        System.out.println(e);
        System.exit(1);
      }



    try
    {
            
      callOneResultSet(con, grp, member);

      // roll back any changes to the database made by this sample
      con.commit();                                   
      con.close();
      System.out.println();
      System.out.println("  Disconnect from database.");
      f1.Closef();
    }
    catch (Exception e)
    {
      try
      {
        con.rollback();
        con.close();
      }
      catch (Exception x)
      { }

      e.printStackTrace();
    }
  } // end main









  public static void callOneResultSet(Connection con, String grp, String ssid_member)
  {
    try
    {
      // prepare the CALL statement for ONE_RESULT_SET
      String sql = "CALL SYSPROC.ADMIN_INFO_SYSPARM(:inSSID, :outRC, :outMSG)";
      String inSSID = ssid_member;
      int outRC = 0;
      String outMSG = "OK";

      CallableStatement callStmt = con.prepareCall(sql);

      // set input parameter to median value passed back by OUT_PARAM
      if ( inSSID.equals(grp) ) { 
          inSSID = "";
          ((com.ibm.db2.jcc.DB2CallableStatement)callStmt).setJccStringAtName("inSSID", null ); 
          System.out.println( grp + " ssid matches grp set to null " );
      } else {
          ((com.ibm.db2.jcc.DB2CallableStatement)callStmt).setJccStringAtName("inSSID", inSSID);
      }
      ((com.ibm.db2.jcc.DB2CallableStatement)callStmt).registerJccOutParameterAtName("outRC", Types.INTEGER);
      ((com.ibm.db2.jcc.DB2CallableStatement)callStmt).registerJccOutParameterAtName("outMSG", Types.VARCHAR);

      // call the stored procedure
      System.out.println();
      System.out.println("ready to xeq SP" );

      callStmt.execute();
      System.out.println("xeq call sp completed successfully");

      outRC  = callStmt.getInt(2);
      outMSG = callStmt.getString(3);

      if ( outRC != 0 ) {   
          System.out.println(  outMSG );
          Integer pos1 = outMSG.indexOf("REASON CODE=5");
          if ( pos1 > 0 ) {
            System.out.println("2nd try " + pos1.toString() );
            ((com.ibm.db2.jcc.DB2CallableStatement)callStmt).setJccStringAtName("inSSID", null ); 
            ((com.ibm.db2.jcc.DB2CallableStatement)callStmt).registerJccOutParameterAtName("outRC", Types.INTEGER);
            ((com.ibm.db2.jcc.DB2CallableStatement)callStmt).registerJccOutParameterAtName("outMSG", Types.VARCHAR);
            callStmt.execute();
            outRC  = callStmt.getInt(2);
            outMSG = callStmt.getString(3);
            if ( outRC != 0 ) { System.out.println(outMSG);  System.exit(16); }
          }
      }
      
       

      ResultSet rs = callStmt.getResultSet();
      fetchAll(rs, ssid_member);

      // close ResultSet and callStmt
      rs.close();
      callStmt.close();
    }
    catch (SQLException e)
    {
      System.out.println(e.getMessage());
    }
  } // callOneResultSet



  // ======================================================
  // Method: fetchAll -- returns all rows from a result set
  // ======================================================
  public static void fetchAll(ResultSet rs, String member)
  {
    try
    {
      System.out.println(
        "=============================================================");
    
      // retrieve the  number, types and properties of the 
      // resultset's columns
      ResultSetMetaData stmtInfo = rs.getMetaData();
      
      int numOfColumns = stmtInfo.getColumnCount();
      int r = 0;

      while (rs.next())
      {
        r++;
        String s1 = member + ",";
        f1.Writef(s1);
        // # System.out.print( member + "," );
        for (int i = 1; i <= numOfColumns; i++)
        {
         
            String element1 = rs.getString(i);
            if ( element1 == null ) { element1 = "NULL"; }
            else {
                     if ( element1.trim().isEmpty()  ) { element1 = "EMPTY"; }
            }
            element1=element1.replaceAll(" ", "_");
            element1=element1.replaceAll(",", "_");
            element1="=\"" + element1 + "\"";
            // #System.out.print( element1 );
            f1.Writef(element1);
          

          if (i != numOfColumns)
          {
            // # System.out.print(",");
            f1.Writef(",");
          }
        }
        // # System.out.println();
        f1.Writefln(" ");
      }
    }
    catch (Exception e)
    {
      System.out.println("Error: fetchALL: exception");
      System.out.println(e.getMessage());
    }
  } // fetchAll
} // SpServer
