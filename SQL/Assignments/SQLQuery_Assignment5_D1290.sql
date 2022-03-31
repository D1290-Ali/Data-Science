create function dbo.Factorial (@Number int )
returns int
as
begin
declare @i  int
	if @Number <= 1
		set @i = 1
	else
		set @i = @Number * dbo.Factorial( @Number - 1 )
return (@i)
end

select dbo.factorial(8)