--[[
function fact (n)
	if n == 0 then
		return 1
	else
		return n * fact(n - 1)
	end
end

print("enter a number:")
a = io.read("*number")
print(fact(a))


--quota
page = [[
<HTML>
<HEAD>
<TITLE>An HTML Page</TITLE>
</HEAD>
<BODY>
Lua
[[a text between double brackets
</BODY>
</HTML>
io.write(page)]]--
--[[local function fact(n)
  print(22)
end
local function b( ... )
  print(11)
  fact()
end
print(b(5))
]]--

function foo( ... )
  function bar( ... )
    print(123)
  end
end

foo()
bar()
--print(x)