## 迭代器

闭包实现：

function list_iter(t)
  local i = 0;
  local n = table.getn(t)
  return function () 
    i = i + 1
    if i <= n then return t[i] end
  end
end

泛型for如何使用迭代器？

for elem in list_iter(t) do
  print(elem)
end

泛型for在内部保存了三个值：迭代函数、状态常量、控制变量

**Note：状态常量在for结构中没有用处，仅仅是在初始化迭代函数是提供参数**

for <var-list> in <exp-list> do end

var-list的第一个变量：控制变量
exp-list：迭代工厂。
执行过程

1.初始化exp-list，返回结果会调整为3个，分别为泛型for需要的三个值，原则等同多值赋值
2.将状态常量与var-list作为参数调用迭代函数
3.将迭代器返回的值赋给var-list
4.如果返回的第一个值为nil退出，否则回到第二步

等价于：

do
	local _iter, _state, _var = explist
	while true do
		local _var1, _var2, ... , _varn = iter(state, _var)
		_var = _var1
		if ~_var then break end
	end
end	

无状态迭代器：不保留状态，无闭包开销

迭代的状态包括*被遍历的表*、*当前的索引下标*
无状态迭代器将这两个值分别视为“状态常量”和“控制变量”，每次迭代都用这两个变量作为参数

ex：ipairs

function iter(a, i)
	i = i + 1
	local v = a[i]
	if v then return i, v end
end

function ipairs(a)
	return iter, a, 0
end


多状态的迭代器

使用table来保存状态信息。不过这种方式的开销大于闭包创建，速度也略慢。

local function iter(state) end

function generator()
	local state = {state=..., var=...}
	return iter, state

## 编译、加载、运行

虽然Lua 是解释型语言,但是 Lua 会首先把代码预编译成中间码然后再执行

loadfile()函数可以加载文件作为chunk但不执行，loadfile会返回一个chunk函数，当调用这个函数时才执行chunk里的代码

loadstring()是从一个字符串中读入chunk，也是返回chunk函数不执行。之后的操作类似JS中的eval()
会在全局环境编译。ex：

function foo( ... )
    loadstring("local x = 1")()
    print(x)
end

foo()	--打印nil
print(x)	--打印nil

f = loadstring("function foo() print(123) end")
f()
foo()	--123

也就是说loadstring中字符串的执行环境是独立的chunk。
因为lua把每一个chunk当作一个匿名函数处理：

loadstring("a = 1")

=>

function () a = 1 end

既然是在函数中，当然也可以返回（return）值。

如果load*函数发生错误会返回nil和错误信息


require函数

require会判断文件是否已经加载，避免重复加载。

被用来加载函数库

require使用的路径是模式列表，查找一个文件时将按如下模式进行：

?;?.lua;c:\windows\?.lua;/usr/local/lua/?/?.lua

## 抛出异常和错误处理

assert()函数提供了错误处理。
ex：

n = assert(io.read(), "invalid!")

error()可以抛出错误

