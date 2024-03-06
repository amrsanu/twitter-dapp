const path = require("path");
const fs = require("fs");
const solc = require("solc");

const twitterPath = path.resolve(__dirname, "contracts", "Twitter.sol");
console.log(twitterPath);

const source = fs.readFileSync(twitterPath, "utf8");

const input = {
  language: "Solidity",
  sources: {
    "Twitter.sol": {
      content: source,
    },
  },
  settings: {
    outputSelection: {
      "*": {
        "*": ["*"],
      },
    },
  },
};

module.exports = JSON.parse(solc.compile(JSON.stringify(input))).contracts[
  "Twitter.sol"
].Twitter;

const compiledContract = JSON.parse(solc.compile(JSON.stringify(input)))
  .contracts["Twitter.sol"].Twitter;

// Extract the ABI from the compiled contract
const abi = compiledContract.abi;

// Save the ABI to a JSON file
fs.writeFileSync("./src/abi.json", JSON.stringify(abi, null, 2));