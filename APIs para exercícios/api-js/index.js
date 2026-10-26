import express from 'express';
import os from 'os';
import router from './router.js';
import db from './database.js';

const app = express();
const port = 3000;

app.use(express.json());

app.get('/info', (req, res) => {
    res.json({ pod: os.hostname(), node: process.env.NODE_NAME || 'local' });
});

app.get('/cpu', (req, res) => {
    const inicio = Date.now();
    while (Date.now() - inicio < 50) Math.sqrt(Math.random());
    res.json({ pod: os.hostname() });
});

app.use('/', router);

try {
    await db.authenticate();
    console.log("Eba!");
} catch (error) {
    console.log("Não eba...");
}

app.listen(port, () => {
    console.log(`Rodando na porta ${port}.`);
});

process.on('SIGTERM', () => process.exit(0));
