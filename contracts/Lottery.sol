pragma solidity >=0.4.22 <0.9.0;
import "@openzeppelin/contracts/access/Ownable.sol";
import "@chainlink/contracts/src/v0.8/VRFConsumerBase.sol";

contract Lottery is VRFConsumerBase,Ownable {
    string public name = "Akhilesh";
    uint256 public entryFee = 0.1 ether;
    uint256 count = 0;
    bytes32 internal keyHash;
    uint256 internal fee;

    uint256 public randomResult;
    address payable[] public players;
    uint256 public CreateAt;
    uint256 public  endhours;
    // function for taking part in lottery
    event Takepart(address players, bool created);

    /**
     * Constructor inherits VRFConsumerBase
     *
     * Network: Kovan
     * Chainlink VRF Coordinator address: 0xdD3782915140c8f3b190B5D67eAc6dc5760C46E9
     * LINK token address:                0xa36085F69e2889c224210F603D836748e7dC0088
     * Key Hash: 0x6c3699283bda56ad74f6b855546325b68d482e983852a7a82979cc4807b641f4
     */
    // 0x9C3a03CF8Cd8Eb94A1B10A100B41c77124B08931 deployed  address
    constructor(
        address _vrfCoordinator,
        address _linkToken,
        bytes32 _keyHash,
        uint256 _endhour
    )
        VRFConsumerBase(
            _vrfCoordinator, // VRF Coordinator
            _linkToken // LINK Token
        )
    { endhours = _endhour;
        keyHash = _keyHash;
        fee = 0.1 * 10 ** 18;
        CreateAt = block.timestamp;
    }

    function takPart() public payable {
       require(block.timestamp <= CreateAt+endhours,"Lottery is closed now");
       require(msg.value == entryFee, "Enter fee  must be >= enteryFee");
       players[count] =payable(msg.sender);
        count++;
        emit Takepart(msg.sender, true);
    }

    //function for piking a winner
    function Paytowinner() public payable onlyOwner {
    require(block.timestamp > CreateAt+endhours,"Lottery is not closed yet");
        players[randomResult].transfer(address(this).balance);
        players = new address payable[](0);
        count =0;
    }

    /**
     * Requests randomness
     */
    function SelectWinner() public onlyOwner returns (bytes32 requestId) {
        require(block.timestamp > CreateAt+endhours,"Lottery is not closed yet");
        require(
            LINK.balanceOf(address(this)) >= fee,
            "Not enough LINK - fill contract with faucet"
        );
        return requestRandomness(keyHash, fee);
    }

    /**
     * Callback function used by VRF Coordinator
    */
 function fulfillRandomness(bytes32 requestId, uint256 randomness) internal override {
        randomResult = randomness%count;
    }
}
