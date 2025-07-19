module.exports = (sequelize, DataTypes) => {
  const HealthCheck = sequelize.define('HealthCheck', {
    checkId: {
      type: DataTypes.INTEGER,
      autoIncrement: true,
      primaryKey: true,
    },
    datetime: {
      type: DataTypes.DATE,
      defaultValue: sequelize.literal('CURRENT_TIMESTAMP'),
    },
  }, {
    timestamps: false, 
    tableName: 'health_checks', 
  });

  return HealthCheck;
};