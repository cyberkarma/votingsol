const { expect } = require("chai")
const { ethers } = require("hardhat")

describe("VEngine", function () {
    let firstAcc, secondAcc, voting
    beforeEach(async function() {
        [firstAcc, secondAcc] = await ethers.getSigners()
        const Voting = await ethers.getContractFactory("VEngine", firstAcc)
        voting = await  Voting.deploy()
        console.log(voting.address)
    })
})