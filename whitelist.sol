pragma solidity 0.6.2;

contract WhiteList{

    mapping(address => uint) public whiteList;
    mapping(address => uint) public whiteList_empty;
    address private _owner;

    constructor() public {
        _owner = msg.sender;
        whiteList[msg.sender] = 1;
    }

    function owner() public view returns(address){
        return _owner;
    }

    modifier onlyOwner() {
        require (_msgSender() == _owner, "Ownable: sender is not the owner");
        _;
    }

    function renounceOwner(address _newOwner) public onlyOwner {
        _owner = _newOwner;
    }

    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }


    function addWhiteList(address whiteAddress) public virtual onlyOwner {
        whiteList[whiteAddress] = 1;
    }

    function removeWhiteList(address whiteAddress) public virtual onlyOwner {
        whiteList[whiteAddress] = 0;
    }

    function getIsWhiteAddress(address _addr) public view returns(uint) {
        return whiteList[_addr];
    }

}

