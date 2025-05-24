package app

data class NumberFact(
    val text: String,
    val number: Int,
    val found: Boolean,
    val type: String
)

data class LogPayload(
    val sortFirst: Int,
    val sortSecond: Int,
    val sortSum: Int,
    val data: NumberFact?
)
