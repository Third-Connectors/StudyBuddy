const { Client } = require('pg');
require('dotenv').config({ path: '../api-gateway/.env' });

async function check() {
  const pgClient = new Client({
    connectionString: process.env.DATABASE_URL,
    ssl: { rejectUnauthorized: false }
  });
  await pgClient.connect();
  const res = await pgClient.query(`
    SELECT conname, pg_get_constraintdef(c.oid) 
    FROM pg_constraint c 
    JOIN pg_namespace n ON n.oid = c.connamespace 
    WHERE conrelid = 'profiles'::regclass
  `);
  console.log(res.rows);
  await pgClient.end();
}
check();
