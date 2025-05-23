package app

import org.springframework.scheduling.annotation.Scheduled
import org.springframework.stereotype.Component
import kotlin.random.Random

@Component
class ScheduledTask {

    @Scheduled(fixedRate = 120_000)
    fun generateRandomSum() {
        val a = Random.nextInt(100)
        val b = Random.nextInt(100)
        val total = a + b
        println("== Sorteador Aleatório ==")
        println("$a + $b = $total")
    }
}
