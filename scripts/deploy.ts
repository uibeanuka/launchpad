import { ethers } from 'hardhat';
import { TokenLaunchPad } from 'typechain';

async function main() {
  // Set up accounts
  const [deployer] = await ethers.getSigners();

  // Deploy TokenLaunchPad contract
  const TokenA_ADDRESS = '0x1234567890123456789012345678901234567890'; // replace with actual address of token A
  const TokenB_ADDRESS = '0x0987654321098765432109876543210987654321'; // replace with actual address of token B
  const TokenLaunchPad_FACTORY = await ethers.getContractFactory('TokenLaunchPad');
  const tokenLaunchPad = (await TokenLaunchPad_FACTORY.deploy(TokenA_ADDRESS, TokenB_ADDRESS)) as TokenLaunchPad;
  await tokenLaunchPad.deployed();

  console.log('TokenLaunchPad deployed to:', tokenLaunchPad.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
