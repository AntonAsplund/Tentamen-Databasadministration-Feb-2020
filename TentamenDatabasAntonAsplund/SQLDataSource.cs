using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data.SqlClient;
using System.Data;

namespace TentamenDatabasAntonAsplund
{
    class SQLDataSource
    {
        /// <summary>
        /// Connection string to the database. Static and thus acessible throughout the database.
        /// </summary>
        private static string _ConnectionString;
        public static string ConnectionString
        {
            get
            {
                return _ConnectionString = "Data Source=DESKTOP-6MGRJ4I\\SQLEXPRESS02;Initial Catalog=TentamenDatabasAntonAsplund;Integrated Security=True";
            }
        }
            
        
    }
}
