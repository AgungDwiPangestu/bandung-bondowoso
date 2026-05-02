import { ethers } from "ethers";

const rpc = process.env.RPC_URL!;

const provider = new ethers.providers.JsonRpcProvider(rpc);
const oneEth = ethers.utils.parseEther("1");
const readable = ethers.utils.formatUnits(oneEth, 18);
const digest = ethers.utils.id("hello");
const checksummed = ethers.utils.getAddress("0x000000000000000000000000000000000000dEaD");

console.log(provider, oneEth, readable, digest, checksummed);
