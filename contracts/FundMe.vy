# @version >=0.2.4 <0.3.0

owner: public(address)
struct Funder:
    Sender: address
    AmountSent: uint256
FunderList: public(HashMap[int128,Funder])
Count:  int128
MAX_ITER: constant(int128) = 1 ** 128

@external
def __init__():
    self.owner = msg.sender
    self.Count = 0

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
    for i in range(MAX_ITER):
        if i > self.Count:
            break
        self.FunderList[i] = Funder({Sender: ZERO_ADDRESS, AmountSent: 0}) # Maybe better way to reset the list
    self.Count = 0
