package app

import com.sun.net.httpserver.HttpServer
import java.net.InetSocketAddress

fun startHealthServer() {
    val server = HttpServer.create(InetSocketAddress(8080), 0)
    server.createContext("/actuator/health") { exchange ->
        println("Conexão recebida de: ${exchange.remoteAddress}")

        val response = "OK"
        exchange.sendResponseHeaders(200, response.length.toLong())
        exchange.responseBody.use { it.write(response.toByteArray()) }
    }
    server.executor = null
    server.start()
    println("Servidor iniciado na porta 80")
}
