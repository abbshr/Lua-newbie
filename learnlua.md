

## Lua中8大基本数据类型：

+ nil
+ boolean
+ number
+ string
+ userdata
+ function
+ thread
+ table

type函数可以测试给定变量或值的数据类型

nil：给全局变量赋nil可以删除变量
nil只和自己相等

boolean：除了false 和 nil 为假,其他值都为真。所以 Lua 认为 0 和空串都是真。

string：可以存储任意二进制数据。字符串是不可修改的。同JS一样。
	可以在字符串中使用\ddd三位十进制整数表示字符
	可以使用[[...]]表示字符串，如果第一个字符是换行符会被自动忽略掉。
	这种形式不会解释转译序列。
	ex：
	html = [[
		<head>
		</head>
		<body>
		</body>
	]]
	显示的将number转换成string可用tostring()
	或追加..
	可以用“ .. ”进行字符串拼接

number：string和number在一定条件下可相互转化。
	显示的将string转成number可用tonumber()，如果string不能被转化则返回nil
	隐式转化：对string使用算术操作符。

function：函数是第一类值，可以存储在变量中。同JS类似，具有闭包等函数式的特点。
	可以调用C实现的函数。

userdata：可以将C数据存放在Lua变量中，除了赋值和相等比较之外没有预定义操作。
	用来描述新类型。


## 表达式

关系运算符：==、~=
混合比较数字和字符串会报错

逻辑运算符：and or not
返回值类似JS

算术运算符：^幂运算

运算符优先级：

^
not - (unary)
* /
+ -
..
< > <= >= ~= ==
and or

除了^和.. 所有二元运算符都是左连接的

## Table

用来构建数组，列表（类似JS对象）

ex：

arr = {
  '12',
  'ggg',
  tab={name='Ran Aizen',"HIT"}
}

**note: 数组索引从1开始**

调用：

	arr[1]      --12
	arr[2]      --ggg
	arr['tab']  --{[1]="HIT", name="Ran Aizen"}
	arr.tab     --{[1]="HIT", name="Ran Aizen"}

也可以显式指定索引：

c = {
 ['-1'] = 'haha',
 ['@#&'] = 'YG',
 ['-1'] = 'xixixi'
}

-- {['-1'] = 'xixixi', ['@#$'] = 'YG'}


","可以用";"代替


## 赋值

多重赋值：a, b = 1, 2  等价于 a=1; b=2

对于赋值语句，lua先计算右边的所有值，然后再执行赋值操作。

所以可以这样交换变量的值：x, y = y, x

当左边和右边数量不一致时，

	变量个数>值个数	变量填补nil
	变量个数<值个数	忽略多余值

note：如果要为多个变量赋值，必须依次对每个变量指明值！
ex：
a, b, c = 0  
print(a,b,c)	--0	nil	nil

a, b, c = nil, nil, 0
print(a,b,c)	--nil	nil	0


## 局部变量

如果变量不声明，默认为全局变量。

使用`local`可以创建一个局部变量。它只在代码块（block）或chunk（被变量声明的文件）内有效。

ex:

x = 10	--全局变量
local a = 1	--chunk内的局部变量

while a <= x do
  local x = a / 2	--while循环体里的局部变量
end	

可以使用`do...end`可以创建一个block

## 语句

条件：

if conditions then
  ...
elseif conditions1 then
  ...
else
  ...
end

循环：

while condition do
   ...
end

repeat
   ...
until condition

for variable = exp1, exp2, exp3 do
   ...	--exp3默认为1，可以省略
end

其中variable是局部变量，自动被声明。

三个表达式在循环开始之前被计算

遍历：(范型for)

-- 遍历数组
for var1, var2 in ipairs(array) do
   print(var1, var2)
end

-- 遍历table
for var1, var2 in pairs(table) do
   print(var1, var2)
end

其中var1, var2均为局部变量

break和return：

只能出现在chunk的最后一句！（block的末尾）

可以显式的通过do...end在其他位置调用break和return
