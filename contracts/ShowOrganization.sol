// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.6.0;

import "@openzeppelin/contracts/math/SafeMath.sol";

contract ShowOrganization {
    using SafeMath for uint256;

    struct Show {
        address organizer;
        string name;
        uint256 date;
        uint256 price;
        uint256 totalTickets;
        uint256 remainingTickets;
    }

    mapping(uint256 => Show) public shows;
    mapping(address => mapping(uint256 => uint256)) public tickets;
    uint256 public nextId;

    event TicketPurchased(
        address indexed buyer,
        uint256 indexed showId,
        uint256 quantity
    );

    modifier showExists(uint256 showId) {
        require(shows[showId].date != 0, "This show doesn't exist, check the show ID and try again");
        require(shows[showId].date > block.timestamp, "This show has expired");
        _;
    }

    function createShow(
        string memory _name,
        uint256 _date,
        uint256 _price,
        uint256 _ticketCount
    ) public {
        require(_date > block.timestamp, "Shows can only be created for the future");
        require(_ticketCount > 0, "Total number of tickets has to be at least 1");

        shows[nextId] = Show(
            msg.sender,
            _name,
            _date,
            _price,
            _ticketCount,
            _ticketCount
        );
        nextId++;
    }

    function buyTicket(uint256 _showId, uint256 _quantity) public payable showExists(_showId) {
        Show storage _show = shows[_showId];
        require(msg.value == _show.price.mul(_quantity), "Not enough Eth");
        require(_show.remainingTickets >= _quantity, "Not enough tickets available");

        _show.remainingTickets = _show.remainingTickets.sub(_quantity);
        tickets[msg.sender][_showId] = tickets[msg.sender][_showId].add(_quantity);

        emit TicketPurchased(msg.sender, _showId, _quantity);
    }

    function giftTickets(
        uint256 _showId,
        uint256 _quantity,
        address _toAccount
    ) public showExists(_showId) {
        require(tickets[msg.sender][_showId] >= _quantity, "You don't have enough tickets");

        tickets[msg.sender][_showId] = tickets[msg.sender][_showId].sub(_quantity);
        tickets[_toAccount][_showId] = tickets[_toAccount][_showId].add(_quantity);
    }
}
