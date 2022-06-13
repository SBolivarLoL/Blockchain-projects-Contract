const main = async () => {
  const waveContractFactory = await hre.ethers.getContractFactory("WavePortal");
  const waveContract = await waveContractFactory.deploy({
    value: hre.ethers.utils.parseEther("0.01"), //this founds my contract with that amount of eth
  });
  await waveContract.deployed();
  console.log("Contract address:", waveContract.address);

  /**
   * Get the current balance of the contract
   */
  let contractBalance = await hre.ethers.provider.getBalance(
    waveContract.address
  );
  console.log(
    "Contract balance:",
    hre.ethers.utils.formatEther(contractBalance)
  );

  /**
   *Send waves
   */
  let waveTxn = await waveContract.wave("A message!");
  await waveTxn.wait(); //wait for the transaction to be mined

  /**
   * Get the current balance of the contract
   * After the transaction has been mined
   */
  contractBalance = await hre.ethers.provider.getBalance(waveContract.address);
  console.log("Contract balance:", hre.ethers.utils.formatEther(contractBalance));

  let allWaves = await waveContract.getAllWaves();
  console.log(allWaves);
};

const runMain = async () => {
  try {
    await main();
    process.exit(0); //we exit the node process without errors
  } catch (error) {
    console.log(error);
    process.exit(1); //we exit the node process with a failure indicating 'Uncaught Fatal Exception' error
  }
};

runMain();