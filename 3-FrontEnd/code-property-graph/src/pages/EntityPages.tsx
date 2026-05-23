import { useState } from 'react'
import { useMutation } from '@tanstack/react-query'
import { CrudPage, FormField, FormActions, inputStyle } from './CrudPage'
import { layersApi, projectsApi, namespacesApi, directoriesApi, codeElementsApi } from '../api/graph'

// ──────────────────────────────
// LAYERS
// ──────────────────────────────
export function LayersPage() {
  return (
    <CrudPage
      title="Layers — Camadas da Arquitetura"
      queryKey={['layers']}
      fetchAll={layersApi.getAll}
      deleteItem={layersApi.delete}
      columns={[
        { key: 'name', label: 'Nome' },
        { key: 'description', label: 'Descrição' },
      ]}
      renderCreateForm={(onSave, onCancel) => <LayerForm onSave={onSave} onCancel={onCancel} />}
    />
  )
}

function LayerForm({ onSave, onCancel }: { onSave: (data: unknown) => void; onCancel: () => void }) {
  const [name, setName] = useState('')
  const [description, setDescription] = useState('')
  const mutation = useMutation({
    mutationFn: () => layersApi.create({ name, description }),
    onSuccess: () => onSave({}),
  })
  return (
    <div style={{ display: 'flex', flexDirection: 'column', gap: 12 }}>
      <div style={{ display: 'grid', gridTemplateColumns: '1fr 2fr', gap: 12 }}>
        <FormField label="Nome *">
          <input style={inputStyle} value={name} onChange={(e) => setName(e.target.value)} placeholder="Domain" />
        </FormField>
        <FormField label="Descrição">
          <input style={inputStyle} value={description} onChange={(e) => setDescription(e.target.value)} placeholder="Camada de domínio..." />
        </FormField>
      </div>
      <FormActions onSave={() => mutation.mutate()} onCancel={onCancel} />
    </div>
  )
}

// ──────────────────────────────
// PROJECTS
// ──────────────────────────────
export function ProjectsPage() {
  return (
    <CrudPage
      title="Projetos (.csproj)"
      queryKey={['projects']}
      fetchAll={projectsApi.getAll}
      deleteItem={projectsApi.delete}
      columns={[
        { key: 'name', label: 'Nome' },
        { key: 'projectType', label: 'Tipo' },
      ]}
      renderCreateForm={(onSave, onCancel) => <ProjectForm onSave={onSave} onCancel={onCancel} />}
    />
  )
}

function ProjectForm({ onSave, onCancel }: { onSave: (data: unknown) => void; onCancel: () => void }) {
  const [name, setName] = useState('')
  const [projectType, setProjectType] = useState('ClassLibrary')
  const mutation = useMutation({
    mutationFn: () => projectsApi.create({ name, projectType }),
    onSuccess: () => onSave({}),
  })
  return (
    <div style={{ display: 'flex', flexDirection: 'column', gap: 12 }}>
      <div style={{ display: 'grid', gridTemplateColumns: '2fr 1fr', gap: 12 }}>
        <FormField label="Nome *">
          <input style={inputStyle} value={name} onChange={(e) => setName(e.target.value)} placeholder="MyApp.Domain" />
        </FormField>
        <FormField label="Tipo *">
          <select style={inputStyle} value={projectType} onChange={(e) => setProjectType(e.target.value)}>
            <option>ClassLibrary</option>
            <option>WebApi</option>
            <option>Test</option>
          </select>
        </FormField>
      </div>
      <FormActions onSave={() => mutation.mutate()} onCancel={onCancel} />
    </div>
  )
}

// ──────────────────────────────
// NAMESPACES
// ──────────────────────────────
export function NamespacesPage() {
  return (
    <CrudPage
      title="Namespaces"
      queryKey={['namespaces']}
      fetchAll={namespacesApi.getAll}
      deleteItem={namespacesApi.delete}
      columns={[{ key: 'fullName', label: 'FullName', mono: true }]}
      renderCreateForm={(onSave, onCancel) => <NamespaceForm onSave={onSave} onCancel={onCancel} />}
    />
  )
}

function NamespaceForm({ onSave, onCancel }: { onSave: (data: unknown) => void; onCancel: () => void }) {
  const [fullName, setFullName] = useState('')
  const mutation = useMutation({
    mutationFn: () => namespacesApi.create(fullName),
    onSuccess: () => onSave({}),
  })
  return (
    <div style={{ display: 'flex', flexDirection: 'column', gap: 12 }}>
      <FormField label="FullName *">
        <input style={{ ...inputStyle, fontFamily: 'JetBrains Mono' }} value={fullName} onChange={(e) => setFullName(e.target.value)} placeholder="MyApp.Domain.Entities" />
      </FormField>
      <FormActions onSave={() => mutation.mutate()} onCancel={onCancel} />
    </div>
  )
}

// ──────────────────────────────
// DIRECTORIES
// ──────────────────────────────
export function DirectoriesPage() {
  return (
    <CrudPage
      title="Diretórios"
      queryKey={['directories']}
      fetchAll={directoriesApi.getAll}
      deleteItem={directoriesApi.delete}
      columns={[{ key: 'path', label: 'Path', mono: true }]}
      renderCreateForm={(onSave, onCancel) => <DirectoryForm onSave={onSave} onCancel={onCancel} />}
    />
  )
}

function DirectoryForm({ onSave, onCancel }: { onSave: (data: unknown) => void; onCancel: () => void }) {
  const [path, setPath] = useState('')
  const mutation = useMutation({
    mutationFn: () => directoriesApi.create(path),
    onSuccess: () => onSave({}),
  })
  return (
    <div style={{ display: 'flex', flexDirection: 'column', gap: 12 }}>
      <FormField label="Path *">
        <input style={{ ...inputStyle, fontFamily: 'JetBrains Mono' }} value={path} onChange={(e) => setPath(e.target.value)} placeholder="src/Domain/Entities" />
      </FormField>
      <FormActions onSave={() => mutation.mutate()} onCancel={onCancel} />
    </div>
  )
}

// ──────────────────────────────
// CODE ELEMENTS
// ──────────────────────────────
export function CodeElementsPage() {
  return (
    <CrudPage
      title="Code Elements — Nós do Grafo"
      queryKey={['codeElements']}
      fetchAll={codeElementsApi.getAll}
      deleteItem={codeElementsApi.delete}
      columns={[
        { key: 'name', label: 'Nome', mono: true },
        { key: 'elementType', label: 'Tipo' },
        { key: 'layerName', label: 'Camada' },
        { key: 'projectName', label: 'Projeto' },
      ]}
      renderCreateForm={(onSave, onCancel) => <CodeElementForm onSave={onSave} onCancel={onCancel} />}
    />
  )
}

function CodeElementForm({ onSave, onCancel }: { onSave: (data: unknown) => void; onCancel: () => void }) {
  const [form, setForm] = useState({
    name: '', elementType: 'Class', layerId: 0,
    projectId: 0, namespaceId: 0, directoryId: 0,
    isAbstract: false, isSealed: false,
  })
  const mutation = useMutation({
    mutationFn: () => codeElementsApi.create(form),
    onSuccess: () => onSave({}),
  })
  const set = (k: string, v: unknown) => setForm((f) => ({ ...f, [k]: v }))

  return (
    <div style={{ display: 'flex', flexDirection: 'column', gap: 12 }}>
      <div style={{ display: 'grid', gridTemplateColumns: '2fr 1fr 1fr 1fr', gap: 12 }}>
        <FormField label="Nome *">
          <input style={{ ...inputStyle, fontFamily: 'JetBrains Mono' }} value={form.name} onChange={(e) => set('name', e.target.value)} placeholder="UserService" />
        </FormField>
        <FormField label="Tipo *">
          <select style={inputStyle} value={form.elementType} onChange={(e) => set('elementType', e.target.value)}>
            <option>Class</option><option>Interface</option><option>Record</option><option>Enum</option>
          </select>
        </FormField>
        <FormField label="LayerId *">
          <input style={inputStyle} type="number" min={1} value={form.layerId || ''} onChange={(e) => set('layerId', +e.target.value)} />
        </FormField>
        <FormField label="ProjectId *">
          <input style={inputStyle} type="number" min={1} value={form.projectId || ''} onChange={(e) => set('projectId', +e.target.value)} />
        </FormField>
      </div>
      <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr 1fr 1fr', gap: 12 }}>
        <FormField label="NamespaceId *">
          <input style={inputStyle} type="number" min={1} value={form.namespaceId || ''} onChange={(e) => set('namespaceId', +e.target.value)} />
        </FormField>
        <FormField label="DirectoryId *">
          <input style={inputStyle} type="number" min={1} value={form.directoryId || ''} onChange={(e) => set('directoryId', +e.target.value)} />
        </FormField>
        <div style={{ display: 'flex', gap: 16, alignItems: 'flex-end', paddingBottom: 2 }}>
          <label style={{ display: 'flex', alignItems: 'center', gap: 6, fontSize: 13, cursor: 'pointer' }}>
            <input type="checkbox" checked={form.isAbstract} onChange={(e) => set('isAbstract', e.target.checked)} style={{ accentColor: '#6366f1' }} />
            Abstract
          </label>
          <label style={{ display: 'flex', alignItems: 'center', gap: 6, fontSize: 13, cursor: 'pointer' }}>
            <input type="checkbox" checked={form.isSealed} onChange={(e) => set('isSealed', e.target.checked)} style={{ accentColor: '#6366f1' }} />
            Sealed
          </label>
        </div>
      </div>
      <FormActions onSave={() => mutation.mutate()} onCancel={onCancel} />
    </div>
  )
}
