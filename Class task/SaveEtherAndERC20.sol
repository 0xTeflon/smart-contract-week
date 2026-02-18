// SPDX-License-Identifier: MIT
pragma solidity ^0.8.3;

contract SaveEtherAndERC20 {
    // Mapping for Ether balances
    mapping(address => uint256) public etherBalances;

    // Mapping for ERC20 token balances
    mapping(address => mapping(address => uint256)) public tokenBalances;

    // Events for Ether
    event EtherDepositSuccessful(address indexed sender, uint256 indexed amount);
    event EtherWithdrawalSuccessful(address indexed receiver, uint256 indexed amount, bytes data);

    // Events for ERC20
    event TokenDepositSuccessful(address indexed sender, address indexed tokenAddress, uint256 indexed amount);
    event TokenWithdrawalSuccessful(address indexed receiver, address indexed tokenAddress, uint256 indexed amount);


    function depositEther() external payable {
        require(msg.value > 0, "Can't deposit zero value");

        etherBalances[msg.sender] = etherBalances[msg.sender] + msg.value;

        emit EtherDepositSuccessful(msg.sender, msg.value);
    }

    function withdrawEther(uint256 _amount) external {
        require(msg.sender != address(0), "Address zero detected");

        uint256 userSavings_ = etherBalances[msg.sender];

        require(userSavings_ > 0, "Insufficient funds");
        require(userSavings_ >= _amount, "Withdrawal amount exceeds balance");

        etherBalances[msg.sender] = userSavings_ - _amount;

        (bool result, bytes memory data) = payable(msg.sender).call{value: _amount}("");

        require(result, "transfer failed");

        emit EtherWithdrawalSuccessful(msg.sender, _amount, data);
    }

    function getUserEtherSavings() external view returns (uint256) {
        return etherBalances[msg.sender];
    }

    function getEtherBalance(address _user) external view returns (uint256) {
        return etherBalances[_user];
    }


    function depositERC20(address _tokenAddress, uint256 _amount) external {
        require(_tokenAddress != address(0), "Invalid token address");
        require(_amount > 0, "Can't deposit zero value");

        ERC20 token = ERC20(_tokenAddress);

        // Transfer tokens from user to contract
        bool success = token.transferFrom(msg.sender, address(this), _amount);
        require(success, "Token transfer failed");

        tokenBalances[msg.sender][_tokenAddress] = tokenBalances[msg.sender][_tokenAddress] + _amount;

        emit TokenDepositSuccessful(msg.sender, _tokenAddress, _amount);
    }

    function withdrawERC20(address _tokenAddress, uint256 _amount) external {
        require(_tokenAddress != address(0), "Invalid token address");
        require(msg.sender != address(0), "Address zero detected");

        uint256 userSavings_ = tokenBalances[msg.sender][_tokenAddress];

        require(userSavings_ > 0, "Insufficient token funds");
        require(userSavings_ >= _amount, "Withdrawal amount exceeds balance");

        tokenBalances[msg.sender][_tokenAddress] = userSavings_ - _amount;

        ERC20 token = ERC20(_tokenAddress);
        bool success = token.transfer(msg.sender, _amount);

        require(success, "Token transfer failed");

        emit TokenWithdrawalSuccessful(msg.sender, _tokenAddress, _amount);
    }

    function getUserTokenSavings(address _tokenAddress) external view returns (uint256) {
        return tokenBalances[msg.sender][_tokenAddress];
    }

    function getTokenBalance(address _user, address _tokenAddress) external view returns (uint256) {
        return tokenBalances[_user][_tokenAddress];
    }


    function getContractEtherBalance() external view returns (uint256) {
        return address(this).balance;
    }

    function getContractTokenBalance(address _tokenAddress) external view returns (uint256) {
        ERC20 token = ERC20(_tokenAddress);
        return token.balanceOf(address(this));
    }


}
