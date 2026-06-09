const express = require('express');
const { DynamoDBClient } = require('@aws-sdk/client-dynamodb');
const { DynamoDBDocumentClient, ScanCommand, GetCommand } = require('@aws-sdk/lib-dynamodb');

const app = express();

const dynamo = DynamoDBDocumentClient.from(new DynamoDBClient({
  region: 'us-east-1',
  endpoint: 'http://localstack:4566',
  credentials: { accessKeyId: 'test', secretAccessKey: 'test' },
}));

app.get('/health', (req, res) => {
  res.json({ status: 'healthy' });
});

app.get('/alunos', async (req, res) => {
  try {
    const result = await dynamo.send(new ScanCommand({ TableName: 'alunos' }));
    res.json(result.Items);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

app.get('/alunos/:id', async (req, res) => {
  try {
    const result = await dynamo.send(new GetCommand({
      TableName: 'alunos',
      Key: { id: req.params.id },
    }));
    if (!result.Item) return res.status(404).json({ error: 'Aluno não encontrado' });
    res.json(result.Item);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

app.listen(5000, '0.0.0.0', () => console.log('API running on port 5000'));
