import java.util.*
import java.util.concurrent.Executors
import java.util.concurrent.TimeUnit

var total = 0

fun main() {
    val scheduler = Executors.newScheduledThreadPool(1)

    var task = Runnable {
        println("== Sorteador Aleatorio para Soma ==")

        var randomNum1 = Random().nextInt(100)
        var randomNum2 = Random().nextInt(100)
        total = randomNum1 + randomNum2

        println("Números sorteados = $randomNum1 + $randomNum2")
        println("É igual a: $total")
    }

    scheduler.scheduleAtFixedRate(task, 0, 1, TimeUnit.SECONDS)
}
