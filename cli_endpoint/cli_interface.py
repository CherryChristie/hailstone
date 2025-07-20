import sys
from ..hailstone_py.hailstone import calculate_hailstone, finalize_sequence

def main():
    if len(sys.argv) != 2:
        print("Usage: python -m src.cli.main <starting_number>")
        return

    try:
        start = int(sys.argv[1])
        sequence = calculate_hailstone(start)
        print(finalize_sequence(sequence))
    except ValueError:
        print("Error: Please provide a valid positive integer.")

if __name__ == "__main__":
    main()
