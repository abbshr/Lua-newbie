# 协程 （coroutine）


创建一个协程：co = coroutine.create(function () end)

	将要运行的代码封装成函数，create返回thread类型的值。

查看协程状态：coroutine.status(co)

	协程三个状态：挂起态、运行态、停止态。

	创建协程之后处于挂起。

变为运行态：coroutine.resume(co)

	当协程执行结束后，状态变为"dead"。

运行态挂起：coroutine.yield()

	co = coroutine.create(function ()
	  for i = 1, 10 do
	    print(i)
	    coroutine.yield()
	  end
	end)

Note：当协程已出于dead状态时，如果调用resume将返回false和错误信息。

Note2：如果协同体内部存在错误，lua不会将错误抛出，而是返回给resume函数

lua中的resume和yield可以交换数据：

co = coroutine.create(function (a, b)
	coroutine.yield(a+b, a-b)
end)

coroutine.resume(co, 10, 20); -- true 30 -10

yield会返回传递给它的参数给resume调用。

co = coroutine.create(function () 
	print(coroutine.yield())
end)

coroutine.resume(co, 45) -- 45

resume传递的额外参数也会作为yield的返回。

当协同代码结束时，主函数返回的值会传给resume调用。

*这种协程为不对称协程*

严格意义的协程无论在任何地方（除了一些辅助代码内部）都可以并且只能使执行挂起。

**生产者、消费者问题**

function send(x)
	coroutine.yield(x)
end

producer = coroutine.create(function() 
	while true do
		local x = io.read()
		send(x)
	end
end)

function receive()
	local status, value = coroutine.resume(producer)
	return value
end

**生产者、过滤器、消费者**

在两者之间添加一个中介者，对来自生产者的数据进行处理，再返回给消费者。

function receive(prod)
	local status, value = coroutine.resume(prod)
	return value
end

function send(x)
	coroutine.yield(x)
end

function producer ()
	return coroutine.create(function () 
		while true do 
			local x = io.read()
			send(x)
		end
	end)

end

function filter(prod)
	return coroutine.create(function () 
		while true do
			local value = receive(prod)
			-- do filter
			send(value)
		end
	end)
end

function consumer(prod)
	while true do
		local value = receive(prod)
		io.write(value) -- consume the value
	end
end

--调用：

p = producer()
f = filter(p)
consumer(f)

--或：

consumer(filter(producer()))

**使用协程实现迭代器**

--输出一个数组的全排列
function permgen(a, n)
 if n == 0 then 
  coroutine.yield(a)
 else
  for i = 1, n do 
   a[n], a[i] = a[i], a[n]
   permgen(a, n-1)
   a[n], a[i] = a[i], a[n]
  end
end

function perm(a)
 local n = table.getn(a)
 local co = coroutine.create(function () permgen(a, n) end)
 return function ()
  local code, res = coroutine.resume(co)
  return res
 end
end

for p in perm {'a', 'b', 'c'} do
 printResult(p)
end
