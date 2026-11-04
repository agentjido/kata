type Entry = { value: string; createdAt: number };

export class Cache {
  private entries = new Map<string, Entry>();
  constructor(private ttlMs = 30_000, private now = () => Date.now()) {}

  put(key: string, value: string): void {
    if (this.ttlMs === 0) return;
    this.entries.set(key, { value, createdAt: this.now() });
  }

  get(key: string): string | undefined {
    const entry = this.entries.get(key);
    if (!entry) return undefined;
    if (this.now() - entry.createdAt >= this.ttlMs) {
      this.entries.delete(key);
      return undefined;
    }
    return entry.value;
  }
}
