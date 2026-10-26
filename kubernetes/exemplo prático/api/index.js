import express from 'express';
import os from 'os';

const app = express();
const port = 3000;

app.get('/info', (req, res) => {
    res.json({ pod: os.hostname(), node: process.env.NODE_NAME || 'local' });
});

app.get('/cpu', (req, res) => {
    const inicio = Date.now();
    while (Date.now() - inicio < 50) Math.sqrt(Math.random());
    res.json({ pod: os.hostname() });
});

app.listen(port, () => {
    console.log(`Rodando na porta ${port}.`);
});

process.on('SIGTERM', () => process.exit(0));
