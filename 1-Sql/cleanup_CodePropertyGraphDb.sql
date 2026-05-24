-- ============================================================
-- CodePropertyGraphDb - LIMPEZA COMPLETA
-- Ordem reversa das foreign keys para evitar violacoes
-- ============================================================
USE CodePropertyGraphDb;
GO
SET NOCOUNT ON;
GO

-- 1. Arestas (dependem de CodeElement)
DELETE FROM ElementDependency;
DELETE FROM ElementImplementation;

-- 2. Nos (dependem de Layer, Project, Namespace, Directory)
DELETE FROM CodeElement;

-- 3. Lookups
DELETE FROM Directory;
DELETE FROM Namespace;
DELETE FROM Project;
DELETE FROM Layer;

-- Resetar identidades (opcional — remove gaps nos IDs)
DBCC CHECKIDENT ('ElementDependency',   RESEED, 0);
DBCC CHECKIDENT ('ElementImplementation', RESEED, 0);
DBCC CHECKIDENT ('CodeElement',         RESEED, 0);
DBCC CHECKIDENT ('Directory',           RESEED, 0);
DBCC CHECKIDENT ('Namespace',           RESEED, 0);
DBCC CHECKIDENT ('Project',             RESEED, 0);
DBCC CHECKIDENT ('Layer',               RESEED, 0);

GO
PRINT 'Banco limpo com sucesso.';
GO
