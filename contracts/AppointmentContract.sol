pragma solidity ^0.8.0;

contract AppointmentContract {
    struct Appointment {
        string location;
        string date;
        string time;
    }
    
    mapping(uint256 => Appointment) appointments;
    uint256 public appointmentCount;
    
    event AppointmentAdded(uint256 indexed appointmentId, string location, string date, string time);
    event AppointmentDeleted(uint256 indexed appointmentId);
    event AppointmentModified(uint256 indexed appointmentId, string location, string date, string time);
    
    function addAppointment(string memory _location, string memory _date, string memory _time) public {
        uint256 newAppointmentId = appointmentCount;
        Appointment storage newAppointment = appointments[newAppointmentId];
        newAppointment.location = _location;
        newAppointment.date = _date;
        newAppointment.time = _time;
        
        appointmentCount++;
        
        emit AppointmentAdded(newAppointmentId, _location, _date, _time);
    }
    
    function deleteAppointment(uint256 _appointmentId) public {
        require(_appointmentId < appointmentCount, "Invalid appointment ID");
        
        delete appointments[_appointmentId];
        
        emit AppointmentDeleted(_appointmentId);
    }
    
    function modifyAppointment(uint256 _appointmentId, string memory _location, string memory _date, string memory _time) public {
        require(_appointmentId < appointmentCount, "Invalid appointment ID");
        
        Appointment storage appointment = appointments[_appointmentId];
        appointment.location = _location;
        appointment.date = _date;
        appointment.time = _time;
        
        emit AppointmentModified(_appointmentId, _location, _date, _time);
    }
    
    function getAppointment(uint256 _appointmentId) public view returns (string memory, string memory, string memory) {
        require(_appointmentId < appointmentCount, "Invalid appointment ID");
        
        Appointment storage appointment = appointments[_appointmentId];
        return (appointment.location, appointment.date, appointment.time);
    }
}
