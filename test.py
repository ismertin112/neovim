from typing import DefaultDict


DefaultDict = DefaultDict[int, int]


def test_defaultdict():
    d: DefaultDict = DefaultDict(int)
    d[1] += 1
    assert d[1] == 1
    assert d[2] == 0
