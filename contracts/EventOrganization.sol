// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.6.0;

import "@openzeppelin/contracts/math/SafeMath.sol";

contract EventContract {
    using SafeMath for uint256;

    struct Event {
        address organizer;
        string name;
        uint256 date;
        uint256 price;
        uint256 totalTickets;
        uint256 remainingTickets;
    }

    mapping(uint256 => Event) public events;
    mapping(address => mapping(uint256 => uint256)) public tickets;
    uint256 public nextId;

    event TicketPurchased(
        address indexed buyer,
        uint256 indexed eventId,
        uint256 quantity
    );

    modifier eventExists(uint256 eventId) {
        require(events[eventId].date != 0, "This event doesn't exist, check the event ID and try again");
        require(events[eventId].date > block.timestamp, "This event has expired");
        _;
    }

    function createEvent(
        string memory _name,
        uint256 _date,
        uint256 _price,
        uint256 _ticketCount
    ) public {
        require(_date > block.timestamp, "Events can only be created for the future");
        require(_ticketCount > 0, "Total number of tickets has to be at least 1");

        events[nextId] = Event(
            msg.sender,
            _name,
            _date,
            _price,
            _ticketCount,
            _ticketCount
        );
        nextId++;
    }

    function buyTicket(uint256 _eventId, uint256 _quantity) public payable eventExists(_eventId) {
        Event storage _event = events[_eventId];
        require(msg.value == _event.price.mul(_quantity), "Not enough Eth");
        require(_event.remainingTickets >= _quantity, "Not enough tickets available");

        _event.remainingTickets = _event.remainingTickets.sub(_quantity);
        tickets[msg.sender][_eventId] = tickets[msg.sender][_eventId].add(_quantity);

        emit TicketPurchased(msg.sender, _eventId, _quantity);
    }

    function giftTickets(
        uint256 _eventId,
        uint256 _quantity,
        address _toAccount
    ) public eventExists(_eventId) {
        require(tickets[msg.sender][_eventId] >= _quantity, "You don't have enough tickets");

        tickets[msg.sender][_eventId] = tickets[msg.sender][_eventId].sub(_quantity);
        tickets[_toAccount][_eventId] = tickets[_toAccount][_eventId].add(_quantity);
    }
}
