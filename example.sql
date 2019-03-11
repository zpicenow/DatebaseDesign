create table my{
  num INTEGER not null ;
  myname character ;
}
create table employee(
empmp number(4) not null, ###员工编号
ename varchar(10), ###员工姓名
job varchar2(9), ###员工工种
mgr number(4), ###上机经理编号
hredate date, ###受雇日期
sal number(7,2), ###受雇薪水
comm number(7,2), ###福利
depton number(2) ###部门编号
)
INSERT  into employee > select * from scott.emp

alter table employee add constraint FK_depton FOREIGN KEY(DEPTON) REFERENCES dept(DEPTNO)
alter table employee add(empTel_no varchar2(12) , empAddress varchar2(20));
select * from employee
alter table employee drop column emptel_no

alter table employee drop column empAddress
select * from  employee order by sal desc
select empno from employee
UNION
select empno from Emp
select empno from employee
UNION
select empno from emp
order by empno

select ename,deptno,sal,
rank() over(partition by deptno order by sal desc) “rank”,
dense_rank() over(partition by deptno order by sal desc) “dense_rank”,
row_number() over(partition by deptno order by sal desc) “row_number”
from employee

select ename,
sal+NVL(comm,0) sall,
nvl2(comm,sal+comm,sal) sal2,

select ename dno
from employee , my
where employee.empmp = my.empmp(+)  --带+的是副表，不带加号的是主表，主表全部显示，