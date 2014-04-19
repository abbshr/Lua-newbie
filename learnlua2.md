## function

基本结构：

function name (arg_list)
  ...
end

**Note：如果参数只有一个，且是字符串或table类型时，函数调用的括号可选**

lua使用的函数可以是lua编写的也可以是其他语言编写的。

行参与实参的匹配与*赋值语句*类似：多删少补nil

多个返回值：

在return后列出要返回的值的列表，即可返回多值。

ex：

function leader (tb)
  local leadlist = {}
  for name, level in pairs(tb) do
    if level == "leader" then
      leadlist[name] = level
    end
  end
  return leadlist, tb
end

**Note：lua会根据调用环境调整函数返回值**

1. 作为表达式调用函数

+ 如果函数调用作为表达式的最后一个参数或唯一一个参数时，根据变量个数函数尽可能多的返回值，多删少补nil原则
+ 其他情况下，函数调用仅返回第一个值（如果没有返回值则返回nil）

2. 作为函数参数被调用

3. 在table中初始化

4. 作为函数的返回值调用

可以使用圆括号强制函数调用返回一个值

ex：

function foo () end

print(foo())	--
print((foo()))	-- nil

unpack()函数，接受一个数组，返回数组的所有元素。

Lua版实现：

function unpack(t, i)
  i = i or 1
  if t[i] then
    return t[i], unpack(t, i + 1)
  end
end

可变参数：

function name (a, b, ...)
  arg = {...}
end

虚变量法：将不需要的值放到一个回收变量中。`_`常用作虚变量。

闭包、词法作用域、高级函数

函数表达式写法： foo = function () end

说明函数是第一类值。闭包概念基本等同JS

作为table内函数：

tb = {}
tb.foo = function () end

ab = {
  foo = function () end
}

fb = {}
function fb.foo() end

局部函数：

local foo = function () end
local function foo() end

**Note：局部函数的递归**

如果按这种方式写：

local fact = function (n)
  if n == 0 then
  return 1
  else
  return n*fact(n-1)
  -- buggy
  end
end

print(fact(5))	--这里会报错，lua会认为fact是全局函数，结果找不到它

为解决这个问题，第一种方法首先声明fact：

local fact
fact = function (n)
  if n == 0 then
  return 1
  else
  return n*fact(n-1)
  -- buggy
  end
end

print(fact(5))

第二种方法：

local function fact(n)
  if n == 0 then
  return 1
  else
  return n*fact(n-1)
  -- buggy
  end
end

print(fact(5))

Note：没有类似JS中的“提升”

local f, g

function f() g() end
function g() f() end
f()

-- 如果写成如下，则会抛出错误：g被看作全局变量

local function f() g() end
local function g() f() end
f()

说明g的声明并没有被提升


尾调用（包含尾递归）

函数的最后一个动作是调用一个函数，称这种调用为尾调用。
因为父函数在尾调用后不会再做任何事情，因此栈中不需要保留其信息。
尾递归的层次可以无限，因为无需额外的栈空间，不会导致栈溢出。

function foo()
  ....
  return fact()
end

下面这些不是尾递归：

return fact() + 1

return (fact())

return x or fact()

fact()
return
