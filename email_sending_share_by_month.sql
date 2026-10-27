-- Final result: one row per account per month
select
     distinct
     sent_month,
     id_account,
     sent_msg_percent_from_this_month,
     first_sent_date,
     last_sent_date
from(
-- Calculate, for each account and month: its share of all emails sent that month (%), and its first and last sent dates
select
     -- Month of sending (session date shifted by the number of days until the email was sent)
     date_trunc(date_add(s.date, interval es.sent_date day), month) as sent_month,
     es.id_account as id_account,
     -- Emails sent by the account in the month / all emails sent in the month * 100
     count(es.id_message) over(partition by es.id_account, date_trunc(date_add(s.date, interval es.sent_date day), month)) /
     count(es.id_message) over(partition by date_trunc(date_add(s.date, interval es.sent_date day), month)) * 100 as sent_msg_percent_from_this_month,
     -- First and last email sent date of the account within the month
     min(date_add(s.date, interval es.sent_date day)) over(partition by es.id_account, date_trunc(date_add(s.date, interval es.sent_date day), month)) as first_sent_date,
     max(date_add(s.date, interval es.sent_date day)) over(partition by es.id_account, date_trunc(date_add(s.date, interval es.sent_date day), month)) as last_sent_date

from `data-analytics-mate.DA.email_sent` es
join `data-analytics-mate.DA.account` a
on es.id_account = a.id
join `data-analytics-mate.DA.account_session` acs
on a.id = acs.account_id
join `data-analytics-mate.DA.session` s
on acs.ga_session_id = s.ga_session_id) table_1
