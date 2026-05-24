import { NavLink, Outlet } from 'react-router-dom'
import { Network, Layers, FolderKanban, Package, FolderOpen, Code2, GitMerge, GitBranch, AlertOctagon, Route, Workflow } from 'lucide-react'

const NAV_ITEMS = [
  { to: '/',                    icon: Network,       label: 'Grafo',           group: 'visualização' },
  { to: '/violations',          icon: AlertOctagon,  label: 'Violações',       group: 'visualização' },
  { to: '/layers',              icon: Layers,        label: 'Layers',          group: 'entidades' },
  { to: '/projects',            icon: FolderKanban,  label: 'Projetos',        group: 'entidades' },
  { to: '/namespaces',          icon: Package,       label: 'Namespaces',      group: 'entidades' },
  { to: '/directories',         icon: FolderOpen,    label: 'Diretórios',      group: 'entidades' },
  { to: '/code-elements',       icon: Code2,         label: 'Code Elements',   group: 'entidades' },
  { to: '/implementations',     icon: GitMerge,      label: 'Implementações',  group: 'arestas' },
  { to: '/dependencies',        icon: GitBranch,     label: 'Dependências',    group: 'arestas' },
  { to: '/api-endpoints',       icon: Route,         label: 'API Endpoints',   group: 'contratos' },
  { to: '/handler-contracts',   icon: Workflow,      label: 'Handler Contracts', group: 'contratos' },
]

const GROUPS: Record<string, string> = {
  visualização: 'Visualização',
  entidades: 'Entidades (Nós)',
  arestas: 'Relacionamentos (Arestas)',
  contratos: 'Contratos (HTTP / CQRS)',
}

export function AppShell() {
  return (
    <div style={{ display: 'flex', height: '100vh', fontFamily: 'Plus Jakarta Sans, system-ui', overflow: 'hidden' }}>
      {/* Sidebar */}
      <nav style={{
        width: 220, background: '#0f172a', display: 'flex',
        flexDirection: 'column', flexShrink: 0, overflowY: 'auto',
      }}>
        {/* Logo */}
        <div style={{ padding: '20px 16px', borderBottom: '1px solid #1e293b' }}>
          <div style={{ display: 'flex', alignItems: 'center', gap: 10 }}>
            <div style={{
              width: 34, height: 34, background: 'linear-gradient(135deg, #6366f1, #8b5cf6)',
              borderRadius: 8, display: 'flex', alignItems: 'center', justifyContent: 'center',
            }}>
              <Network size={18} color="#fff" />
            </div>
            <div>
              <div style={{ color: '#f8fafc', fontWeight: 700, fontSize: 13, lineHeight: 1.2 }}>
                Code Property
              </div>
              <div style={{ color: '#6366f1', fontWeight: 700, fontSize: 13, lineHeight: 1.2 }}>
                Graph
              </div>
            </div>
          </div>
        </div>

        {/* Navigation */}
        <div style={{ flex: 1, padding: '12px 8px' }}>
          {Object.entries(GROUPS).map(([groupKey, groupLabel]) => {
            const items = NAV_ITEMS.filter((i) => i.group === groupKey)
            return (
              <div key={groupKey} style={{ marginBottom: 16 }}>
                <div style={{
                  padding: '4px 8px', fontSize: 10, fontWeight: 700,
                  color: '#475569', textTransform: 'uppercase', letterSpacing: '0.08em',
                  marginBottom: 4,
                }}>
                  {groupLabel}
                </div>
                {items.map(({ to, icon: Icon, label }) => (
                  <NavLink
                    key={to}
                    to={to}
                    end={to === '/'}
                    style={({ isActive }) => ({
                      display: 'flex', alignItems: 'center', gap: 10,
                      padding: '8px 10px', borderRadius: 8,
                      textDecoration: 'none', fontSize: 13,
                      marginBottom: 2, transition: 'all 0.15s',
                      background: isActive ? '#1e293b' : 'transparent',
                      color: isActive ? '#f8fafc' : '#94a3b8',
                      fontWeight: isActive ? 600 : 400,
                    })}
                  >
                    <Icon size={15} />
                    {label}
                  </NavLink>
                ))}
              </div>
            )
          })}
        </div>

        {/* Footer */}
        <div style={{ padding: '12px 16px', borderTop: '1px solid #1e293b' }}>
          <div style={{ fontSize: 10, color: '#475569' }}>
            API: <span style={{ color: '#6366f1', fontFamily: 'JetBrains Mono' }}>localhost:5000</span>
          </div>
        </div>
      </nav>

      {/* Main content */}
      <main style={{ flex: 1, display: 'flex', flexDirection: 'column', overflow: 'hidden', background: '#f8fafc' }}>
        <Outlet />
      </main>
    </div>
  )
}
