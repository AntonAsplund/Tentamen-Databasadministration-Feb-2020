using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data;
using System.Data.SqlClient;

namespace TentamenDatabasAntonAsplund
{
    class SQLQuerys
    {
        /// <summary>
        /// Tries to add a vehicle to the database with the info the user has choosen.<br/> 
        /// And present the parking lot to which is has been assigned.
        /// </summary>
        public static int AddVehicle()
        {
            Vehicle addedVehicle = new Vehicle();

            SqlCommand sqlCommand = new SqlCommand();
            SqlConnection sqlConnection = new SqlConnection(SQLDataSource.ConnectionString);
            sqlCommand.Connection = sqlConnection;
            sqlCommand.CommandText = "dbo.USP_AddVehicle";
            sqlCommand.CommandType = CommandType.StoredProcedure;

            addedVehicle.registrationNumber = UserInputs.GetVehicleRegistrationNumber();

            Console.Clear();

            addedVehicle.vehicleTypeID = UserInputs.GetVehicleType();

            Console.Clear();
            sqlCommand.Parameters.AddWithValue("@RegistrationNumber", addedVehicle.registrationNumber);
            sqlCommand.Parameters.AddWithValue("@VehicleType", addedVehicle.vehicleTypeID);

            var returnParameter = sqlCommand.Parameters.Add("@FirstParkingSpace", SqlDbType.Int);
            returnParameter.Direction = ParameterDirection.ReturnValue;

            int result = 0;

            try
            {
                using (sqlCommand.Connection)
                {
                    sqlCommand.Connection.Open();
                    int resultAddVehicle = sqlCommand.ExecuteNonQuery();


                    if (resultAddVehicle > 0)
                    {
                        Console.WriteLine("The vehicle has been sucessfully added");
                        result = (int)returnParameter.Value;
                    }
                    else
                    {
                        Console.WriteLine("The new vehicle has not been added due to an unforseen event");
                    }

                }
            }
            catch
            {
                Console.WriteLine("Something went wrong when trying to add a new vehicle. Please try again, if problem persists contact software suppport.");
                sqlCommand.Connection.Close();
            }

            return result;
                 
            
        }
        /// <summary>
        /// Removes a vehicle from the currently parked vehicles in the database,<br/> 
        /// and add the information to an archive.
        /// </summary>
        public static Vehicle RemoveVehicle(bool forFree)
        {
            Vehicle removedVehicle = new Vehicle();

            SqlCommand sqlCommand = new SqlCommand();
            SqlConnection sqlConnection = new SqlConnection(SQLDataSource.ConnectionString);
            sqlCommand.Connection = sqlConnection;

            if (forFree == false)
            {
                sqlCommand.CommandText = "dbo.USP_RemoveVehicle";
            }
            if (forFree == true)
            {
                sqlCommand.CommandText = "dbo.USP_RemoveVehicleForFree";
            }

            sqlCommand.CommandType = CommandType.StoredProcedure;

            Console.Clear();

            string registrationNumber = UserInputs.GetVehicleRegistrationNumber();
            sqlCommand.Parameters.AddWithValue("@RegistrationNumber", registrationNumber);

            bool vehicleSucessfullyRemoved = false;

            try
            {
                using (sqlCommand.Connection)
                {
                    sqlCommand.Connection.Open();
                    int resultRemoveVehicle = sqlCommand.ExecuteNonQuery();

                    if (resultRemoveVehicle > 0)
                    {
                        Console.WriteLine("The vehicle has been sucessfully removed");
                        vehicleSucessfullyRemoved = true;
                    }
                    else
                    {
                        Console.WriteLine("The new vehicle has not been removed due to an unforseen event(Have you checked spelling of registration number?)");
                    }

                }
            }
            catch
            {
                Console.WriteLine("Something went wrong when trying to add a new vehicle. Please try again, if problem persists contact software suppport.");
                sqlCommand.Connection.Close();
            }


            if (vehicleSucessfullyRemoved)
            {
                removedVehicle = GetVehicleInfoAfterDelete(registrationNumber);
            }

            return removedVehicle;   

        }
        /// <summary>
        /// Moves a vehicle from it's old parking lot and moves it to the new one given
        /// </summary>
        /// <returns></returns>
        public static Vehicle MoveVehicle()
        {
            Vehicle movedVehicle = new Vehicle();
            SqlCommand sqlCommand = new SqlCommand();
            SqlConnection sqlConnection = new SqlConnection(SQLDataSource.ConnectionString);
            sqlCommand.Connection = sqlConnection;
            sqlCommand.CommandText = "dbo.USP_MoveVehicle";
            sqlCommand.CommandType = CommandType.StoredProcedure;

            var returnParameter = sqlCommand.Parameters.Add("@OldParkingSpot", SqlDbType.Int);
            returnParameter.Direction = ParameterDirection.ReturnValue;

            Console.Clear();

            string registrationNumber = UserInputs.GetVehicleRegistrationNumber();
            sqlCommand.Parameters.AddWithValue("@RegistrationNumber", registrationNumber);

            Console.Clear();
            int parkingLotNumber = UserInputs.GetParkingLotNumber();
            sqlCommand.Parameters.AddWithValue("@SpecificParkingSpot", parkingLotNumber);

            try 
            {
                using (sqlCommand.Connection)
                {
                    sqlCommand.Connection.Open();

                    int resultMoveVehicle = sqlCommand.ExecuteNonQuery();
                    if (resultMoveVehicle <= 0)
                    {
                        Console.WriteLine("The vehicle has not been moved due to parkingspace being full or an incorrect vehicle registration number has been given.");
                    }
                    else
                    {

                        movedVehicle = GetVehicleMoveWorkOrder();
                        DeleteFromWorkOrder();
                    }
                
                }
            }
            catch 
            {
                sqlCommand.Connection.Close();
                Console.WriteLine("The move of the vehicle has not been made due to an unforseen event.");
            }

            return movedVehicle;
        }
        /// <summary>
        /// Selects everything from the work ordertable and returns a Vehicle object with all work order table given parameters
        /// </summary>
        /// <returns></returns>
        internal static Vehicle GetVehicleMoveWorkOrder()
        {
            Vehicle vehicleInWorkOrderPrint = new Vehicle();
            SqlCommand sqlCommand = new SqlCommand();
            SqlConnection sqlConnection = new SqlConnection(SQLDataSource.ConnectionString);
            sqlCommand.Connection = sqlConnection;
            sqlCommand.CommandText = "SELECT * FROM WorkOrderRecipt";

            try
            {
                using (sqlCommand.Connection)
                {
                    sqlCommand.Connection.Open();

                    using (SqlDataReader sqlDataReader = sqlCommand.ExecuteReader())
                    {
                        while (sqlDataReader.Read())
                        {
                            vehicleInWorkOrderPrint.registrationNumber = sqlDataReader.GetString(1);
                            vehicleInWorkOrderPrint.vehicleType = sqlDataReader.GetString(2);
                            vehicleInWorkOrderPrint.oldParkingSpace = sqlDataReader.GetInt32(3);
                            vehicleInWorkOrderPrint.currentParkingSpace = sqlDataReader.GetInt32(4);
                        }
                    }
                }
            }
            catch
            {
                sqlCommand.Connection.Close();
                Console.WriteLine("Something went wrong when trying to print from work order");
            }

            return vehicleInWorkOrderPrint;
        }
        /// <summary>
        /// Retrieves a list of all vehicles in the work order table<br/>
        /// Returns a List<Vehicle>
        /// </summary>
        /// <returns></returns>
        internal static List<Vehicle> GetListVehicleMoveWorkOrder()
        {
            List<Vehicle> listOfVehicleWorkOrder = new List<Vehicle>();

            
            SqlCommand sqlCommand = new SqlCommand();
            SqlConnection sqlConnection = new SqlConnection(SQLDataSource.ConnectionString);
            sqlCommand.Connection = sqlConnection;
            sqlCommand.CommandText = "SELECT * FROM WorkOrderRecipt";

            try
            {
                using (sqlCommand.Connection)
                {
                    sqlCommand.Connection.Open();

                    using (SqlDataReader sqlDataReader = sqlCommand.ExecuteReader())
                    {
                        while (sqlDataReader.Read())
                        {
                            Vehicle vehicleInWorkOrderPrint = new Vehicle();
                            vehicleInWorkOrderPrint.registrationNumber = sqlDataReader.GetString(1);
                            vehicleInWorkOrderPrint.vehicleType = sqlDataReader.GetString(2);
                            vehicleInWorkOrderPrint.oldParkingSpace = sqlDataReader.GetInt32(3);
                            vehicleInWorkOrderPrint.currentParkingSpace = sqlDataReader.GetInt32(4);

                            listOfVehicleWorkOrder.Add(vehicleInWorkOrderPrint);
                        }
                    }
                }
            }
            catch
            {
                sqlCommand.Connection.Close();
                Console.WriteLine("Something went wrong when trying to print from work order");
            }

            return listOfVehicleWorkOrder;
        }
        /// <summary>
        /// Deletes everything from the work ordertable
        /// </summary>
        internal static void DeleteFromWorkOrder()
        {
            SqlCommand sqlCommand = new SqlCommand();
            SqlConnection sqlConnection = new SqlConnection(SQLDataSource.ConnectionString);
            sqlCommand.Connection = sqlConnection;
            sqlCommand.CommandText = " DELETE FROM WorkOrderRecipt";

            try 
            {
                using (sqlCommand.Connection)
                {
                    sqlCommand.Connection.Open();

                    sqlCommand.ExecuteNonQuery();
                }
            }
            catch 
            {
                sqlCommand.Connection.Close();
                Console.WriteLine("Something went wrong when trying to remove already printed vehicles from work order sheet. Try again or contact software support");
            }
        }
        /// <summary>
        /// Gets info about the vehicle from the vehicleArchive table
        /// </summary>
        /// <param name="registrationNumber">The registration number of the vehicle</param>
        /// <returns></returns>
        internal static Vehicle GetVehicleInfoAfterDelete(string registrationNumber)
        {
            Vehicle infoOfRemovedVehicle = new Vehicle();

            SqlCommand sqlCommandFindVehcileAfterDelete = new SqlCommand();
            SqlConnection sqlConnectionFindVehcileAfterDelete = new SqlConnection(SQLDataSource.ConnectionString);
            sqlCommandFindVehcileAfterDelete.Connection = sqlConnectionFindVehcileAfterDelete;

            sqlCommandFindVehcileAfterDelete.CommandText = "SELECT TOP 1 VA.VehicleArchiveID, VA.RegistrationNumber, VA.ArrivalTime, VA.CheckOutTime, CONCAT(CONVERT(nvarchar(255), FLOOR(DATEDIFF(Minute, VA.ArrivalTime, GETDATE()) / 60)), ' Hours ', CONVERT(nvarchar(255), FLOOR(DATEDIFF(Minute, VA.ArrivalTime, GETDATE()) % 60)), ' Minutes ') AS[Total Time Parked], CAST(VA.TotalCost AS int) AS[Total Cost], VA.ParkingSpaceID FROM VehicleArchive VA WHERE VA.RegistrationNumber = @RegistrationNumber ORDER BY VA.VehicleArchiveID DESC";

            sqlCommandFindVehcileAfterDelete.Parameters.AddWithValue("@RegistrationNumber", registrationNumber);

            try
            {
                using (sqlCommandFindVehcileAfterDelete.Connection)
                {
                    sqlCommandFindVehcileAfterDelete.Connection.Open();

                    using (SqlDataReader sqlDataReader = sqlCommandFindVehcileAfterDelete.ExecuteReader())
                    {
                        while (sqlDataReader.Read())
                        {
                            infoOfRemovedVehicle.registrationNumber = sqlDataReader.GetString(1);
                            infoOfRemovedVehicle.arrivalTime = sqlDataReader.GetDateTime(2);
                            infoOfRemovedVehicle.checkOutTime = sqlDataReader.GetDateTime(3);
                            infoOfRemovedVehicle.totalTimeParked = sqlDataReader.GetString(4);
                            infoOfRemovedVehicle.totalCostForParking = sqlDataReader.GetInt32(5);
                            infoOfRemovedVehicle.currentParkingSpace = sqlDataReader.GetInt32(6);

                        }

                    }

                }
            }
            catch
            {
                Console.WriteLine("Something went wrong when trying to find info about deleted vehicle. Please try another type of histry search or call software support");
            }

            return infoOfRemovedVehicle;
        }
        /// <summary>
        /// Search for a specific vehicle and returns info about a vehicle by given registration number
        /// </summary>
        /// <returns></returns>
        public static Vehicle SearchForSpecificVehicle()
        {
            Vehicle searchedVehicle = new Vehicle();

            SqlCommand sqlCommand = new SqlCommand();
            SqlConnection sqlConnection = new SqlConnection(SQLDataSource.ConnectionString);
            sqlCommand.Connection = sqlConnection;
            sqlCommand.CommandText = "dbo.USP_SearchForSpecificVehicle";
            sqlCommand.CommandType = CommandType.StoredProcedure;

            searchedVehicle.registrationNumber = UserInputs.GetVehicleRegistrationNumber();
            sqlCommand.Parameters.AddWithValue("@RegistrationNumber", searchedVehicle.registrationNumber);

            try
            {
                using (sqlCommand.Connection)
                {
                    sqlCommand.Connection.Open();

                    using (SqlDataReader sqlDataReader = sqlCommand.ExecuteReader())
                    {
                        while (sqlDataReader.Read())
                        {
                            searchedVehicle.registrationNumber = sqlDataReader.GetString(0);
                            searchedVehicle.arrivalTime = sqlDataReader.GetDateTime(1);
                            searchedVehicle.totalTimeParked = ((int)sqlDataReader.GetDecimal(2)).ToString() + " hours " + ((int)sqlDataReader.GetDecimal(3)).ToString() + " minutes";
                            searchedVehicle.totalCostForParking = (int)sqlDataReader.GetDecimal(4);
                            searchedVehicle.vehicleType = sqlDataReader.GetString(5);
                            searchedVehicle.currentParkingSpace = sqlDataReader.GetInt32(6);

                        }
                    }
                }
            }
            catch
            {
                Console.WriteLine("Something went wrong when trying to search for a parked vehicle");
            }

            return searchedVehicle;
        }

        /// <summary>
        /// Retrieves a list of info about all vehicles parked more than 48 hours<br/>
        /// List<Vehicle>
        /// </summary>
        public static List<Vehicle> SeeVehiclesParkedMoreThen48Hours()
        {
            List<Vehicle> listVehiclesMoreThan2Days = new List<Vehicle>();

            SqlCommand sqlCommand = new SqlCommand();
            SqlConnection sqlConnection = new SqlConnection(SQLDataSource.ConnectionString);
            sqlCommand.Connection = sqlConnection;
            sqlCommand.CommandText = "USP_SeeVehiclesParkedMoreThanTwoDays";
            sqlCommand.CommandType = CommandType.StoredProcedure;


            try
            {
                using (sqlCommand.Connection)
                {
                    sqlCommand.Connection.Open();

                    using (SqlDataReader sqlDataReader = sqlCommand.ExecuteReader())
                    {
                        while (sqlDataReader.Read())
                        {
                            Vehicle vehicleMoreThan2Days = new Vehicle();

                            vehicleMoreThan2Days.registrationNumber = sqlDataReader.GetString(0);
                            vehicleMoreThan2Days.currentParkingSpace = sqlDataReader.GetInt32(1);
                            vehicleMoreThan2Days.totalTimeParked = sqlDataReader.GetString(2);
                            listVehiclesMoreThan2Days.Add(vehicleMoreThan2Days);

                        }
                    }
                }
            }
            catch 
            {
                Console.WriteLine("Something went wrong when trying to retrieve all vehicles parked more than 2 days");
            }

            return listVehiclesMoreThan2Days;
        }
        /// <summary>
        /// Retrieves a list of the entire parkinglot with each parkingspace and its contents<br/>
        /// List<string>
        /// </summary>
        /// <returns></returns>
        public static List<string> SeeFullParkingLot()
        {
            List<string> listOfParkingSpaceContentString = new List<string>();

            SqlCommand sqlCommand = new SqlCommand();
            SqlConnection sqlConnection = new SqlConnection(SQLDataSource.ConnectionString);
            sqlCommand.Connection = sqlConnection;
            sqlCommand.CommandText = "USP_SeeEntireParkingLot";
            sqlCommand.CommandType = CommandType.StoredProcedure;

            try
            {
                using (sqlCommand.Connection)
                {
                    sqlCommand.Connection.Open();

                    using (SqlDataReader sqlDataReader = sqlCommand.ExecuteReader())
                    {
                        while (sqlDataReader.Read())
                        {
                            listOfParkingSpaceContentString.Add(sqlDataReader.GetInt32(0).ToString());
                            listOfParkingSpaceContentString.Add(sqlDataReader.GetString(1));
                            listOfParkingSpaceContentString.Add(sqlDataReader.GetString(2));
                        }
                    }
                }
            }
            catch
            {
                Console.WriteLine("Something went wrong when trying to search for a parked vehicle");
            }

            return listOfParkingSpaceContentString;
        }
        /// <summary>
        /// Retrieves a list of all empty parking spaces<br/>
        /// List<int>
        /// </summary>
        /// <returns></returns>
        public static List<int> SeeAllEmptyParkingSpaces()
        {
            List<int> listOfEmptyParkingSpaces = new List<int>();

            SqlCommand sqlCommand = new SqlCommand();
            SqlConnection sqlConnection = new SqlConnection(SQLDataSource.ConnectionString);
            sqlCommand.Connection = sqlConnection;
            sqlCommand.CommandText = "USP_GetAllEmptyParkingSpaces";
            sqlCommand.CommandType = CommandType.StoredProcedure;

            try
            {
                using (sqlCommand.Connection)
                {
                    sqlCommand.Connection.Open();

                    using (SqlDataReader sqlDataReader = sqlCommand.ExecuteReader())
                    {
                        while (sqlDataReader.Read())
                        {
                            listOfEmptyParkingSpaces.Add(sqlDataReader.GetInt32(0));
                        }
                    }
                }
            }
            catch
            {
                Console.WriteLine("Something went wrong when trying to search for all empty parking spaces");
            }

            return listOfEmptyParkingSpaces;
        }
        /// <summary>
        /// Optimizes the vehicles of the parking lot and returns a bool if sucessfull.
        /// </summary>
        /// <returns></returns>
        public static bool OptimizeEntireParkingLot()
        {
            bool sucessfullOptimization = false;
            SqlCommand sqlCommand = new SqlCommand();
            SqlConnection sqlConnection = new SqlConnection(SQLDataSource.ConnectionString);
            sqlCommand.Connection = sqlConnection;
            sqlCommand.CommandText = "USP_OptimizeParking";
            sqlCommand.CommandType = CommandType.StoredProcedure;

            try
            {
                using (sqlCommand.Connection)
                {
                    sqlCommand.Connection.Open();

                    int result = sqlCommand.ExecuteNonQuery();

                    if (result > 0)
                    {
                        Console.WriteLine("The parkinglots vehicles was sucessfully optimized");
                        sucessfullOptimization = true;
                    }
                    else
                    {
                        Console.WriteLine("The optimization was not executed due to the parkinglot being already being optimized");
                    }
                }
            }
            catch
            {
                Console.WriteLine("Something went wrong when trying to search for all empty parking spaces");
            }

            return sucessfullOptimization;
        }
        /// <summary>
        /// Optimizes the MC's of the parking lot and returns a bool if sucessfull.
        /// </summary>
        /// <returns></returns>
        public static bool OptimizeParkedMC()
        {
            bool sucessfullOptimization = false;

            SqlCommand sqlCommand = new SqlCommand();
            SqlConnection sqlConnection = new SqlConnection(SQLDataSource.ConnectionString);
            sqlCommand.Connection = sqlConnection;
            sqlCommand.CommandText = "USP_OptimizeParkingMC";
            sqlCommand.CommandType = CommandType.StoredProcedure;

            try
            {
                using (sqlCommand.Connection)
                {
                    sqlCommand.Connection.Open();

                    int result = sqlCommand.ExecuteNonQuery();

                    if (result > 0)
                    {
                        Console.WriteLine("The parkinglots MC's was sucessfully optimized");
                        sucessfullOptimization = true;
                    }
                    else 
                    {
                        Console.WriteLine("The optimization was not executed due to the parkinglot being already being optimized");
                    }
                }
            }
            catch
            {
                Console.WriteLine("Something went wrong when trying to search for all empty parking spaces");
            }

            return sucessfullOptimization;
        }
        /// <summary>
        /// Calculates the income from a past date and up to today.<br/> Presenting it day by day.
        /// </summary>
        public static void CalculateIncomeDuringTodayAndPastDate()
        {
            SqlCommand sqlCommand = new SqlCommand();
            SqlConnection sqlConnection = new SqlConnection(SQLDataSource.ConnectionString);
            sqlCommand.Connection = sqlConnection;
            sqlCommand.CommandText = "USP_CalculateIncomeFromTodayToPastDate";
            sqlCommand.CommandType = CommandType.StoredProcedure;

            Console.WriteLine("Enter Date for the start search date: ");

            sqlCommand.Parameters.AddWithValue("@StartSearchDate", UserInputs.GetDateForIncomeView());

            Console.Clear();

            try
            {
                using (sqlCommand.Connection)
                {
                    sqlCommand.Connection.Open();

                    using (SqlDataReader sqlDataReader = sqlCommand.ExecuteReader())
                    {
                        Console.WriteLine("-Year-Month-Day---------Income per day-----");

                        while (sqlDataReader.Read())
                        {
                            Console.WriteLine("{0,-0}  -  {1,-20} ",sqlDataReader.GetDateTime(0), (int)sqlDataReader.GetDecimal(1));
                        }

                    }

                }
            }
            catch
            {
                Console.WriteLine("Something went wrong when trying to retrieve income history, try again or call software support");
            }
        }
        /// <summary>
        /// Calculates the income from a past date and another past date.<br/> Presenting it day by day.
        /// </summary>
        public static void CaluculateIncomeDuringPastDateAndPastDate()
        {
            SqlCommand sqlCommand = new SqlCommand();
            SqlConnection sqlConnection = new SqlConnection(SQLDataSource.ConnectionString);
            sqlCommand.Connection = sqlConnection;
            sqlCommand.CommandText = "USP_CalculateIncomeFromPastDateToPastDate";
            sqlCommand.CommandType = CommandType.StoredProcedure;

            Console.WriteLine("Enter Date for the start search date: ");

            sqlCommand.Parameters.AddWithValue("@StartSearchDate", UserInputs.GetDateForIncomeView());

            Console.WriteLine("Enter Date for the end search date: ");

            sqlCommand.Parameters.AddWithValue("@EndDate", UserInputs.GetDateForIncomeView());

            Console.Clear();

            try
            {
                using (sqlCommand.Connection)
                {
                    sqlCommand.Connection.Open();

                    using (SqlDataReader sqlDataReader = sqlCommand.ExecuteReader())
                    {
                        Console.WriteLine("-Year-Month-Day---------Income per day-----");

                        while (sqlDataReader.Read())
                        {
                            Console.WriteLine("{0,-0}  -  {1,-20} ", sqlDataReader.GetDateTime(0), (int)sqlDataReader.GetDecimal(1));
                        }

                    }

                }
            }
            catch
            {
                Console.WriteLine("Something went wrong when trying to retrieve income history, try again or call software support");
            }
        }        
        /// <summary>
        /// Gets the entire history of the parking lot. <br/>Which vehicles has been parked here and arrivaltime, checkout time and the amout paid.
        /// </summary>
        /// <returns></returns>
        public static List<Vehicle> SeeFullHistoryTable()
        {
            List<Vehicle> listOfVehicleInArchive = new List<Vehicle>();

            SqlCommand sqlCommand = new SqlCommand();
            SqlConnection sqlConnection = new SqlConnection(SQLDataSource.ConnectionString);
            sqlCommand.Connection = sqlConnection;
            sqlCommand.CommandText = "USP_GetFullParkingSpaceHistory";
            sqlCommand.CommandType = CommandType.StoredProcedure;

            try
            {
                using (sqlCommand.Connection)
                {
                    sqlCommand.Connection.Open();

                    using (SqlDataReader sqlDataReader = sqlCommand.ExecuteReader())
                    {
                        while (sqlDataReader.Read())
                        {
                            Vehicle vehicleInArchive = new Vehicle();
                            vehicleInArchive.registrationNumber = sqlDataReader.GetString(0);
                            vehicleInArchive.checkOutTime = Convert.ToDateTime(sqlDataReader.GetString(1));
                            vehicleInArchive.arrivalTime = Convert.ToDateTime(sqlDataReader.GetString(2));
                            vehicleInArchive.totalTimeParked = sqlDataReader.GetString(3);

                            listOfVehicleInArchive.Add(vehicleInArchive);
                        }
                    }
                }
            }
            catch
            {
                sqlCommand.Connection.Close();
                Console.WriteLine("Something went wrong when trying to acess parking space history");
            }

            return listOfVehicleInArchive;

        }


    }
}
