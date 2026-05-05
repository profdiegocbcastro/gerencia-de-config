import express from "express";

const app = express();

const PORT = process.env.PORT || 3000;
const APP_NAME = process.env.APP_NAME || "App padrão";
const ENVIRONMENT = process.env.ENVIRONMENT || "dev";

app.get("/", (req, res) => {
  res.json({
    message: "App rodando com sucesso!",
    appName: APP_NAME,
    environment: ENVIRONMENT
  });
});

app.listen(PORT, () => {
  console.log(`Rodando na porta ${PORT}`);
});