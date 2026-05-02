const { ethers } = require("hardhat");

const apiKey = process.env.API_KEY;

const alchemyProvider = new ethers.providers.AlchemyProvider("goerli", apiKey);
const parse = ethers.utils.parseEther;
const digest = ethers.utils.id("hello");

console.log(alchemyProvider, parse, digest);
