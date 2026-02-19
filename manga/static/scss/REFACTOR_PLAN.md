# Refactor SCSS Plan

## Goals
- Remove duplication
- Adopt strict mobile-first architecture (base styles first, then min-width breakpoints)

---

## Steps

### 1. Audit
- List all SCSS files
- Identify duplicated selectors and rules
- Detect repeated media queries
- Check for deep nesting (max 2 levels recommended)
- Identify repeated colors, spacing, and layout patterns

---

### 2. Create Core Partials
Organize the SCSS architecture with:

- scss/_variables.scss
- scss/_functions.scss
- scss/_mixins.scss
- scss/_placeholders.scss
- scss/_base.scss
- scss/_utilities.scss
- scss/components/ (one file per component)
- scss/layout/
- scss/pages/

Create a central entry file (main.scss or index.scss) that uses @use.

---

### 3. Centralize Breakpoints
Create a $breakpoints map and a mobile-first mixin:

```scss
$breakpoints: (
  tablet: 768px,
  desktop: 1024px,
  large: 1280px
);

@mixin respond-to($bp) {
  @if map-has-key($breakpoints, $bp) {
    @media (min-width: map-get($breakpoints, $bp)) {
      @content;
    }
  }
}
