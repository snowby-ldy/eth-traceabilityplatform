// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

contract TUC {
    // Mapping from user address to boolean type
    mapping(address => bool) isAuthorized;

    // Define struct
    struct tr {
        string _currentTx;
        string _previousTx;
        address _sender;
        string _receiver;
        uint256 _time;
    }

    mapping(uint256 => tr) trs;

    uint256 _numberOfTrs;

    address payable _batchAdmin;

    // As a prerequisite for some functions
    modifier onlyAdmin() {
        require(msg.sender == _batchAdmin);
        _;
    }

    modifier onlyAuthorized(address addr) {
        require(isAuthorized[addr] == true);
        _;
    }

    // Constructor function
    constructor() {
        _batchAdmin = payable(msg.sender);
        _numberOfTrs = 1;
    }

    // Update transaction information
    function addTr(
        string memory currentTx,
        string memory previousTx,
        string memory re
    ) public onlyAuthorized(msg.sender) {
        trs[_numberOfTrs]._currentTx = currentTx;
        trs[_numberOfTrs]._previousTx = previousTx;
        trs[_numberOfTrs]._sender = msg.sender;
        trs[_numberOfTrs]._receiver = re;
        trs[_numberOfTrs]._time = block.timestamp;

        _numberOfTrs++;
    }

    // Get transaction information by id
    function getTrOfId(uint256 id)
        public view
        returns (
            string memory currentTx,
            string memory previousTx,
            address se,
            string memory re,
            uint256 time
        )
    {
        currentTx = trs[id]._currentTx;
        previousTx = trs[id]._previousTx;
        se = trs[id]._sender;
        re = trs[id]._receiver;
        time = trs[id]._time;
    }

    // Get the number of transactions
    function getNumberOfTrs() public view returns (uint256 numberOfTrs) {
        numberOfTrs = _numberOfTrs - 1;
    }

    // Add user to authorization list
    function addUser(address addr) public onlyAdmin {
        isAuthorized[addr] = true;
    }

    // Remove user
    function removeUser(address addr) public onlyAdmin {
        isAuthorized[addr] = false;
    }

    // Check if the user is authorized
    function checkUser(address addr) public view returns (bool result) {
        result = isAuthorized[addr];
    }

    // Destroy the contract
    function deleteContract() public onlyAdmin {
        selfdestruct(_batchAdmin);
    }
}
