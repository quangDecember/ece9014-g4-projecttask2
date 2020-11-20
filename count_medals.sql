-- joining 2 tables if using this formula
select sum(medal), authorid
from kernels
group by authorid;

select sum(medal), userid
from forummessages_tb
group by userid;