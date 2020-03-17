use Northwind
go
drop proc sp_emp_nivel
go

alter proc sp_emp_nivel @emp int,@nivel int output,@jefes varchar(300) output as
declare @reportsTo int

select @nivel = 0
select @jefes = ''
select @reportsTo = ReportsTo from Employees 
where EmployeeID = @emp
	
while @reportsTo is not null
begin
	select @nivel = @nivel + 1
	select @reportsTo = ReportsTo from Employees
	where EmployeeID = @reportsTo
end
select @nivel
go

declare @n int 
exec sp_emp_nivel 1,@n output
select @n
go
select EmployeeID,ReportsTo from Employees