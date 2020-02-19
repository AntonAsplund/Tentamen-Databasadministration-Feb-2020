using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TentamenDatabasAntonAsplund
{
    class Vehicle
    {
        internal string registrationNumber { get; set; }
        internal string vehicleType { get; set; }
        internal int vehicleTypeID { get; set; }
        internal DateTime arrivalTime { get; set; }
        internal DateTime checkOutTime { get; set; }
        internal int totalCostForParking { get; set; }
        internal int currentParkingSpace { get; set; }
        internal int oldParkingSpace { get; set; }
        internal string totalTimeParked { get; set; }

        public Vehicle()
        {
            this.totalCostForParking = -1;
        }

        public Vehicle(string registrationNumber, string vehicleType, int vehicleTypeID, DateTime arrivalTime, DateTime checkOutTime, int totalCostForParking, int currentParkingSpace, int oldParkingSpace, string totalTimeParked)
        {
            this.registrationNumber = registrationNumber;
            this.vehicleType = vehicleType;
            this.vehicleTypeID = vehicleTypeID;
            this.arrivalTime = arrivalTime;
            this.checkOutTime = checkOutTime;
            this.totalCostForParking = -1;
            this.currentParkingSpace = currentParkingSpace;
            this.oldParkingSpace = oldParkingSpace;
            this.totalTimeParked = totalTimeParked;
        }
        /// <summary>
        /// Overrides the to string method and prints all info avaible on the vehicle object. <br/> Returns a string object.
        /// </summary>
        /// <returns></returns>
        public override string ToString()
        {
            string vehicleStringRepresentation = "";

            if (this.registrationNumber != null)
            {
                vehicleStringRepresentation +=" - Registration Number: " + this.registrationNumber + "\n";
            }
            if (this.vehicleType != null)
            {
                vehicleStringRepresentation +=" - Vehicle Type: " + this.vehicleType + "\n";
            }
            if (this.vehicleTypeID > 0)
            {
                vehicleStringRepresentation += " - Vehicle Type ID: " + this.vehicleTypeID + "\n";
            }
            if (this.arrivalTime > DateTime.MinValue.Add(TimeSpan.FromMinutes(10)))
            {
                vehicleStringRepresentation += " - Arrival time: " + this.arrivalTime.ToString("dd MMMM yyyy HH:mm:ss") + "\n";
            }
            if (this.checkOutTime > DateTime.MinValue.Add(TimeSpan.FromMinutes(10)))
            {
                vehicleStringRepresentation += " - Checkout time: " + this.checkOutTime.ToString("dd MMMM yyyy HH:mm:ss") + "\n";
            }
            if (this.totalCostForParking >= 0)
            {
                vehicleStringRepresentation += " - Total parking cost: " + this.totalCostForParking.ToString() + "\n";
            }
            if (this.currentParkingSpace != 0)
            {
                vehicleStringRepresentation += " - Current parkingspace: " + this.currentParkingSpace.ToString() + "\n";
            }
            if (this.oldParkingSpace != 0)
            {
                vehicleStringRepresentation += " - Old parkingspace: " + this.oldParkingSpace.ToString() + "\n";
            }
            if (this.totalTimeParked != null)
            {
                vehicleStringRepresentation += " - Total time parked: " + this.totalTimeParked.ToString() + "\n";
            }

            return vehicleStringRepresentation;
        }
    }
}
