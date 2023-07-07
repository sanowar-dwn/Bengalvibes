
# ShowOrganization Contract Documentation

The `ShowOrganization` contract allows organizers to create shows, sell tickets, and allows users to gift tickets to other accounts.

Interact with this contract via [Etherscan](https://sepolia.etherscan.io/address/0x36c825415baB22eC1466567Df54578b277fF3Ead#writeContract) using the contract address "0x36c825415baB22eC1466567Df54578b277fF3Ead" in the Sepolia Test Net.


## Contract Overview

- Contract Name: ShowOrganization
- Solidity Version: ^0.6.0
- License: GPL-3.0
- Libraries used: [OpenZeppelin-SafeMath](https://docs.openzeppelin.com/contracts/2.x/api/math)


## Structs

### Show

- **organizer**: The address of the show organizer.
- **name**: The name of the show.
- **date**: The date of the show.
- **price**: The price of a ticket for the show.
- **totalTickets**: The total number of tickets available for the show.
- **remainingTickets**: The number of tickets remaining for the show.

## Public State Variables

### shows

- **Type**: Mapping
- **Key**: uint256
- **Value**: Show

A mapping that stores information about each show created in the contract. The key is a unique identifier for the show, and the value is a struct of type `Show` containing show details.

### tickets

- **Type**: Mapping
- **Key**: address => uint256 => uint256
- **Value**: uint256

A nested mapping that stores the number of tickets owned by each account for each show. The outer mapping uses the address of the account, and the inner mapping uses the show ID as the key.

### nextId

- **Type**: uint256

A public state variable that keeps track of the next available show ID.

## Events

### TicketPurchased

- **Parameters**:
  - `buyer` (address): The address of the buyer who purchased the tickets.
  - `showId` (uint256): The ID of the show for which the tickets were purchased.
  - `quantity` (uint256): The number of tickets purchased.

An event emitted when tickets are purchased for a show.

## Modifiers

### showExists

- **Parameters**:
  - `showId` (uint256): The ID of the show being checked.
  
A modifier that verifies whether a show exists based on its ID and whether it is still valid (not expired).

## Public Functions

### createShow

- **Parameters**:
  - `_name` (string): The name of the show.
  - `_date` (uint256): The date of the show.
  - `_price` (uint256): The price of a ticket for the show.
  - `_ticketCount` (uint256): The total number of tickets available for the show.

Creates a new show with the given details and adds it to the `shows` mapping. The show can only be created for future dates, and the ticket count must be at least 1.

### buyTicket

- **Parameters**:
  - `_showId` (uint256): The ID of the show for which the tickets are being purchased.
  - `_quantity` (uint256): The number of tickets to purchase.

Allows the caller to purchase tickets for a specific show. The caller must send the correct amount of Ether as payment, and the show must have enough available tickets.

### giftTickets

- **Parameters**:
  - `_showId` (uint256): The ID of the show for which the tickets are being gifted.
  - `_quantity` (uint256): The number of tickets to gift.
  - `_toAccount` (address): The address of the account receiving the gifted tickets.

Allows the caller to gift tickets to another account for a specific show. The caller must own enough tickets to gift.
