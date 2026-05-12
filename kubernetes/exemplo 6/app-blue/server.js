const express = require("express");
const path = require("path");

const app = express();

const podName = process.env.HOSTNAME || "pod-desconhecido";

app.use(express.static(path.join(__dirname, "build")));

app.get("/podname", (req, res) => {
  res.send(podName);
});

app.use((req, res) => {
  res.sendFile(path.join(__dirname, "build", "index.html"));
});

app.listen(3000, () => {
  console.log("Servidor iniciado na porta 3000");
});