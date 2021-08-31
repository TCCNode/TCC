pragma solidity ^0.5.4;

import "./ERC20.sol";
import "./ERC20Detailed.sol";

/**
 * @title SimpleToken
 * @dev Very simple ERC20 Token example, where all tokens are pre-assigned to the creator.
 * Note they can later distribute these tokens as they wish using `transfer` and other
 * `ERC20` functions.
 */
contract TCC is ERC20, ERC20Detailed {
    uint256 public _locked;
    uint256 public _remain;
    uint256 private _lastTime;
    address private _node;
    address private _suanli;
    address private _productor;
    uint256 private _days;
    uint256 private _turn;
    uint256 public _sourceTotalSupply;
    address private _owner;
    address private _newOwner;

    constructor() public ERC20Detailed("Taiwan Cloud Coin", "TCC", 8) {
        _owner = msg.sender;
        _lastTime = 1619711999;
        uint256 initTotalSupply = 23550000 * (10**uint256(decimals()));
        _totalSupply = initTotalSupply;
        _locked = initTotalSupply;
        _remain = initTotalSupply;
        _sourceTotalSupply = initTotalSupply;
        _turn = 0;
        _days = 0;
    }

    modifier onlyOwner() {
        require(msg.sender == _owner, "TCC: Caller is not the owner");
        _;
    }

    function getNode() public view returns (address) {
        return _node;
    }

    function getSuanli() public view returns (address) {
        return _suanli;
    }

    function getProductor() public view returns (address) {
        return _productor;
    }

    function issue() public returns (bool) {
        require(_node != address(0), "TCC: node is the zero address");
        require(_productor != address(0), "TCC: productor is the zero address");
        require(_suanli != address(0), "TCC: suanli is the zero address");
        require(block.timestamp.sub(_lastTime) > 86400, "TCC: It's not time yet");

        uint256 _decimals = 10**uint256(decimals());
        uint256 amount = _remain.div(3650).div(_decimals).mul(_decimals);
        _locked = _locked.sub(amount);
        uint256 amount1 = amount.div(10);
        uint256 amount2 = amount.div(10);
        uint256 amount3 = amount.sub(amount1).sub(amount2);

        _balances[_node] = _balances[_node].add(amount1);
        _balances[_productor] = _balances[_productor].add(amount2);
        _balances[_suanli] = _balances[_suanli].add(amount3);

        uint256 nowturn = _days.div(365);
        if (nowturn > _turn) {
            _turn = nowturn;
            _remain = _remain.mul(9).div(10);
        }

        _lastTime = _lastTime.add(86400);
        _days = _days.add(1);

        emit Transfer(address(0), _suanli, amount);

        return true;
    }

    function bindNode(address addressNode) public onlyOwner returns (bool) {
        require(addressNode != address(0), "TCC: New node is the zero address");
        _node = addressNode;

        return true;
    }

    function bindSuanli(address addressSuanli) public onlyOwner returns (bool) {
        require(addressSuanli != address(0), "TCC: New suanli is the zero address");
        _suanli = addressSuanli;

        return true;
    }

    function bindProductor(address addressProductor) public onlyOwner returns (bool) {
        require(addressProductor != address(0), "TCC: New productor is the zero address");
        _productor = addressProductor;

        return true;
    }

    function transferOwnership(address newOwner) public onlyOwner returns (bool) {
        require(newOwner != address(0), "TCC: New owner is the zero address");
        _newOwner = newOwner;

        return true;
    }

    function acceptOwnership() public returns (bool) {
        require(msg.sender == _newOwner, "TCC: Caller is not the new owner");
        _owner = _newOwner;
        _newOwner = address(0);

        return true;
    }
}
