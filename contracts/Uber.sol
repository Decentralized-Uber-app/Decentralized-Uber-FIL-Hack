// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "./proxiable.sol";
import "./AccessControlUpgradeable.sol";
contract Uber is Proxiable, Initializable {
     
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

}
