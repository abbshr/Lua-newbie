## metatables和metamethods

Metatables允许我们改变 table 的行为

每个表都可以有其Metatable.

任何一个表都可以是其他一个表的 metatable,一组相关的表可以共享一个 metatable(描述他们共同的行为).

一个表也可以是自身的 metatable(描述其私有行为)

创建一个不带metatable的表:
t = {}
print(getmetatable(t)) -- nil

使用setmetatable函数设置/改变一个表的metatable:
mt = {}
setmetatable(t, mt)
print(getmetatable(t) == mt) -- true

### 定义table的算术运算
对于每个算数运算法,metatable都有对应的域:

__add加,__sub减,__mul乘,__div除,__unm负,__pow幂

把相应的域赋值自定义函数,即可在调用算数运算时生效:

mt.__add = add

当对两个不同metatable的操作数执行算数运算时,选择metatable的原则是:

如果第一个操作数的metatable有相应的域,则使用这个metatable,否则查看第二个操作数,否则报错

### 定义table的关系运算

__eq等于,__lt小于,__le小于等于

关系运算的metatable不支持混合类型运算.如果两个操作数的metatable不同,则直接报错.但相等操作除外,如果类型不等直接返回false

### 其他metamethod

print函数通常会调用tostring来格式化输出,而tostring又会调用参数的metatable的__tostring域.

setmetatable/getmetatable会使用__metatable域: 可用于metatable的保护

设置table的__metatable后,setmetatable则会报错,而getmetatable会返回__metatabel的值


