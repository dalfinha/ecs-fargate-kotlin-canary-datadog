package app

import io.opentelemetry.api.trace.Span
import org.slf4j.LoggerFactory
import org.springframework.scheduling.annotation.Scheduled
import org.springframework.stereotype.Component
import kotlin.random.Random
import com.fasterxml.jackson.module.kotlin.jacksonObjectMapper
import com.fasterxml.jackson.module.kotlin.registerKotlinModule

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

        val spanContext = Span.current().spanContext
        val traceId = spanContext.traceId
        val spanId = spanContext.spanId

        val payload = LogPayload(
            sortFirst = sortFirst,
            sortSecond = sortSecond,
            sortSum = sortSum,
            numberFact = data,
            dd_trace_id = traceId,
            dd_span_id = spanId
        )

        val mapPayload = objectMapper.convertValue(payload, Map::class.java) as Map<String, Any?>

        val jsonLog = objectMapper.writeValueAsString(mapPayload)
        logger.info(jsonLog)
    }
}
