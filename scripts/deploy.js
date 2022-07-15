const hre = require('hardhat');

async function main() {
  console.log(`starting migrations on ${hre.network.name} network`);
  console.log('compiling contracts');
  await hre.run('compile');
  console.log(`running migrations on ${hre.network.name} network`);

  const OneERC721 = await hre.ethers.getContractFactory('OneERC721');
  const deployment = await OneERC721.deploy(
    'MEMBER',
    'Membership',
    'http://localhost/',
  );
  const contract = await deployment.deployed();
  console.log(`deployed contract at ${contract.address}`);
}

main().then(() => {
  console.log('MIGRATIONS DONE');
  process.exit(0);
}).catch((error) => {
  console.error(error);
  process.exit(1);
});
