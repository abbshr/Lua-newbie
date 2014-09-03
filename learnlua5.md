## 数据结构

Lua中所有的数据结构均由table扩展而来

数组

arr = {}
arr = { 'a', 1, 3, 'fsdf' }

*下标默认从1开始

队列

queue = { first = 0, last = -1 }
-- 队列操作
function queue.push(q)
  local last = q.last + 1
  q[last] = last
  q.last = last
  return q
end
function queue.pop(q)
  local first = q.first
  if first > q.last then
    error("queue is empty")
  end
  q.frist = first + 1
  local value = q[first]
  q[first] = nil
  return value
end

字符串缓冲算法

由于每次追加将导致字符串在内存中的复制,如果大量的字符串经过复制,就会触发垃圾回收机制循环内存中所有的数据结构,找出垃圾数据清除.因此在如读取文件操作时,效率很低.下面是改进的算法:

function newStack()
  return { "" }
end

function addString(stack, s)
  table.insert(stack, s)
  for i = table.getn(stack), 1, -1 do
    if stack[i] > stack[i+1] then
      break
    end
    stack[i] = stack[i] .. table.remove(stack)
  end
end

最后用table.concat()可将table中的所有串拼接起来



