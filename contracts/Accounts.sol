// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Accounts {
    error OINK__UserAlreadyExist();
    error OINK__TokenNotWhitelisted();

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

    mapping(address user => uint256 points) private s_userPoints;
    mapping(address user => uint256 amount) private s_creditLimit;
    mapping(address user => uint256 amount) private s_creditBalance;
    mapping(address user => uint256 amount) private s_collateralBalance;

    mapping(address user => AccountDetails account) private s_accountDetails;

    struct AccountDetails {
        uint256 points;
        uint256 creditLimit;
        uint256 creditBalance;
        uint256 collateralBalance;
    }

    constructor(address _whitelistedTokenAddress) {
        s_whitelistedTokenAddress = _whitelistedTokenAddress;
    }

    modifier newUserOnly() {
        if (s_creditLimit[msg.sender] > 0) {
            revert OINK__UserAlreadyExist();
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
        _updateCreditLimit(_user);
    }

    // Update credit limit based on how many points
    function _updateCreditLimit(address _user) internal {
        uint256 points = getPoints(_user);

        if (points < 250) s_accountDetails[_user].creditLimit = s_bronzeCreditLimit;
        if (points >= 250 && points < 500) s_accountDetails[_user].creditLimit = s_silverCreditLimit;
        if (points >= 500 && points < 750) s_accountDetails[_user].creditLimit = s_goldCreditLimit;
        if (points >= 750 && points < 975) s_accountDetails[_user].creditLimit = s_platinumCreditLimit;
        if (points >= 975 && points <= 1000) s_accountDetails[_user].creditLimit = s_diamondCreditLimit;
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
