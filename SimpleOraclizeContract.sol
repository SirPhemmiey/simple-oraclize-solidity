pragma solidity ^0.4.23;
import "./Oraclize.sol";

contract OraclizeSolidity is usingOraclize {
    string public ETHXBT;
    event LogContructorInitiated(string nextStep);
    event LogPriceCalculated(string price);
    event LogNewOraclizeQuery(string description);

    constructor() public payable {
        emit LogContructorInitiated("Contructor was initiated. Call 'updatePrice()' to send the Oraclize Query.");
    }

    function updatePrice() public payable {
        if (oraclize_getPrice("URL") > this.balance) {
            emit LogNewOraclizeQuery("Oraclize was not sent, please add some ETH to cover for the query fee");
        }
        else {
            oraclize_query("URL", "json(https://api.kraken.com/0/public/Ticker?pair=ETHXBT).result.XETHXXBT.c.0");
            emit LogNewOraclizeQuery("Oraclize was sent, standing by the former answer");
        }
    }

    //callback
    function __callback(bytes32 myId, string result){
        require(msg.sender != oraclize_cbAddress(), "Invalid Address");
        ETHXBT = result;
        emit LogPriceCalculated(result);
    }
}