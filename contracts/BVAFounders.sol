pragma solidity ^0.5.0;

import "openzeppelin-solidity/contracts/math/SafeMath.sol";
import "./ERC20Interface.sol";

contract BVAFounders {
    using SafeMath for uint;

    ERC20Interface erc20Contract;
    address payable owner;


    modifier isOwner() {
        require(msg.sender == owner, "must be contract owner");
        _;
    }


    // ------------------------------------------------------------------------
    // Constructor
    // ------------------------------------------------------------------------
    constructor(ERC20Interface ctr) public {
        erc20Contract = ctr;
        owner         = msg.sender;
    }


    // ------------------------------------------------------------------------
    // Unlock Tokens
    // ------------------------------------------------------------------------
    function unlockTokens(address to) external isOwner {
        // Total Allocation : 1,260,000 BVA (4.5% of total supply)
        // 1. 25% - 2020/12/01 (315,000 BVA) - timestamp 1606752000
        // 2. 25% - 2021/12/01 (315,000 BVA) - timestamp 1638288000
        // 3. 15% - 2022/12/01 (189,000 BVA) - timestamp 1669824000
        // 4. 15% - 2023/12/01 (189,000 BVA) - timestamp 1701360000
        // 5. 10% - 2024/12/01 (126,000 BVA) - timestamp 1732982400
        // 6. 10% - 2025/12/01 (126,000 BVA) - timestamp 1764518400

        require(now >= 1606752000, "locked");

        uint balance = erc20Contract.balanceOf(address(this));
        uint amount;
        uint remain;

        if (now < 1638288000) {
            // 1st unlock : before balance must have at least 1,260,000 BVA
            require(balance >= 1260000e18, "checkpoint 1 balance error");
            remain = 945000e18;
            amount = balance.sub(remain);
        } else if (now < 1669824000) {
            // 2nd unlock : before balance must have at least 945,000 BVA
            require(balance >= 945000e18, "checkpoint 2 balance error");
            remain = 630000e18;
            amount = balance.sub(remain);
        } else if (now < 1701360000) {
            // 3rd unlock : before balance must have at least 630,000 BVA
            require(balance >= 630000e18, "checkpoint 3 balance error");
            remain = 441000e18;
            amount = balance.sub(remain);
        } else if (now < 1732982400) {
            // 4th unlock : before balance must have at least 441,000 BVA
            require(balance >= 441000e18, "checkpoint 4 balance error");
            remain = 252000e18;
            amount = balance.sub(remain);
        } else if (now < 1764518400) {
            // 5th unlock : before balance must have at least 252,000 BVA
            require(balance >= 252000e18, "checkpoint 5 balance error");
            remain = 126000e18;
            amount = balance.sub(remain);
        } else {
            // 6th unlock : before balance must have at least 126,000 BVA
            amount = balance;
        }

        if (amount > 0) {
            erc20Contract.transfer(to, amount);
        }
    }


    // ------------------------------------------------------------------------
    // Withdraw ETH from this contract to `owner`
    // ------------------------------------------------------------------------
    function withdrawEther(uint _amount) external isOwner {
        owner.transfer(_amount);
    }


    // ------------------------------------------------------------------------
    // accept ETH
    // ------------------------------------------------------------------------
    function () external payable {
    }
}
