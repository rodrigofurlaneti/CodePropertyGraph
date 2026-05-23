# Code Property Graph

> Visualize your software architecture as an interactive **Knowledge Graph** — entities as nodes, relationships as edges, with dependency analysis and real-time Clean Architecture violation detection.

---

## Overview

**Code Property Graph** is a full-stack system that maps any software project into a relational graph model. By combining the **Relational Paradigm** (SQL Server + EF Core) with the **Graph View** (Knowledge Graph), it lets you navigate code architecture intuitively — without changing your existing stack.

The concept is inspired by the *Code Property Graph* (Yamaguchi et al.), adapted for architectural analysis of .NET solutions built on Clean Architecture. The database stores relationships between layers, projects, namespaces, and code elements (classes, interfaces, records, enums), while the frontend renders those relationships as an interactive mind map.

---

## Repository Structure

```
CodePropertyGraph/
├── 1-Sql/
│   └── CreateDatabase.sql          # Database creation script (SQL Server)
├── 2-BackEnd/
│   └── CodePropertyGraph.sln       # .NET 9.0 Solution
│       └── src/
│           ├── CodePropertyGraph.Domain/        # Rich entities + IRepository interfaces
│           ├── CodePropertyGraph.Application/   # CQRS with MediatR + FluentValidation
│           ├── CodePropertyGraph.Infrastructure/# EF Core + Repositories + Fluent API
│           └── CodePropertyGraph.Api/           # ASP.NET Core 9 + Swagger
└── 3-FrontEnd/
    └── code-property-graph/        # React 18 + TypeScript + React Flow + Zustand
```

---

## Data Model — The Graph

The database implements a **directed graph** on top of SQL Server:

| Table | Graph Role | Description |
|---|---|---|
| `Layer` | Node metadata | Clean Architecture layers (Domain, Application, Infrastructure, Api) |
| `Project` | Node metadata | Physical projects (.csproj files) |
| `Namespace` | Node metadata | Logical scope (C# namespaces) |
| `Directory` | Node metadata | Physical path on disk |
| `CodeElement` | **Node** | Class, Interface, Record, or Enum — the central node of the graph |
| `ElementImplementation` | **IMPLEMENTS edge** | ClassId → InterfaceId |
| `ElementDependency` | **DEPENDS_ON edge** | SourceId → TargetId with type and directionality |

### Why Relational + Graph?

Projects already running on SQL don't need to migrate to a native graph database. Modeling edges with composite keys and foreign keys resolves graph queries through simple JOINs, while preserving ACID guarantees, existing tooling, and team familiarity. The frontend then transforms that data into a visual graph using React Flow.

---

## Backend — .NET 9.0

### Architecture

```
Domain         ← Rich entities with private setters, no Data Annotations
Application    ← CQRS (Commands + Queries) via MediatR, FluentValidation, Result Pattern
Infrastructure ← EF Core with Fluent API (IEntityTypeConfiguration<T>), mandatory AsNoTracking
Api            ← Thin controllers that only delegate to IMediator, CORS configured for the frontend
```

### Applied Patterns

- **SOLID**: Single Responsibility per Handler, Open/Closed via IRepository abstractions, Dependency Inversion through the DI container
- **CQRS**: Commands (writes) and Queries (reads) fully separated, with no shared models
- **Repository Pattern**: Interface defined in Domain, implementation in Infrastructure — Domain never depends on EF Core
- **Result Pattern**: No exceptions for flow control — all handlers return `Result<T>` or `Result`
- **Rich Entities**: Private constructors, static factory methods (`Layer.Create(...)`), business logic encapsulated inside the entity

### Main Endpoints

```
GET    /api/graph?projectId=&layerId=   → Nodes + edges for the frontend (Knowledge Graph)
GET    /api/graph/violations            → Detects Clean Architecture violations
GET    /api/layers                      → CRUD Layer
GET    /api/projects                    → CRUD Project
GET    /api/namespaces                  → CRUD Namespace
GET    /api/directories                 → CRUD Directory
GET    /api/codeelements                → CRUD CodeElement
GET    /api/elementimplementations      → IMPLEMENTS edges
GET    /api/elementdependencies         → DEPENDS_ON edges
```

### Running the Backend

**Prerequisites**: .NET 9.0 SDK, SQL Server (local or Docker)

```bash
# 1. Create the database
# Run the script: 1-Sql/CreateDatabase.sql in SQL Server Management Studio

# 2. Configure the connection string
# Edit: 2-BackEnd/src/CodePropertyGraph.Api/appsettings.json

# 3. Apply migrations (optional if you ran the SQL script directly)
cd 2-BackEnd/src/CodePropertyGraph.Api
dotnet ef database update --project ../CodePropertyGraph.Infrastructure

# 4. Start the API
dotnet run
# Open: http://localhost:5000/swagger
```

---

## Frontend — React + Knowledge Graph

### Tech Stack

| Library | Purpose |
|---|---|
| React 18 + TypeScript | UI with strict typing (zero `any`) |
| React Flow (@xyflow/react) | Interactive Knowledge Graph rendering |
| TanStack Query | Server state + API query caching |
| Zustand | Client state (filters, selected node) |
| React Router v6 | Navigation between graph view and CRUDs |
| Vite | Build tool with API proxy |

### Graph Features

The graph displays **color-coded nodes** by element type (Class, Interface, Record, Enum) and **directed edges** of two kinds:

- Solid green line — `IMPLEMENTS` (Class → Interface)
- Dashed indigo line — `DEPENDS_ON` (with type: ConstructorInjection, MethodParameter, Inheritance)

**Left panel filters:**

- Filter by Project or by Layer
- Filter by element type (Class / Interface / Record / Enum)
- Search by name or namespace
- Show only direct dependencies

**Node detail panel (click any node):**

Clicking a node opens the right-side panel showing full metadata (layer, project, namespace, directory) and a list of all inbound and outbound dependencies for that element.

**Violations page:**

Detects elements that break layer dependency rules (e.g., Domain → Infrastructure). Powered by the SQL query from `CreateDatabase.sql`, executed via EF Core with `AsSplitQuery`.

### Running the Frontend

**Prerequisites**: Node.js 20+, npm or pnpm

```bash
cd 3-FrontEnd/code-property-graph

# Install dependencies
npm install

# Start development server (auto-proxy to localhost:5000)
npm run dev

# Open: http://localhost:5173
```

---

## Recommended Usage Flow

1. Start the backend (`dotnet run`) and open Swagger at `/swagger`
2. Seed the base tables via Swagger or the SQL script: Layers, Projects, Namespaces, Directories
3. Create CodeElements (the classes and interfaces in your project)
4. Add ElementImplementations (who implements what) and ElementDependencies (who depends on whom)
5. Open the frontend (`npm run dev`) and explore the Knowledge Graph
6. Use the **Violations** page to verify that Clean Architecture boundaries are being respected

---

## Roadmap

- [ ] Automatic import via Roslyn — parse .csproj files and generate the graph automatically
- [ ] Export graph as PNG / SVG
- [ ] Diff mode: compare two architecture snapshots side by side
- [ ] Metrics: afferent/efferent coupling, instability, abstractness
- [ ] Multi-project / multi-tenant support

---

## Contributing

Pull requests are welcome. For significant changes, please open an issue first to discuss what you'd like to modify. Follow the Clean Architecture and SOLID patterns already established throughout the project.
