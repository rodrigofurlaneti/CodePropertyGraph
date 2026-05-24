// ========================
// Domain Types (espelham os DTOs do backend)
// ========================

export interface Layer {
  id: number
  name: string
  description?: string
}

export interface Project {
  id: number
  name: string
  projectType: string
}

export interface Namespace {
  id: number
  fullName: string
}

export interface Directory {
  id: number
  path: string
}

export interface CodeElement {
  id: number
  name: string
  elementType: 'Class' | 'Interface' | 'Record' | 'Enum'
  isAbstract: boolean
  isSealed: boolean
  layerId: number
  layerName: string
  projectId: number
  projectName: string
  namespaceId: number
  namespaceFullName: string
  directoryId: number
  directoryPath: string
}

export interface ElementImplementation {
  classId: number
  className: string
  interfaceId: number
  interfaceName: string
}

export interface ElementDependency {
  sourceElementId: number
  sourceElementName: string
  targetElementId: number
  targetElementName: string
  dependencyType: string
  isDirect: boolean
}

// ========================
// Graph Types (para React Flow)
// ========================

export interface GraphNode {
  id: string
  label: string
  type: 'Class' | 'Interface' | 'Record' | 'Enum'
  layer: string
  project: string
  namespace: string
  isAbstract: boolean
  isSealed: boolean
}

export interface GraphEdge {
  id: string
  source: string
  target: string
  edgeType: 'IMPLEMENTS' | 'DEPENDS_ON' | 'HTTP_INPUT' | 'HTTP_OUTPUT' | 'HANDLER_INPUT' | 'HANDLER_OUTPUT'
  label: string
  isDirect: boolean
}

export interface GraphData {
  nodes: GraphNode[]
  edges: GraphEdge[]
}

export interface ApiEndpoint {
  id: number
  controllerId: number
  controllerName: string
  methodName: string
  httpVerb: string
  route: string
  inputId?: number
  inputName?: string
  outputId?: number
  outputName?: string
  roles?: string
}

export interface HandlerContract {
  handlerId: number
  handlerName: string
  inputId: number
  inputName: string
  outputId: number
  outputName: string
}

export interface ArchitectureViolation {
  sourceElementName: string
  forbiddenDependencyName: string
}

// ========================
// Filter Types
// ========================

export interface GraphFilters {
  projectId?: number
  layerId?: number
  elementTypes: string[]
  showOnlyDirect: boolean
  searchTerm: string
}
