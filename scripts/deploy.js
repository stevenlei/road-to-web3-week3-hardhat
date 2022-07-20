const hre = require("hardhat");

async function main() {
  const ChainBattles = await hre.ethers.getContractFactory("ChainBattles");
  const chainBattles = await ChainBattles.deploy();
  await chainBattles.deployed();

  console.log(`Contract address: ${chainBattles.address}`);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
