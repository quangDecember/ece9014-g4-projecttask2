select count(submissionid),userid 
from submissions
group by USERID;

select count(forummid),userid
from forummessages_tb
group by userid;