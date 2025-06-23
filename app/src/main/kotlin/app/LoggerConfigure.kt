package app
import com.fasterxml.jackson.annotation.JsonProperty

data class NumberFact(
    val number: Int,
    val found: Boolean,
    val type: String,
    val text: String
)

data class LogPayload(
    val sortFirst: Int,
    val sortSecond: Int,
    val sortSum: Int,
    val numberFact: NumberFact?,

    @JsonProperty("dd.trace_id")
    val dd_trace_id: String,

    @JsonProperty("dd.span_id")
    val dd_span_id: String,
)