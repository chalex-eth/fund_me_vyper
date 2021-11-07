# SPDX-License-Identifier: MIT
# @version 0.2.16

interface AggregatorV3Interface:
    def version() -> uint256: view
    def description() -> String[100]: view
    def latestRoundData() -> (int256, int256,uint256,uint256,int256) : view 
    # Here it is a trick the first and last input are uint80 but it is not supported by Vyper
    # Since we are only interested by the second input which is the answer (price), I made this trick by
    # changing the type of these inputs

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

@view
@external
def getVersion() -> uint256:
    return self.priceFeed.version()

@view
@external 
def getDescription() -> String[100]:
    return self.priceFeed.description()

@view
@internal
def _getPrice() -> int256:
    a: int256 = 0
    price: int256 = 0
    b: uint256 = 0
    c: uint256 = 0
    d: int256 = 0
    (a,price,b,c,d) = self.priceFeed.latestRoundData() 
    return (price * 10000000000)

@view
@internal
def _getConversionRate(ethAmount: uint256) -> uint256:
    price: int256 = self._getPrice()
    ethPrice: uint256 = convert(price,uint256)
    ethAmountInUsd: uint256 = (ethPrice * ethAmount) / 1000000000000000000
    return ethAmountInUsd

@view
@external
def getEntranceFee() -> int256:
    minimumUSD: int256 = 10 * 10 ** 18 # 10 dollars equivalent worth of Eth
    price: int256 = self._getPrice()
    precision: int256 = 1 * 10**18
    return (minimumUSD * precision) / price

@external
@payable
def fund():
    minimumUSD: uint256 = 10 * 10 ** 18 # 10 dollars equivalent worth of Eth
    #ValueInUSDsent: uint256 = self.getConversionRate(msg.value)
    assert  self._getConversionRate(msg.value) > minimumUSD, "Not enough money sent"
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
    