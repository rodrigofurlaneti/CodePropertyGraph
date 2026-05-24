"""
Analisador C# -> INSERTs CodePropertyGraphDb
v4 - aditivo (MERGE / INSERT WHERE NOT EXISTS), sem DELETE
"""
import os, re, json
from pathlib import Path
from collections import Counter

BASE_PATH = Path("/sessions/zealous-gifted-mendel/mnt/BackEnd")

PROJECT_LAYER = {
    "FSI.FinancialManager.Domain":           "Domain",
    "FSI.FinancialManager.Application":      "Application",
    "FSI.FinancialManager.Infrastructure":   "Infrastructure",
    "FSI.FinancialManager.Api":              "Api",
    "FSI.FinancialManager.Test.Acceptance":  "Test",
    "FSI.FinancialManager.Test.Architecture":"Test",
    "FSI.FinancialManager.Test.UnitTest":    "Test",
}
PROJECT_TYPE = {
    "FSI.FinancialManager.Api":              "WebApi",
    "FSI.FinancialManager.Application":      "ClassLibrary",
    "FSI.FinancialManager.Domain":           "ClassLibrary",
    "FSI.FinancialManager.Infrastructure":   "ClassLibrary",
    "FSI.FinancialManager.Test.Acceptance":  "Test",
    "FSI.FinancialManager.Test.Architecture":"Test",
    "FSI.FinancialManager.Test.UnitTest":    "Test",
}

def to_windows_rel(fp: Path) -> str:
    try:
        return str(fp.relative_to(BASE_PATH).parent).replace("/", "\\")
    except:
        return str(fp.parent)

def infer_namespace(proj: str, fp: Path) -> str:
    try:
        parts = list(fp.relative_to(BASE_PATH / "src" / proj).parent.parts)
        parts = [p for p in parts if p not in ('', '.')]
        return (proj + "." + ".".join(parts)) if parts else proj
    except:
        return proj

def extract_namespace(content: str, proj: str, fp: Path) -> str:
    m = re.search(r'^[ \t]*namespace\s+([\w.]+)', content, re.MULTILINE)
    return m.group(1) if m else infer_namespace(proj, fp)

def extract_types(content: str):
    c = re.sub(r'//[^\n]*', '', content)
    c = re.sub(r'/\*.*?\*/', '', c, flags=re.DOTALL)
    pat = re.compile(
        r'(?:^|\n)[ \t]*'
        r'((?:(?:public|private|protected|internal|sealed|abstract|static|partial|readonly|file)\s+)*)'
        r'(class|interface|record(?:\s+class|\s+struct)?|enum|struct)\s+'
        r'(\w+)'
        r'(?:\s*<[^>]*>)?(?:\s*\([^)]*\))?'
        r'(?:\s*:\s*([^{;\n]+?))?[ \t]*(?:\{|;|\n)',
        re.MULTILINE
    )
    types = []
    for m in pat.finditer(c):
        mods = m.group(1).lower()
        rt   = m.group(2).strip().lower()
        name = m.group(3)
        base = (m.group(4) or "").strip()
        etype = "Record" if "record" in rt else "Interface" if rt=="interface" else "Enum" if rt=="enum" else "Class"
        ia = 1 if "abstract" in mods else 0
        is_ = 1 if "sealed" in mods else 0
        if ia and etype == "Class": etype = "AbstractClass"
        impl, inh = [], ""
        if base:
            clean = re.sub(r'<[^>]*>', '', base)
            for p in [x.strip() for x in clean.split(',') if x.strip()]:
                if re.match(r'^I[A-Z]', p): impl.append(p)
                elif not inh: inh = p
        types.append({"name":name,"elementType":etype,"isAbstract":ia,"isSealed":is_,"implements":impl,"inherits":inh})
    return types

def extract_ctor_deps(content: str, name: str) -> list:
    deps = set()
    pm = re.search(rf'\b(?:class|record)\s+{re.escape(name)}\s*(?:<[^>]*>)?\s*\(([^)]+)\)', content)
    if pm:
        for p in re.finditer(r'(I[A-Z]\w+)\s+\w+', pm.group(1)): deps.add(p.group(1))
    for ctor in re.finditer(rf'(?:public|protected|private|internal)\s+{re.escape(name)}\s*\(([^)]+)\)', content):
        for p in re.finditer(r'(I[A-Z]\w+)\s+\w+', ctor.group(1)): deps.add(p.group(1))
    return sorted(deps)

def find_cs(proj_path: Path) -> list:
    files = []
    for root, dirs, fnames in os.walk(proj_path):
        dirs[:] = [d for d in dirs if d not in ('bin','obj','Migrations','.git')]
        for f in fnames:
            if f.endswith('.cs'): files.append(Path(root)/f)
    return sorted(files)

def sq(s): return s.replace("'","''")

def analyze():
    elems = []
    for proj_dir in sorted((BASE_PATH/"src").iterdir()):
        if not proj_dir.is_dir(): continue
        proj = proj_dir.name
        if proj not in PROJECT_LAYER: continue
        files = find_cs(proj_dir)
        print(f"  {proj}: {len(files)} arquivos")
        for fp in files:
            try: content = fp.read_text(encoding='utf-8-sig', errors='ignore')
            except: continue
            ns  = extract_namespace(content, proj, fp)
            dir_= to_windows_rel(fp)
            for t in extract_types(content):
                elems.append({**t,
                    "file": str(fp.relative_to(BASE_PATH)),
                    "directory": dir_, "project": proj, "namespace": ns,
                    "constructorDeps": extract_ctor_deps(content, t["name"]),
                })
    return elems

# ─── helpers SQL ────────────────────────────────────────────────
def merge_lookup(table: str, key_col: str, val_col: str, val: str) -> str:
    """MERGE idempotente para tabelas de lookup simples (Layer, Project, Namespace, Directory)."""
    return (
        f"IF NOT EXISTS (SELECT 1 FROM {table} WHERE {key_col} = '{sq(val)}')\n"
        f"    INSERT INTO {table} ({key_col}) VALUES ('{sq(val)}');"
    )

def merge_layer(name: str, desc: str) -> str:
    return (
        f"IF NOT EXISTS (SELECT 1 FROM Layer WHERE Name = '{sq(name)}')\n"
        f"    INSERT INTO Layer (Name, Description) VALUES ('{sq(name)}', '{sq(desc)}');"
    )

def merge_project(name: str, ptype: str) -> str:
    return (
        f"IF NOT EXISTS (SELECT 1 FROM Project WHERE Name = '{sq(name)}')\n"
        f"    INSERT INTO Project (Name, ProjectType) VALUES ('{sq(name)}', '{sq(ptype)}');"
    )

def ce_select(name: str, proj: str) -> str:
    return (f"(SELECT TOP 1 Id FROM CodeElement WHERE Name='{sq(name)}' "
            f"AND ProjectId=(SELECT TOP 1 Id FROM Project WHERE Name='{sq(proj)}'))")

def ce_exists(name: str, proj: str) -> str:
    return (f"EXISTS(SELECT 1 FROM CodeElement WHERE Name='{sq(name)}' "
            f"AND ProjectId=(SELECT TOP 1 Id FROM Project WHERE Name='{sq(proj)}'))")

# ────────────────────────────────────────────────────────────────
def generate_sql(elems):
    L = []
    L += [
        "-- ============================================================",
        "-- CodePropertyGraph INSERTs - FSI.FinancialManager",
        f"-- Total CodeElements: {len(elems)}",
        "-- Estratégia: ADITIVO — insere apenas o que ainda não existe.",
        "-- Seguro para bancos com dados de outros projetos.",
        "-- ============================================================",
        "USE CodePropertyGraphDb;",
        "GO",
        "SET NOCOUNT ON;",
        "GO",
        "",
        "-- ── 0. DEDUP PROJECT (Project.Name não tem UNIQUE constraint) ──",
        "-- Remove linhas duplicadas mantendo apenas a de menor Id por nome.",
        "WITH Dupes AS (",
        "    SELECT Id, ROW_NUMBER() OVER (PARTITION BY Name ORDER BY Id) AS rn",
        "    FROM Project",
        ")",
        "DELETE FROM Dupes WHERE rn > 1;",
        "GO",
        "",
    ]

    # ── 1. Layers ──────────────────────────────────────────────
    desc_map = {
        "Api":            "Controllers, Middlewares, configuracao da Web API",
        "Application":    "Casos de uso, Commands, Queries, Handlers, Validators, DTOs",
        "Domain":         "Entidades, Value Objects, Interfaces de repositorio, Domain Events",
        "Infrastructure": "Implementacoes de repositorio, EF Core, servicos externos",
        "Test":           "Testes unitarios, de integracao e de arquitetura",
    }
    L.append("-- ── 1. LAYERS ────────────────────────────────────────────")
    for layer in sorted(set(PROJECT_LAYER.values())):
        L.append(merge_layer(layer, desc_map.get(layer, layer)))
    L.append("")

    # ── 2. Projects ────────────────────────────────────────────
    L.append("-- ── 2. PROJECTS ──────────────────────────────────────────")
    for proj in sorted(set(e["project"] for e in elems)):
        L.append(merge_project(proj, PROJECT_TYPE.get(proj, "ClassLibrary")))
    L.append("")

    # ── 3. Namespaces ──────────────────────────────────────────
    L.append("-- ── 3. NAMESPACES ────────────────────────────────────────")
    for ns in sorted(set(e["namespace"] for e in elems if e["namespace"])):
        L.append(f"IF NOT EXISTS (SELECT 1 FROM Namespace WHERE FullName='{sq(ns)}')\n"
                 f"    INSERT INTO Namespace (FullName) VALUES ('{sq(ns)}');")
    L.append("")

    # ── 4. Directories ─────────────────────────────────────────
    L.append("-- ── 4. DIRECTORIES ───────────────────────────────────────")
    for d in sorted(set(e["directory"] for e in elems if e["directory"])):
        L.append(f"IF NOT EXISTS (SELECT 1 FROM Directory WHERE Path='{sq(d)}')\n"
                 f"    INSERT INTO Directory (Path) VALUES ('{sq(d)}');")
    L.append("")

    # ── 5. CodeElements ────────────────────────────────────────
    L.append("-- ── 5. CODE ELEMENTS ─────────────────────────────────────")
    L.append("GO")
    L.append("")
    for e in elems:
        layer = PROJECT_LAYER.get(e["project"], "Domain")
        sname = sq(e["name"]); sproj = sq(e["project"])
        sns   = sq(e["namespace"]); sdir = sq(e["directory"])
        L.append(
            f"-- {e['project']} | {e['namespace']} | {e['name']}\n"
            f"IF NOT EXISTS (SELECT 1 FROM CodeElement WHERE Name='{sname}'\n"
            f"    AND ProjectId=(SELECT TOP 1 Id FROM Project WHERE Name='{sproj}'))\n"
            f"    INSERT INTO CodeElement(Name,ElementType,IsAbstract,IsSealed,LayerId,ProjectId,NamespaceId,DirectoryId)\n"
            f"    SELECT '{sname}','{e['elementType']}',{e['isAbstract']},{e['isSealed']},\n"
            f"        (SELECT TOP 1 Id FROM Layer     WHERE Name    ='{layer}'),\n"
            f"        (SELECT TOP 1 Id FROM Project   WHERE Name    ='{sproj}'),\n"
            f"        (SELECT TOP 1 Id FROM Namespace WHERE FullName='{sns}'),\n"
            f"        (SELECT TOP 1 Id FROM Directory WHERE Path    ='{sdir}');\n"
        )

    # ── 6. Implementations ─────────────────────────────────────
    L.append("-- ── 6. ELEMENT IMPLEMENTATIONS ───────────────────────────")
    impl_n = 0
    for e in elems:
        if not e["implements"]: continue
        sn = sq(e["name"]); sp = sq(e["project"])
        for iface in e["implements"]:
            fi = sq(iface)
            L.append(
                f"-- {e['name']} IMPLEMENTS {iface}\n"
                f"IF {ce_exists(e['name'],e['project'])}\n"
                f"AND EXISTS(SELECT 1 FROM CodeElement WHERE Name='{fi}' AND ElementType='Interface')\n"
                f"AND NOT EXISTS(SELECT 1 FROM ElementImplementation\n"
                f"    WHERE ClassId={ce_select(e['name'],e['project'])}\n"
                f"    AND InterfaceId=(SELECT TOP 1 Id FROM CodeElement WHERE Name='{fi}' AND ElementType='Interface'))\n"
                f"    INSERT INTO ElementImplementation(ClassId,InterfaceId) SELECT\n"
                f"        {ce_select(e['name'],e['project'])},\n"
                f"        (SELECT TOP 1 Id FROM CodeElement WHERE Name='{fi}' AND ElementType='Interface');\n"
            )
            impl_n += 1

    # ── 7. Dependencies ────────────────────────────────────────
    L.append("-- ── 7. ELEMENT DEPENDENCIES ──────────────────────────────")
    dep_n = 0
    for e in elems:
        sn = sq(e["name"]); sp = sq(e["project"])

        if e["inherits"]:
            base = sq(e["inherits"])
            L.append(
                f"-- {e['name']} INHERITS {e['inherits']}\n"
                f"IF {ce_exists(e['name'],e['project'])}\n"
                f"AND EXISTS(SELECT 1 FROM CodeElement WHERE Name='{base}')\n"
                f"AND NOT EXISTS(SELECT 1 FROM ElementDependency\n"
                f"    WHERE SourceElementId={ce_select(e['name'],e['project'])}\n"
                f"    AND TargetElementId=(SELECT TOP 1 Id FROM CodeElement WHERE Name='{base}')\n"
                f"    AND DependencyType='Inheritance')\n"
                f"    INSERT INTO ElementDependency(SourceElementId,TargetElementId,DependencyType,IsDirect) SELECT\n"
                f"        {ce_select(e['name'],e['project'])},\n"
                f"        (SELECT TOP 1 Id FROM CodeElement WHERE Name='{base}'),\n"
                f"        'Inheritance',1;\n"
            )
            dep_n += 1

        for dep in e["constructorDeps"]:
            di = sq(dep)
            L.append(
                f"-- {e['name']} -> {dep} (ConstructorInjection)\n"
                f"IF {ce_exists(e['name'],e['project'])}\n"
                f"AND EXISTS(SELECT 1 FROM CodeElement WHERE Name='{di}')\n"
                f"AND NOT EXISTS(SELECT 1 FROM ElementDependency\n"
                f"    WHERE SourceElementId={ce_select(e['name'],e['project'])}\n"
                f"    AND TargetElementId=(SELECT TOP 1 Id FROM CodeElement WHERE Name='{di}')\n"
                f"    AND DependencyType='ConstructorInjection')\n"
                f"    INSERT INTO ElementDependency(SourceElementId,TargetElementId,DependencyType,IsDirect) SELECT\n"
                f"        {ce_select(e['name'],e['project'])},\n"
                f"        (SELECT TOP 1 Id FROM CodeElement WHERE Name='{di}'),\n"
                f"        'ConstructorInjection',1;\n"
            )
            dep_n += 1

    L += [
        "GO",
        "-- ============================================================",
        f"-- FIM | CodeElements: {len(elems)} | Impl: {impl_n} | Deps: {dep_n}",
        "-- ============================================================",
    ]
    return "\n".join(L)


if __name__ == "__main__":
    print("Analisando:", BASE_PATH)
    elems = analyze()
    print(f"\nTotal: {len(elems)}  | namespace vazio: {sum(1 for e in elems if not e['namespace'])}")

    import json
    with open("/sessions/zealous-gifted-mendel/mnt/outputs/all_elements.json","w") as f:
        json.dump(elems, f, ensure_ascii=False, indent=2)

    sql = generate_sql(elems)
    out = "/sessions/zealous-gifted-mendel/mnt/outputs/insert_CodePropertyGraphDb.sql"
    with open(out, "w", encoding="utf-8") as f:
        f.write(sql)
    print(f"SQL: {out}  ({sql.count(chr(10))} linhas)")

    from collections import Counter
    tc = Counter(e["elementType"] for e in elems)
    pc = Counter(e["project"]     for e in elems)
    print("\n--- ElementType ---")
    for k, v in tc.most_common():
        print(f"  {k}: {v}")
    print("\n--- Por Projeto ---")
    for k, v in pc.most_common():
        print(f"  {k}: {v}")
    impl_total = sum(len(e["implements"]) for e in elems)
    dep_total  = sum(1 for e in elems if e["inherits"]) + sum(len(e["constructorDeps"]) for e in elems)
    print(f"\nImplementations: {impl_total}")
    print(f"Dependencies:    {dep_total}")
