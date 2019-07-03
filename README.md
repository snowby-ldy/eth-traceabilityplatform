安装教程：

1. testRPC安装

   我们使用testrpc作为项目的测试链，首先运行以下命令安装testrpc

   ```
   $ npm install -g ethereumjs-testrpc
   ```

   安装完成后启动testrpc，执行以下命令

   ```
   $ testrpc -m 'silver village coyote camera write pact bomb skirt rabbit visit forget account'

   EthereumJS TestRPC v6.0.3 (ganache-core: 2.0.2)

   Available Accounts
   ==================
   (0) 0x6267b256ebc4988a7e26abc12c220c5b44a0199b
   (1) 0xc0705e2340db639d7bfc2f1fe1cdd3eba28ff0e4
   (2) 0x32cde197955db7220e7dd3dfe8263bed1436d192
   (3) 0x69aec06dbdccd0918253e2dcbd05677ce1270013
   (4) 0x38c20b926b2ba14c7575f97c824205e55c6e0d2a
   (5) 0x3a07e91d363a53abc745c041a129e6973cd5c89b
   (6) 0xdde6cd68c2c09c7619bc0aca12944f1f635608a0
   (7) 0x2bbc15cd0866d8706d9913d3133b52b50c1f9255
   (8) 0xca77439aaddb717f30f0192d869f26141ef3c644
   (9) 0xaa4e3cd7207ff2aad0132878af8ac1eef3b1da63

   Private Keys
   ==================
   (0) c22d6c938c1d0305ef4db54bec3ec1d5da92ac53be5330089a2228b505c0828f
   (1) 16ab014530a26384c26856babee04541bae03a64b47df32054b0659c7241e561
   (2) 26d07a3d1c96ceb60993ab4abd050ff4524dab8358f7a755ca47a8f962512b57
   (3) fdfb552c8498b7335319173b3b6e5b5bc3399bb4c16e60368bbb6f94d656f765
   (4) c5f6b1c8fbe29b6488b901ef9fdff6283e2fb93a06a647fbe66f3806a5eef27c
   (5) 22dc2c84ebb0399ab8017b110c6e4a8be9defa5e993ec2ae9a5c7092b7e24b0c
   (6) 4d8ff76ea1925c31d2716f20697d31b279b771f9e11ddcb361932841d943fe7c
   (7) bc78779383c558c2848bb349b81c4794228a7932dfe4a3ff564346e3b2f26acb
   (8) 70a44e91c0876225fc8707e48b88582ac4bd79cffa7a48b22f22ee0dbf00bc86
   (9) 31748cb27dec6cbc53b35620085fe9d40ccdf86b51ab966072f3805451c512d2

   HD Wallet
   ==================
   Mnemonic:      silver village coyote camera write pact bomb skirt rabbit visit forget account
   Base HD Path:  m/44'/60'/0'/0/{account_index}

   Listening on localhost:8545
   ```

2. 部署合约

   进入 eth-traceabilityplatform 目录

   ```
   $ cd eth-traceabilityplatform
   ```

   安装依赖

   ```
   $ npm install
   ```

   部署合约

   ```
   $ truffle migrate

   Using network 'development'.

   Running migration: 1_initial_migration.js
     Deploying Migrations...
     ... 0x0eafef042f678fb8faa504e87cada19405249e6ae3de93ded4f7ef56f1678991
     Migrations: 0x936495d24f8fca6117550045a4857fe9c473f867
   Saving successful migration to network...
     ... 0x11ad6613b9158ba397feb2a2b421460ab0eae8743a23e6bb6be72e308fbf67ad
   Saving artifacts...
   Running migration: 2_prc_migration.js
     Deploying PRC...
     ... 0x2b5af9c81df7bc74bd49ca4a927ed69e79837e2663e83a47b80532ae87160d05
     PRC: 0x9bdb8bcb4eb5ce1fbaf696159aec85f51491992c
   Saving successful migration to network...
     ... 0x48d8a8ac3facf98a9391a29796c8ea9c62f9c3f0367ee399a9e4aa71cdd792fe
   Saving artifacts...
   ```

   合约部署完成后就可以开始调用界面了

3. 运行 eth-traceabilityplatform Dapps

   首先进入`build/`目录

   ```
   cd ./build
   ```

   在浏览器打开 build/index.html 页面，就可以开始体验 eth-traceabilityplatform 了！
