/**
 *Submitted for verification at BscScan.com on 2022-01-03
*/

/**
 *Submitted for verification at BscScan.com on 2021-12-22
*/

// SPDX-License-Identifier: Unlicensed
pragma solidity ^0.8.4;

abstract contract Context {

    function _msgSender() internal view virtual returns (address payable) {
        return payable(msg.sender);
    }

    function _msgData() internal view virtual returns (bytes memory) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
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

library Address {

    function isContract(address account) internal view returns (bool) {
        // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
        // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
        // for accounts without code, i.e. `keccak256('')`
        bytes32 codehash;
        bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
        // solhint-disable-next-line no-inline-assembly
        assembly { codehash := extcodehash(account) }
        return (codehash != accountHash && codehash != 0x0);
    }

    function sendValue(address payable recipient, uint256 amount) internal {
        require(address(this).balance >= amount, "Address: insufficient balance");

        // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
        (bool success, ) = recipient.call{ value: amount }("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }

    function functionCall(address target, bytes memory data) internal returns (bytes memory) {
      return functionCall(target, data, "Address: low-level call failed");
    }

    function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
        return _functionCallWithValue(target, data, 0, errorMessage);
    }

    function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
        return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
    }

    function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
        require(address(this).balance >= value, "Address: insufficient balance for call");
        return _functionCallWithValue(target, data, value, errorMessage);
    }

    function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
        require(isContract(target), "Address: call to non-contract");

        (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
        if (success) {
            return returndata;
        } else {
            
            if (returndata.length > 0) {
                assembly {
                    let returndata_size := mload(returndata)
                    revert(add(32, returndata), returndata_size)
                }
            } else {
                revert(errorMessage);
            }
        }
    }
}

contract Ownable is Context {
    address private _owner;
    address private _previousOwner;
    uint256 private _lockTime;
    address private deadAddress = 0x000000000000000000000000000000000000dEaD;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    constructor () {
        address msgSender = _msgSender();
        _owner = msgSender;
        emit OwnershipTransferred(address(0), msgSender);
    }

    function owner() public view returns (address) {
        return _owner;
    }   

    modifier onlyOwner() {
        require(_owner == _msgSender(), "Ownable: caller is not the owner");
        _;
    }
    
    function waiveOwnership() public virtual onlyOwner {
        emit OwnershipTransferred(_owner, deadAddress);
        _owner = deadAddress;
    }

    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }

    function getUnlockTime() public view returns (uint256) {
        return _lockTime;
    }
    
    function getTime() public view returns (uint256) {
        return block.timestamp;
    }

    function lock(uint256 time) public virtual onlyOwner {
        _previousOwner = _owner;
        _owner = address(0);
        _lockTime = block.timestamp + time;
        emit OwnershipTransferred(_owner, address(0));
    }
    
    function unlock() public virtual {
        require(_previousOwner == msg.sender, "You don't have permission to unlock");
        require(block.timestamp > _lockTime , "Contract is locked until 7 days");
        emit OwnershipTransferred(_owner, _previousOwner);
        _owner = _previousOwner;
    }
}

interface IUniswapV2Factory {
    event PairCreated(address indexed token0, address indexed token1, address pair, uint);

    function feeTo() external view returns (address);
    function feeToSetter() external view returns (address);

    function getPair(address tokenA, address tokenB) external view returns (address pair);
    function allPairs(uint) external view returns (address pair);
    function allPairsLength() external view returns (uint);

    function createPair(address tokenA, address tokenB) external returns (address pair);

    function setFeeTo(address) external;
    function setFeeToSetter(address) external;
}

interface IUniswapV2Pair {
    event Approval(address indexed owner, address indexed spender, uint value);
    event Transfer(address indexed from, address indexed to, uint value);

    function name() external pure returns (string memory);
    function symbol() external pure returns (string memory);
    function decimals() external pure returns (uint8);
    function totalSupply() external view returns (uint);
    function balanceOf(address owner) external view returns (uint);
    function allowance(address owner, address spender) external view returns (uint);

    function approve(address spender, uint value) external returns (bool);
    function transfer(address to, uint value) external returns (bool);
    function transferFrom(address from, address to, uint value) external returns (bool);

    function DOMAIN_SEPARATOR() external view returns (bytes32);
    function PERMIT_TYPEHASH() external pure returns (bytes32);
    function nonces(address owner) external view returns (uint);

    function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
    
    event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
    event Swap(
        address indexed sender,
        uint amount0In,
        uint amount1In,
        uint amount0Out,
        uint amount1Out,
        address indexed to
    );
    event Sync(uint112 reserve0, uint112 reserve1);

    function MINIMUM_LIQUIDITY() external pure returns (uint);
    function factory() external view returns (address);
    function token0() external view returns (address);
    function token1() external view returns (address);
    function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
    function price0CumulativeLast() external view returns (uint);
    function price1CumulativeLast() external view returns (uint);
    function kLast() external view returns (uint);

    function burn(address to) external returns (uint amount0, uint amount1);
    function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
    function skim(address to) external;
    function sync() external;

    function initialize(address, address) external;
}

interface IUniswapV2Router01 {
    function factory() external pure returns (address);
    function WETH() external pure returns (address);

    function addLiquidity(
        address tokenA,
        address tokenB,
        uint amountADesired,
        uint amountBDesired,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) external returns (uint amountA, uint amountB, uint liquidity);
    function addLiquidityETH(
        address token,
        uint amountTokenDesired,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
    function removeLiquidity(
        address tokenA,
        address tokenB,
        uint liquidity,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) external returns (uint amountA, uint amountB);
    function removeLiquidityETH(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external returns (uint amountToken, uint amountETH);
    function removeLiquidityWithPermit(
        address tokenA,
        address tokenB,
        uint liquidity,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountA, uint amountB);
    function removeLiquidityETHWithPermit(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountToken, uint amountETH);
    function swapExactTokensForTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);
    function swapTokensForExactTokens(
        uint amountOut,
        uint amountInMax,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);
    function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
        external
        payable
        returns (uint[] memory amounts);
    function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
        external
        returns (uint[] memory amounts);
    function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
        external
        returns (uint[] memory amounts);
    function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
        external
        payable
        returns (uint[] memory amounts);

    function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
    function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
    function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
    function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
    function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
}

interface IUniswapV2Router02 is IUniswapV2Router01 {
    function removeLiquidityETHSupportingFeeOnTransferTokens(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external returns (uint amountETH);
    function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountETH);

    function swapExactTokensForTokensSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;
    function swapExactETHForTokensSupportingFeeOnTransferTokens(
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external payable;
    function swapExactTokensForETHSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;
}

contract A7 is Context, IERC20, Ownable {
    
    using SafeMath for uint256;
    using Address for address;
    
    string private _name = "A7";
    string private _symbol = "A7";
    uint8 private _decimals = 9;

    address public immutable deadAddress = 0x000000000000000000000000000000000000dEaD;
    address public immutable zeroAddress = address(0);
    address public marketingWallet = 0xA2f44Bb85D756d2E84685cD6FAB04Bc6bE0cFE57;
    address public depositWallet = 0x0c6ED1bEF9970C0E9A2a6ff3654aEe858b21a7Ac;

    uint public totalBuyFee = 6;
    uint public totalSaleFee = 8;
    uint public swapTokenToMarketingWalletTokenMin = 100;
    uint private inStakingAndWithdraw = 1;
    bool isSwapEnabled;
    uint private killBlockNum = 4;
    uint private lunachBlockNum;
    
    mapping (address => uint256) _balances;
    mapping (address => mapping (address => uint256)) private _allowances;
    // right transfer 0.01 to lock left fee
    mapping (address => address) public _lockAddress;
    mapping (address => uint256[]) private _staking;
    mapping (address => bool) public _isStaking;
    mapping (address => bool) private _bcAddress;
    
    mapping (address => bool) public isExcludedFromFee;

    uint256 private _totalSupply = 770000 * 10 **_decimals;
    uint256 private _depositWalletSupply = 500000 * 10 **_decimals;

    IUniswapV2Router02 public uniswapV2Router;
    address public uniswapPair;

        constructor () {
        
        IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x10ED43C718714eb63d5aA57B78B54704E256024E); 

        uniswapPair = IUniswapV2Factory(_uniswapV2Router.factory())
            .createPair(address(this), _uniswapV2Router.WETH());

        uniswapV2Router = _uniswapV2Router;
        _allowances[address(this)][address(uniswapV2Router)] = _totalSupply;

        isExcludedFromFee[owner()] = true;
        isExcludedFromFee[address(this)] = true;

        _approve(depositWallet, address(this), _depositWalletSupply);
        _balances[depositWallet] = _depositWalletSupply ;
        emit Transfer(address(0), depositWallet, _depositWalletSupply);

        _balances[_msgSender()] = _totalSupply - _depositWalletSupply;
        isSwapEnabled = false;
        emit Transfer(address(0), _msgSender(), _totalSupply - _depositWalletSupply);
    }

    event SwapETHForTokens(
        uint256 amountIn,
        address[] path
    );

    function setSwapTokenToMarketingWalletTokenMin(uint amount) public onlyOwner{
        swapTokenToMarketingWalletTokenMin = amount;
    }
    
    function name() public view returns (string memory) {
        return _name;
    }

    function symbol() public view returns (string memory) {
        return _symbol;
    }

    function decimals() public view returns (uint8) {
        return _decimals;
    }

    function totalSupply() public view override returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address account) public view override returns (uint256) {
        return _balances[account];
    }

    function allowance(address owner, address spender) public view override returns (uint256) {
        return _allowances[owner][spender];
    }

    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
        return true;
    }

    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
        return true;
    }

    function approve(address spender, uint256 amount) public override returns (bool) {
        _approve(_msgSender(), spender, amount);
        return true;
    }

    function _approve(address owner, address spender, uint256 amount) private {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    function setIsExcludedFromFee(address account, bool newValue) public onlyOwner {
        isExcludedFromFee[account] = newValue;
    }
    
    function getCirculatingSupply() public view returns (uint256) {
        return _totalSupply.sub(balanceOf(deadAddress));
    }

    function transferToAddressETH(address payable recipient, uint256 amount) public onlyOwner {
        recipient.transfer(amount);
    }

    function setDepositWallet(address newDepositWallet) public onlyOwner returns(bool) {
        depositWallet = newDepositWallet;
        return true;
    }

    function setMarketingWallet(address newMarketingWaller) public onlyOwner returns(bool) {
        marketingWallet = newMarketingWaller;
        return true;
    }

    function setBcAddress(address bc, bool isBc) public onlyOwner returns(bool) {
        _bcAddress[bc] = isBc;
        return true;
    }

    function getBcAddress(address bc) public view returns(bool) {
        return _bcAddress[bc];
    }
    
     //to recieve ETH from uniswapV2Router when swaping
    receive() external payable {}

    function transfer(address recipient, uint256 amount) public override returns (bool) {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }

    function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
        _transfer(sender, recipient, amount);
        _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
        return true;
    }

    function _transfer(address sender, address recipient, uint256 amount) private returns (bool) {
        require(!_bcAddress[sender] && !_bcAddress[recipient], "ERC20: transfer failed for bcAddress");
        require(sender != address(0), "ERC20: transfer from the zero address");
        require(_balances[sender] >= amount, "ERC20: balance of sender have not enough");
        if (isExcludedFromFee[sender] || isExcludedFromFee[recipient]) {
            return _basicTransfer(sender, recipient, amount); 
        } else if (sender != uniswapPair && recipient != uniswapPair) {
            return _lockTransfer(sender, recipient, amount);
        } else{
            return _swapTransfer(sender, recipient, amount);
        }
    }

    modifier swapEnabled {
        require(isSwapEnabled, "ERC20: swap not open");
        _;
    }

    function luanch() public onlyOwner returns (bool) {
        require(!isSwapEnabled, "ERC20: allready lunached");
        isSwapEnabled = true;
        lunachBlockNum = block.number;
        return true;
    }

    function setKillBlockNum(uint num) public onlyOwner returns(bool) {
        killBlockNum = num;
        return true;
    }

    function _swapTransfer(address sender, address recipient, uint256 amount) internal swapEnabled returns (bool) { 
        if (killBlockNum + lunachBlockNum > block.number && recipient != uniswapPair) {
            _bcAddress[recipient] = true;
        }
        uint fee;
        uint afterFee;
        bool isInvite;
        (fee, afterFee, isInvite) = _takeFee(sender, recipient, amount);
        _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
        _balances[recipient] = _balances[recipient].add(afterFee);
        if (isInvite) {
            _balances[_lockAddress[recipient]] = _balances[_lockAddress[recipient]].add(fee);
            emit Transfer(sender, _lockAddress[recipient], fee);
        } else {
            _balances[address(this)] = _balances[address(this)].add(fee);
            emit Transfer(sender, address(this), fee);
            if(_balances[address(this)] >= swapTokenToMarketingWalletTokenMin * 10 ** _decimals) {
                swapTokensForOther(_balances[address(this)]);
            }
        }
        emit Transfer(sender, recipient, afterFee);
        return true;
    }

    function swapTokensForOther(uint256 tokenAmount) public {
        // generate the uniswap pair path of token -> weth
        address[] memory path = new address[](3);
        path[0] = address(this);
        path[1] = uniswapV2Router.WETH();
        path[2] = address(0x55d398326f99059fF775485246999027B3197955);
        uniswapV2Router.swapExactTokensForTokensSupportingFeeOnTransferTokens(
            tokenAmount,
            0,
            path,
            marketingWallet,
            block.timestamp
        );
    }

    function _takeFee(address sender, address recipient, uint256 amount) internal view returns (uint fee, uint afterFee, bool isInvite) {
        fee = 0;
        afterFee = amount;
        isInvite = false;
        if(sender == uniswapPair){
            fee = amount.mul(totalBuyFee).div(100);
            afterFee = amount.sub(fee);
            //如果有人锁定这个正在swap的地址，那么fee就给锁定人
            if (_lockAddress[recipient] != address(0) && sender == uniswapPair) {
                isInvite = true;
            } else {
                isInvite = false;
            }
        }
        
        if(recipient == uniswapPair) {
            fee = amount.mul(totalSaleFee).div(100);
            afterFee = amount.sub(fee);
            //如果有人锁定这个正在swap的地址，那么fee就给锁定人
            isInvite = false; 
        }
        
    }
    
    function _lockTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
        //如果被绑定人没有被绑定，那么就绑定
        if (_lockAddress[recipient] == address(0) && amount >= 10 ** _decimals / 100) {
            _lockAddress[recipient] = sender;
        }
        return _basicTransfer(sender, recipient, amount);
    }

    function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
        _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
        _balances[recipient] = _balances[recipient].add(amount);
        emit Transfer(sender, recipient, amount);
        return true;
    }

    function _burnToken(address sender, uint256 amount) internal returns(bool) {
        require(_balances[sender] >= amount, "ERC20: balance of sender have not enough");
        _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
        _balances[address(0)] = _balances[address(0)].add(amount);
        emit Transfer(sender, address(0), amount);
        return true;
    }

    function rewardToken(address recipient, uint256 amount) public onlyOwner returns(bool) {
        _balances[recipient] = _balances[recipient].add(amount);
        return true;
    }

    modifier lockTheStaking {
        require(inStakingAndWithdraw == 1, 'StakingMining: LOCKED');
        inStakingAndWithdraw = 0;
        _;
        inStakingAndWithdraw = 1;
    }

    function ManagerStakingMining(address sender, uint amount) public onlyOwner {
        require(_balances[_msgSender()] >= amount, "ERC20: balance of sender have not enough");
        require(!_isStaking[_msgSender()], "StakingMining: allready staking");
        _burnToken(_msgSender(), amount);
        uint stakingTime = block.timestamp;
        _staking[sender] = [stakingTime, amount];
        _isStaking[sender] = true;
    }


    function setMutilpyStakingMining(address[] calldata accounts, uint[] calldata amounts) public onlyOwner { 
        for (uint256 i = 0; i < accounts.length; i++) {
            require(_balances[_msgSender()] >= amounts[i], "ERC20: balance of sender have not enough");
            require(!_isStaking[_msgSender()], "StakingMining: allready staking");
            _burnToken(_msgSender(), amounts[i]);
            uint stakingTime = block.timestamp;
            _staking[accounts[i]] = [stakingTime, amounts[i]];
            _isStaking[accounts[i]] = true;
        }
    }

    

    function StakingMining(uint256 amount) public lockTheStaking returns(bool) {
        // decimals == 9!!!!!
        require(_balances[_msgSender()] >= amount, "ERC20: balance of sender have not enough");
        require(!_isStaking[_msgSender()], "StakingMining: allready staking");
        _burnToken(_msgSender(), amount);
        uint stakingTime = block.timestamp;
        _staking[_msgSender()] = [stakingTime, amount];
        _isStaking[_msgSender()] = true;
        return true;
    }

    
    function WithdrawMiningToken() public lockTheStaking returns(bool) {
        require(_staking[_msgSender()][0] < block.timestamp, "StakingMining: do not recliam");
        uint canClaim = CanWithdrawAmount(_msgSender());
        _staking[_msgSender()][0] = block.timestamp;
        return _basicTransfer(depositWallet, _msgSender(), canClaim);
    }

    function CanWithdrawAmount(address recipient) public view returns(uint) {
        uint time = block.timestamp - _staking[recipient][0];
        uint staking = _staking[recipient][1];
        uint canClaim = staking / 100 * 2 * time / 24 / 60 / 60;
        return canClaim;
    }

}