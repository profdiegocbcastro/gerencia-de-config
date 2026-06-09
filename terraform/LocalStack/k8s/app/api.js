const express = require('express');
const { Pool } = require('pg');

const app = express();
app.use(express.json());

const pool = new Pool({
  host: process.env.DB_HOST || 'postgres',
  port: 5432,
  database: process.env.DB_NAME || 'cefet',
  user: process.env.DB_USER || 'admin',
  password: process.env.DB_PASSWORD || 'senha123',
});

async function initDB() {
  await pool.query(`
    CREATE TABLE IF NOT EXISTS alunos (
      id SERIAL PRIMARY KEY,
      nome VARCHAR(100) NOT NULL,
      curso VARCHAR(100) NOT NULL,
      email VARCHAR(100) UNIQUE NOT NULL
    )
  `);
  await pool.query(`
    INSERT INTO alunos (nome, curso, email) VALUES
      ('João Silva', 'DevOps', 'joao@email.com'),
      ('Maria Santos', 'Kubernetes', 'maria@email.com'),
      ('Pedro Costa', 'Terraform', 'pedro@email.com')
    ON CONFLICT (email) DO NOTHING
  `);
}

setTimeout(() => initDB().catch(console.error), 3000);

let activeRequests = 0;
const MAX_REQUESTS = 10;

app.use((req, res, next) => {
  if (req.path === '/health') return next();

  if (activeRequests >= MAX_REQUESTS) {
    return res.status(503).json({
      error: 'Pod at capacity',
      pod: process.env.HOSTNAME,
      activeRequests,
    });
  }

  activeRequests++;
  res.on('finish', () => activeRequests--);
  next();
});

app.get('/health', (req, res) => {
  res.json({ status: 'healthy', pod: process.env.HOSTNAME, activeRequests });
});

app.get('/alunos', async (req, res) => {
  try {
    const result = await pool.query('SELECT * FROM alunos ORDER BY id');
    res.json({ pod: process.env.HOSTNAME, alunos: result.rows });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

app.listen(3000, '0.0.0.0', () => console.log('API running on port 3000'));
