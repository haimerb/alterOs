# Guía de Contribución - alterOs

Gracias por tu interés en contribuir a alterOs. Este documento describe el flujo de trabajo para contribuir al proyecto.

## Flujo de Trabajo

### 1. Issues First
- **Siempre** crea un issue antes de empezar trabajo significativo
- Usa las plantillas de issue si están disponibles
- Describe claramente el problema o la mejora propuesta

### 2. Branching Strategy
```bash
# Tipos de ramas:
feature/<descripcion-corta>     # Nueva funcionalidad
fix/<descripcion-corta>         # Corrección de bug
docs/<descripcion-corta>        # Cambios de documentación
refactor/<descripcion-corta>    # Refactorización
ci/<descripcion-corta>          # Cambios en CI/CD
```

Ejemplos:
- `feature/add-kali-tools-cloud`
- `fix/systemd-config-wsl`
- `docs/update-build-instructions`

### 3. Commits
Usa [Conventional Commits](https://www.conventionalcommits.org/):

```
tipo(ámbito): descripción corta

Cuerpo explicativo si es necesario (opcional)

Fixes #123
```

Tipos:
- `feat`: Nueva funcionalidad
- `fix`: Corrección de bug
- `docs`: Documentación
- `style`: Formato (sin cambio de lógica)
- `refactor`: Refactorización
- `test`: Tests
- `chore`: Mantenimiento
- `ci`: CI/CD

### 4. Pull Requests
- Abre PR contra `master`
- Referencia el issue: `Closes #123` o `Fixes #123`
- Describe **qué** cambia y **por qué**
- Asegúrate de que CI pasa (GitHub Actions)

### 5. Code Review
- Al menos 1 aprobación requerida
- Resuelve todos los comentarios
- No mergees tus propios PRs sin revisión

## Cómo Agregar Herramientas

### Categorías de Kali (config/package-lists/kali-tools.list.chroot)
```bash
# Buscar paquetes disponibles:
docker run --rm kali-linux/kali-rolling apt-cache search kali-tools-

# Agregar al archivo correspondiente:
kali-tools-<categoria>
```

### Herramientas de Desarrollo
Agrega a la sección correspondiente en `config/package-lists/kali-tools.list.chroot`:
```bash
# Build tools
# Languages & Runtimes
# Shell & Terminal
# Containers & Cloud
# etc.
```

### Repositorios Externos
Para nuevos repos (Microsoft, Docker, etc.):
1. Crea un hook en `config/hooks/XX-nombre.hook.chroot`
2. Numera secuencialmente (00-, 01-, etc.)
3. Agrega la clave GPG y el repositorio
4. Ejecuta `apt-get update` al final

## Testing Local

```bash
# Construir
./scripts/build.sh

# Verificar estructura del tarball
tar -tzf dist/alteros-kali-amd64-wsl.tar.gz | head

# Test en WSL (requiere Windows)
./scripts/test-wsl.sh
```

## Estructura del Proyecto
```
alterOs/
├── config/
│   ├── package-lists/      # Listas de paquetes
│   ├── includes.chroot/    # Archivos overlay
│   └── hooks/              # Scripts de build (orden numérico)
├── scripts/                # Automatización
├── wsl/                    # Configuración WSL
└── .github/workflows/      # CI/CD
```

## Preguntas
- Abre un issue con label `question`
- O inicia una discusión en GitHub Discussions