const request = require("supertest");
const app = require("../index");

describe("Health Check API /healthz", () => {
  test("Should return 200 OK when database is connected", async () => {
    const db = require("../models");
    jest.spyOn(db.HealthCheck, "create").mockResolvedValue({});

    const response = await request(app).get("/healthz");

    expect(response.status).toBe(200);

    db.HealthCheck.create.mockRestore();
  });

  test("Should return 400 Bad Request if query parameters are sent", async () => {
    const response = await request(app).get("/healthz?extra=1");
    expect(response.status).toBe(400);
  });

  test("Should return 405 Method Not Allowed for POST", async () => {
    const response = await request(app).post("/healthz");
    expect(response.status).toBe(405);
  });

  test("Should return 405 Method Not Allowed for PUT", async () => {
    const response = await request(app).put("/healthz");
    expect(response.status).toBe(405);
  });

  test("Should return 405 Method Not Allowed for DELETE", async () => {
    const response = await request(app).delete("/healthz");
    expect(response.status).toBe(405);
  });

  test("Should return 405 Method Not Allowed for PATCH", async () => {
    const response = await request(app).patch("/healthz");
    expect(response.status).toBe(405);
  });

  test("Should return 405 Method Not Allowed for HEAD", async () => {
    const response = await request(app).head("/healthz");
    expect(response.status).toBe(405);
  });

  test("Should return 405 Method Not Allowed for options", async () => {
    const response = await request(app).options("/healthz");
    expect(response.status).toBe(405);
  });

  test("Should return 404 Not Found for unknown routes", async () => {
    const response = await request(app).get("/invalid-route");
    expect(response.status).toBe(404);
  });

  test("Should return 503 Service Unavailable when database is down", async () => {
    const db = require("../models");

    // Mock `HealthCheck.create()` to throw an error
    jest
      .spyOn(db.HealthCheck, "create")
      .mockRejectedValue(new Error("Database down"));

    const response = await request(app).get("/healthz");

    expect(response.status).toBe(503);

    // Restore original implementation after the test
    db.HealthCheck.create.mockRestore();
  });
});
