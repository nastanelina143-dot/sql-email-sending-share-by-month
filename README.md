# SQL Email Sending Share by Month

## Task
For each month and each account, find what share of all emails sent in that month belongs to the account, and when the account received its first and last email in that month.

## Two approaches to the same task

### 1. Window functions: `email_sending_share_by_month.sql`
- Builds the sending date from the session date and the sent-date offset
- Calculates the account's monthly share (%) with `COUNT() OVER(PARTITION BY ...)`
- Finds first and last sent dates with `MIN() OVER()` and `MAX() OVER()`
- Removes duplicates with `DISTINCT`

### 2. CTEs + aggregation + view: `email_sending_share_by_month_view.sql`
- Splits the logic into separate CTEs: base dates, emails per account per month, emails per month, first/last dates
- Aggregates with `GROUP BY` and joins the CTEs together
- Saves the result as a BigQuery `VIEW` so it can be reused in reports

## SQL techniques used
CTEs, subquery, window functions, aggregation, `JOIN ... USING`, date functions (`DATE_TRUNC`, `DATE_ADD`), `CAST`, `CREATE VIEW`

## Tools
Google BigQuery
