// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Accounts {
    error OINK__UserAlreadyExist();
    error OINK__TokenNotWhitelisted();

    // Whitelisted Stablecoins
    address[] private s_whitelistedTokenAddresses;
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

    constructor(address[] memory _whitelistedTokenAddresses) {
        s_whitelistedTokenAddresses = _whitelistedTokenAddresses;
    }

    modifier newUserOnly() {
        if (s_creditLimit[msg.sender] > 0) {
            revert OINK__UserAlreadyExist();
        }
        _;
    }

    modifier onlyWhitelistedTokens(address _tokenAddress) {
        for (uint256 i = 0; i < s_whitelistedTokenAddresses.length; i++) {
            if (s_whitelistedTokenAddresses[i] == _tokenAddress) {
                return;
                _;
            }
        }
        revert OINK__TokenNotWhitelisted();
    }

    // Start initial credit limit
    function openAccount() public newUserOnly {
        _updatePoints(msg.sender, s_pointsForOpeningNewAccount);
    }

    // Update user points
    function _updatePoints(address _user, uint256 _action) internal {
        s_userPoints[_user] += _action;
        _updateCreditLimit(_user);
    }

    // Update credit limit based on how many points
    function _updateCreditLimit(address _user) internal {
        uint256 points = _getPoints(_user);

        if (points < 250) s_creditLimit[_user] = s_bronzeCreditLimit;
        if (points >= 250 && points < 500) s_creditLimit[_user] = s_silverCreditLimit;
        if (points >= 500 && points < 750) s_creditLimit[_user] = s_goldCreditLimit;
        if (points >= 750 && points < 975) s_creditLimit[_user] = s_platinumCreditLimit;
        if (points >= 975 && points <= 1000) s_creditLimit[_user] = s_diamondCreditLimit;
    }

    function _getPoints(address _user) internal view returns (uint256) {
        return s_userPoints[_user];
    }

    function getCreditLimit(address _user) public view returns (uint256) {
        return s_creditLimit[_user];
    }
}
