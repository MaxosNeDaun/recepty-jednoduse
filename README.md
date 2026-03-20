# 🍳 Recepty jednoduše

> Vařte s radostí každý den — stovky receptů, jednoduché postupy a chuťové zážitky na dosah ruky.

![Version](https://img.shields.io/badge/version-1.0.0-blue.svg)
![License](https://img.shields.io/badge/license-MIT-green.svg)

## ✨ Funkce

- 🍴 **Kategorie receptů** - Snídaně, obědy, večeře, dezerty, zdravé recepty
- 🔍 **Vyhledávání** - Rychlé hledání receptů podle názvu
- ⚙️ **Filtry** - Doba přípravy, obtížnost, dieta
- ⭐ **Hodnocení** - Ohodnoťte své oblíbené recepty
- ➕ **Přidání receptu** - Přidejte vlastní recepty
- 📱 **Responsivní design** - Funguje na všech zařízeních

## 🖼️ Obrázky receptů

Aplikace obsahuje profesionální fotografie pro všechny recepty:
- 🍝 Carbonara
- 🥗 Řecký salát
- 🥣 Dýňová polévka
- 🍫 Lávový dort
- 🥑 Avokádový toast
- 🥩 Hovězí steak
- 🍣 Sushi bowl
- 🥞 Banánové lívance
- 🍕 Pizza Margherita
- 🍛 Zeleninové kari
- 🐟 Pečený losos
- 🌮 Tacos

## 🚀 Deployment na Render.com

### Metoda 1: Automatický deployment z GitHub (Doporučeno)

1. **Vytvoř repozitář na GitHub**
   ```bash
   git init
   git add .
   git commit -m "Initial commit"
   git branch -M main
   git remote add origin https://github.com/TVOJE-USERNAME/recepty-jednoduse.git
   git push -u origin main
   ```

2. **Připojení k Render.com**
   - Jdi na [render.com](https://render.com) a přihlaš se
   - Klikni na **"New +"** → **"Web Service"**
   - Připoj svůj GitHub repozitář
   - Render automaticky detekuje `render.yaml` a nastaví vše za tebe

3. **Hotovo!** 🎉
   - Render automaticky nasadí tvou aplikaci
   - Dostaneš URL ve formátu: `https://recepty-jednoduse-xxx.onrender.com`

### Metoda 2: Manuální nastavení

Pokud nechceš použít Blueprint:

1. Vytvoř nový **Web Service**
2. **Runtime**: Node
3. **Build Command**: `npm install`
4. **Start Command**: `npm start`
5. **Plan**: Free

## 🛠️ Lokální vývoj

### Požadavky
- Node.js 18+ 
- npm nebo yarn

### Instalace

```bash
# Naklonuj repozitář
git clone https://github.com/TVOJE-USERNAME/recepty-jednoduse.git
cd recepty-jednoduse

# Nainstaluj závislosti
npm install

# Spusť vývojový server
npm start
```

Aplikace běží na `http://localhost:3000`

## 📁 Struktura projektu

```
recepty-jednoduse/
├── index.html          # Hlavní HTML soubor
├── server.js           # Express server
├── package.json        # Node.js konfigurace
├── render.yaml         # Render.com konfigurace
├── README.md           # Tento soubor
├── .gitignore          # Git ignore soubor
└── images/             # Obrázky receptů
    ├── carbonara.jpg
    ├── greek-salad.jpg
    ├── pumpkin-soup.jpg
    ├── lava-cake.jpg
    ├── avocado-toast.jpg
    ├── steak.jpg
    ├── sushi-bowl.jpg
    ├── pancakes.jpg
    ├── pizza.jpg
    ├── curry.jpg
    ├── salmon.jpg
    └── tacos.jpg
```

## 🔧 Konfigurace

### Environment variables
- `PORT` - Port na kterém běží server (default: 3000)
- `NODE_ENV` - Prostředí (development/production)

## 📝 Licence

MIT License - volně k použití a úpravám.

---

Vytvořeno s ❤️ pro milovníky vaření.
