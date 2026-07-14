# Datos de ejemplo para desarrollo / demo.
# Idempotente: se puede correr con `bin/rails db:seed` las veces que haga falta.
#
# El reset se hace en orden hijo -> padre para que el guard de Client
# ("no se puede eliminar un cliente con proyectos activos") no bloquee la limpieza.

puts "Limpiando datos existentes..."
Project.destroy_all # elimina en cascada las tareas (dependent: :destroy)
Client.destroy_all

puts "Creando clientes, proyectos y tareas..."

estudio = Client.create!(name: "Estudio Norte",  email: "hola@estudionorte.com")
delta   = Client.create!(name: "Delta Software",  email: "contacto@deltasoftware.com")
andes   = Client.create!(name: "Grupo Andes",     email: "proyectos@grupoandes.com")
Client.create!(name: "Comercial Sur", email: "info@comercialsur.com") # sin proyectos: demuestra el estado vacío

# Estudio Norte -> tiene un proyecto ACTIVO, por lo que NO se puede eliminar (demuestra el guard).
web = estudio.projects.create!(title: "Rediseño del sitio web", status: :active)
web.tasks.create!([
  { title: "Definir wireframes",      done: true,  due_date: Date.current - 20 },
  { title: "Diseñar la home",         done: true,  due_date: Date.current - 10 },
  { title: "Maquetar componentes",    done: false, due_date: Date.current - 3 },  # vencida
  { title: "Integrar con el backend", done: false, due_date: Date.current + 7 }
]) # 2/4 completadas -> 50%

estudio.projects.create!(title: "Campaña de marketing", status: :paused).tasks.create!([
  { title: "Investigar audiencia", done: true,  due_date: Date.current - 5 },
  { title: "Redactar copies",      done: false, due_date: nil } # sin fecha límite
])

# Delta Software -> también tiene un proyecto activo (App móvil).
delta.projects.create!(title: "Migración de datos", status: :completed).tasks.create!([
  { title: "Exportar base legada", done: true, due_date: Date.current - 30 },
  { title: "Validar integridad",   done: true, due_date: Date.current - 25 }
]) # 100%

delta.projects.create!(title: "App móvil", status: :active).tasks.create!([
  { title: "Setup del proyecto",   done: true,  due_date: Date.current - 15 },
  { title: "Pantalla de login",    done: false, due_date: Date.current - 1 },  # vencida
  { title: "Pantalla de perfil",   done: false, due_date: Date.current + 14 },
  { title: "Tests de integración", done: false, due_date: nil }
]) # 1/4 -> 25%

# Grupo Andes -> solo proyectos completados: SÍ se puede eliminar aunque tenga proyectos
# (el guard bloquea únicamente cuando hay proyectos activos).
andes.projects.create!(title: "Auditoría contable", status: :completed).tasks.create!([
  { title: "Relevar comprobantes", done: true, due_date: Date.current - 40 }
]) # 100%

puts "Listo: #{Client.count} clientes, #{Project.count} proyectos, #{Task.count} tareas."
