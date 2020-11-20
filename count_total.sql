select count(submissionid),userid 
from submissions
group by USERID;

select count(forummid),userid
from forummessages_tb
group by userid;

select sum(totalgold + totalsilver + totalbronze), userid
from user_achievements
group by userid;