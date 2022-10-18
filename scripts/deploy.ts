import { USDT } from './../typechain-types/contracts/USDT';
import { ethers, hardhatArguments } from 'hardhat';
import * as Config from './config';

async function main() {
    await Config.initConfig();
    const network = hardhatArguments.network ? hardhatArguments.network : 'dev';
    const [ deployer] = await ethers.getSigners();
    console.log('deploy from address: ', deployer.address);
    
    const Floppy = await ethers.getContractFactory("Floppy");
    const floppy = await Floppy.deploy();
    console.log('floppy from address: ', floppy.address);
    Config.setConfig(network + '.Floppy', floppy.address);

    const Vault = await ethers.getContractFactory("Vault");
    const vault = await Vault.deploy();
    console.log("Vault address: ", vault.address);
    Config.setConfig(network + '.Vault', vault.address);

    const USDT = await ethers.getContractFactory("USDT");
    const usdt = await USDT.deploy();
    console.log("USDT address: ", usdt.address);
    Config.setConfig(network + '.USDT', usdt.address);

    const FLPCrowdSale = await ethers.getContractFactory("FLPCrowdSale");
    const flpCrowdSale = await FLPCrowdSale.deploy(1000, 100, "0xDeee2F0277aB300513326436C35116670e512Fec", "0xA27513b041D24fd7c85a3B626F4E79F2e32a988E");
    console.log("FLPCrowdSale address: " + flpCrowdSale.address);
    Config.setConfig(network + '.FLPCrowdSale', flpCrowdSale.address);

    await Config.updateConfig();


}

main().then(() => process.exit(0))
    .catch(err => {
        console.error(err);
        process.exit(1);
    })
