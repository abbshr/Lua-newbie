local config = require('./config')
local http = require("http")
local html = [[
  <html>
    <head>
      <title>
]] .. config.title .. [[
      
      </title>
    </head>
    <body>
      <h1>
]] .. config.title .. [[
      
      </h1>
      <ul>
        <li>
]] .. config.owner .. [[
        
        </li>
        <li>
]] .. config.URL .. [[
        
        </li>
      </ul>
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
print(html, "Server listening at http://localhost:3000/")