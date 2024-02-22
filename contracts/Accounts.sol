// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {IERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import {ReentrancyGuard} from "lib/openzeppelin-contracts/contracts/utils/ReentrancyGuard.sol";

contract Accounts is ReentrancyGuard {
    error OINK__UserAlreadyExist();
    error OINK__TokenNotWhitelisted();
    error OINK__MustBeMoreThanZero();
    error OINK__PercentageCantBeMoreThan100();
    error OINK__TransactionFailed();

    event CollateralDeposited(address indexed user, address indexed token, uint256 indexed amount);
    event CreditWithrawn(address indexed user, address indexed token, uint256 indexed amount);

    // Whitelisted Stablecoins
    address private s_whitelistedTokenAddress;
    // Points per action
    uint256 public constant s_pointsForOnTimePayment = 10;
    uint256 public constant s_pointsForlimitUsage = 1;
    uint256 public constant s_pointsForlengthOfUsage = 1;
    uint256 public constant s_pointsForOpeningNewAccount = 10;

    // Credit limits per rank
    uint256 public constant s_bronzeCreditLimit = 1000;
    uint256 public constant s_silverCreditLimit = 2000;
    uint256 public constant s_goldCreditLimit = 3000;
    uint256 public constant s_platinumCreditLimit = 4000;
    uint256 public constant s_diamondCreditLimit = 5000;

    // Required Collateral needed per rank
    uint256 public constant s_bronzeCollateralRequiredPercentage = 100;
    uint256 public constant s_silverCollateralRequiredPercentage = 75;
    uint256 public constant s_goldCollateralRequiredPercentage = 50;
    uint256 public constant s_platinumCollateralRequiredPercentage = 25;
    uint256 public constant s_diamondCollateralRequiredPercentage = 0;

    mapping(address user => AccountDetails account) private s_accountDetails;

    struct AccountDetails {
        uint256 points;
        uint256 creditLimit;
        uint256 creditBalance;
        uint256 collateralBalance;
        uint256 collateralRequired;
    }

    constructor(address _whitelistedTokenAddress) {
        s_whitelistedTokenAddress = _whitelistedTokenAddress;
    }

    modifier newUserOnly() {
        if (s_accountDetails[msg.sender].creditLimit > 0) {
            revert OINK__UserAlreadyExist();
        }
        _;
    }

    modifier moreThanZero(uint256 _amount) {
        if (_amount == 0) {
            revert OINK__MustBeMoreThanZero();
        }
        _;
    }

    modifier onlyWhitelistedTokens(address _tokenAddress) {
        if (s_whitelistedTokenAddress != _tokenAddress) {
            revert OINK__TokenNotWhitelisted();
        }
        _;
    }

    // Start initial credit limit
    function openAccount() public newUserOnly {
        _updatePoints(msg.sender, s_pointsForOpeningNewAccount);
    }

    // Update user points
    function _updatePoints(address _user, uint256 _action) internal {
        s_accountDetails[_user].points += _action;
        _updateCreditDetails(_user);
    }

    // Update credit limit based on how many points
    function _updateCreditDetails(address _user) internal {
        uint256 points = getPoints(_user);

        if (points < 250) {
            s_accountDetails[_user].creditLimit = s_bronzeCreditLimit;
            s_accountDetails[_user].collateralRequired = s_bronzeCollateralRequiredPercentage;
            s_accountDetails[_user].creditBalance = s_bronzeCreditLimit;
        } else if (points < 500) {
            s_accountDetails[_user].creditLimit = s_silverCreditLimit;
            s_accountDetails[_user].collateralRequired = s_silverCollateralRequiredPercentage;
            s_accountDetails[_user].creditBalance = s_silverCreditLimit;
        } else if (points < 750) {
            s_accountDetails[_user].creditLimit = s_goldCreditLimit;
            s_accountDetails[_user].collateralRequired = s_goldCollateralRequiredPercentage;
            s_accountDetails[_user].creditBalance = s_goldCreditLimit;
        } else if (points < 975) {
            s_accountDetails[_user].creditLimit = s_platinumCreditLimit;
            s_accountDetails[_user].collateralRequired = s_platinumCollateralRequiredPercentage;
            s_accountDetails[_user].creditBalance = s_platinumCreditLimit;
        } else {
            s_accountDetails[_user].creditLimit = s_diamondCreditLimit;
            s_accountDetails[_user].collateralRequired = s_diamondCollateralRequiredPercentage;
            s_accountDetails[_user].creditBalance = s_diamondCreditLimit;
        }
    }

    // Deposit collateral
    function depositCollateral(address _token, uint256 _amount) external onlyWhitelistedTokens(_token) nonReentrant {
        require(IERC20(_token).allowance(msg.sender, address(this)) >= _amount, "Amount not approved for transfer");

        bool success = IERC20(_token).transferFrom(msg.sender, address(this), _amount);
        if (!success) {
            revert OINK__TransactionFailed();
        }

        s_accountDetails[msg.sender].collateralBalance += _amount;

        emit CollateralDeposited(msg.sender, _token, _amount);
    }

    // Withdraw from available credit
    function withdrawCredit(address _token, uint256 _amount) external moreThanZero(_amount) nonReentrant {
        require(s_accountDetails[msg.sender].creditBalance >= _amount, "Insufficiant Funds");
        uint256 collateralNeeded = _calculateCollateral(_amount, s_accountDetails[msg.sender].collateralRequired);
        require(s_accountDetails[msg.sender].collateralBalance >= collateralNeeded, "Deposit more collateral");

        s_accountDetails[msg.sender].creditBalance -= _amount;

        bool succcess = IERC20(_token).transfer(msg.sender, _amount);
        if (!succcess) {
            revert OINK__TransactionFailed();
        }

        emit CreditWithrawn(msg.sender, _token, _amount);
    }

    function _calculateCollateral(uint256 _amount, uint256 _percentage) internal pure returns (uint256) {
        require(_percentage <= 100, "Percentage cant be more than 100");
        uint256 scaledAmount = _amount * 1 ether;
        uint256 result = (scaledAmount * _percentage) / 100;

        return result / 1 ether;
    }

    function getPoints(address _user) public view returns (uint256) {
        return s_accountDetails[_user].points;
    }

    function getCreditLimit(address _user) public view returns (uint256) {
        return s_accountDetails[_user].creditLimit;
    }

    function getCreditBalance(address _user) public view returns (uint256) {
        return s_accountDetails[_user].creditBalance;
    }

    function getCollateralBalance(address _user) public view returns (uint256) {
        return s_accountDetails[_user].collateralBalance;
    }
}
