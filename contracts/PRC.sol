pragma solidity ^ 0.4 .10;

contract PRC {

  mapping(address => bool) isAuthorized;

  //定义产品结构体
  struct product {
    string _productName;
    string _productCode;
    string _rawMaterials;
    address _productOwner;
    uint _timestamp;
    address _BACAddress;
  }

  //产品Id映射到产品
  mapping(uint => product) _products;

  mapping(string => uint) _productCodeToId;

  //定义注册的产品数量
  uint _numberOfProducts;

  //定义平台管理者
  address _admin;

  mapping(string => string) _productCodeToName;
  mapping(string => address) _productCodeToBACAddress;

  //定义修饰符，作为某些功能的先决条件
  modifier onlyAdmin {
    require(msg.sender == _admin);
    _;
  }

  modifier onlyAuthorized(address addr) {
    require(isAuthorized[addr] == true);
    _;
  }

  //构造函数
  constructor() public {
    _admin = msg.sender; //平台管理者部署该合约
    _numberOfProducts = 1;
  }

  //注册产品
  function productRegister(string productName, string productCode, string rawMaterials, address BACAddress) public onlyAuthorized(msg.sender) {

    require(bytes(_productCodeToName[productCode]).length == 0);

    require(bytes(productName).length >= 3 && bytes(productName).length <= 64);
    require(bytes(productCode).length == 13);
    require(bytes(rawMaterials).length >= 9);

    _productCodeToName[productCode] = productName;
    _productCodeToId[productCode] = _numberOfProducts;
    _productCodeToBACAddress[productCode] = BACAddress;

    _products[_numberOfProducts]._productName = productName;
    _products[_numberOfProducts]._productCode = productCode;
    _products[_numberOfProducts]._rawMaterials = rawMaterials;
    _products[_numberOfProducts]._productOwner = msg.sender;
    _products[_numberOfProducts]._timestamp = now;
    _products[_numberOfProducts]._BACAddress = BACAddress;

    _numberOfProducts++;

  }

  //注册原料
  function materialRegister(string materialName, string materialCode, address BACAddress) public onlyAuthorized(msg.sender) {

    require(bytes(_productCodeToName[materialCode]).length == 0);

    require(bytes(materialName).length >= 3 && bytes(materialName).length <= 64);
    require(bytes(materialCode).length == 9);

    _productCodeToName[materialCode] = materialName;
    _productCodeToId[materialCode] = _numberOfProducts;
    _productCodeToBACAddress[materialCode] = BACAddress;

    _products[_numberOfProducts]._productName = materialName;
    _products[_numberOfProducts]._productCode = materialCode;
    _products[_numberOfProducts]._rawMaterials = "/";
    _products[_numberOfProducts]._productOwner = msg.sender;
    _products[_numberOfProducts]._timestamp = now;
    _products[_numberOfProducts]._BACAddress = BACAddress;

    _numberOfProducts++;

  }

  //获取已注册产品数量
  function getNumberOfProducts() constant public returns(uint numberOfProducts) {
    numberOfProducts = _numberOfProducts - 1;
  }

  function getProductOfId(uint id) constant public returns(string productName, string productCode, string rawMaterials, address productOwner, uint timestamp, address BACAddress) {

    productName = _products[id]._productName;
    productCode = _products[id]._productCode;
    rawMaterials = _products[id]._rawMaterials;
    productOwner = _products[id]._productOwner;
    timestamp = _products[id]._timestamp;
    BACAddress = _products[id]._BACAddress;
  }

  function getIdOfCode(string productCode) constant public returns(uint id) {
    id = _productCodeToId[productCode];
  }

  function getAddressOfCode(string productCode) constant public returns(address addr) {
    addr = _productCodeToBACAddress[productCode];
  }

  function addUser(address addr) public onlyAdmin {
    isAuthorized[addr] = true;
  }

  function removeUser(address addr) public onlyAdmin {
    isAuthorized[addr] = false;
  }

  function checkUser(address addr) constant public returns(bool result) {
    result = isAuthorized[addr];
  }

  //摧毁合约
  function deleteContract() public onlyAdmin {
    selfdestruct(_admin);
  }

}
