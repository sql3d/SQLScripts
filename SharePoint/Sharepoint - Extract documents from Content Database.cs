/*
   Microsoft SQL Server Integration Services Script Task
   Write scripts using Microsoft Visual C# 2008.
   The ScriptMain is the entry point class of the script.
*/

using System;
using System.Data;
using Microsoft.SqlServer.Dts.Runtime;
using System.Windows.Forms;
using System.Collections.Generic;
using System.Text;
using System.Data.SqlClient;
using System.IO;
namespace ST_0929bff23b6e44218e3ddcc182f996d2.csproj
{
    [System.AddIn.AddIn("ScriptMain", Version = "1.0", Publisher = "", Description = "")]
    public partial class ScriptMain : Microsoft.SqlServer.Dts.Tasks.ScriptTask.VSTARTScriptObjectModelBase
    {

        #region VSTA generated code
        enum ScriptResults
        {
            Success = Microsoft.SqlServer.Dts.Runtime.DTSExecResult.Success,
            Failure = Microsoft.SqlServer.Dts.Runtime.DTSExecResult.Failure
        };
        #endregion

        /*
		The execution engine calls this method when the task executes.
		To access the object model, use the Dts property. Connections, variables, events,
		and logging features are available as members of the Dts property as shown in the following examples.

		To reference a variable, call Dts.Variables["MyCaseSensitiveVariableName"].Value;
		To post a log entry, call Dts.Log("This is my log text", 999, null);
		To fire an event, call Dts.Events.FireInformation(99, "test", "hit the help message", "", 0, true);

		To use the connections collection use something like the following:
		ConnectionManager cm = Dts.Connections.Add("OLEDB");
		cm.ConnectionString = "Data Source=localhost;Initial Catalog=AdventureWorks;Provider=SQLNCLI10;Integrated Security=SSPI;Auto Translate=False;";

		Before returning from this method, set the value of Dts.TaskResult to indicate success or failure.
		
		To open Help, press F1.
	*/

        public void Main()
        {
            // To extract document from content database

            string DBConnString = "Server=ccal0db123;Database=WSS_CONTENT_CB;Trusted_Connection=True;";
 
            // create a DB connection
            SqlConnection con = new SqlConnection(DBConnString);
            con.Open();
 
            
            SqlCommand com = con.CreateCommand();
            com.CommandText = "SELECT D.DirName, D.LeafName, DS.Content FROM AllDocStreams DS INNER JOIN AllDocs D ON (D.Id=DS.Id) where D.DirName = 'Sites/CB/Engineering/AlcatelLucent'";
 
            // execute query
            SqlDataReader reader = com.ExecuteReader();
 
            while (reader.Read())
            {
                
                string DirName = "c:\\users\\wsong\\" + reader["DirName"];  //Make sure the path is accessible.
                string LeafName = (string)reader["LeafName"];
 
               
                if (!Directory.Exists(DirName))
                {
                    Directory.CreateDirectory(DirName);
                   
                }
 
                
                FileStream fs = new FileStream(DirName + "/" + LeafName, FileMode.Create, FileAccess.Write);
                BinaryWriter writer = new BinaryWriter(fs);
 
                
                int bufferSize = 1000000;
                long startIndex = 0;
                long retval = 0;
                byte[] outByte = new byte[bufferSize];
 
                
                do
                {
                        retval = reader.GetBytes(2, startIndex, outByte, 0, bufferSize);
                        startIndex += bufferSize;
 
                        writer.Write(outByte, 0, (int)retval);
                        writer.Flush();
                } 
                
                while (retval == bufferSize);
 
                
                writer.Close();
                fs.Close();
 
                
            }
 
            
        reader.Close();
        con.Close();












            Dts.TaskResult = (int)ScriptResults.Success;
        }
    }
}