package app

import com.fasterxml.jackson.annotation.JsonProperty

data class NumberFact(
    val number: Int,
    val found: Boolean,
    val type: String,
    val text: String
)