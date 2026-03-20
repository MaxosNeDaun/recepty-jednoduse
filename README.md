# 🍳 Recepty jednoduše + Supabase

> Vařte s radostí každý den — nyní s plným backendem včetně databáze, autentizace a real-time aktualizací!

## 🗄️ Co je Supabase?

**Supabase** je open-source alternativa k Firebase, postavená na PostgreSQL databázi.

| Funkce | Popis |
|--------|-------|
| **Database** | PostgreSQL s real-time subscriptions |
| **Auth** | Přihlašování (email, Google, GitHub...) |
| **Storage** | Ukládání obrázků a souborů |
| **Edge Functions** | Serverless funkce |
| **Real-time** | Live aktualizace dat |

---

## 🚀 Rychlý start

### Krok 1: Vytvoření Supabase projektu

1. Jdi na [supabase.com](https://supabase.com)
2. Klikni **"Start your project"** a přihlaš se přes GitHub
3. Vytvoř nový projekt:
   - **Name**: `recepty-jednoduse`
   - **Database Password**: (vygeneruj silné heslo)
   - **Region**: `Central EU (Frankfurt)`
4. Klikni **"Create new project"**

### Krok 2: Získání API klíčů

V Supabase dashboardu:
1. Jdi do **Project Settings** → **API**
2. Zkopíruj:
   - `Project URL` (např. `https://xxxxx.supabase.co`)
   - `anon public` API klíč

### Krok 3: Vytvoření databázových tabulek

V Supabase dashboardu:
1. Jdi do **SQL Editor** → **New query**
2. Vlož obsah souboru `supabase-schema.sql`
3. Klikni **"Run"**

### Krok 4: Konfigurace aplikace

V souboru `index.html` najdi tuto část a doplň své údaje:

```javascript
const SUPABASE_URL = 'https://YOUR_PROJECT_ID.supabase.co';
const SUPABASE_KEY = 'YOUR_ANON_PUBLIC_KEY';
```

---

## 📊 Databázové tabulky

### `categories` - Kategorie receptů
| Sloupec | Typ | Popis |
|---------|-----|-------|
| id | serial | Primární klíč |
| slug | varchar | Unikátní identifikátor |
| name | varchar | Název kategorie |
| emoji | varchar | Emoji ikona |

### `recipes` - Recepty
| Sloupec | Typ | Popis |
|---------|-----|-------|
| id | serial | Primární klíč |
| name | varchar | Název receptu |
| slug | varchar | Unikátní URL |
| description | text | Popis |
| category_id | integer | Reference na kategorii |
| image_url | text | URL obrázku |
| time_minutes | integer | Doba přípravy |
| servings | integer | Počet porcí |
| difficulty | varchar | Obtížnost (easy/medium/hard) |
| rating | decimal | Průměrné hodnocení |
| rating_count | integer | Počet hodnocení |
| author_id | uuid | Autor receptu |
| is_public | boolean | Veřejný/schovaný |

### `ingredients` - Ingredience
| Sloupec | Typ | Popis |
|---------|-----|-------|
| id | serial | Primární klíč |
| recipe_id | integer | Reference na recept |
| name | varchar | Název ingredience |
| amount | varchar | Množství |
| order_index | integer | Pořadí |

### `steps` - Kroky přípravy
| Sloupec | Typ | Popis |
|---------|-----|-------|
| id | serial | Primární klíč |
| recipe_id | integer | Reference na recept |
| description | text | Popis kroku |
| emoji | varchar | Emoji ikona |
| order_index | integer | Pořadí |

### `favorites` - Oblíbené recepty
| Sloupec | Typ | Popis |
|---------|-----|-------|
| user_id | uuid | Uživatel |
| recipe_id | integer | Recept |

### `ratings` - Hodnocení
| Sloupec | Typ | Popis |
|---------|-----|-------|
| user_id | uuid | Uživatel |
| recipe_id | integer | Recept |
| rating | integer | Hodnocení 1-5 |

---

## 🔐 Bezpečnost (Row Level Security)

Databáze používá RLS (Row Level Security) pro ochranu dat:

- **Veřejné recepty** - viditelné pro všechny
- **Vlastní recepty** - uživatel vidí své recepty i když nejsou veřejné
- **Oblíbené** - každý uživatel vidí jen své oblíbené
- **Hodnocení** - veřejně viditelná, ale měnit může jen autor

---

## ⚡ Real-time funkce

Aplikace automaticky sleduje změny v databázi:
- Nové recepty se objeví okamžitě
- Aktualizace hodnocení jsou live
- Přidání do oblíbených je okamžité

---

## 📁 Struktura projektu

```
recepty-supabase/
├── index.html              # Hlavní aplikace s Supabase
├── supabase-schema.sql     # SQL pro vytvoření tabulek
├── server.js               # Express server
├── package.json            # Node.js konfigurace
├── render.yaml             # Render.com konfigurace
├── README.md               # Tento soubor
└── .gitignore              # Git ignore
```

---

## 🚀 Deployment na Render.com

### 1. Pushni kód na GitHub

```bash
git init
git add .
git commit -m "Initial commit"
git branch -M main
git remote add origin https://github.com/TVOJE-USERNAME/recepty-supabase.git
git push -u origin main
```

### 2. Vytvoř Web Service na Render

1. Jdi na [dashboard.render.com](https://dashboard.render.com)
2. **New +** → **Web Service**
3. Připoj GitHub repozitář
4. Nastavení:
   - **Build Command**: `npm install`
   - **Start Command**: `npm start`
   - **Plan**: Free

### 3. Hotovo! 🎉

---

## 🛠️ Lokální vývoj

```bash
# Instalace závislostí
npm install

# Spuštění serveru
npm start

# Aplikace běží na http://localhost:3000
```

---

## ✨ Funkce aplikace

### Pro nepřihlášené uživatele:
- ✅ Prohlížení všech veřejných receptů
- ✅ Filtrování podle kategorie, času, obtížnosti
- ✅ Vyhledávání receptů
- ✅ Zobrazení detailu receptu
- ✅ Vidět hodnocení

### Pro přihlášené uživatele:
- ✅ Vše výše + 
- ✅ Přidávání vlastních receptů
- ✅ Ukládání receptů do oblíbených
- ✅ Hodnocení receptů
- ✅ Real-time aktualizace

---

## 🔧 Troubleshooting

### Chyba: "Invalid API key"
- Zkontroluj, že jsi správně zkopíroval `anon public` klíč
- Ujisti se, že URL končí na `.supabase.co`

### Recepty se nenačítají
- Zkontroluj v Supabase **Table Editor**, zda existují tabulky
- Ověř v **Authentication** → **Policies**, že jsou nastaveny RLS policies

### Nepřihlašuje to
- V **Authentication** → **Providers** musí být zapnutý **Email**
- Pro testování můžeš vypnout email confirmation v **Settings**

---

## 📚 Užitečné odkazy

- [Supabase Dokumentace](https://supabase.com/docs)
- [Supabase JavaScript Client](https://supabase.com/docs/reference/javascript)
- [PostgreSQL Dokumentace](https://www.postgresql.org/docs/)

---

Vytvořeno s ❤️ a 🍳
