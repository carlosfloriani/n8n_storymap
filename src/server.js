const express = require('express');
const cors = require('cors');
const helmet = require('helmet');
const morgan = require('morgan');
require('dotenv').config();

const app = express();
const PORT = process.env.PORT || 3000;

// Middleware
app.use(helmet());
app.use(cors());
app.use(morgan('combined'));
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Rotas
app.get('/', (req, res) => {
  res.json({
    message: 'StoryMapp API está funcionando!',
    version: '1.0.0',
    timestamp: new Date().toISOString()
  });
});

// Rota de health check
app.get('/health', (req, res) => {
  res.json({
    status: 'OK',
    uptime: process.uptime(),
    timestamp: new Date().toISOString()
  });
});

// Rota para integração com n8n
app.get('/api/n8n-status', async (req, res) => {
  try {
    const axios = require('axios');
    const n8nResponse = await axios.get('http://n8n:5678/healthz', { timeout: 5000 });
    res.json({
      n8n: 'online',
      status: n8nResponse.data
    });
  } catch (error) {
    res.status(503).json({
      n8n: 'offline',
      error: error.message
    });
  }
});

// Middleware de tratamento de erros
app.use((err, req, res, next) => {
  console.error(err.stack);
  res.status(500).json({
    error: 'Algo deu errado!',
    message: err.message
  });
});

// Middleware para rotas não encontradas
app.use('*', (req, res) => {
  res.status(404).json({
    error: 'Rota não encontrada',
    path: req.originalUrl
  });
});

// Iniciar servidor
app.listen(PORT, () => {
  console.log(`🚀 StoryMapp API rodando na porta ${PORT}`);
  console.log(`📊 Health check: http://localhost:${PORT}/health`);
  console.log(`🔗 n8n status: http://localhost:${PORT}/api/n8n-status`);
});

module.exports = app; 