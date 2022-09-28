import {expect} from "chai";
import {ethers} from "hardhat";
import {Contract} from "@ethersproject/contracts";
import {SignerWithAddress} from "@nomiclabs/hardhat-ethers/signers";
import * as chai from "chai";
const chaiAsPromised = require('chai-as-promised');
chai.use(chaiAsPromised);
import { keccak256 } from 'ethers/lib/utils';
import { parse } from "dotenv";

function parseEther(amount : number) {
    return ethers.utils.parseUnits(amount.toString(), 18);
}

describe("Vault", function() {
    let owner : SignerWithAddress,
        alice : SignerWithAddress,
        bob   : SignerWithAddress, 
        carol : SignerWithAddress

    let vault : Contract;
    let token : Contract;

    beforeEach(async() => {
        await ethers.provider.send("hardhat_reset", []);
        [owner, alice, bob, carol] = await ethers.getSigners();

        const Vault = await ethers.getContractFactory("Vault", owner);
        vault = await Vault.deploy();
        const Token = await ethers.getContractFactory("Floppy", owner);
        token = await Token.deploy();
        await vault.setToken(token.address);
    });

    // Happy Path
    it("Should deposit into the Vault", async () => {
        await token.transfer(alice.address, parseEther(1 *10**6));
        console.log("balanceOf Alice: " + await token.balanceOf(alice.address));
        await token.connect(alice).approve(vault.address, token.balanceOf(alice.address));
        console.log("allowance: " +   await token.connect(alice).allowance(alice.address, vault.address));
        await vault.connect(alice).deposit(parseEther(500 *10**3));
        expect(await token.balanceOf(vault.address)).equal(parseEther(500 *10**3));
    });

    it("Should withdraw", async () => {
        // grant withdrawer role to bob.
        let WITHDRAWER_ROLE = keccak256(Buffer.from("WITHDRAWER_ROLE")).toString();
        await vault.grantRole(WITHDRAWER_ROLE, bob.address);

        // setter vaul function.
        await vault.setWithDrawEnable(true);
        await vault.setMaxWithDrawAmount(parseEther(1 *10**6));

        console.log("withdrawEnable: ", await vault.getMaxWithdrawAmount());
        console.log("maxWithdrawAmount: ",  await vault.getWithdrawEnable());

        // alice deposit into the vault.
        await token.transfer(alice.address, parseEther(1 *10**6));
        await token.connect(alice).approve(vault.address, token.balanceOf(alice.address));
        await vault.connect(alice).deposit(parseEther(500 *10**3));

        // bob withdraw into alice address.
        await vault.connect(bob).withdraw(parseEther(300 *10**3), alice.address);
        
        expect(await token.balanceOf(vault.address)).equal(parseEther(200 *10**3));
        expect(await token.balanceOf(alice.address)).equal(parseEther(800 *10**3));
    });

    // Unhappy Path
    it("Should not deposit, Insufficient account balance", async () => {
        await token.transfer(alice.address, parseEther(1 *10**6));
        await token.connect(alice).approve(vault.address, token.balanceOf(alice.address));
        expect(await vault.connect(alice).deposit(parseEther(2 *10**6))).revertedWith("Insufficient account balance");
    });

    it("Should not withDraw, Withdraw is not available", async () => {
        //grant withdrawer role to bob
        let WITHDRAWER_ROLE = keccak256(Buffer.from("WITHDRAWER_ROLE")).toString();
        await vault.grantRole(WITHDRAWER_ROLE, bob.address);

        // set vault function
        await vault.setWithDrawEnable(false);
        await vault.setMaxWithDrawAmount(parseEther(1 *10**6));

        // alice deposit into the vault.
        await token.transfer(alice.address, parseEther(1 *10**6));
        await token.connect(alice).approve(vault.address, token.balanceOf(alice.address));
        await vault.connect(alice).deposit(parseEther(500 *10**3));

        // bob withdraw into the alice address
        await expect(vault.connect(bob).withdraw(parseEther(300 *10**3), alice.address)).revertedWith("Withdraw is not available");
    });
});

