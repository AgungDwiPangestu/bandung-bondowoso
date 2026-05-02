import { ethers } from "ethers";

const rpc = process.env.RPC_URL!;
const apiKey = process.env.ALCHEMY_API_KEY!;

const provider = new ethers.JsonRpcProvider(rpc);
const alchemyProvider = new ethers.AlchemyProvider("goerli", apiKey);
const oneEth = ethers.parseEther("1");
const readable = ethers.formatUnits(oneEth, 18);
const digest = ethers.id("hello");
const checksummed = ethers.getAddress("0x000000000000000000000000000000000000dEaD");
const parse = ethers.parseUnits;

console.log(provider, alchemyProvider, oneEth, readable, digest, checksummed, parse);
