// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title TransitPass
 * @notice Automates public transport pass purchase, automatic expiry tracking, and validation.
 */
contract TransitPass {
    address public owner;
    uint256 public passPrice = 0.01 ether; // Default price for a 30-day pass

    struct Pass {
        uint256 expiryTimestamp;
        bool isActive;
    }

    mapping(address => Pass) public userPasses;

    event PassPurchased(address indexed user, uint256 expiryTimestamp);
    event PassValidated(address indexed user, bool isValid, uint256 expiryTimestamp);
    event PriceUpdated(uint256 newPrice);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    /**
     * @notice Allows users to purchase or extend a 30-day transit pass.
     */
    function buyPass() external payable {
        require(msg.value == passPrice, "Incorrect Ether amount sent");
        
        uint256 currentExpiry = userPasses[msg.sender].expiryTimestamp;
        // If existing pass is still valid, extend from expiry; otherwise start from now
        uint256 startFrom = (currentExpiry > block.timestamp) ? currentExpiry : block.timestamp;
        
        userPasses[msg.sender].expiryTimestamp = startFrom + 30 days;
        userPasses[msg.sender].isActive = true;

        emit PassPurchased(msg.sender, userPasses[msg.sender].expiryTimestamp);
    }

    /**
     * @notice Validates whether a user has a currently active and non-expired transit pass.
     * @param _user The address of the passenger.
     */
    function validatePass(address _user) external returns (bool) {
        if (userPasses[_user].isActive && userPasses[_user].expiryTimestamp >= block.timestamp) {
            emit PassValidated(_user, true, userPasses[_user].expiryTimestamp);
            return true;
        } else {
            userPasses[_user].isActive = false;
            emit PassValidated(_user, false, userPasses[_user].expiryTimestamp);
            return false;
        }
    }

    function updatePrice(uint256 _newPrice) external onlyOwner {
        passPrice = _newPrice;
        emit PriceUpdated(_newPrice);
    }

    function withdraw() external onlyOwner {
        payable(owner).transfer(address(this).balance);
    }
}