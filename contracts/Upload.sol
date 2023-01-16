// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

contract Upload {
    struct Access {
        address user;
        bool access;
    }

    mapping(address => string[]) value;
    mapping(address => mapping(address => bool)) ownership;
    mapping(address => Access[]) accessList;
    mapping(address => mapping(address => bool)) previousData;

    function add(address _user, string memory url) external {
        value[_user].push(url);
    }

    // permit to view image
    // msg.sender = the one allowing to view image
    // user the one view image
    function allow(address user) external {
        ownership[msg.sender][user] = true;
        if (previousData[msg.sender][user]) {
            for (uint i = 0; i < accessList[msg.sender].length; i++) {
                if (accessList[msg.sender][i].user == user) {
                    accessList[msg.sender][i].access=true;
                    break;
                }
            }
        }else {
            accessList[msg.sender].push(Access(user, true));
            previousData[msg.sender][user] = true;
        }
        
    }

    function disAllow(address user) public {
        ownership[msg.sender][user] = false;
        for (uint i = 0; i < accessList[msg.sender].length; i++) {
            if (accessList[msg.sender][i].user == user) {
                accessList[msg.sender][i].access = false;
                break;
            }
        }
    }

    function display(address _user) external view returns(string[] memory) {
        require(_user == msg.sender || ownership[_user][msg.sender],"No Access");
        string[] memory ImageString = value[_user];
        return ImageString;
    }

    function shareAccess() public view returns (Access[] memory) {
        Access[] memory AccessList = accessList[msg.sender];
        return AccessList;
    }
}
