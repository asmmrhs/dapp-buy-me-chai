//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

// Example deployed to Sepolia: 0xbd03ec003206f46E730cb22e62ea2D05FA2bBB1D

contract BuyMeAChai {
    // Event to emit when a Memo is created.
    event NewMemo(
        address indexed from,
        uint256 timestamp,
        string name,
        string message
    );

    // Memo struct.
    struct Memo {
        address from;
        uint256 timestamp;
        string name;
        string message;
    }

    // Address of contract deployer. Marked payable so that
    // we can withdraw to this address later.
    address payable owner;

    // List of all memos received from chai purchases.
    Memo[] memos;

    constructor() {
        // Store the address of the deployer as a payable address.
        // When we withdraw funds, we'll withdraw here.
        owner = payable(msg.sender);
    }

    /**
     * @dev fetches all stored memos
     */
    function getMemos() public view returns (Memo[] memory) {
        return memos;
    }

    /**
     * @dev buy a chai for owner (sends an ETH tip and leaves a memo)
     * @param _name name of the chai purchaser
     * @param _message a nice message from the purchaser
     */
    function buyChai(
        string memory _name,
        string memory _message
    ) public payable {
        // Must accept more than 0 ETH for a chai.
        require(msg.value > 0, "can't buy chai for free!");

        // Add the memo to storage!
        memos.push(Memo(msg.sender, block.timestamp, _name, _message));

        // Emit a NewMemo event with details about the memo.
        emit NewMemo(msg.sender, block.timestamp, _name, _message);
    }

    /**
     * @dev send the entire balance stored in this contract to the owner
     */
    function withdrawTips() public {
        require(owner.send(address(this).balance));
    }
}
