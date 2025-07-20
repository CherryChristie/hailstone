def calculate_hailstone(start: int) -> list[int]:
    if start < 1:
        raise ValueError("Start must be a positive integer.")
    sequence = [start]
    while start != 1:
        start = start // 2 if start % 2 == 0 else 3 * start + 1
        sequence.append(start)
    return sequence

def finalize_sequence(sequence: list[int]) -> str:
    steps = len(sequence) - 1
    return f"The sequence took {steps} steps.\nSequence: {sequence}"
 