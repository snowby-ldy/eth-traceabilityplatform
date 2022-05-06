// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

contract BAC {
    // Mapping from user address to boolean type
    mapping(address => bool) isAuthorized;

    // Define struct
    struct batch {
        string _productBatch;
        string _materialBatch;
        address _batchManager;
        address _TUCAddress;
        uint256 _addTime;
    }

    mapping(uint256 => batch) _batchs;

    mapping(string => address) _batchToAddress;

    mapping(address => string) _addressToBatch;

    uint256 _numberOfBatchs;

    address payable _productAdmin;

    // As a prerequisite for some functions
    modifier onlyAdmin() {
        require(msg.sender == _productAdmin);
        _;
    }

    modifier onlyAuthorized(address addr) {
        require(isAuthorized[addr] == true);
        _;
    }

    // Constructor function
    constructor() {
        _productAdmin = payable(msg.sender);
        _numberOfBatchs = 1;
    }

    // Add production batch information
    function addBatch(
        string memory productBatch,
        string memory materialBatch,
        address TUCAddress
    ) public onlyAuthorized(msg.sender) {
        require(_batchToAddress[productBatch] == address(0));
        require(bytes(_addressToBatch[TUCAddress]).length == 0);

        require(bytes(productBatch).length == 12);

        _batchs[_numberOfBatchs]._productBatch = productBatch;
        _batchs[_numberOfBatchs]._materialBatch = materialBatch;
        _batchs[_numberOfBatchs]._batchManager = msg.sender;
        _batchs[_numberOfBatchs]._TUCAddress = TUCAddress;
        _batchs[_numberOfBatchs]._addTime = block.timestamp;
        _batchToAddress[productBatch] = TUCAddress;

        _numberOfBatchs++;
    }

    // Get batch information by id
    function getBatchOfId(uint256 id)
        public
        view
        returns (
            string memory productBatch,
            string memory materialBatch,
            address batchManager,
            address TUCAddress,
            uint256 addTime
        )
    {
        productBatch = _batchs[id]._productBatch;
        materialBatch = _batchs[id]._materialBatch;
        batchManager = _batchs[id]._batchManager;
        TUCAddress = _batchs[id]._TUCAddress;
        addTime = _batchs[id]._addTime;
    }

    // Get the number of batches
    function getNumberOfBatchs() public view returns (uint256 numberOfBatchs) {
        numberOfBatchs = _numberOfBatchs - 1;
    }

    function getAddressOfBatch(string memory productBatch)
        public
        view
        returns (address addr)
    {
        addr = _batchToAddress[productBatch];
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
        selfdestruct(_productAdmin);
    }
}
