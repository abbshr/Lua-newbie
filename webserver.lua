local http = require("http")
local html = [[
  <html>
    <body>
      <h1>Hello World</h1>
    </body>
  </html>
]]

local function cb(req, res)
  res:writeHead(200, {
    ["Content-Type"] = "text/html",
    ["Content-Length"] = #html,
    ['X-Powered-By'] = "Lua & libuv",
    ['Server'] = "Ran_Server"
  })
  res:finish(html)
end
local server = http.createServer(cb)

server:listen(3000)

print("Server listening at http://localhost:3000/")