# Code Property Graph

> Visualize a arquitetura do seu software como um **Knowledge Graph** interativo — entidades como nós, relacionamentos como arestas, com análise de dependências e detecção de violações de Clean Architecture em tempo real.

---

![alt text](https://github.com/rodrigofurlaneti/CodePropertyGraph/blob/main/Project.jpg?raw=true)
![alt text](https://github.com/rodrigofurlaneti/CodePropertyGraph/blob/main/4-Doc/ArqDDD.png?raw=true)
![alt text](https://github.com/rodrigofurlaneti/CodePropertyGraph/blob/main/4-Doc/Grafo.png?raw=true)
![alt text](https://github.com/rodrigofurlaneti/CodePropertyGraph/blob/main/4-Doc/LayerFocus.png?raw=true)


## Visão Geral

O **Code Property Graph** é um sistema full-stack que mapeia qualquer projeto de software para um modelo de grafo relacional. Combinando o **Paradigma Relacional** (SQL Server + EF Core) com a **visão de Grafo** (Knowledge Graph), ele permite que você navegue pela arquitetura de código de forma intuitiva — sem precisar mudar de stack.

A inspiração vem do conceito de *Code Property Graph* (Yamaguchi et al.), adaptado para análise arquitetural de soluções .NET com Clean Architecture. O banco de dados armazena as relações entre camadas, projetos, namespaces e elementos de código (classes, interfaces, records, enums), enquanto o frontend renderiza essas relações como um mapa mental interativo.

---

## Estrutura do Repositório

```
CodePropertyGraph/
├── 1-Sql/
│   └── CreateDatabase.sql          # Script de criação do banco (SQL Server)
├── 2-BackEnd/
│   └── CodePropertyGraph.sln       # Solução .NET 9.0
│       └── src/
│           ├── CodePropertyGraph.Domain/        # Entidades ricas + interfaces IRepository
│           ├── CodePropertyGraph.Application/   # CQRS com MediatR + FluentValidation
│           ├── CodePropertyGraph.Infrastructure/# EF Core + Repositories + Fluent API
│           └── CodePropertyGraph.Api/           # ASP.NET Core 9 + Swagger
└── 3-FrontEnd/
    └── code-property-graph/        # React 18 + TypeScript + React Flow + Zustand
```

---

## Modelo de Dados — O Grafo

O banco de dados implementa um **grafo direcionado** sobre SQL Server:

| Tabela | Papel no Grafo | Descrição |
|---|---|---|
| `Layer` | Metadado de nó | Camadas da Clean Architecture (Domain, Application, Infrastructure, Api) |
| `Project` | Metadado de nó | Projetos físicos (.csproj) |
| `Namespace` | Metadado de nó | Escopo lógico (namespaces C#) |
| `Directory` | Metadado de nó | Caminho físico no disco |
| `CodeElement` | **Nó** | Classe, Interface, Record ou Enum — o nó central do grafo |
| `ElementImplementation` | **Aresta IMPLEMENTS** | ClassId → InterfaceId |
| `ElementDependency` | **Aresta DEPENDS_ON** | SourceId → TargetId com tipo e direcionalidade |

### Por que Relacional + Grafo?

Projetos que já usam SQL não precisam migrar para um banco de grafos nativo. A modelagem de arestas com chaves compostas e FKs resolve queries de grafo via JOINs simples, mantendo ACID, ferramentas existentes e familiaridade da equipe. O frontend transforma esses dados em um grafo visual usando React Flow.

---

## Backend — .NET 9.0

### Arquitetura

```
Domain       ← Entidades ricas com setters privados, sem Data Annotations
Application  ← CQRS (Commands + Queries) via MediatR, validações FluentValidation, Result Pattern
Infrastructure ← EF Core com Fluent API (IEntityTypeConfiguration<T>), AsNoTracking obrigatório
Api          ← Controllers finos, apenas delegam para IMediator, CORS configurado para o frontend
```

### Padrões aplicados

- **SOLID**: Single Responsibility por Handler, Open/Closed via abstrações IRepository, Dependency Inversion no DI container
- **CQRS**: Commands (escrita) e Queries (leitura) completamente separados, sem compartilhar models
- **Repository Pattern**: Interface no Domain, implementação no Infrastructure — Domain nunca depende de EF Core
- **Result Pattern**: Sem exceções para controle de fluxo — todos os handlers retornam `Result<T>` ou `Result`
- **Rich Entities**: Construtores privados, factory methods estáticos (`Layer.Create(...)`), lógica dentro da entidade

### Endpoints principais

```
GET    /api/graph?projectId=&layerId=   → Nós + arestas para o frontend (Knowledge Graph)
GET    /api/graph/violations            → Detecta violações de Clean Architecture
GET    /api/layers                      → CRUD Layer
GET    /api/projects                    → CRUD Project
GET    /api/namespaces                  → CRUD Namespace
GET    /api/directories                 → CRUD Directory
GET    /api/codeelements                → CRUD CodeElement
GET    /api/elementimplementations      → Arestas IMPLEMENTS
GET    /api/elementdependencies         → Arestas DEPENDS_ON
```

### Como rodar o Backend

**Pré-requisitos**: .NET 9.0 SDK, SQL Server (local ou Docker)

```bash
# 1. Criar o banco de dados
# Execute o script: 1-Sql/CreateDatabase.sql no SQL Server Management Studio

# 2. Configurar a connection string
# Edite: 2-BackEnd/src/CodePropertyGraph.Api/appsettings.json

# 3. Aplicar migrations (opcional se usou o script SQL diretamente)
cd 2-BackEnd/src/CodePropertyGraph.Api
dotnet ef database update --project ../CodePropertyGraph.Infrastructure

# 4. Rodar a API
dotnet run
# Acesse: http://localhost:5000/swagger
```

---

## Frontend — React + Knowledge Graph

### Tecnologias

| Biblioteca | Função |
|---|---|
| React 18 + TypeScript | UI com tipagem estrita (zero `any`) |
| React Flow (@xyflow/react) | Renderização do Knowledge Graph interativo |
| TanStack Query | Server state + cache das queries da API |
| Zustand | Client state (filtros, nó selecionado) |
| React Router v6 | Navegação entre grafo e CRUDs |
| Vite | Build tool com proxy para a API |

### Funcionalidades do Grafo

O grafo exibe **nós coloridos** por tipo de elemento (Class, Interface, Record, Enum) e **arestas direcionadas** com dois tipos:

- Linha sólida verde — `IMPLEMENTS` (Class → Interface)
- Linha tracejada índigo — `DEPENDS_ON` (com tipo: ConstructorInjection, MethodParameter, Inheritance)

**Filtros disponíveis no painel esquerdo:**

- Filtrar por Projeto ou por Camada
- Filtrar por tipo de elemento (Class / Interface / Record / Enum)
- Busca por nome ou namespace
- Exibir apenas dependências diretas

**Painel de detalhes (clique em um nó):**

Ao clicar em qualquer nó, o painel direito exibe metadados completos (camada, projeto, namespace, diretório) e lista todas as dependências de entrada e saída daquele elemento.

**Página de Violações:**

Detecta elementos que violam as regras de dependência entre camadas (ex: Domain → Infrastructure). Utiliza a query SQL do arquivo `CreateDatabase.sql`, executada via EF Core com `AsSplitQuery`.

### Como rodar o Frontend

**Pré-requisitos**: Node.js 20+, pnpm ou npm

```bash
cd 3-FrontEnd/code-property-graph

# Instalar dependências
npm install

# Rodar em desenvolvimento (proxy automático para localhost:5000)
npm run dev

# Acesse: http://localhost:5173
```

---

## Fluxo de Uso Recomendado

1. Rode o backend (`dotnet run`) e acesse o Swagger em `/swagger`
2. Popule as tabelas base via Swagger ou via script SQL: Layers, Projects, Namespaces, Directories
3. Crie CodeElements (classes e interfaces do seu projeto)
4. Adicione ElementImplementations (quem implementa o quê) e ElementDependencies (quem depende de quem)
5. Abra o frontend (`npm run dev`) e navegue pelo Knowledge Graph
6. Use a página de **Violações** para verificar se a Clean Architecture está sendo respeitada

---

## Roadmap

- [ ] Import automático via Roslyn — analisar .csproj e gerar o grafo automaticamente
- [ ] Exportar grafo como PNG / SVG
- [ ] Modo diff: comparar dois snapshots da arquitetura
- [ ] Métricas: acoplamento aferente/eferente, instabilidade, abstração
- [ ] Suporte a múltiplos projetos / tenants

---

## Contribuindo

Pull requests são bem-vindos. Para mudanças grandes, abra uma issue primeiro para discutir o que você gostaria de modificar. Siga os padrões de Clean Architecture e SOLID já estabelecidos no projeto.
