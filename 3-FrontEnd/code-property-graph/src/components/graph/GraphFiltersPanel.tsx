import { Search, RotateCcw, Filter } from 'lucide-react'
import { useQuery } from '@tanstack/react-query'
import { layersApi, projectsApi } from '../../api/graph'
import { useGraphStore } from '../../store/graphStore'

const ELEMENT_TYPES = ['Class', 'Interface', 'Record', 'Enum']

const TYPE_COLORS: Record<string, string> = {
  Class: '#6366f1',
  Interface: '#10b981',
  Record: '#f59e0b',
  Enum: '#ef4444',
}

export function GraphFiltersPanel() {
  const { filters, setFilters, resetFilters } = useGraphStore()
  const { data: layers = [] } = useQuery({ queryKey: ['layers'], queryFn: layersApi.getAll })
  const { data: projects = [] } = useQuery({ queryKey: ['projects'], queryFn: projectsApi.getAll })

  const toggleType = (type: string) => {
    const types = filters.elementTypes.includes(type)
      ? filters.elementTypes.filter((t) => t !== type)
      : [...filters.elementTypes, type]
    setFilters({ elementTypes: types })
  }

  return (
    <div style={{
      width: 260, minHeight: '100%', background: '#fff',
      borderRight: '1px solid #e2e8f0', padding: 16,
      display: 'flex', flexDirection: 'column', gap: 20,
      fontFamily: 'Plus Jakarta Sans, system-ui',
    }}>
      {/* Header */}
      <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between' }}>
        <div style={{ display: 'flex', alignItems: 'center', gap: 8 }}>
          <Filter size={16} color="#6366f1" />
          <span style={{ fontWeight: 700, fontSize: 14, color: '#1e293b' }}>Filtros</span>
        </div>
        <button
          onClick={resetFilters}
          style={{
            display: 'flex', alignItems: 'center', gap: 4,
            background: 'none', border: '1px solid #e2e8f0', borderRadius: 6,
            padding: '4px 8px', fontSize: 11, color: '#6b7280', cursor: 'pointer',
          }}
        >
          <RotateCcw size={11} />
          Reset
        </button>
      </div>

      {/* Search */}
      <div>
        <label style={{ fontSize: 11, fontWeight: 600, color: '#64748b', textTransform: 'uppercase', letterSpacing: '0.05em' }}>
          Buscar Elemento
        </label>
        <div style={{ position: 'relative', marginTop: 6 }}>
          <Search size={14} color="#9ca3af" style={{ position: 'absolute', left: 9, top: '50%', transform: 'translateY(-50%)' }} />
          <input
            type="text"
            placeholder="Nome, namespace..."
            value={filters.searchTerm}
            onChange={(e) => setFilters({ searchTerm: e.target.value })}
            style={{
              width: '100%', padding: '7px 10px 7px 30px',
              border: '1px solid #e2e8f0', borderRadius: 8, fontSize: 13,
              background: '#f8fafc', outline: 'none', boxSizing: 'border-box',
              fontFamily: 'Plus Jakarta Sans, system-ui',
            }}
          />
        </div>
      </div>

      {/* Project filter */}
      <div>
        <label style={{ fontSize: 11, fontWeight: 600, color: '#64748b', textTransform: 'uppercase', letterSpacing: '0.05em' }}>
          Projeto
        </label>
        <select
          value={filters.projectId ?? ''}
          onChange={(e) => setFilters({ projectId: e.target.value ? Number(e.target.value) : undefined, layerId: undefined })}
          style={{
            width: '100%', marginTop: 6, padding: '7px 10px',
            border: '1px solid #e2e8f0', borderRadius: 8, fontSize: 13,
            background: '#f8fafc', outline: 'none', fontFamily: 'Plus Jakarta Sans, system-ui',
          }}
        >
          <option value="">Todos os projetos</option>
          {projects.map((p) => (
            <option key={p.id} value={p.id}>{p.name} ({p.projectType})</option>
          ))}
        </select>
      </div>

      {/* Layer filter */}
      <div>
        <label style={{ fontSize: 11, fontWeight: 600, color: '#64748b', textTransform: 'uppercase', letterSpacing: '0.05em' }}>
          Camada
        </label>
        <select
          value={filters.layerId ?? ''}
          onChange={(e) => setFilters({ layerId: e.target.value ? Number(e.target.value) : undefined, projectId: undefined })}
          style={{
            width: '100%', marginTop: 6, padding: '7px 10px',
            border: '1px solid #e2e8f0', borderRadius: 8, fontSize: 13,
            background: '#f8fafc', outline: 'none', fontFamily: 'Plus Jakarta Sans, system-ui',
          }}
        >
          <option value="">Todas as camadas</option>
          {layers.map((l) => (
            <option key={l.id} value={l.id}>{l.name}</option>
          ))}
        </select>
      </div>

      {/* Element Types */}
      <div>
        <label style={{ fontSize: 11, fontWeight: 600, color: '#64748b', textTransform: 'uppercase', letterSpacing: '0.05em' }}>
          Tipo de Elemento
        </label>
        <div style={{ marginTop: 8, display: 'flex', flexWrap: 'wrap', gap: 6 }}>
          {ELEMENT_TYPES.map((type) => {
            const active = filters.elementTypes.includes(type)
            return (
              <button
                key={type}
                onClick={() => toggleType(type)}
                style={{
                  padding: '4px 10px', borderRadius: 20, fontSize: 12, fontWeight: 600,
                  cursor: 'pointer', transition: 'all 0.15s',
                  background: active ? TYPE_COLORS[type] : '#f1f5f9',
                  color: active ? '#fff' : '#64748b',
                  border: `1.5px solid ${active ? TYPE_COLORS[type] : '#e2e8f0'}`,
                }}
              >
                {type}
              </button>
            )
          })}
        </div>
      </div>

      {/* Direct only */}
      <div style={{ display: 'flex', alignItems: 'center', gap: 10 }}>
        <input
          type="checkbox"
          id="directOnly"
          checked={filters.showOnlyDirect}
          onChange={(e) => setFilters({ showOnlyDirect: e.target.checked })}
          style={{ width: 16, height: 16, cursor: 'pointer', accentColor: '#6366f1' }}
        />
        <label htmlFor="directOnly" style={{ fontSize: 13, color: '#374151', cursor: 'pointer' }}>
          Apenas dependências diretas
        </label>
      </div>

      {/* Legend */}
      <div style={{ borderTop: '1px solid #f1f5f9', paddingTop: 16 }}>
        <label style={{ fontSize: 11, fontWeight: 600, color: '#64748b', textTransform: 'uppercase', letterSpacing: '0.05em' }}>
          Legenda — Arestas
        </label>
        <div style={{ marginTop: 8, display: 'flex', flexDirection: 'column', gap: 6 }}>
          <div style={{ display: 'flex', alignItems: 'center', gap: 8 }}>
            <div style={{ width: 30, height: 2, background: '#10b981' }} />
            <span style={{ fontSize: 12, color: '#374151' }}>IMPLEMENTS</span>
          </div>
          <div style={{ display: 'flex', alignItems: 'center', gap: 8 }}>
            <div style={{ width: 30, height: 2, background: '#6366f1', borderTop: '2px dashed #6366f1' }} />
            <span style={{ fontSize: 12, color: '#374151' }}>DEPENDS_ON</span>
          </div>
        </div>
      </div>
    </div>
  )
}
