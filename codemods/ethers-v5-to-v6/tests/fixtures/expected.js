const { ethers } = require("hardhat");

const apiKey = process.env.API_KEY;

const alchemyProvider = new ethers.AlchemyProvider("goerli", apiKey);
const parse = ethers.parseEther;
const digest = ethers.id("hello");

console.log(alchemyProvider, parse, digest);
