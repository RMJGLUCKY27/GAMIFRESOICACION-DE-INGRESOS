# Análisis de Flujos de Trabajo - GAMIFRESOICACIÓN DE INGRESOS

## Parte 1: Identificación de Flujos Principales (30%)

### Flujo A: Registrar y Gestionar un Ingreso

#### Objetivo Principal del Usuario
El usuario busca registrar un ingreso (monto, categoría, fecha), verificar que se guardó correctamente y consultarlo en el historial o tablero de progreso.

#### Tipo de Patrón de Flujo
**Patrón: Lineal con ramificaciones menores**
- Flujo primario lineal: formulario → confirmación → historial
- Ramificaciones en validaciones y opciones de categoría

**Justificación**: El camino principal sigue una secuencia de pasos obligatorios (formulario → guardar), pero puede ramificarse si el usuario necesita crear una categoría nueva o decide cancelar la operación.

#### Puntos de Entrada
- Botón "+ Nuevo ingreso" en el dashboard
- Vista de historial (acción rápida desde una fila)
- Widget o acceso rápido desde el home

### Flujo B: Completar una Misión / Objetivo Gamificado

#### Objetivo Principal del Usuario
El usuario busca seleccionar una misión que incremente la motivación (ejemplo: "Registrar 3 ingresos esta semana"), seguir los requisitos establecidos y reclamar la recompensa (puntos, medalla).

#### Tipo de Patrón de Flujo
**Patrón: Convergente**
- Múltiples tareas/parciales que deben completarse para lograr la misión

**Justificación**: La misión típicamente requiere completar varios subpasos (registrar N ingresos, verificar metas) y estos subpasos convergen en la recompensa final.

#### Puntos de Entrada
- Pantalla de "Misiones" o "Retos"
- Notificación push o banner que invita a aceptar la misión
- Sugerencia proactiva en el dashboard

## Parte 2: Diagramación de Flujo (40%)

### Diagrama del Flujo A: Registrar y Gestionar un Ingreso

```
Start
  ↓
[Botón + Nuevo ingreso]
  ↓
[Formulario: Monto] → (si inválido) → [Alert: corregir] → volver a Formulario
  ↓
[Seleccionar/Crear Categoría] → (si crear) → [Subformulario crear categoría] → volver
  ↓
[Fecha] → [Nota opcional]
  ↓
[Pulsar Guardar] → (si validaciones OK) → [Guardar en BD]
  ↓
[Confirmación (modal/snackbar)]
  ↓
[Actualizar Dashboard/Historial] → End
```

## Parte 3: Evaluación de Principios de Diseño (20%)

### Claridad
**Calificación: 4/5**

**Justificación**: 
- Los campos del formulario son explícitos (monto, categoría, fecha)
- Las acciones principales (Guardar, Cancelar) están claramente visibles
- La creación de categoría dentro del flujo podría ser más clara

**Área de mejora**: 
- Añadir microcopy y placeholders informativos
- Mostrar estado contextual (ej. "Categoría: sin seleccionar")
- Implementar preselecciones basadas en comportamiento pasado

### Eficiencia
**Calificación: 3/5**

**Justificación**:
- El flujo minimiza pasos para el caso ideal
- La creación de categorías y validaciones pueden interrumpir la fluidez

**Área de mejora**:
- Implementar autocompletado de categorías
- Añadir acción rápida "guardar y añadir otro"

## Parte 4: Propuesta de Mejora (10%)

### Mejora Propuesta
Implementación de una "acción rápida" tipo sheet modal desde el dashboard que permita "Agregar ingreso rápido" con autocompletado de categoría y opción "Guardar y añadir otro".

### Problema que Resuelve
- Reduce la fricción al registrar múltiples ingresos consecutivos
- Evita navegación completa a una nueva pantalla
- Disminuye errores por falta de categoría al sugerir automáticamente categorías frecuentes

### Implementación Técnica en SwiftUI
```swift
NavigationStack {
    Form {
        TextField("Monto", text: $monto)
            .keyboardType(.decimalPad)
        Picker("Categoría", selection: $categoria) {
            ForEach(categorias) { cat in Text(cat.name).tag(cat) }
        }
        .searchable(text: $categoriaBusqueda)
        DatePicker("Fecha", selection: $fecha, displayedComponents: .date)
        Toggle("Guardar y añadir otro", isOn: $guardarYAnadirOtro)
    }
    .toolbar {
        ToolbarItem(placement: .confirmationAction) {
            Button("Guardar") { guardarIngreso() }
        }
    }
}
.sheetPresentation()
.alert("Error", isPresented: $showError) {
    Button("OK", role: .cancel) {}
} message: {
    Text(errorMessage)
}
```

### Impacto en UX
- Reduce tiempo por registro
- Aumenta consistencia
- Mejora tasa de registro de ingresos
- Mejora la percepción de fluidez en la aplicación