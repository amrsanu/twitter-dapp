const fs = require("fs");
const HDWalletProvider = require("@truffle/hdwallet-provider");
const { Web3 } = require("web3");
const { abi, evm } = require("./compile");

// deploy code will go here
const provider = new HDWalletProvider(
  "emotion obtain lock verify demand stick have wire seed brass caught winter",
  //   "https://goerli.infura.io/v3/bdfbdef428ed49dca4e9471871b42adf",
  "https://sepolia.infura.io/v3/bdfbdef428ed49dca4e9471871b42adf"
);

const web3 = new Web3(provider);

const DEFAULT_MESSAGE = "Hi, there!";
const deploy = async () => {
  const accounts = await web3.eth.getAccounts();
  console.log("Attempting to deploy from web3 account: ", accounts[0]);

  try {
    const result = await new web3.eth.Contract(abi)
      .deploy({ data: evm.bytecode.object })
      .send({ gas: "10000000", from: accounts[0] });
    console.log("Contract deployed successfully to : ", result.options.address);
    let config = JSON.parse(fs.readFileSync("/src/config.json"));
    config.contractAddress = result.options.address;
    // Save changes to config file
    fs.writeFileSync("config.json", JSON.stringify(config, null, 2));
  } catch (error) {
    console.error("An error occured: ", error);
  } finally {
    provider.engine.stop();
  }
};

deploy();
