require("dotenv").config();
const express = require("express");
const db = require("./models");
const healthRoutes = require("./routes/health.routes");

const app = express();
app.use(express.json());
app.use("/", healthRoutes);

//this function creates a new table, if the table does not exist or if the table is dropped/deleted!
(async () => {
  try {
    await db.sequelize.sync({ alter: true });
    // console.log("Database sync successfully.");
  } catch (err) {
    // console.error("Failed to sync database:", err);
  }
})();

if (require.main === module) {
  const PORT = process.env.PORT || 3000;
  app.listen(PORT, () => {
    console.log(`Server is running on port ${PORT}`);
  });
}

module.exports = app;
