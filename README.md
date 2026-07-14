# Gdigital — Gestor de Clientes, Proyectos y Tareas

> Prueba técnica — Desarrollador Mid Level Full Stack

Aplicación Ruby on Rails para administrar **clientes**, sus **proyectos** y las **tareas**
de cada proyecto, con seguimiento de avance y reglas de negocio del dominio.

## Stack

- **Ruby** 4.0.x · **Rails** 8.1
- **SQLite** (desarrollo / test)
- **Hotwire** (Turbo + Stimulus) e **import maps** — sin build step de JS
- **Propshaft** para assets
- **Minitest** para la suite de tests
- i18n en español (`rails-i18n`)

## Levantar el proyecto

### Con Docker

Requiere  Docker. Un comando construye la imagen, prepara la base con datos de
ejemplo y levanta la app en http://localhost:3000:

```bash
docker compose up --build
```

La base SQLite se guarda en un volumen (`storage`) y persiste entre reinicios.
Para empezar de cero: `docker compose down -v`.

### Sin Docker

Requiere Ruby 4.0.x y Bundler. Recomiendo usar docker para
utilizar simplemente el contenedor.

```bash
bundle install          # instala las gemas
bin/rails db:prepare    # crea y migra la base de datos
bin/rails db:seed        # (opcional) carga datos de ejemplo
bin/rails server         # levanta la app en http://localhost:3000
```

> `bin/rails db:setup` crea, migra y siembra en un solo paso

## Tests

```bash
bin/rails test          
```

O dentro del contenedor sin instalar Ruby localmente:

```bash
docker compose run --rm web bin/rails test
```

Chequeos de calidad adicionales:

```bash
bin/rubocop             # estilo (rubocop-rails-omakase)
bin/brakeman            # análisis de seguridad estático
```


## Estructura del dominio

```
Client (name, email)
  └─ has_many :projects           # se elimina en cascada, salvo que haya activos
Project (title, status, client_id)
  └─ has_many :tasks              # se elimina en cascada
Task (title, done, due_date, project_id)
```
