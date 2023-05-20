pragma solidity ^0.8.0;

contract AppointmentContract {
    struct Appointment {
        string location;
        string date;
        string time;
        bool exists;
        bool isMet;
        address alice;
        address bob;
        mapping(address => bool) consent;
        mapping(address => bool) depositRefunded;
    }

    mapping(address => Appointment) appointments;
    uint256 public appointmentCount;
    uint256 public depositAmount;

    event AppointmentCreated(address receiver, string location, string date, string time);
    event AppointmentConsented(address receiver, address indexed participant, uint256 depositAmount);
    event DepositRefunded(address receiver, address indexed participant, uint256 depositAmount);


    constructor(uint256 _depositAmount) {
        depositAmount = _depositAmount;
    }

    function createAppointment(address receiver, string memory _location, string memory _date, string memory _time) public {
        Appointment storage newAppointment = appointments[receiver];
        newAppointment.location = _location;
        newAppointment.date = _date;
        newAppointment.time = _time;
        newAppointment.exists = true;
        newAppointment.consent[receiver]=false;
        newAppointment.consent[msg.sender]=false;
        newAppointment.isMet=false;
        newAppointment.alice=msg.sender;
        newAppointment.bob=receiver;

        appointmentCount++;

        emit AppointmentCreated(receiver, _location, _date, _time);
    }

    function giveConsent(address receiver) public payable {
        Appointment storage appointment = appointments[receiver];
        require(appointment.exists, "Appointment does not exist");
        require(!appointment.consent[msg.sender], "Already given consent");
        require(msg.value >= depositAmount, "Insufficient deposit amount");

        appointment.consent[msg.sender] = true;

        emit AppointmentConsented(receiver, msg.sender, msg.value);
    }

    function refundDeposit(address receiver) public {
        Appointment storage appointment = appointments[receiver];
        require(appointment.exists, "Appointment does not exist");
        require(appointment.isMet,"Havn't met");
        require(appointment.consent[msg.sender],"Me Haven't Deposit");
        require(appointment.consent[receiver],"Other Haven't Deposit");
        require(!appointment.depositRefunded[msg.sender], "Me Deposit already refunded");
        require(!appointment.depositRefunded[receiver], "Other Deposit already refunded");

        if (depositAmount > 0) {
            appointment.depositRefunded[msg.sender] = true;
            appointment.depositRefunded[receiver] = true;
            payable(msg.sender).transfer(depositAmount);
            payable(appointment.bob).transfer(depositAmount);
            emit DepositRefunded(receiver, msg.sender, depositAmount);
        }
    }

    function verifyMeet(address receiver) public {
        Appointment storage appointment = appointments[receiver];
        require(appointment.exists, "Appointment does not exist");
        appointment.isMet=true;
    }

    function getIsMet(address receiver)external view returns (bool){
        Appointment storage appointment = appointments[receiver];
        require(appointment.exists, "Appointment does not exist");
        
        return appointment.isMet;
    }

    function getAppointmentCount()external view returns (uint256){
        return appointmentCount;
    }

}
