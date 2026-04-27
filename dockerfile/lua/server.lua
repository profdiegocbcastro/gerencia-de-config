local socket = require("socket")

local server = assert(socket.bind("*", 8091))

while true do
  local client = server:accept()
  client:settimeout(1)
  local request = client:receive("*l")

  if request and (request:find("^GET / HTTP/1%.1") or request:find("^GET / HTTP/1%.0")) then
    client:send("HTTP/1.1 200 OK\r\nContent-Type: text/plain\r\nContent-Length: 11\r\n\r\nHello World")
  else
    client:send("HTTP/1.1 404 Not Found\r\nContent-Length: 0\r\n\r\n")
  end

  while true do
    local line = client:receive("*l")
    if not line or line == "" then
      break
    end
  end

  client:close()
end
