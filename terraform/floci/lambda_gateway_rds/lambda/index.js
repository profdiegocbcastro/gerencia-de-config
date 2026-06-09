const express = require('express');
const serverless = require('serverless-http');
const { Pool } = require('pg');

const app = express();
app.use(express.json());

const pool = new Pool({
  host:     process.env.DB_HOST,
  port:     parseInt(process.env.DB_PORT || '5432'),
  database: process.env.DB_NAME,
  user:     process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  ssl:      false,
  max:      1,
});

const initDB = async () => {
  await pool.query(`
    CREATE TABLE IF NOT EXISTS alunos (
      id        SERIAL PRIMARY KEY,
      nome      VARCHAR(100) NOT NULL,
      email     VARCHAR(100) UNIQUE NOT NULL,
      curso     VARCHAR(100) NOT NULL,
      criado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    )
  `);

  const { rows } = await pool.query('SELECT COUNT(*) FROM alunos');
  if (parseInt(rows[0].count) === 0) {
    await pool.query(`
      INSERT INTO alunos (nome, email, curso) VALUES
        ('Joao Silva',    'joao@example.com',  'Engenharia de Software'),
        ('Maria Santos',  'maria@example.com', 'Ciencia da Computacao'),
        ('Pedro Oliveira','pedro@example.com', 'Sistemas de Informacao')
    `);
  }
};

let initialized = false;

app.use(async (req, res, next) => {
  if (!initialized) {
    await initDB();
    initialized = true;
  }
  next();
});

app.get('/alunos', async (req, res) => {
  try {
    const { rows } = await pool.query('SELECT * FROM alunos ORDER BY id');
    res.json({ alunos: rows, total: rows.length });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

app.get('/alunos/:id', async (req, res) => {
  try {
    const { rows } = await pool.query('SELECT * FROM alunos WHERE id = $1', [req.params.id]);
    if (rows.length === 0) return res.status(404).json({ error: 'Aluno nao encontrado' });
    res.json(rows[0]);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

app.get('/health', (req, res) => {
  res.json({ status: 'healthy', db: process.env.DB_HOST });
});

module.exports.handler = serverless(app);
