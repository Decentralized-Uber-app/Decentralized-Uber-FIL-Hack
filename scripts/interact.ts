import { ethers } from "hardhat";

async function main() {

  const Uber = await ethers.getContractFactory("Uber");
  const uber = await Uber.deploy();

  await uber.deployed();

  const uberinterract = await ethers.getContractAt("Uber", uber.address)

  const driversReg = await uberinterract.driversRegister("isaac", 20)

  console.log(`Uber contract has been deployed to ${uber.address}`);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
