import pytest
from hailstone_py.hailstone import calculate_hailstone

def test_sequence_for_1():
    assert calculate_hailstone(1) == [1]

def test_sequence_for_7():
    result = calculate_hailstone(7)
    assert result[-1] == 1
    assert len(result) == 17

def test_invalid_input():
    with pytest.raises(ValueError):
        calculate_hailstone(0)

