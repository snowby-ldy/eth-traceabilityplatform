// Deployed PRC contract address
var prcAddress = "0x9bdb8bcb4eb5ce1fbaf696159aec85f51491992c";
var newBAC;
var newTUC;
var bacAddress;
var tucAddress;

var defaultGas = 4700000;

// Register Product
function productRegister() {
  var prcInstance;
  var productName = $("#productNameA").val();
  var productCode = $("#productCodeA").val();
  var rawMaterials = $("#rawMaterialsA").val();
  BAC.new({
    from: web3.eth.accounts[0],
    gas: defaultGas
  }).then(function(instance) {
    newBAC = instance.address;
  }).then(function() {
    PRC.at(prcAddress).then(function(instance) {
      prcInstance = instance;
      return prcInstance.productRegister(productName, productCode, rawMaterials, newBAC, {
        from: web3.eth.accounts[0],
        gas: defaultGas
      });
    }).then(function(txReceipt) {
      console.info(txReceipt);
      showAllRegister();
      $("#productNameA").val('');
      $("#productCodeA").val('');
      $("#rawMaterialsA").val('');
    });
  });
}

// Register raw material
function materialRegister() {
  var prcInstance;
  var materialName = $("#materialNameA").val();
  var materialCode = $("#materialCodeA").val();
  BAC.new({
    from: defaultAccount,
    gas: defaultGas
  }).then(function(instance) {
    newBAC = instance.address;
  }).then(function() {
    PRC.at(prcAddress).then(function(instance) {
      prcInstance = instance;
      return prcInstance.materialRegister(materialName, materialCode, newBAC, {
        from: defaultAccount,
        gas: defaultGas
      });
    }).then(function(txReceipt) {
      console.info(txReceipt);
      showAllRegister();
      $("#materialNameA").val('');
      $("#materialCodeA").val('');
    });
  });
}

// Get product information by id
function getRegisterProduct(id) {
  return PRC.at(prcAddress).then(function(instance) {
    prcInstance = instance;
    return prcInstance.getProductOfId.call(id).then(function(product) {
      return {
        id: id,
        name: product[0],
        code: product[1],
        materials: product[2],
        owner: product[3],
        time: product[4],
        addr: product[5]
      }
    })
  });
}

// The number of all registered products on the platform
function getTotalRegisterProduct() {
  return PRC.at(prcAddress).then(function(instance) {
    prcInstance = instance;
    return prcInstance.getNumberOfProducts.call()
  }).then(function(total) {
    return total;
  });
}

// All registered products of the platform
async function getAllRegister() {
  let products = [];
  let total = await getTotalRegisterProduct();
  for (let i = 1; i <= total; i++) {
    let product = await getRegisterProduct(i);
    products.push(product);
  }
  return products;
}

// Show all registered products on the page
function showAllRegister() {
  getAllRegister().then(function(list) {
    $("#productListA").html('');
    list.forEach(function(item, index) {
      $("#productListA").append("<tr><td>" + item.id + "</td><td>" + item.code + "</td><td>" + item.name + "</td><td>" + item.materials + "</td><td>" + item.owner + "</td><td>" + item.addr + "</td><td>" + item.time + "</td></tr>");
    });
  })
}

// Add user
function addPRCUser() {
  var prcInstance;
  var userAddress = $("#userAddressA").val();
  PRC.at(prcAddress).then(function(instance) {
    prcInstance = instance;
    return prcInstance.addUser(userAddress, {
      from: web3.eth.accounts[0],
      gas: defaultGas
    });
  }).then(function(txReceipt) {
    console.info(txReceipt);
    $("#userAddressA").val('');
  });
}

// Remove user
function removePRCUser() {
  var prcInstance;
  var userAddress = $("#userAddressA").val();
  PRC.at(prcAddress).then(function(instance) {
    prcInstance = instance;
    return prcInstance.removeUser(userAddress, {
      from: web3.eth.accounts[0],
      gas: defaultGas
    });
  }).then(function(txReceipt) {
    console.info(txReceipt);
    $("#userAddressA").val('');
  });
}

// Check user
function checkPRCUser() {
  var prcInstance;
  var userAddress = $("#userAddressA").val();
  return PRC.at(prcAddress).then(function(instance) {
    prcInstance = instance;
    return prcInstance.checkUser.call(userAddress);
  }).then(function(result) {
    $("#checkResultA").html(result.toString());
  });
}

// Platform information
function getPlantformInfo() {
  $("#plantformAddressA").html(prcAddress);
}

function getProductOfCode() {
  var productCode = $("#productCodeB").val();
  var id;
  return PRC.at(prcAddress).then(function(instance) {
    prcInstance = instance;
    return prcInstance.getIdOfCode.call(productCode);
  }).then(function(idd) {
    id = idd;
    return prcInstance.getProductOfId.call(id);
  }).then(function(product) {
    bacAddress = product[5];
    $("#productNameB").html(product[0]);
    $("#rawMaterialsB").html(product[2]);
    $("#memberAddressB").html(product[3]);
    $("#registryTimeB").html(product[4].toString());
    $("#productAddressB").html(product[5]);
    showAllBatch();
  });
}

// Add batch information
function addBatch() {
  var bacInstance;
  var productBatch = $("#productBatchB").val();
  var materialBatch = $("#materialBatchB").val();
  TUC.new({
    from: web3.eth.accounts[0],
    gas: defaultGas
  }).then(function(instance) {
    newTUC = instance.address;
  }).then(function() {
    BAC.at(bacAddress).then(function(instance) {
      bacInstance = instance;
      return bacInstance.addBatch(productBatch, materialBatch, newTUC, {
        from: web3.eth.accounts[0],
        gas: defaultGas
      });
    }).then(function(txReceipt) {
      console.info(txReceipt);
      showAllBatch();
      $("#productBatchB").val('');
      $("#materialBatchB").val('');
    });
  });
}

function getBatch(id) {
  return BAC.at(bacAddress).then(function(instance) {
    bacInstance = instance;
    return bacInstance.getBatchOfId.call(id).then(function(batch) {
      return {
        id: id,
        batch: batch[0],
        materials: batch[1],
        manager: batch[2],
        addr: batch[3],
        time: batch[4]
      }
    })
  });
}

// The number of all added batches
function getTotalProductBatch() {
  return BAC.at(bacAddress).then(function(instance) {
    bacInstance = instance;
    return bacInstance.getNumberOfBatchs.call()
  }).then(function(total) {
    return total;
  });
}

// All added batches
async function getAllBatch() {
  let batchs = [];
  let total = await getTotalProductBatch();
  for (let i = 1; i <= total; i++) {
    let batch = await getBatch(i);
    batchs.push(batch);
  }
  return batchs;

}

// Show all added batches on the page
function showAllBatch() {
  getAllBatch().then(function(list) {
    $("#batchListB").html('');
    list.forEach(function(item, index) {
      $("#batchListB").append("<tr><td>" + item.id + "</td><td>" + item.batch + "</td><td>" + item.materials + "</td><td>" + item.manager + "</td><td>" + item.addr + "</td><td>" + item.time + "</td></tr>");
    });
  })
}

function addBACUser() {
  var bacInstance;
  var userAddress = $("#userAddressB").val();
  BAC.at(bacAddress).then(function(instance) {
    bacInstance = instance;
    return bacInstance.addUser(userAddress, {
      from: web3.eth.accounts[0],
      gas: defaultGas
    });
  }).then(function(txReceipt) {
    console.info(txReceipt);
    $("#userAddressB").val('');
  });
}

function removeBACUser() {
  var bacInstance;
  var userAddress = $("#userAddressB").val();
  BAC.at(bacAddress).then(function(instance) {
    bacInstance = instance;
    return bacInstance.removeUser(userAddress, {
      from: web3.eth.accounts[0],
      gas: defaultGas
    });
  }).then(function(txReceipt) {
    console.info(txReceipt);
    $("#userAddressB").val('');
  });
}

function checkBACUser() {
  var bacInstance;
  var userAddress = $("#userAddressB").val();
  return BAC.at(bacAddress).then(function(instance) {
    bacInstance = instance;
    return bacInstance.checkUser.call(userAddress);
  }).then(function(result) {
    $("#checkResultB").html(result.toString());
  });
}

function getProductInfo() {
  $("#productNameB").html('');
  $("#rawMaterialsB").html('');
  $("#memberAddressB").html('');
  $("#registryTimeB").html('');
  $("#productAddressB").html('');
}

function getTrOfCodeAndBatch() {
  var productCode = $("#productCodeC").val();
  var productBatch = $("#productBatchC").val();
  var addr;
  return PRC.at(prcAddress).then(function(instance) {
    prcInstance = instance;
    return prcInstance.getAddressOfCode.call(productCode);
  }).then(function(a) {
    addr = a;
    return BAC.at(addr).then(function(instance) {
      bacInstance = instance;
      return bacInstance.getAddressOfBatch.call(productBatch);
    }).then(function(b) {
      tucAddress = b;
      $("#batchAddressC").html(b);
      showAllTr();
    });
  });
}

// Update transaction information
function addTr() {
  var tucInstance;
  var referenceTx = $("#referenceTxC").val();
  var re = ($("#receiverC").val()).toString();
  var currentTx = web3.eth.sendTransaction({
    from: web3.eth.accounts[0],
    to: re,
    gas: defaultGas
  });
  TUC.at(tucAddress).then(function(instance) {
    tucInstance = instance;
    return tucInstance.addTr(currentTx, referenceTx, re, {
      from: web3.eth.accounts[0],
      gas: defaultGas
    });
  }).then(function(txReceipt) {
    console.info(txReceipt);
    showAllTr();
    $("#referenceTxC").val('');
    $("#receiverC").val('');
  });
}

function getTr(id) {
  return TUC.at(tucAddress).then(function(instance) {
    tucInstance = instance;
    return tucInstance.getTrOfId.call(id).then(function(tr) {
      return {
        id: id,
        currentTx: tr[0],
        referenceTx: tr[1],
        se: tr[2],
        re: tr[3],
        time: tr[4]
      }
    })
  });
}

// The number of all updated transactions
function getTotalProductTr() {
  return TUC.at(tucAddress).then(function(instance) {
    tucInstance = instance;
    return tucInstance.getNumberOfTrs.call()
  }).then(function(total) {
    return total;
  });
}

// All updated transactions
async function getAllTr() {
  let trs = [];
  let total = await getTotalProductTr();
  for (let i = 1; i <= total; i++) {
    let tr = await getTr(i);
    trs.push(tr);
  }
  return trs;
}

// Show all updated transactions on the page
function showAllTr() {
  getAllTr().then(function(list) {
    $("#transactionListC").html('');
    list.forEach(function(item, index) {
      $("#transactionListC").append("<tr><td>" + item.id + "</td><td>" + item.currentTx + "</td><td>" + item.referenceTx + "</td><td>" + item.se + "</td><td>" + item.re + "</td><td>" + item.time + "</td></tr>");
    });
  })
}

function addTUCUser() {
  var tucInstance;
  var userAddress = $("#userAddressC").val();
  TUC.at(tucAddress).then(function(instance) {
    tucInstance = instance;
    return tucInstance.addUser(userAddress, {
      from: web3.eth.accounts[0],
      gas: defaultGas
    });
  }).then(function(txReceipt) {
    console.info(txReceipt);
    $("#userAddressC").val('');
  });
}

function removeTUCUser() {
  var tucInstance;
  var userAddress = $("#userAddressC").val();
  TUC.at(tucAddress).then(function(instance) {
    tucInstance = instance;
    return tucInstance.removeUser(userAddress, {
      from: web3.eth.accounts[0],
      gas: defaultGas
    });
  }).then(function(txReceipt) {
    console.info(txReceipt);
    $("#userAddressC").val('');
  });
}

function checkTUCUser() {
  var tucInstance;
  var userAddress = $("#userAddressC").val();
  return TUC.at(tucAddress).then(function(instance) {
    tucInstance = instance;
    return tucInstance.checkUser.call(userAddress);
  }).then(function(result) {
    $("#checkResultC").html(result.toString());
  });
}

function getBatchAddress() {
  $("#batchAddressC").html('');
}

// Loading page
window.onload = function() {

  getPlantformInfo();
  showAllRegister();

  $("#home_tab").click(function(e) {
    e.preventDefault();
    getPlantformInfo();
    showAllRegister();
  })

  $("#product_tab").click(function(e) {
    e.preventDefault();
    getProductInfo();
  })

  $("#account_tab").click(function(e) {
    e.preventDefault();
    getBatchAddress();
  })

  $("#registerProductBtnA").click(function() {
    productRegister();
  });

  $("#registerMaterialBtnA").click(function() {
    materialRegister();
  });

  $("#addBtnA").click(function() {
    addPRCUser();
  });

  $("#removeBtnA").click(function() {
    removePRCUser();
  });

  $("#checkBtnA").click(function() {
    checkPRCUser();
  });

  $("#okBtnB").click(function() {
    getProductOfCode();
  });

  $("#updateBtnB").click(function() {
    addBatch();
  });

  $("#addBtnB").click(function() {
    addBACUser();
  });

  $("#removeBtnB").click(function() {
    removeBACUser();
  });

  $("#checkBtnB").click(function() {
    checkBACUser();
  });

  $("#okBtnC").click(function() {
    getTrOfCodeAndBatch();
  });

  $("#addBtnC").click(function() {
    addTr();
  });

  $("#addUserBtnC").click(function() {
    addTUCUser();
  });

  $("#removeBtnC").click(function() {
    removeTUCUser();
  });

  $("#checkBtnC").click(function() {
    checkTUCUser();
  });

};
