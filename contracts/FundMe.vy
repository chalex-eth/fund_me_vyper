# @version >=0.2.4 <0.3.0

#import "@chainlink/contracts/src/v0.6/interfaces/AggregatorV3Interface.sol"

interface AggregatorV3Interface:
    def getVersion() -> uint256: view

owner: public(address)
struct Funder:
    Sender: address
    AmountSent: uint256
FunderList: public(HashMap[int128,Funder])
Count:  int128
priceFeed: public(AggregatorV3Interface)

@external
def __init__(_priceFeed: address):
    self.owner = msg.sender
    self.Count = 0
    self.priceFeed = AggregatorV3Interface(_priceFeed)

@external
@payable
def fund():
    assert msg.value > 1 * 10 ** 16, "Not enough money sent"
    funder: Funder = Funder({Sender: msg.sender,AmountSent: msg.value})
    self.Count += 1
    self.FunderList[self.Count] = funder

@external
@payable
def withdraw():
    assert msg.sender == self.owner, "Only owner can withdraw fund"
    send(msg.sender, self.balance)
    # In the Patrick Collins code, there is a reset of the array, after some discussion in the Vyper discord
    # it is not optimal and can be dangerous to create a loop and resetting the value of the FunderList
    # So do nothing in the contract state after withdraw function
