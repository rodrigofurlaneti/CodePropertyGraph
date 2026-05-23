-- Representa as camadas da Clean Architecture (Domain, Application, Infrastructure, etc.)
CREATE TABLE Layer (
    Id INT PRIMARY KEY IDENTITY(1,1),
    Name VARCHAR(100) NOT NULL UNIQUE,
    Description VARCHAR(255)
);

-- Representa os projetos físicos (.csproj)
CREATE TABLE Project (
    Id INT PRIMARY KEY IDENTITY(1,1),
    Name VARCHAR(200) NOT NULL,
    ProjectType VARCHAR(50) NOT NULL -- Ex: 'WebApi', 'ClassLibrary', 'Test'
);

-- Representa o escopo lógico (Namespaces)
CREATE TABLE Namespace (
    Id INT PRIMARY KEY IDENTITY(1,1),
    FullName VARCHAR(500) NOT NULL UNIQUE
);

-- Representa o caminho físico no disco (Para a IA saber onde criar o arquivo)
CREATE TABLE Directory (
    Id INT PRIMARY KEY IDENTITY(1,1),
    Path VARCHAR(1000) NOT NULL UNIQUE
);

-- Representa qualquer elemento de código (Classe, Interface, Record, etc.)
CREATE TABLE CodeElement (
    Id INT PRIMARY KEY IDENTITY(1,1),
    Name VARCHAR(200) NOT NULL,
    ElementType VARCHAR(50) NOT NULL, -- Discriminador: 'Class', 'Interface', 'Record', 'Enum'
    IsAbstract BIT NOT NULL DEFAULT 0,
    IsSealed BIT NOT NULL DEFAULT 0,
    
    -- Chaves Estrangeiras (Os relacionamentos estruturais)
    LayerId INT NOT NULL,
    ProjectId INT NOT NULL,
    NamespaceId INT NOT NULL,
    DirectoryId INT NOT NULL,

    CONSTRAINT FK_CodeElement_Layer FOREIGN KEY (LayerId) REFERENCES Layer(Id),
    CONSTRAINT FK_CodeElement_Project FOREIGN KEY (ProjectId) REFERENCES Project(Id),
    CONSTRAINT FK_CodeElement_Namespace FOREIGN KEY (NamespaceId) REFERENCES Namespace(Id),
    CONSTRAINT FK_CodeElement_Directory FOREIGN KEY (DirectoryId) REFERENCES Directory(Id)
);

-- Representa a aresta IMPLEMENTS (Ex: UserService implementa IUserService)
CREATE TABLE ElementImplementation (
    ClassId INT NOT NULL,
    InterfaceId INT NOT NULL,
    
    PRIMARY KEY (ClassId, InterfaceId),
    CONSTRAINT FK_Impl_Class FOREIGN KEY (ClassId) REFERENCES CodeElement(Id),
    CONSTRAINT FK_Impl_Interface FOREIGN KEY (InterfaceId) REFERENCES CodeElement(Id)
);

-- Representa a aresta DEPENDS_ON (O coração do acoplamento)
CREATE TABLE ElementDependency (
    SourceElementId INT NOT NULL,   -- Quem está dependendo (Ex: UserQueryHandler)
    TargetElementId INT NOT NULL,   -- De quem depende (Ex: IUserRepository)
    
    -- Propriedades da aresta (Edge properties)
    DependencyType VARCHAR(50) NOT NULL, -- Ex: 'ConstructorInjection', 'MethodParameter', 'Inheritance'
    IsDirect BIT NOT NULL DEFAULT 1,     -- Se for 0, indica uma dependência transitiva descoberta por IA
    
    PRIMARY KEY (SourceElementId, TargetElementId, DependencyType),
    CONSTRAINT FK_Dep_Source FOREIGN KEY (SourceElementId) REFERENCES CodeElement(Id),
    CONSTRAINT FK_Dep_Target FOREIGN KEY (TargetElementId) REFERENCES CodeElement(Id)
);

-- Verifica se há violação de Clean Architecture
SELECT 
    SourceElem.Name AS ArquivoIncorreto,
    TargetElem.Name AS DependenciaProibida
FROM ElementDependency Dep
INNER JOIN CodeElement SourceElem ON Dep.SourceElementId = SourceElem.Id
INNER JOIN Layer SourceLayer ON SourceElem.LayerId = SourceLayer.Id
INNER JOIN CodeElement TargetElem ON Dep.TargetElementId = TargetElem.Id
INNER JOIN Layer TargetLayer ON TargetElem.LayerId = TargetLayer.Id
WHERE 
    SourceLayer.Name = 'Domain' AND 
    TargetLayer.Name = 'Infrastructure';