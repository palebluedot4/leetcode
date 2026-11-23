_SIZE = 769


class MyHashSet:
    def __init__(self) -> None:
        self._buckets: list[list[int]] = [[] for _ in range(_SIZE)]

    def add(self, key: int) -> None:
        bucket = self._buckets[key % _SIZE]
        if key not in bucket:
            bucket.append(key)

    def remove(self, key: int) -> None:
        bucket = self._buckets[key % _SIZE]
        if key in bucket:
            bucket.remove(key)

    def contains(self, key: int) -> bool:
        return key in self._buckets[key % _SIZE]
