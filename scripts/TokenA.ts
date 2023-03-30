import { HardhatRuntimeEnvironment } from "hardhat/types";
import { DeployFunction } from "hardhat-deploy/types";

const func: DeployFunction = async function (hre: HardhatRuntimeEnvironment) {
  const { deployments, getNamedAccounts } = hre;
  const { deploy } = deployments;

  const { deployer } = await getNamedAccounts();

  await deploy("Decode", {
    from: deployer,
    args: [],
    log: true,
  });

  // interact with the contract using ethers.js
  const Decode = await ethers.getContract("Decode", deployer);
  console.log("Decode contract deployed at:", Decode.address);

  // mint some initial tokens
  await Decode.mint(deployer, "1000000000000000000000000000");
};

export default func;
