// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

contract PRC {
    // Mapping from user address to boolean type
    mapping(address => bool) isAuthorized;

    // Define struct
    struct product {
        string _productName;
        string _productCode;
        string _rawMaterials;
        address _productOwner;
        uint256 _timestamp;
        address _BACAddress;
    }

    mapping(uint256 => product) _products;

    mapping(string => uint256) _productCodeToId;

    uint256 _numberOfProducts;

    address payable _admin;

    mapping(string => string) _productCodeToName;
    mapping(string => address) _productCodeToBACAddress;

    // As a prerequisite for some functions
    modifier onlyAdmin() {
        require(msg.sender == payable(_admin));
        _;
    }

    modifier onlyAuthorized(address addr) {
        require(isAuthorized[addr] == true);
        _;
    }

    // Constructor function
    constructor() {
        _admin = payable(msg.sender);
        _numberOfProducts = 1;
    }

    // Register product information
    function productRegister(
        string memory productName,
        string memory productCode,
        string memory rawMaterials,
        address BACAddress
    ) public onlyAuthorized(msg.sender) {
        require(bytes(_productCodeToName[productCode]).length == 0);

        require(
            bytes(productName).length >= 3 && bytes(productName).length <= 64
        );
        require(bytes(productCode).length == 13);
        require(bytes(rawMaterials).length >= 9);

        _productCodeToName[productCode] = productName;
        _productCodeToId[productCode] = _numberOfProducts;
        _productCodeToBACAddress[productCode] = BACAddress;

        _products[_numberOfProducts]._productName = productName;
        _products[_numberOfProducts]._productCode = productCode;
        _products[_numberOfProducts]._rawMaterials = rawMaterials;
        _products[_numberOfProducts]._productOwner = msg.sender;
        _products[_numberOfProducts]._timestamp = block.timestamp;
        _products[_numberOfProducts]._BACAddress = BACAddress;

        _numberOfProducts++;
    }

    // Register raw material information
    function materialRegister(
        string memory materialName,
        string memory materialCode,
        address BACAddress
    ) public onlyAuthorized(msg.sender) {
        require(bytes(_productCodeToName[materialCode]).length == 0);

        require(
            bytes(materialName).length >= 3 && bytes(materialName).length <= 64
        );
        require(bytes(materialCode).length == 9);

        _productCodeToName[materialCode] = materialName;
        _productCodeToId[materialCode] = _numberOfProducts;
        _productCodeToBACAddress[materialCode] = BACAddress;

        _products[_numberOfProducts]._productName = materialName;
        _products[_numberOfProducts]._productCode = materialCode;
        _products[_numberOfProducts]._rawMaterials = "/";
        _products[_numberOfProducts]._productOwner = msg.sender;
        _products[_numberOfProducts]._timestamp = block.timestamp;
        _products[_numberOfProducts]._BACAddress = BACAddress;

        _numberOfProducts++;
    }

    // Get the number of products
    function getNumberOfProducts()
        public
        view
        returns (uint256 numberOfProducts)
    {
        numberOfProducts = _numberOfProducts - 1;
    }

    // Get product information by id
    function getProductOfId(uint256 id)
        public
        view
        returns (
            string memory productName,
            string memory productCode,
            string memory rawMaterials,
            address productOwner,
            uint256 timestamp,
            address BACAddress
        )
    {
        productName = _products[id]._productName;
        productCode = _products[id]._productCode;
        rawMaterials = _products[id]._rawMaterials;
        productOwner = _products[id]._productOwner;
        timestamp = _products[id]._timestamp;
        BACAddress = _products[id]._BACAddress;
    }

    function getIdOfCode(string memory productCode)
        public
        view
        returns (uint256 id)
    {
        id = _productCodeToId[productCode];
    }

    function getAddressOfCode(string memory productCode)
        public
        view
        returns (address addr)
    {
        addr = _productCodeToBACAddress[productCode];
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
        selfdestruct(_admin);
    }
}
