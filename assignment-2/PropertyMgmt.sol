// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "@openzeppelin/contracts/access/AccessControl.sol";
import "../assignment-1/ERC20.sol";

contract PropertyMgmt is AccessControl {

	ERC20 public token;

	constructor(address _token) {
        require(_token != address(0), "zero token");
        owner = msg.sender;
		_setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
		token = ERC20(_token);
	}

	struct Property {
		uint256 id;
		address owner;
		string title;
		string location;
		uint256 price; 
		bool forSale;
		bool exists;
	}

	uint256 public nextId = 1;
	mapping(uint256 => Property) public properties;
	uint256[] public propertyIds;

	event PropertyCreated(uint256 indexed id, address indexed owner, uint256 price);
	event PropertyRemoved(uint256 indexed id);
	event PropertyBought(uint256 indexed id, address indexed from, address indexed to, uint256 price);

	modifier onlyAdmin() {
		require(hasRole(DEFAULT_ADMIN_ROLE, msg.sender), "not admin");
		_;
	}

	function createProperty(string calldata _title, string calldata _location, uint256 _price) external onlyAdmin returns (uint256) {
		uint256 id = nextId++;

		properties[id] = Property({
			id: id,
			owner: msg.sender,
			title: _title,
			location: _location,
			price: _price,
			forSale: _price > 0,
			exists: true
		});

		propertyIds.push(id);

		emit PropertyCreated(id, msg.sender, _price);
		return id;
	}

	function removeProperty(uint256 _id) external onlyAdmin {
		require(properties[_id].exists, "property not found");
		delete properties[_id];
		emit PropertyRemoved(_id);
	}


	function buyProperty(uint256 _id) external {
		Property storage p = properties[_id];
		require(p.exists, "property not found");
		require(p.forSale, "property not for sale");
		require(msg.sender != p.owner, "owner cannot buy");
		require(p.price > 0, "invalid price");

		// transfer token from buyer to current owner (uses local ERC20)
		bool ok = token.transferFrom(msg.sender, p.owner, p.price);
		require(ok, "transfer failed");

		address previousOwner = p.owner;
		p.owner = msg.sender;
		p.forSale = false; 

		emit PropertyBought(_id, previousOwner, msg.sender, p.price);
	}
	function setPrice(uint256 _id, uint256 _price) external {
		Property storage p = properties[_id];
		require(p.exists, "property not found");
		require(msg.sender == p.owner || hasRole(DEFAULT_ADMIN_ROLE, msg.sender), "not owner or admin");

		p.price = _price;
		p.forSale = _price > 0;
	}

	function getAllProperties() external view returns (Property[] memory) {
		Property[] memory list = new Property[](propertyIds.length);
		for (uint256 i = 0; i < propertyIds.length; i++) {
			list[i] = properties[propertyIds[i]];
		}
		return list;
	}
}
