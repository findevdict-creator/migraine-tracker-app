import type { Firestore } from "firebase-admin/firestore";

/** Enough of Firestore for the cache: one collection of documents. */
export class FakeFirestore {
  readonly docs = new Map<string, Record<string, unknown>>();
  reads = 0;
  writes = 0;

  collection(name: string): { doc: (id: string) => FakeDoc } {
    return {
      doc: (id: string) => new FakeDoc(this, `${name}/${id}`),
    };
  }

  asFirestore(): Firestore {
    return this as unknown as Firestore;
  }
}

class FakeDoc {
  constructor(
    private readonly store: FakeFirestore,
    private readonly path: string,
  ) {}

  get(): Promise<{ exists: boolean; data: () => Record<string, unknown> | undefined }> {
    this.store.reads++;
    const data = this.store.docs.get(this.path);
    return Promise.resolve({ exists: data !== undefined, data: () => data });
  }

  set(data: Record<string, unknown>): Promise<void> {
    this.store.writes++;
    this.store.docs.set(this.path, structuredClone(data));
    return Promise.resolve();
  }
}
