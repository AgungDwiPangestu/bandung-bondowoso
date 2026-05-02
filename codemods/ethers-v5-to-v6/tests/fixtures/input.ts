import { ethers } from "ethers";

const rpc = process.env.RPC_URL!;
const apiKey = process.env.ALCHEMY_API_KEY!;

const provider = new ethers.providers.JsonRpcProvider(rpc);
const alchemyProvider = new ethers.providers.AlchemyProvider("goerli", apiKey);
const oneEth = ethers.utils.parseEther("1");
const readable = ethers.utils.formatUnits(oneEth, 18);
const digest = ethers.utils.id("hello");
const checksummed = ethers.utils.getAddress("0x000000000000000000000000000000000000dEaD");
const parse = ethers.utils.parseUnits;

console.log(provider, alchemyProvider, oneEth, readable, digest, checksummed, parse);
