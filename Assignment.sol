// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MybookStore {
    address public owner;
    uint256 public premiumPrice;

    mapping(address => bool) public premiumMembers;
    mapping(uint256 => Book) public books;

    struct Book {
        uint256 id;
        string title;
        bool isPremium;
    }

    uint256 public bookCount;

    event BookAdded(uint256 id, string title, bool isPremium);
    event PremiumPurchased(address indexed user);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can perform this action");
        _;
    }

    /*modifier onlyPremium() {
        require(premiumMembers[msg.sender], "Only premium members can access this content");
        _;
    }*/

    constructor(uint256 _premiumPrice) {
        owner = msg.sender;
        premiumPrice = _premiumPrice;
    }

    function addBook(string memory _title, bool _isPremium) public onlyOwner {
        bookCount++;
        books[bookCount] = Book(bookCount, _title, _isPremium);
        emit BookAdded(bookCount, _title, _isPremium);
    }

    function purchasePremium() public payable {
        require(msg.value >= premiumPrice, "Please purchase premium membership");
        premiumMembers[msg.sender] = true;
        emit PremiumPurchased(msg.sender);
    }

    function getBook(uint256 _id) public view returns (string memory title) {
        Book memory book = books[_id];
        require(book.id != 0, "Book does not exist");
        if (book.isPremium) {
            require(premiumMembers[msg.sender], "This book is only available to premium members");
        }
        return (book.title);
    }

}
