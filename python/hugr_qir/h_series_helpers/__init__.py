
def to_int(bits: list[bool]) -> int:
    # Create an integer from the random bits
    integer_value = 0
    if len(bits) > 63:
        raise ValueError("as_i64: only supports lists of bits up to length 63")
    for b in bits:
        integer_value = (integer_value << 1) | int(b)  # for big-endian
    return integer_value

