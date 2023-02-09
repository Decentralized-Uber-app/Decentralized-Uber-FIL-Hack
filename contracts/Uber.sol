// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "./proxiable.sol";
import "./AccessControlUpgradeable.sol";
import "./DriverVault.sol";
import "./PassengerVault.sol";

contract Uber is Initializable, AccessControlUpgradeable, Proxiable {
     
    bytes32 public constant REVIEWER_ROLE = keccak256("REVIEWER_ROLE"); 
     
     // STATE VARIABLES //
    address admin;
    address[] driversAddress;
    address[] driverReviewers;
    address[] passengersAddress;
    address[] approvedDrivers;
    address tokenAddress;
    uint public driveFeePerTime;
    uint public driveFeePerDistance;

    uint public rideCount;

    function constructor1(address _tokenAddress) public {
        require(admin == address(0), "Already initalized");
        admin = msg.sender;
         tokenAddress = _tokenAddress;
    }

     function initialize() public initializer {
        require(msg.sender == admin, "not admin");

        __AccessControl_init();
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _grantRole(REVIEWER_ROLE, msg.sender);
    }

     function updateCode(address newCode) onlyOwner public {
        updateCodeAddress(newCode);
    }

     function encode(address _tokenAddress) external pure returns (bytes memory) {
        return abi.encodeWithSignature("constructor1(address)", _tokenAddress);
    }

    struct DriverDetails{
        address driversAddress;
        string driversName;
        uint112 driversLicenseIdNo;
        bool registered;
        bool approved;
        bool rideRequest; // When a user request for ride
        bool acceptRide; // Driver accepts requested
        bool booked; // When driver accepts ride
        uint timePicked;
        uint successfulRide;
        address currentPassenger;
        DriverVault vaultAddress;
    }

       struct PassengerDetails{
        address passengerAddress;
        bool registered;
        bool ridepicked;
        PassengerVault vaultAddress;
    }

    mapping(address => DriverDetails) driverDetails;
    mapping(address => PassengerDetails) passengerDetails;

      ///////////DRIVERS //////////
    function driversRegister(string memory _drivername, uint112 _driversLicenseIdNo) public {
        DriverDetails storage dd = driverDetails[msg.sender];
        require(dd.registered == false, "already registered");
        dd.driversAddress = msg.sender;
        dd.driversName = _drivername;
        dd.registered = true;
        dd.driversLicenseIdNo = _driversLicenseIdNo;
        driversAddress.push(msg.sender); 
    }

    function reviewDriver(address _driversAddress) public onlyRole(REVIEWER_ROLE){
        DriverDetails storage dd = driverDetails[_driversAddress];
        require(dd.driversAddress == _driversAddress, "Driver not registered");
        require(dd.approved == false, "driver already approved");
        dd.approved = true;

        // deploy a new driver vault contract for the driver whose address is passed
        DriverVault newVault = new DriverVault(_driversAddress, tokenAddress);
        dd.vaultAddress = newVault;
    }

    function isUserInRide (address _owner) public view returns (bool rideOngoing) {
        PassengerDetails memory pd = passengerDetails[_owner];
        rideOngoing = pd.ridepicked;
    }
    function viewAllDrivers () external view returns(address[] memory) {
        return driversAddress;
    }

    function changeTokenAddress(address _newTokenAddress) external onlyRole(DEFAULT_ADMIN_ROLE){
        tokenAddress = _newTokenAddress;
    }

    modifier onlyOwner() {
        require(msg.sender == admin, "Only owner is allowed to perform this action");
        _;
    }

}
