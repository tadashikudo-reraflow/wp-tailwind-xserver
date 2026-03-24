# DESIGN.md — Design Tokens (SSOT)

> This file is the Single Source of Truth for design decisions.
> Edit here first, then reflect changes in `src/input.css` and `theme.json`.

---

## Color Palette

| Token | Value | Usage |
|-------|-------|-------|
| `primary` | `#7FB8E6` | Brand blue |
| `primary-light` | `#A2C6E9` | Lighter variant |
| `primary-dark` | `#5A9BD4` | Darker variant |
| `accent` | `#FFF5D1` | CTA section background |
| `emphasis` | `#4A90E2` | Links, buttons, highlights |
| `emphasis-dark` | `#357ABD` | Hover states |
| `text` | `#333333` | Body text |
| `text-light` | `#666666` | Secondary text |
| `surface` | `#F5F5F5` | Section backgrounds |
| `border` | `#E6E7EA` | Dividers, borders |
| `white` | `#FFFFFF` | Cards, backgrounds |

## Gradients

| Name | Value |
|------|-------|
| Hero | `linear-gradient(135deg, #7FB8E6 0%, #A2C6E9 30%, #FDFBD4 70%, #FCEEEB 100%)` |
| Footer | `linear-gradient(135deg, #3A6EA8 0%, #4A85C5 40%, #5A9BD4 70%, #7FB8E6 100%)` |

## Typography

| Font | Usage | Weights |
|------|-------|---------|
| Noto Sans JP | Body, headings (Japanese) | 400, 600, 700, 900 |
| Inter | English display, labels | 300, 400 |

## Spacing Scale

| Name | Value |
|------|-------|
| Section padding | `80px` top/bottom |
| Card padding | `40px` |
| Content max-width | `1200px` |
| Wide max-width | `1400px` |

## Component Decisions

- **Cards**: White bg, `border-radius: 16px`, subtle shadow `0 1px 3px rgba(0,0,0,0.04)`
- **Hover**: `translateY(-2px)` + shadow increase
- **Header**: Sticky, `backdrop-filter: blur(12px)`, 90% white opacity
- **Buttons**: `border-radius: 8px`, padding `16px 40px`
