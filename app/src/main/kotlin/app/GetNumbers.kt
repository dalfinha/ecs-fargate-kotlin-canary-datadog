package app

import org.slf4j.LoggerFactory
import org.springframework.stereotype.Service
import org.springframework.web.client.RestTemplate
import com.fasterxml.jackson.module.kotlin.jacksonObjectMapper
import com.fasterxml.jackson.module.kotlin.readValue

@Service
class NumbersApiService {
    private val restTemplate = RestTemplate()
    private val objectMapper = jacksonObjectMapper()

    fun getNumberFact(number: Int): NumberFact? {
        val url = "http://numbersapi.com/$number?json"
        return try {
            val response = restTemplate.getForObject(url, String::class.java)
            response?.let { objectMapper.readValue<NumberFact>(it) }
        } catch (e: Exception) {
            null
        }
    }
}