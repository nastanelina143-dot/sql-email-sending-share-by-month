-- Create a view with the monthly email sending share per account
create view `Students.v_emails_sent_by_month_nelina_1` as

-- Build the actual sending date (session date + sent-date offset) and its month for every email
with sent_date_month as (SELECT
    es.id_account,
    es.id_message,
    date_add(s.date, INTERVAL es.sent_date day) as sent_date,
    date_trunc(date_add(s.date, INTERVAL es.sent_date day), month) as sent_month
FROM `data-analytics-mate.DA.email_sent` es
join `data-analytics-mate.DA.account_session` acs
on es.id_account = acs.account_id
join `data-analytics-mate.DA.session` s
using(ga_session_id)),

-- Count emails sent by each account in each month
mssg_cnt_per_acc as (select
    id_account,
    sent_month,
    count(id_message) as mssg_cnt_1
from sent_date_month
group by 1, 2),

-- Count all emails sent in each month
mssg_cnt_per_month as (select
    sent_month,
    count(id_message) as mssg_cnt_2
from sent_date_month
group by 1),

-- Find the first and last sent date of each account in each month
first_and_last_dates as (select
    id_account,
    sent_month,
    max(sent_date) as last_sent_date,
    min(sent_date) as first_sent_date
from sent_date_month
group by 1, 2)

-- Combine everything: account's share of the month's emails (%), first and last sent dates
select
    mssg_cnt_per_acc.sent_month,
    mssg_cnt_per_acc.id_account,
    CAST(mssg_cnt_1 AS FLOAT64) / mssg_cnt_2 * 100 as sent_msg_percent_from_this_month,
    first_sent_date,
    last_sent_date
from mssg_cnt_per_acc
join mssg_cnt_per_month
using(sent_month)
join first_and_last_dates
on mssg_cnt_per_acc.id_account = first_and_last_dates.id_account and
mssg_cnt_per_acc.sent_month = first_and_last_dates.sent_month
