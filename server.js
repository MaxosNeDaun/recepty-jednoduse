const express = require('express');
const path = require('path');
const app = express();
const PORT = process.env.PORT || 3000;

// Statické soubory
app.use(express.static(path.join(__dirname)));

// Hlavní stránka
app.get('/', (req, res) => {
  res.sendFile(path.join(__dirname, 'index.html'));
});

// Health check pro Render
app.get('/health', (req, res) => {
  res.status(200).json({ 
    status: 'OK', 
    timestamp: new Date().toISOString(),
    service: 'recepty-jednoduse-supabase'
  });
});

// 404 handler
app.use((req, res) => {
  res.sendFile(path.join(__dirname, 'index.html'));
});

app.listen(PORT, () => {
  console.log('🍳 Recepty jednoduše + Supabase');
  console.log(`🌐 Server běží na http://localhost:${PORT}`);
  console.log('');
  console.log('📋 Nezapomeň:');
  console.log('   1. Vytvořit Supabase projekt');
  console.log('   2. Spustit SQL z supabase-schema.sql');
  console.log('   3. Doplnit SUPABASE_URL a SUPABASE_KEY v index.html');
});
