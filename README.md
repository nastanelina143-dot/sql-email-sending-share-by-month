# SQL Email Sending Share by Month

## Task
For each month and each account, find what share of all emails sent in that month belongs to the account, and when the account received its first and last email in that month.

## What the query does
- Builds the sending date from the session date and the sent-date offset, then truncates it to the month
- Calculates an account's share of monthly emails (%) using window functions
- Finds the first and last sent date per account per month with `MIN() OVER()` and `MAX() OVER()`
- Removes duplicate rows with `DISTINCT` to get one row per account per month

## SQL techniques used
Subquery, multiple `JOIN`s, window functions (`COUNT`, `MIN`, `MAX` with `PARTITION BY`), date functions (`DATE_TRUNC`, `DATE_ADD`)

## Tools
Google BigQuery
