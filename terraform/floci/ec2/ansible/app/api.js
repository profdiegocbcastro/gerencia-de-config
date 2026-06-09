const express = require('express');

const app = express();

app.get('/', (req, res) => {
  res.json({ message: 'Hello World!', status: 'ok' });
});

app.get('/health', (req, res) => {
  res.json({ status: 'healthy' });
});

const port = process.env.PORT || 5000;
app.listen(port, '0.0.0.0', () => {
  console.log(`API rodando na porta ${port}`);
});
