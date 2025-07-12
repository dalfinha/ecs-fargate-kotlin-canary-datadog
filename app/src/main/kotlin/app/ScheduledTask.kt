package app

import org.slf4j.LoggerFactory
import org.springframework.scheduling.annotation.Scheduled
import org.springframework.stereotype.Component
import kotlin.random.Random
import com.fasterxml.jackson.module.kotlin.jacksonObjectMapper
import com.fasterxml.jackson.module.kotlin.registerKotlinModule
import net.logstash.logback.argument.StructuredArguments.keyValue

@Component
class ScheduledTask(private val numbersApiService: NumbersApiService) {
    private val logger = LoggerFactory.getLogger(ScheduledTask::class.java)
    private val objectMapper = jacksonObjectMapper().apply { registerKotlinModule() }

    @Scheduled(fixedRate = 60000)
    fun generateRandomSum() {
        val sortFirst = Random.nextInt(100)
        val sortSecond = Random.nextInt(100)
        val sortSum = sortFirst + sortSecond

        val data = numbersApiService.getNumberFact(sortSum)

        logger.info("sortNumbers: {}, {}, sum: {}, response: {}",
            keyValue("sortFirst", sortFirst),
            keyValue("sortSecond", sortSecond),
            keyValue("sortSum", sortSum),
            keyValue("response", data)
        )
    }
}
