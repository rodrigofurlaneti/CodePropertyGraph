-- ══════════════════════════════════════════════════════════════════════════════
-- SETUP COMPLETO: CodePropertyGraphDb
-- Execute este script ANTES de rodar os inserts do OrderManager.
-- Cria o banco, todas as tabelas (incluindo HandlerContract e ApiEndpoint).
-- É seguro rodar mais de uma vez (usa IF NOT EXISTS em tudo).
-- ══════════════════════════════════════════════════════════════════════════════

-- ── 1. CRIAR O BANCO DE DADOS ─────────────────────────────────────────────────
IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = 'CodePropertyGraphDb')
BEGIN
    CREATE DATABASE CodePropertyGraphDb;
    PRINT 'Banco CodePropertyGraphDb criado.';
END
ELSE
    PRINT 'Banco CodePropertyGraphDb já existe — nenhuma ação necessária.';
GO

USE CodePropertyGraphDb;
GO

SET NOCOUNT ON;
GO

-- ── 2. LAYER ──────────────────────────────────────────────────────────────────
IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'Layer')
BEGIN
    CREATE TABLE Layer (
        Id          INT PRIMARY KEY IDENTITY(1,1),
        Name        VARCHAR(100) NOT NULL UNIQUE,
        Description VARCHAR(255)
    );
    PRINT 'Tabela Layer criada.';
END
GO

-- ── 3. PROJECT ────────────────────────────────────────────────────────────────
IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'Project')
BEGIN
    CREATE TABLE Project (
        Id          INT PRIMARY KEY IDENTITY(1,1),
        Name        VARCHAR(200) NOT NULL,
        ProjectType VARCHAR(50)  NOT NULL  -- Ex: 'WebApi', 'ClassLibrary', 'Test'
    );
    PRINT 'Tabela Project criada.';
END
GO

-- ── 4. NAMESPACE ──────────────────────────────────────────────────────────────
IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'Namespace')
BEGIN
    CREATE TABLE [Namespace] (
        Id       INT PRIMARY KEY IDENTITY(1,1),
        FullName VARCHAR(500) NOT NULL UNIQUE
    );
    PRINT 'Tabela Namespace criada.';
END
GO

-- ── 5. DIRECTORY ──────────────────────────────────────────────────────────────
IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'Directory')
BEGIN
    CREATE TABLE [Directory] (
        Id   INT PRIMARY KEY IDENTITY(1,1),
        Path VARCHAR(1000) NOT NULL UNIQUE
    );
    PRINT 'Tabela Directory criada.';
END
GO

-- ── 6. CODEELEMENT ────────────────────────────────────────────────────────────
IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'CodeElement')
BEGIN
    CREATE TABLE CodeElement (
        Id          INT PRIMARY KEY IDENTITY(1,1),
        Name        VARCHAR(200) NOT NULL,
        ElementType VARCHAR(50)  NOT NULL,       -- 'Class','Interface','Record','Enum'
        IsAbstract  BIT NOT NULL DEFAULT 0,
        IsSealed    BIT NOT NULL DEFAULT 0,

        LayerId     INT NOT NULL,
        ProjectId   INT NOT NULL,
        NamespaceId INT NOT NULL,
        DirectoryId INT NOT NULL,

        CONSTRAINT FK_CodeElement_Layer      FOREIGN KEY (LayerId)     REFERENCES Layer(Id),
        CONSTRAINT FK_CodeElement_Project    FOREIGN KEY (ProjectId)   REFERENCES Project(Id),
        CONSTRAINT FK_CodeElement_Namespace  FOREIGN KEY (NamespaceId) REFERENCES [Namespace](Id),
        CONSTRAINT FK_CodeElement_Directory  FOREIGN KEY (DirectoryId) REFERENCES [Directory](Id)
    );
    PRINT 'Tabela CodeElement criada.';
END
GO

-- ── 7. ELEMENTIMPLEMENTATION ─────────────────────────────────────────────────
IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'ElementImplementation')
BEGIN
    CREATE TABLE ElementImplementation (
        ClassId     INT NOT NULL,
        InterfaceId INT NOT NULL,

        PRIMARY KEY (ClassId, InterfaceId),
        CONSTRAINT FK_Impl_Class      FOREIGN KEY (ClassId)     REFERENCES CodeElement(Id),
        CONSTRAINT FK_Impl_Interface  FOREIGN KEY (InterfaceId) REFERENCES CodeElement(Id)
    );
    PRINT 'Tabela ElementImplementation criada.';
END
GO

-- ── 8. ELEMENTDEPENDENCY ──────────────────────────────────────────────────────
IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'ElementDependency')
BEGIN
    CREATE TABLE ElementDependency (
        SourceElementId INT NOT NULL,
        TargetElementId INT NOT NULL,
        DependencyType  VARCHAR(50) NOT NULL,  -- 'ConstructorInjection','Inheritance','MethodParameter'
        IsDirect        BIT NOT NULL DEFAULT 1,

        PRIMARY KEY (SourceElementId, TargetElementId, DependencyType),
        CONSTRAINT FK_Dep_Source FOREIGN KEY (SourceElementId) REFERENCES CodeElement(Id),
        CONSTRAINT FK_Dep_Target FOREIGN KEY (TargetElementId) REFERENCES CodeElement(Id)
    );
    PRINT 'Tabela ElementDependency criada.';
END
GO

-- ── 9. HANDLERCONTRACT (migration: AddApiEndpointAndHandlerContract) ──────────
IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'HandlerContract')
BEGIN
    CREATE TABLE HandlerContract (
        HandlerId INT NOT NULL,
        InputId   INT NOT NULL,
        OutputId  INT NOT NULL,

        CONSTRAINT PK_HandlerContract            PRIMARY KEY (HandlerId),
        CONSTRAINT FK_HandlerContract_Handler    FOREIGN KEY (HandlerId) REFERENCES CodeElement(Id) ON DELETE NO ACTION,
        CONSTRAINT FK_HandlerContract_Input      FOREIGN KEY (InputId)   REFERENCES CodeElement(Id) ON DELETE NO ACTION,
        CONSTRAINT FK_HandlerContract_Output     FOREIGN KEY (OutputId)  REFERENCES CodeElement(Id) ON DELETE NO ACTION
    );
    CREATE INDEX IX_HandlerContract_InputId  ON HandlerContract(InputId);
    CREATE INDEX IX_HandlerContract_OutputId ON HandlerContract(OutputId);
    PRINT 'Tabela HandlerContract criada.';
END
GO

-- ── 10. APIENDPOINT (migration: AddApiEndpointAndHandlerContract) ─────────────
IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'ApiEndpoint')
BEGIN
    CREATE TABLE ApiEndpoint (
        Id           INT PRIMARY KEY IDENTITY(1,1),
        ControllerId INT NOT NULL,
        MethodName   NVARCHAR(100) NOT NULL,
        HttpVerb     NVARCHAR(10)  NOT NULL,
        Route        NVARCHAR(300) NOT NULL,
        InputId      INT NULL,
        OutputId     INT NULL,
        Roles        NVARCHAR(200) NULL,

        CONSTRAINT FK_ApiEndpoint_Controller FOREIGN KEY (ControllerId) REFERENCES CodeElement(Id) ON DELETE NO ACTION,
        CONSTRAINT FK_ApiEndpoint_Input      FOREIGN KEY (InputId)      REFERENCES CodeElement(Id) ON DELETE NO ACTION,
        CONSTRAINT FK_ApiEndpoint_Output     FOREIGN KEY (OutputId)     REFERENCES CodeElement(Id) ON DELETE NO ACTION
    );
    CREATE INDEX IX_ApiEndpoint_ControllerId ON ApiEndpoint(ControllerId);
    CREATE INDEX IX_ApiEndpoint_InputId      ON ApiEndpoint(InputId);
    CREATE INDEX IX_ApiEndpoint_OutputId     ON ApiEndpoint(OutputId);
    PRINT 'Tabela ApiEndpoint criada.';
END
GO

-- ── FIM DO SETUP ──────────────────────────────────────────────────────────────
PRINT '════════════════════════════════════════════════════════';
PRINT 'Setup CodePropertyGraphDb concluído com sucesso!';
PRINT 'Agora execute: insert_OrderManager_CodePropertyGraphDb.sql';
PRINT '════════════════════════════════════════════════════════';
GO
