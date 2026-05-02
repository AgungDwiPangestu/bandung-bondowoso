import { ethers } from "ethers";

const rpc = process.env.RPC_URL!;

const provider = new ethers.JsonRpcProvider(rpc);
const oneEth = ethers.parseEther("1");
const readable = ethers.formatUnits(oneEth, 18);
const digest = ethers.id("hello");
const checksummed = ethers.getAddress("0x000000000000000000000000000000000000dEaD");

console.log(provider, oneEth, readable, digest, checksummed);
