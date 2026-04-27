import com.sun.net.httpserver.HttpServer
import java.net.InetSocketAddress

fun main() {
    val server = HttpServer.create(InetSocketAddress(8089), 0)
    server.createContext("/") { exchange ->
        if (exchange.requestMethod == "GET" && exchange.requestURI.path == "/") {
            val response = "Hello World".toByteArray()
            exchange.sendResponseHeaders(200, response.size.toLong())
            exchange.responseBody.use { it.write(response) }
        } else {
            exchange.sendResponseHeaders(404, -1)
        }
    }
    server.executor = null
    server.start()
}
