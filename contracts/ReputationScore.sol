// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;
/**
 * @title Reputation Score
 * @author https://github.com/X-O1
 * @notice Algorithm to determine a reputation score.
 */

contract ReputationScore {
/**
 * RANKING HIERARCHY:
 * 0 = Bronze Tier -> 100% Collateralized
 * 250 = Silver Tier -> 75% Collateralized
 * 500 = Gold Tier -> 50% Collateralized
 * 750 = Platinum Tier -> 25% Collateralized
 * 975 - 1000 = Diamond Tier -> 0% Collateralized
 *
 * User starts with a 0 score (Bronze Tier) after opening first line of secured credit.
 * Each rank allows user to deposit less collateral in order withdraw funds from balance.
 */

/**
 * LIQUIDATIONS:
 * If user reaches a higher rank while having a collateralized balance withdrawn, the user's callateral will be unlocked for them to withdraw. The percentage unlocked with be based on which rank they reached.
 *
 * If a user loses a rank while having a balance, which ever percentage that new rank demands will be liquidated from their collateral to meet that rank's collateral requirments. They must deposit more collateral that their new rank demands before downgrading or repay entire loan to avoid this.
 */

/**
 * CREDIT LIMITS:
 * Initial: $1k USDC/Tether
 * Every rank up unlocks a $1K limit increase and decreases for every rank lost.
 * Can only withdraw what percentage your rank allows without adding necessary collateral
 */

/**
 * APRs:
 * Fixed
 * Interest accrues only on non-collateralized percentage of balance. (Ex: A Diamond tier loan (0% collaterlized loan) would be accruing interest on 100% of the balance.)
 * If user ranks down with a balance, interest accrues on total balance and double on non-collateralized portion until enough collateral is deposited.
 *
 */

/**
 * PENALTIES:
 * Missed payments & Defaulted accounts will be reported to the credit bureaus.
 * User locked out of taking anymore loans
 *
 */

/**
 * POINT WEIGHTAGE:
 * Payment History - 40% - Timing of Interest payments made for used balances
 * Limit Usage - 30% - Percentage of available balance withdrawn
 * Derogatory Marks - 20% - EX: 1 per missed payment
 * Length of Reputation - 10% - How long since user first established a reputation
 */

/**
 * HOW POINTS WILL ACCUMULATE:
 * Each action will earn or slash a fixed amount of points.
 * Points can not get slashed if available balance is at 100%;
 */

/**
 * R&D:
 * How can I use weights to determine a score?
 * How does the score determine fixed APRs?
 */

/**
 * SIMULATION:
 * 1. Open Account: Rank: Bronze | Limit: $1k | Collateral Req: 100%
 * 2. Deposit $1000 into collateral account
 * 3. Withdraw $1000 from available balance
 * 4. $1000 of the collateral balance is locked
 * 5. Rank Up: Rank: Silver | Limit: $2k | Collateral Req: 75%
 * 6. 25% of collateral balance is unlocked and available for withdraw
 * 7. Withdraw 25% from collateral account. Loan: $1k Collateral: $750
 * 8. Interest starts accruing on the $250 non-collaterlized portion of the loan
 * 9. User misses an interest payment and doesnt have "auto-payment" on. (You can deposit $ into a pre-paid interest account to cover future interest payments "auto-payment")
 * 10. Ranks down: Rank: Bronze | Limit: $1k | Collateral Req: 100% | Loan: $1k | Collateral: $750
 * 11. Collateral account locked. APR now applies on total withdrawn balance and double APR on $250 until user deposits $250 needed to meet bronze rank 100% collateral requirment.
 */
}
