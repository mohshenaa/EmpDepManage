use EmpManDB
select * from Employees
select * from Departments
--1"Show me all employees whose salary is greater than 40,000.
select * from Employees where salary >40000
--2Find employees whose salary is between 30,000 and 60,000.
select * from Employees where salary between 30000 and 60000

--3Find all employees belonging to IT.
select * from Employees where DepId in(select DepId from Departments where DepName='IT')
--or
select e.EmpName,d.DepName from Employees e join Departments d on e.DepId=d.DepId where DepName='IT'

--4Find employees whose name contains "a".
select * from Employees where EmpName like '%a%'
--5Find employees whose email contains "gmail".
select * from Employees where Email like '%gmail%'

--6Find employees from IT whose salary is greater than 40,000.
select e.EmpName,d.DepName from Employees e join Departments d on e.DepId=d.DepId where DepName='IT' and salary >40000

--7Show all employees ordered by salary from highest to lowest.
select * from Employees order by Salary desc

--8Show the employee with the lowest salary.
select top 1* from Employees order by Salary asc

--9Show the employee with the highest salary.
select top 1* from Employees order by Salary desc

--10Find the total number of employees.
select count(EmpId)as 'total Employee' from Employees 

--11Find how many employees have salary greater than 40,000.
select count(EmpId) as 'total Employee' from Employees where salary >40000

--12Find the average employee salary.
select avg(salary) as 'Average Salary' from Employees 

--13Find the total salary paid to all employees.
select sum(salary) as 'total Salary' from Employees 

--14Show each department and the number of employees in that department.
select count(e.EmpId) as 'employee number',d.DepName from Employees e join Departments d on e.DepId=d.DepId group by d.DepName
--15Show each department and its total salary.
select sum(e.salary) as 'total Salary',d.DepName from Employees e join Departments d on e.DepId=d.DepId group by d.DepName

--16Show each department and its average salary
select avg(e.salary) as 'Avg Salary',d.DepName from Employees e join Departments d on e.DepId=d.DepId group by d.DepName
--17Employee + Department...Show: Employee Name | Email | Department Name | Salary
select e.EmpName as 'Employee Name',e.Email,d.DepName as 'Department Name' ,e.Salary from Employees e join Departments d on e.DepId=d.DepId 

--18Show employee name, email and salary for employees belonging to IT.
select e.EmpName,e.Email,e.Salary from Employees e join Departments d on e.DepId=d.DepId where DepName='IT'

--19Find the highest salary for every department.
select max(salary),d.DepName from Employees e join Departments d on e.DepId=d.DepId group by d.DepName

--20Find employees whose salary is greater than the overall average salary
select * from Employees where salary>(select avg(salary) from Employees)

--21Find the second-highest salary
select top 1* from Employees where salary <(select max(salary) from Employees) order by salary desc

--22Find duplicate email addresses.
select Email,count(*) as duplicate from Employees group by email having count(*)>1

--23Find departments having more than 2 employees.
select d.DepName,count(e.EmpId) as number from Employees e left join Departments d on e.DepId=d.DepId group by d.DepName having count(e.EmpId)>2

--24Find employees who don't belong to any department.
select e.EmpName,d.DepName from Employees e join Departments d on e.DepId=d.DepId where DepName is null

--25Find the department with the highest total salary
select top 1 sum(salary) as total,d.DepName from Employees e join Departments d on e.DepId=d.DepId group by d.DepName order by sum(salary) desc

--26Find employees whose salary is higher than their department's average salary.?????
select e.EmpName,d.DepName,salary from Employees e join Departments d on e.DepId=d.DepId where salary>(select avg(salary) as avg from Employees e1 where e1.DepId=e.depId)


--27Find the top 3 highest-paid employees.
select top 3* from Employees order by Salary desc

--28Find employees whose names start with M.
select * from Employees where EmpName like 'M%'

--29Find employees whose salary has not been assigned / is NULL
select * from Employees  where Salary is null

--30Find employees in either IT or HR.
select e.EmpName,d.DepName from Employees e join Departments d on e.DepId=d.DepId where DepName='it'or DepName='hr'

--31Check whether any employee belongs to the IT department.
If Exists
(select * from Employees e join Departments d on e.DepId=d.DepId where d.DepName= 'IT')
Select 1 else select 0

go
create procedure Getallemployees
as begin
select e.EmpId,e.EmpName,e.Email,e.PhoneNumber,e.Salary,d.DepName from Employees e join Departments d on e.DepId=d.DepId 
end 
go 
exec Getallemployees
go

--Stored Procedure with Parameter : return all employees belonging to that department.
create procedure Getemployeesbydep
@depId int
as begin
select * from Employees where DepId=@depId
end 
go 
exec Getemployeesbydep @depId=1
go
--Stored Procedure with Parameter : return all employees belonging to that departmentName.
create procedure GetemployeebydepName
@depName varchar(30)
as begin
select e.EmpId,e.EmpName,e.Email,e.PhoneNumber,e.Salary,d.DepName from Employees e join Departments d on e.DepId=d.DepId where d.DepName=@depName
end 
go 
exec GetemployeebydepName @depName='HR'
go

--insert an employee
create proc InsertEmployee
@EmpName varchar(100),@Email varchar(100), @Phone varchar (50), @Salary decimal(18,2),@depId int
as begin
begin transaction
if(@EmpName is null)
begin rollback transaction
raiserror('Employee name cannot be null',16,1)
return
end
if exists (
select 1 from Employees where Email=@Email
)
begin rollback transaction
raiserror('Email already exists',16,1)
return
end
if exists(select 1 from Employees where PhoneNumber= @Phone)
begin rollback transaction
raiserror('PhoneNumber already exists',16,1)
return
end
if (@Salary is null or @Salary<=0)
begin rollback transaction
raiserror('salary must be greater than 0',16,1)
return
end
if not exists (select 1 from Departments where DepId=@depId)
begin rollback transaction
raiserror('department must exists',16,1)
return
end

insert into Employees(EmpName,Email,PhoneNumber,Salary,DepId)
values (@EmpName,@Email,@Phone,@Salary,@depId)
commit transaction
end

go 
exec InsertEmployee @EmpName='munia',@Email='munia@gmail.com',@Phone='01236856974',@Salary=35000,@depId=1
go

--update procedure
create proc updateEmployee
@EmpId int, @EmpName varchar(100),@Email varchar(100), @Phone varchar (50), @Salary decimal(18,2),@depId int
as begin

begin transaction

if not exists(
select 1 from Employees where EmpId=@EmpId)
begin 
rollback transaction
raiserror('Employee not found',16,1)
return
end

if (@EmpName is null)
begin 
rollback transaction
raiserror('Employee name cannot be null',16,1)
return
end

if exists(
select 1 from Employees where Email=@Email and EmpId<>@EmpId)
begin 
rollback transaction
raiserror('Email already exists',16,1)
return
end

if exists(
select 1 from Employees where PhoneNumber=@Phone and EmpId<>@EmpId)
begin 
rollback transaction
raiserror('Phone number already exists',16,1)
return
end

if (@Salary<=0 or @Salary is null)
begin 
rollback transaction
raiserror('Salary must be grater than 0',16,1)
return
end

if not exists(
select 1 from Departments where DepId=@depId)
begin 
rollback transaction
raiserror('Departments must exists',16,1)
return
end

update Employees
set EmpName=@EmpName, Email=@Email,PhoneNumber =@Phone, Salary=@Salary,DepId=@depId where EmpId=@EmpId
commit transaction
end
exec updateEmployee @EmpId=12,  @EmpName='sadi',@Email='sadia@gmail.com',@Phone='01123456987',@Salary=35000,@depId=1
go

--delete employee
create proc deleteEmployee
@EmpId int

as begin
begin transaction

if not exists(
select 1 from Employees where EmpId=@EmpId)
begin 
rollback transaction
raiserror('Employee not found',16,1)
return 
end
delete from Employees where EmpId=@EmpId
commit transaction
end
exec deleteEmployee @EmpId=12
go

--update procedure with try...catch
create proc UpdateEmployeeSafe
@EmpId int, @EmpName varchar(100),@Email varchar(100), @Phone varchar (50), @Salary decimal(18,2),@depId int
as begin

begin try
begin transaction

if not exists(
select 1 from Employees where EmpId=@EmpId)
begin 
raiserror('Employee not found',16,1)
return
end

if (@EmpName is null)
begin 
raiserror('Employee name cannot be null',16,1)
return
end

if exists(
select 1 from Employees where Email=@Email and EmpId<>@EmpId)
begin 
raiserror('Email already exists',16,1)
return
end

if exists(
select 1 from Employees where PhoneNumber=@Phone and EmpId<>@EmpId)
begin 
raiserror('Phone number already exists',16,1)
return
end

if (@Salary<=0 or @Salary is null)
begin 
raiserror('Salary must be grater than 0',16,1)
return
end

if not exists(
select 1 from Departments where DepId=@depId)
begin 
raiserror('Departments must exists',16,1)
return
end

update Employees
set EmpName=@EmpName, Email=@Email,PhoneNumber =@Phone, Salary=@Salary,DepId=@depId where EmpId=@EmpId
commit transaction
end try

begin catch
if @@TRANCOUNT>0
rollback transaction

declare @errormessage varchar(100)
set @errormessage=ERROR_MESSAGE()

RAISERROR(@errormessage, 16, 1)
end catch

end
exec UpdateEmployeeSafe @EmpId=12,  @EmpName='sadi',@Email='sadia@gmail.com',@Phone='01123456987',@Salary=35000,@depId=1
go

--view
create view vw_EmployeeDepartment
as
select e.EmpId,d.DepName,e.EmpName,e.Email,salary from Employees e join Departments d on e.DepId=d.DepId
go
select * from vw_EmployeeDepartment;
go
--create view showing Salary greater than 40000.
create view vw_HighSalaryEmployees
as
select e.EmpId,e.EmpName,e.Email,salary,d.DepName from Employees e join Departments d on e.DepId=d.DepId where salary>40000
go
select * from vw_HighSalaryEmployees;
go

--It should return one row per department with:DepName,,Number of employees → EmployeeCount,,Total salary → TotalSalary,,Average salary → AverageSalary
create view vw_DepartmentSalarySummary
as
select d.DepName,count(e.EmpId) as EmployeeCount,sum(e.Salary) as TotalSalary,avg(e.Salary) as AverageSalary from Employees e join Departments d on e.DepId=d.DepId group by d.DepName
go
select * from vw_DepartmentSalarySummary;
go

--create view showing employee with it
create view vw_ITEmployees
as
select e.EmpId,e.EmpName,e.Email,salary,d.DepName from Employees e join Departments d on e.DepId=d.DepId where d.DepName='IT'
go
select * from vw_ITEmployees;
go

----create view showing employee's annual salary
create view vw_EmployeeSalaryReport
as
select e.EmpName,d.DepName,salary,(e.Salary*12)as AnnualSalary from Employees e join Departments d on e.DepId=d.DepId 
go
select * from vw_EmployeeSalaryReport;
go

--case
select EmpName,Salary,
case
when salary >= 50000 then 'High'
when salary >=30000 and salary< 50000 then 'Medium'
when salary <30000 then 'Low'
else 'other'
end as SalaryGrade
from Employees
go

--case 2
select EmpName,Salary,
case
when salary >=50000 then '10%'
when salary >=30000 then '5%'
when salary <30000 then '2%'
else 'n/a'
end as BonusPercentage,
case 
when salary >=50000 then Salary*.10
when salary >=30000then Salary*.05
when salary <30000 then Salary*.02
else 'n/a'
end as BonusAmount
from Employees
go

--sql task
select d.DepName,count(e.EmpId) as EmployeeCount,sum(e.Salary) as TotalSalary from Employees e join Departments d on e.DepId=d.DepId group by d.DepName having sum(e.Salary)>100000

--sql task 2
select e.EmpName,d.DepName,e.Salary from Employees e join Departments d on e.DepId=d.DepId where e.salary>(select avg(e1.Salary) from Employees e1 where e.DepId=e1.DepId)
go

--search store procedure
create proc SearchEmployees
@Search varchar(100)

as begin

select EmpName,Email from Employees
where EmpName like '%'+ @Search+'%' or Email like '%'+ @Search+'%'

end
EXEC SearchEmployees @Search = 'meem';
go

--case,join,orderby-- salary report-
select e.EmpId,e.EmpName,d.DepName,e.Salary,
case
when Salary >= 50000 then 'High'
when Salary >= 30000 then 'Medium'
else 'Low'
end as SalaryGrade
from Employees e join Departments d on e.DepId=d.DepId
order by Salary desc
go

-----------final task--------------
--1--
select top 2 e.EmpName,e.Salary,d.DepName from Employees e join Departments d on e.DepId=d.DepId where DepName ='IT'
order by e.Salary desc

--2---
select d.DepName,avg(e.salary) as avg from Employees e join Departments d on e.DepId=d.DepId group by d.DepName having 
avg(e.salary)>40000
go
-----3---
create proc GetEmployeeById
@EmpId int
as begin
if not exists(
select 1 from Employees where EmpId=@EmpId
)
begin
raiserror('Employee not found',16,1)
return
end
select e.EmpName,d.DepName from Employees e join Departments d on e.DepId=d.DepId where EmpId=@EmpId

end
exec GetEmployeeById @EmpId=6
go

-----4----
create view vw_EmployeeAnnualSalary
as
select e.EmpName,d.DepName,e.Salary,(e.Salary*12)as AnnualSalary from Employees e join Departments d on e.DepId=d.DepId 
go
select * from vw_EmployeeAnnualSalary

----5---
select e.EmpName,d.DepName,e.Salary from Employees e join Departments d on e.DepId=d.DepId where salary>(select 
avg(e1.salary) from Employees e1 where e.DepId=e1.DepId)