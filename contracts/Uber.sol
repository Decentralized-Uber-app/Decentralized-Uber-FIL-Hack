// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "./proxiable.sol";
import "./AccessControlUpgradeable.sol";
contract Uber is Proxiable, Initializable {
     
    bytes32 public constant REVIEWER_ROLE = keccak256("REVIEWER_ROLE"); 
     
     // STATE VARIABLES //
    address admin;

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

}
