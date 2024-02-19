// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;
/**
 * @title Reputation Score
 * @author https://github.com/X-O1
 * @notice Algorithm to determine a reputation score.
 */

contract ReputationScore {
/**
 * Score Weightage:
 * Payment History - 40% - Timing of Interest payments made for used balances
 * * Lender determines how many missed payments before closing account and labeling as default.
 * Limit Usage - 30% - Percentage of available balance withdrawn
 * Derogatory Marks - 20% - Number of Defaulted accounts
 * Length of Reputation - 10% - How long since user first established a reputation
 */

/**
 * Score Determination:
 * Score weightages and users wallet address would be used to generate a keccak256 hash and used as an on-chain indentifier. (MAYBE)
 *
 */
}
