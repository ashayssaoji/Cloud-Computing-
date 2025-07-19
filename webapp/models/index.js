const { Sequelize } = require("sequelize");
const dbConfig = require("../config/config");

const sequelize = new Sequelize(
  dbConfig.database,
  dbConfig.username,
  dbConfig.password,
  {
    host: dbConfig.host,
    dialect: dbConfig.dialect,
    logging: false,
  }
);

(async () => {
  try {
    await sequelize.authenticate();
    console.log("Database connected successfully.");
  } catch (err) {
    // console.error('Unable to connect to the database:', err);
  }
})();

const db = { sequelize, Sequelize };

db.HealthCheck = require("./health.model")(sequelize, Sequelize);

module.exports = db;
