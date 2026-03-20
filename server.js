const express = require('express');
const path = require('path');
const app = express();
const PORT = process.env.PORT || 3000;

// Statické soubory (obrázky, CSS, JS)
app.use(express.static(path.join(__dirname)));

// Hlavní stránka
app.get('/', (req, res) => {
  res.sendFile(path.join(__dirname, 'index.html'));
});

// Health check endpoint pro Render
app.get('/health', (req, res) => {
  res.status(200).json({ status: 'OK', timestamp: new Date().toISOString() });
});

// 404 handler - vrátí index.html pro SPA chování
app.use((req, res) => {
  res.sendFile(path.join(__dirname, 'index.html'));
});

app.listen(PORT, () => {
  console.log(`🍳 Recepty jednoduše běží na portu ${PORT}`);
  console.log(`📱 Otevři http://localhost:${PORT} ve svém prohlížeči`);
});
