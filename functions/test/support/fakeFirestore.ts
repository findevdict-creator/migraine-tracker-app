import type { Firestore } from "firebase-admin/firestore";

export interface FakeSnapshotDoc {
  id: string;
  ref: FakeDoc;
  data: () => Record<string, unknown>;
}

export interface FakeCollection {
  doc: (id: string) => FakeDoc;
  get: () => Promise<{ docs: FakeSnapshotDoc[] }>;
}

/** Enough of Firestore for the functions: flat collections of documents. */
export class FakeFirestore {
  readonly docs = new Map<string, Record<string, unknown>>();
  reads = 0;
  writes = 0;
  deletes = 0;

  collection(name: string): FakeCollection {
    return {
      doc: (id: string): FakeDoc => new FakeDoc(this, `${name}/${id}`),
      get: (): Promise<{ docs: FakeSnapshotDoc[] }> => {
        this.reads++;
        const prefix = `${name}/`;
        const docs = [...this.docs.entries()]
          .filter(([path]) => path.startsWith(prefix))
          .map(([path, data]) => ({
            id: path.slice(prefix.length),
            ref: new FakeDoc(this, path),
            data: (): Record<string, unknown> => data,
          }));
        return Promise.resolve({ docs });
      },
    };
  }

  asFirestore(): Firestore {
    return this as unknown as Firestore;
  }
}

export class FakeDoc {
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

  delete(): Promise<void> {
    this.store.deletes++;
    this.store.docs.delete(this.path);
    return Promise.resolve();
  }
}
