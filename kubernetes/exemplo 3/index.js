const express = require('express');
const os = require('os');

const app = express();

app.get('/', (req, res) => {
    res.send({
        mensagem: "Load Balancer funcionando 🚀",
        pod: os.hostname()
    });
});

const PORT = 3000;

app.listen(PORT, '0.0.0.0', () => {
    console.log(`Rodando na porta ${PORT}`);
});