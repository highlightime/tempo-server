pragma solidity ^0.8.0;



contract UserAuth {
    struct User {
        bytes32 emailHash;
        bytes32 passwordHash;
        bool exists;
    }

    mapping(address => User) private users;
    uint256 public number;

    event UserRegistered(address indexed userAddress, bytes32 emailHash);
    event UserAuthenticated(address indexed userAddress);

    function registerUser(bytes32 emailHash, bytes32 passwordHash) external {
        require(!users[msg.sender].exists, "User already registered");
        users[msg.sender] = User(emailHash, passwordHash, true);
        emit UserRegistered(msg.sender, emailHash);
    }

    function authenticateUser(bytes32 emailHash, bytes32 passwordHash) external view returns (bool) {
        User storage user = users[msg.sender];
        if (!user.exists) {
            return false;
        }
        return user.emailHash == emailHash && user.passwordHash == passwordHash;
    }

    function isRegistered(address userAddress) external view returns (bool) {
        return users[userAddress].exists;
    }

    function setNumber(uint256 newNumber) public {
        number = newNumber;
    }

    function increment() public {
        number++;
    }
}
