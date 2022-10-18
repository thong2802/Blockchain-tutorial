const { expect } = require("chai");
const { ethers } = require("hardhat");

let deadline;
let amountMinted;
let amount;
let deployer;
let permit;
let token;
let DECIMAL;

async function main() {
    deadline = ethers.constants.MaxUint256;
    DECIMAL = await ethers.BigNumber.from(10).pow(18);
    amountMinted = await ethers.BigNumber.from(1000).mul(DECIMAL);
    amount = await ethers.BigNumber.from(100).mul(DECIMAL);

    let accounts = await ethers.getSigners(1);
    deployer   = accounts[0];
    console.log("deployer: " + deployer.address);

    let TokenERC20Permit = await ethers.getContractFactory("TokenERC20Permit");
    token = await TokenERC20Permit.deploy();
    await token.deployed();
    console.log("token " + token.address);

    let Permit = await ethers.getContractFactory("ContractPermit");
    permit = await Permit.deploy(token.address);
    await permit.deployed();
    console.log("permit: " + permit.address);

    // mint token
    token.mint(deployer.address, amountMinted); 

    const{v, r, s} = await getPermitSignature(deployer, token, permit.address, amount, deadline);
    console.log("v: " + v);
    console.log("r: " + r);
    console.log("s: " + s);

    await permit.depositWithPermit(deployer.address, amount, deadline, v, r, s);
    console.log("balanceOf Permit: " + await token.balanceOf(permit.address));
    console.log("balanceOf Deployer: " + await token.balanceOf(deployer.address));
    
}

async function getPermitSignature(signer: any, token: any, spender: any, value: any, deadline: any) {
    const [nonce, name, version, chainId] = await Promise.all([
      token.nonces(signer.address),
      token.name(),
      "1",
      signer.getChainId(),
    ])
  
    return ethers.utils.splitSignature(
      await signer._signTypedData(
        {
          name,
          version,
          chainId,
          verifyingContract: token.address,
        },
        {
          Permit: [
            {
              name: "owner",
              type: "address",
            },
            {
              name: "spender",
              type: "address",
            },
            {
              name: "value",
              type: "uint256",
            },
            {
              name: "nonce",
              type: "uint256",
            },
            {
              name: "deadline",
              type: "uint256",
            },
          ],
        },
        {
          owner: signer.address,
          spender,
          value,
          nonce,
          deadline,
        }
      )
    )
}


// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});