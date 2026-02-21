<<<<<<< HEAD
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

interface IERC20 {
    function transfer(address to, uint256 amount) external returns (bool);
    function transferFrom(address from, address to, uint256 amount) external returns (bool);
}

contract SchoolSystem {
    address public owner;
    IERC20 public token;

    constructor(address _token) {
        owner = msg.sender;
        token = IERC20(_token);
    }

    struct Student {
        uint256 id;
        string name;
        uint256 level;
        bool hasPaid;
        uint256 paidAt;
    }

    struct Staff {
        uint256 id;
        string name;
        uint256 salary;
        uint256 lastPaidAt;
    }

    uint256 public studentCount;
    uint256 public staffCount;

    mapping(address => Student) public students;
    mapping(address => Staff) public staffs;

    address[] public studentAddresses;
    address[] public staffAddresses;

    mapping(uint256 => uint256) public levelPrice;

    modifier onlyOwner() {
        require(msg.sender == owner, "not owner");
        _;
    }

    function setLevelPrice(uint256 level, uint256 price) external onlyOwner {
        levelPrice[level] = price;
    }

    function registerStudent(string memory _name, uint256 _level) external {
        require(students[msg.sender].id == 0, "already registered");
        require(
            _level == 100 || _level == 200 || _level == 300 || _level == 400,
            "invalid level"
        );
        require(levelPrice[_level] > 0, "price not set");

        uint256 price = levelPrice[_level];

        bool ok = token.transferFrom(msg.sender, address(this), price);
        require(ok, "payment failed");

        studentCount++;

        students[msg.sender] = Student({
            id: studentCount,
            name: _name,
            level: _level,
            hasPaid: true,
            paidAt: block.timestamp
        });

        studentAddresses.push(msg.sender);
    }

    function registerStaff(address _staff, string memory _name, uint256 _salary) external onlyOwner {
        require(staffs[_staff].id == 0, "already staff");

        staffCount++;

        staffs[_staff] = Staff({
            id: staffCount,
            name: _name,
            salary: _salary,
            lastPaidAt: 0
        });

        staffAddresses.push(_staff);
    }

    function payStaff(address _staff) external onlyOwner {
        require(staffs[_staff].id != 0, "not staff");

        uint256 amount = staffs[_staff].salary;

        bool ok = token.transfer(_staff, amount);
        require(ok, "transfer failed");

        staffs[_staff].lastPaidAt = block.timestamp;
    }

    function getStudent(address _student) external view returns (Student memory) {
        return students[_student];
    }

    function getAllStudents() external view returns (Student[] memory) {
        Student[] memory all = new Student[](studentAddresses.length);

        for (uint256 i = 0; i < studentAddresses.length; i++) {
            all[i] = students[studentAddresses[i]];
        }

        return all;
    }

    function updateStudentPaymentStatus(address student, bool paid) external onlyOwner {
        require(students[student].id != 0, "not student");

        if (paid) {
            students[student].hasPaid = true;
            students[student].paidAt = block.timestamp;
        } else {
            students[student].hasPaid = false;
            students[student].paidAt = 0;
        }
    }

    function getAllStaffs() external view returns (Staff[] memory) {
        Staff[] memory all = new Staff[](staffAddresses.length);

        for (uint256 i = 0; i < staffAddresses.length; i++) {
            all[i] = staffs[staffAddresses[i]];
        }

        return all;
    }
}
=======
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import "../Task1/ERC20-Deployment/src/ERC20.sol";

contract SchoolSystem {
    address public owner;
    ERC20 public token;

    constructor(ERC20 _token) {
        owner = msg.sender;
        token = _token;
    }

    struct Student {
        uint256 id;
        string name;
        uint256 level;
        bool hasPaid;
        uint256 paidAt;
    }

    struct Staff {
        uint256 id;
        string name;
        uint256 salary;
        uint256 lastPaidAt;
    }

    uint256 public studentCount;
    uint256 public staffCount;

    mapping(address => Student) public students;
    mapping(address => Staff) public staffs;

    address[] public studentAddresses;
    address[] public staffAddresses;

    mapping(uint256 => uint256) public levelPrice;

    modifier onlyOwner() {
        require(msg.sender == owner, "not owner");
        _;
    }

    function setLevelPrice(uint256 level, uint256 price) external onlyOwner {
        levelPrice[level] = price;
    }

    function registerStudent(string memory _name, uint256 _level) external {
        require(students[msg.sender].id == 0, "already registered");
        require(
            _level == 100 || _level == 200 || _level == 300 || _level == 400,
            "invalid level"
        );
        require(levelPrice[_level] > 0, "price not set");

        uint256 price = levelPrice[_level];

        bool ok = token.transferFrom(msg.sender, address(this), price);
        require(ok, "payment failed");

        studentCount++;

        students[msg.sender] = Student({
            id: studentCount,
            name: _name,
            level: _level,
            hasPaid: true,
            paidAt: block.timestamp
        });

        studentAddresses.push(msg.sender);
    }

    function registerStaff(address _staff, string memory _name, uint256 _salary) external onlyOwner {
        require(staffs[_staff].id == 0, "already staff");

        staffCount++;

        staffs[_staff] = Staff({
            id: staffCount,
            name: _name,
            salary: _salary,
            lastPaidAt: 0
        });

        staffAddresses.push(_staff);
    }

    function payStaff(address _staff) external onlyOwner {
        require(staffs[_staff].id != 0, "not staff");

        uint256 amount = staffs[_staff].salary;

        bool ok = token.transfer(_staff, amount);
        require(ok, "transfer failed");

        staffs[_staff].lastPaidAt = block.timestamp;
    }

    function getStudent(address _student) external view returns (Student memory) {
        return students[_student];
    }

    function getAllStudents() external view returns (Student[] memory) {
        Student[] memory all = new Student[](studentAddresses.length);

        for (uint256 i = 0; i < studentAddresses.length; i++) {
            all[i] = students[studentAddresses[i]];
        }

        return all;
    }

    function updateStudentPaymentStatus(address student, bool paid) external onlyOwner {
        require(students[student].id != 0, "not student");

        if (paid) {
            students[student].hasPaid = true;
            students[student].paidAt = block.timestamp;
        } else {
            students[student].hasPaid = false;
            students[student].paidAt = 0;
        }
    }

    function getAllStaffs() external view returns (Staff[] memory) {
        Staff[] memory all = new Staff[](staffAddresses.length);

        for (uint256 i = 0; i < staffAddresses.length; i++) {
            all[i] = staffs[staffAddresses[i]];
        }

        return all;
    }
}
>>>>>>> 3e904e1 (Initial commit - smart contract week)
