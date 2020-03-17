use Northwind
go
drop proc sp_emp_nivel
go

alter proc sp_nivel_jefes @emp int,@nivel int output,@jefes varchar(300) output as
declare @reportsTo int

select @nivel = 0

if @jefes is null
	select @jefes = ''

select @reportsTo = ReportsTo from Employees 
where EmployeeID = @emp
	
while @reportsTo is not null
begin
	select @nivel = @nivel + 1

	select @jefes = @jefes +', '+FirstName+' '+LastName from Employees 
	where EmployeeID = @reportsTo

	select @reportsTo = ReportsTo from Employees
	where EmployeeID = @reportsTo
end
go



alter proc  sp_emp_nivel_jefe as
declare @emp int, @nivel int, @jefes varchar(300)

create table #t(emp int, nivel int, jefes varchar(300))
select @emp = min(EmployeeID) from Employees

while @emp is not null
begin
	
	exec sp_nivel_jefes @emp,@nivel output,@jefes output
	insert into #t values(@emp,@nivel,@jefes)
	select @nivel = 0, @jefes =''
	select @emp = min(EmployeeID) from Employees 
	where EmployeeID > @emp
end
select * from #t order by nivel
go

exec sp_emp_nivel_jefe