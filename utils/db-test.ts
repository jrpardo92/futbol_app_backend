// utils/db-test.ts
import { testConnection } from '../config/database';

testConnection()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error('Error en la prueba de conexión:', error);
    process.exit(1);
  });