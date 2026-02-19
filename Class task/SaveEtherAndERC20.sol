// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

interface IERC20 {
    function transfer(address to, uint256 amount) external returns (bool);
    function transferFrom(address from, address to, uint256 amount) external returns (bool);
}

contract SaveEtherAndERC20 {
    mapping(address => uint256) private etherSaved;
    mapping(address => mapping(address => uint256)) private tokenSaved;

    function depositEther() external payable {
        require(msg.value > 0, "zero");
        etherSaved[msg.sender] += msg.value;
    }

    function withdrawEther(uint256 amount) external {
        require(amount > 0, "zero");
        require(etherSaved[msg.sender] >= amount, "low");

        etherSaved[msg.sender] -= amount;

        (bool ok, ) = payable(msg.sender).call{value: amount}("");
        require(ok, "fail");
    }

    function depositToken(address token, uint256 amount) external {
        require(token != address(0), "zero token");
        require(amount > 0, "zero");

        bool ok = IERC20(token).transferFrom(msg.sender, address(this), amount);
        require(ok, "fail");

        tokenSaved[msg.sender][token] += amount;
    }

    function withdrawToken(address token, uint256 amount) external {
        require(token != address(0), "zero token");
        require(amount > 0, "zero");
        require(tokenSaved[msg.sender][token] >= amount, "low");

        tokenSaved[msg.sender][token] -= amount;

        bool ok = IERC20(token).transfer(msg.sender, amount);
        require(ok, "fail");
    }

    function getMyEtherBalance() external view returns (uint256) {
        return etherSaved[msg.sender];
    }

    function getMyTokenBalance(address token) external view returns (uint256) {
        return tokenSaved[msg.sender][token];
    }

    function getUserEtherBalance(address user) external view returns (uint256) {
        return etherSaved[user];
    }

    function getUserTokenBalance(address user, address token) external view returns (uint256) {
        return tokenSaved[user][token];
    }

    function getContractEtherBalance() external view returns (uint256) {
        return address(this).balance;
    }

    receive() external payable {
        etherSaved[msg.sender] += msg.value;
    }
}
