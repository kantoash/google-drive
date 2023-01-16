// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// You can also run a script with `npx hardhat run <script>`. If you do that, Hardhat
// will compile your contracts, add the Hardhat Runtime Environment's members to the
// global scope, and execute the script.
const hre = require("hardhat");
const { verify } = require("../utils/verify")

async function main() {
  
  const Upload = await hre.ethers.getContractFactory('Upload');
  const upload = await Upload.deploy();
  await upload.deployed();

  if (process.env.ETHERSCAN_API_KEY) {
    console.log("verifying");
    await verify(upload.address,[])
  }
  console.log("Address goerli", upload.address); //0x1F88e1548D87d25d5AaBDEc19E8934BF7aC5aD47

}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
