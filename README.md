# WP Tailwind Starter

WordPress FSE Block Theme + Tailwind CSS v4 + Xserver SSH Deploy.
AI Agent-native workflow: edit locally → `npm run deploy` → live in seconds.

## Stack

- **WordPress 6.1+** Full Site Editing (FSE) Block Theme
- **Tailwind CSS v4** — CSS-first `@theme` config (no tailwind.config.js)
- **DESIGN.md** — Single Source of Truth for design tokens
- **SSH rsync** — Vercel-like deploy to Xserver

## Quick Start

### 1. Clone & Install

```bash
git clone https://github.com/YOUR_USERNAME/wp-tailwind-xserver.git my-theme
cd my-theme
npm install
```

### 2. Setup Deploy (Xserver)

```bash
./setup-deploy.sh <ssh-user> <server-id> <domain> [theme-folder-name]

# Example:
./setup-deploy.sh reraflow sv16843 reraflow.com my-theme
```

The script will:
- Generate an SSH key at `~/.ssh/xserver_<user>`
- Add an entry to `~/.ssh/config`
- Update `package.json` deploy script
- Print the public key to register in Xserver panel

**One manual step**: Copy the printed public key → Xserver Panel → SSH公開鍵登録

### 3. Test & Deploy

```bash
ssh xserver-<user>           # test connection
npm run deploy               # build + rsync to production
```

## Workflow

| Task | Command |
|------|---------|
| Watch CSS changes | `npm run watch` |
| Deploy to production | `npm run deploy` |
| Version release | `npm version patch && npm run deploy && npm run zip` |

## Customization

### Design Tokens

Edit `DESIGN.md` first (SSOT), then update `src/input.css` and `theme.json`:

```css
/* src/input.css */
@theme inline {
  --color-primary: #YOUR_COLOR;
  --color-emphasis: #YOUR_COLOR;
  /* ... */
}
```

```json
// theme.json
{ "slug": "primary", "color": "#YOUR_COLOR", "name": "Primary" }
```

### Block Patterns

Edit files in `patterns/`:

| File | Section |
|------|---------|
| `hero.php` | Top hero section |
| `services.php` | Service cards (3-up) |
| `company.php` | About / company table |
| `cta.php` | Contact CTA |

### Navigation

Edit `parts/header.html` to change nav links.

### Footer

Edit `parts/footer.html` to update footer links and copyright.

## File Structure

```
.
├── setup-deploy.sh       # SSH + deploy setup script
├── DESIGN.md             # Design tokens SSOT
├── style.css             # Theme metadata
├── functions.php         # Minimal WP functions
├── theme.json            # WP color palette + typography
├── package.json          # build / watch / deploy / zip scripts
├── src/
│   └── input.css         # Tailwind v4 + custom CSS
├── assets/css/
│   └── tailwind.css      # Built CSS (generated, do not edit)
├── parts/
│   ├── header.html       # Sticky header with nav
│   └── footer.html       # Footer with gradient
├── patterns/
│   ├── hero.php
│   ├── services.php
│   ├── company.php
│   └── cta.php
└── templates/
    ├── front-page.html   # Homepage
    ├── index.html        # Blog index
    └── page.html         # Generic page
```

## WordPress Setup

1. Upload theme zip to WP Admin → Appearance → Themes → Add New → Upload
2. Activate the theme
3. Settings → Reading → set Homepage to a static page
4. Set the static page template to "Front Page"

## Requirements

- WordPress 6.1+
- PHP 8.1+
- Node.js 18+ (for build)
- Xserver hosting (for deploy script)

## License

MIT
