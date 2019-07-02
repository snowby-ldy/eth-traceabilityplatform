pragma solidity ^ 0.4 .10;

contract TUC {

  mapping(address => bool) isAuthorized;

  struct tr {
    string _currentTx;
    string _previousTx;
    address _sender;
    string _receiver;
    uint _time;
  }

  mapping(uint => tr) trs;

  uint _numberOfTrs;

  address _batchAdmin;

  modifier onlyAdmin {
    require(msg.sender == _batchAdmin);
    _;
  }

  modifier onlyAuthorized(address addr) {
    require(isAuthorized[addr] == true);
    _;
  }

  //初始化
  constructor() public {
    _batchAdmin = msg.sender; //账户管理者部署该合约
    _numberOfTrs = 1;
  }

  //添加产品交易记录
  function addTr(string currentTx, string previousTx, string re) public onlyAuthorized(msg.sender) {

    trs[_numberOfTrs]._currentTx = currentTx;
    trs[_numberOfTrs]._previousTx = previousTx;
    trs[_numberOfTrs]._sender = msg.sender;
    trs[_numberOfTrs]._receiver = re;
    trs[_numberOfTrs]._time = now;

    _numberOfTrs++;

  }

  function getTrOfId(uint id) constant public returns(string currentTx, string previousTx, address se, string re, uint time) {
    currentTx = trs[id]._currentTx;
    previousTx = trs[id]._previousTx;
    se = trs[id]._sender;
    re = trs[id]._receiver;
    time = trs[id]._time;
  }

  //获取已注册产品数量
  function getNumberOfTrs() constant public returns(uint numberOfTrs) {
    numberOfTrs = _numberOfTrs - 1;
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
    selfdestruct(_batchAdmin);
  }

}
