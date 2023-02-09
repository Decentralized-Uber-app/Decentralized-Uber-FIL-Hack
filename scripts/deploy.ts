import { ethers } from "hardhat";

async function main() {

  const Uber = await ethers.getContractFactory("Uber");
  const uber = await Uber.deploy();

  await uber.deployed();

  console.log(`Ube contract has been deployed to ${uber.address}`);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
