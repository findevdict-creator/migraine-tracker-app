import { config } from "../config";

/** The counts a phone sends: nothing that identifies a person or a day. */
export interface AuditPayload {
  attacks: number;
  hits: number;
  misses: number;
  highDays: number;
  falseAlarms: number;
  modelVersion: string;
}

/** What is stored: the payload plus the month the server saw it in. */
export interface AuditDoc extends AuditPayload {
  month: string;
  receivedAt: number;
}

export interface AuditStore {
  add(doc: AuditDoc): Promise<void>;
}

const KEYS = ["attacks", "falseAlarms", "highDays", "hits", "misses", "modelVersion"] as const;

function count(value: unknown, name: string, max: number): number {
  if (typeof value !== "number" || !Number.isInteger(value) || value < 0 || value > max) {
    throw new Error(`${name} must be a whole number from 0 to ${String(max)}`);
  }
  return value;
}

/**
 * Accepts exactly the six fields, as whole numbers that add up, and refuses
 * anything else. A stray field (a date, a place, an id) fails the call
 * rather than being dropped, so a client bug can never leak one quietly.
 */
export function parseAuditPayload(data: unknown): AuditPayload {
  if (typeof data !== "object" || data === null || Array.isArray(data)) {
    throw new Error("payload must be an object");
  }
  const input = data as Record<string, unknown>;
  const keys = Object.keys(input).sort();
  if (keys.length !== KEYS.length || keys.some((k, i) => k !== KEYS[i])) {
    throw new Error(`payload must have exactly ${KEYS.join(", ")}`);
  }
  const { maxAttacks, maxHighDays, modelVersionPattern } = config.audit;
  const attacks = count(input.attacks, "attacks", maxAttacks);
  const hits = count(input.hits, "hits", maxAttacks);
  const misses = count(input.misses, "misses", maxAttacks);
  const highDays = count(input.highDays, "highDays", maxHighDays);
  const falseAlarms = count(input.falseAlarms, "falseAlarms", maxHighDays);
  if (hits + misses !== attacks) throw new Error("hits and misses must add up to attacks");
  if (falseAlarms > highDays) throw new Error("falseAlarms cannot exceed highDays");
  if (attacks === 0 && highDays === 0) throw new Error("nothing to record");
  const modelVersion = input.modelVersion;
  if (typeof modelVersion !== "string" || !modelVersionPattern.test(modelVersion)) {
    throw new Error("modelVersion must look like 1.2.3");
  }
  return { attacks, hits, misses, highDays, falseAlarms, modelVersion };
}

/** The calendar month (UTC) before the one `now` falls in, as `yyyy-MM`. */
export function previousMonth(now: number): string {
  const d = new Date(now);
  const first = Date.UTC(d.getUTCFullYear(), d.getUTCMonth(), 1);
  const prev = new Date(first - 1);
  return `${String(prev.getUTCFullYear())}-${String(prev.getUTCMonth() + 1).padStart(2, "0")}`;
}

/** Stores one month's counts with the month stamped by the server clock. */
export async function recordAudit(store: AuditStore, data: unknown, now: number): Promise<void> {
  const payload = parseAuditPayload(data);
  await store.add({ ...payload, month: previousMonth(now), receivedAt: now });
}
