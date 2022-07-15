const { ethers, waffle } = require('hardhat');
const chai = require('chai');

chai.use(waffle.solidity);
const { expect } = chai;

describe('OneERC721', () => {
  let admin;
  let allAccounts;
  let OneERC721;
  let one;

  before(async () => {
    const accounts = await ethers.getSigners();
    admin = accounts[0];
    allAccounts = accounts;
    OneERC721 = await ethers.getContractFactory('OneERC721');
  });
  beforeEach(async () => {
    one = await OneERC721.deploy('One', 'One', 'http://localhost/');
  });

  it('should mint a token', async () => {
    await one.mint({ value: ethers.utils.parseEther('0.1') });
    const hasToken = await one.hasToken(admin.address);
    expect(hasToken).to.equal(true);
  });
});
