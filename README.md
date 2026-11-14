# Tallerweb2

Online store for Taller Web 2. Angular frontend + Express/Prisma backend + PostgreSQL.

```
Angular (root, :4200) ──HTTP──> Express + TypeScript (Backend/, :3000) ──Prisma──> PostgreSQL 17 (Docker, :5432)
```

The backend is layered: `routes -> controller -> service -> repository -> prisma`. The API lives under `/api/...` (`productos`, `categorias`, `subcategorias`).

## Local setup (step by step)

### Prerequisites

- [Node.js](https://nodejs.org/) 22+ and npm
- [Docker Desktop](https://www.docker.com/products/docker-desktop/) (must be running)
- Git

### 1. Get the code

```bash
git clone https://github.com/rioslucas1/tp-tallerweb2.git
cd tp-tallerweb2
# Keep the original repo as "upstream" to pull team changes
git remote add upstream https://github.com/pucci96/tp-tallerweb2.git
```

### 2. Start PostgreSQL

From the repo root:

```bash
docker compose -f docker-compose.postgres.yml up -d
```

This starts a Postgres 17 container (user `postgres`, password `postgres`, database `prisma`) on port `5432`. `-d` runs it in the background. Data persists in the `postgres_data` Docker volume.

### 3. Configure the backend

Create `Backend/.env`:

```env
DATABASE_URL="postgresql://postgres:postgres@127.0.0.1:5432/prisma"
PORT=3000
```

The URL format is `postgresql://USER:PASSWORD@HOST:PORT/DATABASE`.

> **Use `127.0.0.1`, not `localhost`.** On some Windows machines `localhost` resolves to IPv6 (`::1`) first, and Docker Desktop's port forward does not answer there, so Prisma fails with `P1001: Can't reach database server`.

`.env` is git-ignored: never commit it.

### 4. Install dependencies

Root and `Backend/` are separate npm projects, so install both:

```bash
npm install
cd Backend
npm install
```

### 5. Create the database tables

Still in `Backend/`:

```bash
npx prisma migrate deploy   # applies the SQL migrations in prisma/migrations
npx prisma generate         # generates the typed Prisma Client used by the repositories
```

### 6. Run the app

Two terminals:

```bash
# Terminal A — backend (http://localhost:3000)
cd Backend
npx tsx server.ts
```

```bash
# Terminal B — frontend (http://localhost:4200), from the repo root
npm start
```

Open `http://localhost:4200/`. Quick API check: `http://localhost:3000/api/productos` should return `200` (an empty `[]` until there is data).

### Troubleshooting

| Error | Cause | Fix |
| --- | --- | --- |
| `P1012: Argument "url" is missing in data source block "db"` | Old `schema.prisma` without `url` | Pull the latest changes (`url = env("DATABASE_URL")` is now in the schema) |
| `P1001: Can't reach database server at localhost:5432` | Postgres not running, or `localhost` resolving to IPv6 | Check `docker ps`; use `127.0.0.1` in `DATABASE_URL` |
| `column Producto.imagen does not exist` (500 on `/api/productos`) | Database created with old migrations | Run `npx prisma migrate deploy` in `Backend/` |
| `failed to connect to the docker API` | Docker Desktop is not running | Start Docker Desktop and retry |

### Changing the database schema

Edit `Backend/prisma/schema.prisma`, then create a migration and commit it together with the schema change:

```bash
cd Backend
npx prisma migrate dev --name short_description
```

Avoid `npx prisma db push` for shared changes: it updates your local database but does not create a migration file, so teammates' databases drift.

## Development server

To start only the frontend dev server, run:

```bash
ng serve
```

Once the server is running, open your browser and navigate to `http://localhost:4200/`. The application will automatically reload whenever you modify any of the source files.

## Code scaffolding

Angular CLI includes powerful code scaffolding tools. To generate a new component, run:

```bash
ng generate component component-name
```

For a complete list of available schematics (such as `components`, `directives`, or `pipes`), run:

```bash
ng generate --help
```

## Building

To build the project run:

```bash
ng build
```

This will compile your project and store the build artifacts in the `dist/` directory. By default, the production build optimizes your application for performance and speed.

## Running unit tests

To execute unit tests with the [Vitest](https://vitest.dev/) test runner, use the following command:

```bash
ng test
```

## Running end-to-end tests

For end-to-end (e2e) testing, run:

```bash
ng e2e
```

Angular CLI does not come with an end-to-end testing framework by default. You can choose one that suits your needs.

## Additional Resources

For more information on using the Angular CLI, including detailed command references, visit the [Angular CLI Overview and Command Reference](https://angular.dev/tools/cli) page.
