const db = require("../models");
const HealthCheck = db.HealthCheck;

exports.checkHealth = async (req, res) => {
  if (
    req.url.includes("?") ||
    Object.keys(req.query).length > 0 ||
    req.headers["content-length"] > 0 ||
    Object.keys(req.body).length > 0
  ) {
    return res.status(400).set("Cache-Control", "no-cache").send();
  }

  try {
    await HealthCheck.create();
    res.status(200).set("Cache-Control", "no-cache, no-store, must-revalidate"),
      res.status(200).set("Pragma", "no-cache"),
      res.status(200).set("X-Content-Type-Options", "nosniff").send();
  } catch (err) {
    // console.error('Health check failed:', err);
    res.status(503).set("Cache-Control", "no-cache, no-store, must-revalidate"),
      res.status(503).set("Pragma", "no-cache"),
      res.status(503).set("X-Content-Type-Options", "nosniff").send();
  }
};
