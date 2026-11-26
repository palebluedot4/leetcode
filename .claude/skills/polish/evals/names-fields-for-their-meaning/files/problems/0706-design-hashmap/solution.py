_SIZE = 769


class MyHashMap:
    def __init__(self) -> None:
        self.b: list[list[tuple[int, int]]] = [[] for _ in range(_SIZE)]

    def put(self, key: int, value: int) -> None:
        bucket = self.b[key % _SIZE]
        for i, (k, _) in enumerate(bucket):
            if k == key:
                bucket[i] = key, value
                return
        bucket.append((key, value))

    def get(self, key: int) -> int:
        return next((v for k, v in self.b[key % _SIZE] if k == key), -1)

    def remove(self, key: int) -> None:
        bucket = self.b[key % _SIZE]
        for i, (k, _) in enumerate(bucket):
            if k == key:
                del bucket[i]
                return
