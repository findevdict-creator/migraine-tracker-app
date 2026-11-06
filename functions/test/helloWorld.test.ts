import { helloPayload } from "../src/helloWorld";

describe("helloPayload", () => {
  it("reports the region and an ISO timestamp", () => {
    const now = new Date("2026-11-06T08:00:00.000Z");
    expect(helloPayload(now)).toEqual({
      ok: true,
      region: "us-central1",
      time: "2026-11-06T08:00:00.000Z",
    });
  });
});
