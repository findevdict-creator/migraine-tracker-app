import { cellFor, parseCellRequest } from "../src/weather/cell";

describe("cellFor", () => {
  it("rounds to 0.1 degrees and builds a stable key", () => {
    expect(cellFor(51.5074, -0.1278)).toEqual({ lat: 51.5, lon: -0.1, key: "51.5,-0.1" });
    expect(cellFor(51.5074, -0.1278).key).toBe(cellFor(51.46, -0.14).key);
    expect(cellFor(0, 0).key).toBe("0.0,0.0");
    expect(cellFor(-33.8688, 151.2093).key).toBe("-33.9,151.2");
  });

  it("folds -180 into 180", () => {
    expect(cellFor(10, -180).key).toBe(cellFor(10, 180).key);
  });

  it("rejects bad coordinates", () => {
    expect(() => cellFor(91, 0)).toThrow(/valid coordinates/);
    expect(() => cellFor(Number.NaN, 0)).toThrow();
    expect(() => parseCellRequest({ lat: "51", lon: 0 })).toThrow(/numbers/);
    expect(() => parseCellRequest(null)).toThrow(/expected/);
    expect(parseCellRequest({ lat: 51.5, lon: -0.1 }).key).toBe("51.5,-0.1");
  });
});
