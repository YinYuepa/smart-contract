// SPDX-License-Identifier: Unlicensed
pragma solidity ^0.8.4;

library SafeMath {

    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }

    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }

    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "SafeMath: division by zero");
    }

    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return mod(a, b, "SafeMath: modulo by zero");
    }

    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
}

interface IERC20 {

    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

contract Presale {
    using SafeMath for uint;

    address public owner;
    mapping(address => bool) public whiteList;
    mapping(address => uint) public presaleAmount;
    uint public _totalAmount;
    uint public _amountNow;
    uint public _paushTime;
    uint public _maxPresale;
    uint public _minPresale;
    bool public canAnyoneJoin;
    bool public canWithdraw;
    address public erc20;

    constructor(uint amount, uint paushTime, uint max, uint min, address erc20Addr) {
        owner = msg.sender;
        _totalAmount = amount;
        _paushTime = paushTime;
        _maxPresale = max;
        _minPresale = min;
        erc20 = erc20Addr;
    }

    receive() external payable {}

    function deletePresale() public onlyOwner {
        selfdestruct(payable(owner));
    }

    function transfer() external canJoinPresale payable returns(bool) {
        require(_amountNow <= _totalAmount, "presale has full");
        require(msg.value <= _maxPresale, "send ETH value too mach");
        require(msg.value >= _minPresale, "send ETH value too low");
        presaleAmount[msg.sender] = presaleAmount[msg.sender].add(msg.value);
        payable(owner).transfer(msg.value);
        _amountNow = _amountNow.add(msg.value);
        return true;
    }

    function transferERC20(address to, uint amount) external returns(bool) {
        IERC20(erc20).transfer(to, amount);
        return true;
    }

    modifier onlyOwner {
        require(msg.sender == owner, "request not from owner");
        _;
    }

    modifier withdrawNow {
        require(canWithdraw, "you cant withdraw at this time");
        _;
    }

    function changeCanWithDrow(bool b) external onlyOwner returns(bool) {
        canWithdraw = b;
        return true;
    }

    function addWhiteAddress(address white) external onlyOwner returns(bool) {
        whiteList[white] = true;
        return true;
    }

    function removeWhiteAddress(address white) external onlyOwner returns(bool) {
        whiteList[white] = false;
        return true;
    }

    modifier canJoinPresale {
        require(block.timestamp >= _paushTime, "presale not begin");
        if (!canAnyoneJoin) {
            require(whiteList[msg.sender], "you are not in the whiteList");
            _;
        }
        else {
            _;
        }
    }

    function changePaushTime(uint paushTime) external onlyOwner returns(bool) {
        _paushTime = paushTime;
        return true;
    }

    function withdraw() public withdrawNow returns(bool) {
        require(presaleAmount[msg.sender] > 0, "you have not join the presale");
        uint totalPreSale = IERC20(erc20).balanceOf(address(this));
        uint balance = presaleAmount[msg.sender].mul(totalPreSale).div(_totalAmount);
        IERC20(erc20).transfer(msg.sender, balance);
        presaleAmount[msg.sender] = 0;
        return true;
    }

}