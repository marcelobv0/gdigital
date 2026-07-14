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

## Puesta en marcha

Requiere Ruby 4.0.x y Bundler.

```bash
bundle install          # instala las gemas
bin/rails db:prepare    # crea y migra la base de datos
bin/rails db:seed        # (opcional) carga datos de ejemplo
bin/rails server         # levanta la app en http://localhost:3000
```

> Atajo: `bin/rails db:setup` crea, migra y siembra en un solo paso.

## Tests

```bash
bin/rails test          # 44 tests (modelos + requests)
```

Chequeos de calidad adicionales:

```bash
bin/rubocop             # estilo (rubocop-rails-omakase)
bin/brakeman            # análisis de seguridad estático
```

## Funcionalidades

| Requerimiento | Dónde |
|---|---|
| CRUD completo de clientes | `/clients` |
| CRUD completo de proyectos | `/projects` |
| Tareas creadas y completadas desde la vista del proyecto | `projects#show` (sin CRUD propio) |
| Porcentaje de avance del proyecto (completadas / total) | `Project#progress` + barra de progreso |
| Un cliente no se puede eliminar si tiene proyectos activos | guard `before_destroy` en `Client` |
| Filtrado de proyectos por estado | `/projects?status=active\|paused\|completed` |
| Tareas vencidas resaltadas visualmente | fila roja + etiqueta "Vencida" en `projects#show` |
| Al menos 5 tests entre modelos y requests | 23 de modelos + 21 de requests |

## Decisiones de diseño

- **Regla de negocio en el modelo, no en el controlador.** La restricción de borrado vive
  en un `before_destroy` con `prepend: true`, de modo que se ejecuta antes del
  `dependent: :destroy` y bloquea el borrado sin eliminar registros asociados. Así la regla
  se cumple sin importar desde dónde se dispare el `destroy`.
- **`status` como enum respaldado por string** con `default: :active` y `validate: true`:
  un valor inválido produce un error de validación (no una excepción) y la base guarda
  valores legibles.
- **Cálculo de avance en Ruby** sobre la asociación `tasks` ya cargada (`includes(:tasks)`),
  evitando consultas N+1 en el listado de proyectos.
- **Tareas anidadas bajo proyectos** (`only: [:create, :update]`): sin CRUD propio, tal como
  pide la consigna. El toggle de "hecha" es un `PATCH` que reenvía el formulario.
- **UI en español** con mensajes de validación y de framework traducidos vía `rails-i18n`
  y un locale propio (`config/locales/es.yml`).

## Estructura del dominio

```
Client (name, email)
  └─ has_many :projects           # se elimina en cascada, salvo que haya activos
Project (title, status, client_id)
  └─ has_many :tasks              # se elimina en cascada
Task (title, done, due_date, project_id)
```
