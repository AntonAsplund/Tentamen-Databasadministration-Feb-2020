using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data.SqlClient;
using System.Data;

namespace TentamenDatabasAntonAsplund
{
    class Program
    {
        //ConnectionString ligger i SQLDataSource!!

        static void Main(string[] args)
        {
            Console.OutputEncoding = Encoding.Unicode;
            Console.InputEncoding = Encoding.Unicode;
            

            MainMenu.Run();
          
        }

    }
}
