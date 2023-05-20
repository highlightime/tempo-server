const { ethers } = require('hardhat');

async function main() {
  // const MyNFT = await ethers.getContractFactory('MyNFT');
  // const myNFT = await MyNFT.deploy();

  // await myNFT.deployed();

  // console.log('MyNFT contract deployed to:', myNFT.address);

  const UserAuth = await ethers.getContractFactory('UserAuth');
  const userAuth = await UserAuth.deploy();

  await userAuth.deployed();

  console.log('UserAuth contract deployed to:', userAuth.address);


  // const AppointmentContract = await ethers.getContractFactory('AppointmentContract');
  // const appointmentContract = await AppointmentContract.deploy();

  // await appointmentContract.deployed();

  // console.log('AppointmentContract contract deployed to:', appointmentContract.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
