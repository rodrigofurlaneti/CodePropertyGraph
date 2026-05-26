-- ============================================================
-- CodePropertyGraph INSERTs - OrderManager
-- Estratégia: ADITIVO — insere apenas o que ainda não existe.
-- Seguro para bancos com dados de outros projetos.
-- ============================================================
USE CodePropertyGraphDb;
GO
SET NOCOUNT ON;
GO

-- ── 1. LAYERS ────────────────────────────────────────────
IF NOT EXISTS (SELECT 1 FROM Layer WHERE Name = 'Api')
    INSERT INTO Layer (Name, Description) VALUES ('Api', 'Controllers, Middlewares, configuracao da Web API');
IF NOT EXISTS (SELECT 1 FROM Layer WHERE Name = 'Application')
    INSERT INTO Layer (Name, Description) VALUES ('Application', 'Casos de uso, Commands, Queries, Handlers, Validators, DTOs');
IF NOT EXISTS (SELECT 1 FROM Layer WHERE Name = 'Domain')
    INSERT INTO Layer (Name, Description) VALUES ('Domain', 'Entidades, Value Objects, Interfaces de repositorio, Domain Events');
IF NOT EXISTS (SELECT 1 FROM Layer WHERE Name = 'Infrastructure')
    INSERT INTO Layer (Name, Description) VALUES ('Infrastructure', 'Implementacoes de repositorio, EF Core, servicos externos');
IF NOT EXISTS (SELECT 1 FROM Layer WHERE Name = 'Test')
    INSERT INTO Layer (Name, Description) VALUES ('Test', 'Testes unitarios, de integracao e BDD');

-- ── 2. PROJECTS ──────────────────────────────────────────
IF NOT EXISTS (SELECT 1 FROM Project WHERE Name = 'OrderManager.Api')
    INSERT INTO Project (Name, ProjectType) VALUES ('OrderManager.Api', 'WebApi');
IF NOT EXISTS (SELECT 1 FROM Project WHERE Name = 'OrderManager.Application')
    INSERT INTO Project (Name, ProjectType) VALUES ('OrderManager.Application', 'ClassLibrary');
IF NOT EXISTS (SELECT 1 FROM Project WHERE Name = 'OrderManager.Domain')
    INSERT INTO Project (Name, ProjectType) VALUES ('OrderManager.Domain', 'ClassLibrary');
IF NOT EXISTS (SELECT 1 FROM Project WHERE Name = 'OrderManager.Infrastructure')
    INSERT INTO Project (Name, ProjectType) VALUES ('OrderManager.Infrastructure', 'ClassLibrary');
IF NOT EXISTS (SELECT 1 FROM Project WHERE Name = 'OrderManager.UnitTests')
    INSERT INTO Project (Name, ProjectType) VALUES ('OrderManager.UnitTests', 'Test');
IF NOT EXISTS (SELECT 1 FROM Project WHERE Name = 'OrderManager.BddTests')
    INSERT INTO Project (Name, ProjectType) VALUES ('OrderManager.BddTests', 'Test');

-- ── 3. NAMESPACES ────────────────────────────────────────
-- Api
IF NOT EXISTS (SELECT 1 FROM Namespace WHERE FullName='OrderManager.Api.Controllers')
    INSERT INTO Namespace (FullName) VALUES ('OrderManager.Api.Controllers');
IF NOT EXISTS (SELECT 1 FROM Namespace WHERE FullName='OrderManager.Api.Middleware')
    INSERT INTO Namespace (FullName) VALUES ('OrderManager.Api.Middleware');
-- Application Common
IF NOT EXISTS (SELECT 1 FROM Namespace WHERE FullName='OrderManager.Application.Common.Behaviors')
    INSERT INTO Namespace (FullName) VALUES ('OrderManager.Application.Common.Behaviors');
IF NOT EXISTS (SELECT 1 FROM Namespace WHERE FullName='OrderManager.Application.Common.Exceptions')
    INSERT INTO Namespace (FullName) VALUES ('OrderManager.Application.Common.Exceptions');
IF NOT EXISTS (SELECT 1 FROM Namespace WHERE FullName='OrderManager.Application.Common.Models')
    INSERT INTO Namespace (FullName) VALUES ('OrderManager.Application.Common.Models');
IF NOT EXISTS (SELECT 1 FROM Namespace WHERE FullName='OrderManager.Application.Mappings')
    INSERT INTO Namespace (FullName) VALUES ('OrderManager.Application.Mappings');
-- Application Features - CashRegister
IF NOT EXISTS (SELECT 1 FROM Namespace WHERE FullName='OrderManager.Application.Features.CashRegister.Commands.CloseCashRegister')
    INSERT INTO Namespace (FullName) VALUES ('OrderManager.Application.Features.CashRegister.Commands.CloseCashRegister');
IF NOT EXISTS (SELECT 1 FROM Namespace WHERE FullName='OrderManager.Application.Features.CashRegister.Commands.OpenCashRegister')
    INSERT INTO Namespace (FullName) VALUES ('OrderManager.Application.Features.CashRegister.Commands.OpenCashRegister');
IF NOT EXISTS (SELECT 1 FROM Namespace WHERE FullName='OrderManager.Application.Features.CashRegister.DTOs')
    INSERT INTO Namespace (FullName) VALUES ('OrderManager.Application.Features.CashRegister.DTOs');
IF NOT EXISTS (SELECT 1 FROM Namespace WHERE FullName='OrderManager.Application.Features.CashRegister.Queries.GetActiveCashRegister')
    INSERT INTO Namespace (FullName) VALUES ('OrderManager.Application.Features.CashRegister.Queries.GetActiveCashRegister');
IF NOT EXISTS (SELECT 1 FROM Namespace WHERE FullName='OrderManager.Application.Features.CashRegister.Queries.GetCashRegisterClosingById')
    INSERT INTO Namespace (FullName) VALUES ('OrderManager.Application.Features.CashRegister.Queries.GetCashRegisterClosingById');
-- Application Features - Employees
IF NOT EXISTS (SELECT 1 FROM Namespace WHERE FullName='OrderManager.Application.Features.Employees.Commands.CreateEmployee')
    INSERT INTO Namespace (FullName) VALUES ('OrderManager.Application.Features.Employees.Commands.CreateEmployee');
IF NOT EXISTS (SELECT 1 FROM Namespace WHERE FullName='OrderManager.Application.Features.Employees.Commands.DeleteEmployee')
    INSERT INTO Namespace (FullName) VALUES ('OrderManager.Application.Features.Employees.Commands.DeleteEmployee');
IF NOT EXISTS (SELECT 1 FROM Namespace WHERE FullName='OrderManager.Application.Features.Employees.Commands.UpdateEmployee')
    INSERT INTO Namespace (FullName) VALUES ('OrderManager.Application.Features.Employees.Commands.UpdateEmployee');
IF NOT EXISTS (SELECT 1 FROM Namespace WHERE FullName='OrderManager.Application.Features.Employees.DTOs')
    INSERT INTO Namespace (FullName) VALUES ('OrderManager.Application.Features.Employees.DTOs');
IF NOT EXISTS (SELECT 1 FROM Namespace WHERE FullName='OrderManager.Application.Features.Employees.Queries.GetAllEmployees')
    INSERT INTO Namespace (FullName) VALUES ('OrderManager.Application.Features.Employees.Queries.GetAllEmployees');
IF NOT EXISTS (SELECT 1 FROM Namespace WHERE FullName='OrderManager.Application.Features.Employees.Queries.GetEmployeeById')
    INSERT INTO Namespace (FullName) VALUES ('OrderManager.Application.Features.Employees.Queries.GetEmployeeById');
-- Application Features - OrderItems
IF NOT EXISTS (SELECT 1 FROM Namespace WHERE FullName='OrderManager.Application.Features.OrderItems.Commands.CancelOrderItem')
    INSERT INTO Namespace (FullName) VALUES ('OrderManager.Application.Features.OrderItems.Commands.CancelOrderItem');
IF NOT EXISTS (SELECT 1 FROM Namespace WHERE FullName='OrderManager.Application.Features.OrderItems.Commands.CreateOrderItem')
    INSERT INTO Namespace (FullName) VALUES ('OrderManager.Application.Features.OrderItems.Commands.CreateOrderItem');
IF NOT EXISTS (SELECT 1 FROM Namespace WHERE FullName='OrderManager.Application.Features.OrderItems.Queries.GetOrderItemById')
    INSERT INTO Namespace (FullName) VALUES ('OrderManager.Application.Features.OrderItems.Queries.GetOrderItemById');
IF NOT EXISTS (SELECT 1 FROM Namespace WHERE FullName='OrderManager.Application.Features.OrderItems.Queries.GetOrderItemsByOrder')
    INSERT INTO Namespace (FullName) VALUES ('OrderManager.Application.Features.OrderItems.Queries.GetOrderItemsByOrder');
-- Application Features - Orders
IF NOT EXISTS (SELECT 1 FROM Namespace WHERE FullName='OrderManager.Application.Features.Orders.Commands.AdvanceOrderStatus')
    INSERT INTO Namespace (FullName) VALUES ('OrderManager.Application.Features.Orders.Commands.AdvanceOrderStatus');
IF NOT EXISTS (SELECT 1 FROM Namespace WHERE FullName='OrderManager.Application.Features.Orders.Commands.CancelOrder')
    INSERT INTO Namespace (FullName) VALUES ('OrderManager.Application.Features.Orders.Commands.CancelOrder');
IF NOT EXISTS (SELECT 1 FROM Namespace WHERE FullName='OrderManager.Application.Features.Orders.Commands.CreateOrder')
    INSERT INTO Namespace (FullName) VALUES ('OrderManager.Application.Features.Orders.Commands.CreateOrder');
IF NOT EXISTS (SELECT 1 FROM Namespace WHERE FullName='OrderManager.Application.Features.Orders.DTOs')
    INSERT INTO Namespace (FullName) VALUES ('OrderManager.Application.Features.Orders.DTOs');
IF NOT EXISTS (SELECT 1 FROM Namespace WHERE FullName='OrderManager.Application.Features.Orders.Queries.GetAllOrders')
    INSERT INTO Namespace (FullName) VALUES ('OrderManager.Application.Features.Orders.Queries.GetAllOrders');
IF NOT EXISTS (SELECT 1 FROM Namespace WHERE FullName='OrderManager.Application.Features.Orders.Queries.GetOrderById')
    INSERT INTO Namespace (FullName) VALUES ('OrderManager.Application.Features.Orders.Queries.GetOrderById');
-- Application Features - PaymentMethods
IF NOT EXISTS (SELECT 1 FROM Namespace WHERE FullName='OrderManager.Application.Features.PaymentMethods.Commands.CreatePaymentMethod')
    INSERT INTO Namespace (FullName) VALUES ('OrderManager.Application.Features.PaymentMethods.Commands.CreatePaymentMethod');
IF NOT EXISTS (SELECT 1 FROM Namespace WHERE FullName='OrderManager.Application.Features.PaymentMethods.Commands.DeletePaymentMethod')
    INSERT INTO Namespace (FullName) VALUES ('OrderManager.Application.Features.PaymentMethods.Commands.DeletePaymentMethod');
IF NOT EXISTS (SELECT 1 FROM Namespace WHERE FullName='OrderManager.Application.Features.PaymentMethods.Commands.UpdatePaymentMethod')
    INSERT INTO Namespace (FullName) VALUES ('OrderManager.Application.Features.PaymentMethods.Commands.UpdatePaymentMethod');
IF NOT EXISTS (SELECT 1 FROM Namespace WHERE FullName='OrderManager.Application.Features.PaymentMethods.DTOs')
    INSERT INTO Namespace (FullName) VALUES ('OrderManager.Application.Features.PaymentMethods.DTOs');
IF NOT EXISTS (SELECT 1 FROM Namespace WHERE FullName='OrderManager.Application.Features.PaymentMethods.Queries.GetAllPaymentMethods')
    INSERT INTO Namespace (FullName) VALUES ('OrderManager.Application.Features.PaymentMethods.Queries.GetAllPaymentMethods');
IF NOT EXISTS (SELECT 1 FROM Namespace WHERE FullName='OrderManager.Application.Features.PaymentMethods.Queries.GetPaymentMethodById')
    INSERT INTO Namespace (FullName) VALUES ('OrderManager.Application.Features.PaymentMethods.Queries.GetPaymentMethodById');
-- Application Features - ProductCategories
IF NOT EXISTS (SELECT 1 FROM Namespace WHERE FullName='OrderManager.Application.Features.ProductCategories.Commands.CreateProductCategory')
    INSERT INTO Namespace (FullName) VALUES ('OrderManager.Application.Features.ProductCategories.Commands.CreateProductCategory');
IF NOT EXISTS (SELECT 1 FROM Namespace WHERE FullName='OrderManager.Application.Features.ProductCategories.Commands.DeleteProductCategory')
    INSERT INTO Namespace (FullName) VALUES ('OrderManager.Application.Features.ProductCategories.Commands.DeleteProductCategory');
IF NOT EXISTS (SELECT 1 FROM Namespace WHERE FullName='OrderManager.Application.Features.ProductCategories.Commands.UpdateProductCategory')
    INSERT INTO Namespace (FullName) VALUES ('OrderManager.Application.Features.ProductCategories.Commands.UpdateProductCategory');
IF NOT EXISTS (SELECT 1 FROM Namespace WHERE FullName='OrderManager.Application.Features.ProductCategories.DTOs')
    INSERT INTO Namespace (FullName) VALUES ('OrderManager.Application.Features.ProductCategories.DTOs');
IF NOT EXISTS (SELECT 1 FROM Namespace WHERE FullName='OrderManager.Application.Features.ProductCategories.Queries.GetAllProductCategories')
    INSERT INTO Namespace (FullName) VALUES ('OrderManager.Application.Features.ProductCategories.Queries.GetAllProductCategories');
IF NOT EXISTS (SELECT 1 FROM Namespace WHERE FullName='OrderManager.Application.Features.ProductCategories.Queries.GetProductCategoryById')
    INSERT INTO Namespace (FullName) VALUES ('OrderManager.Application.Features.ProductCategories.Queries.GetProductCategoryById');
-- Application Features - Products
IF NOT EXISTS (SELECT 1 FROM Namespace WHERE FullName='OrderManager.Application.Features.Products.Commands.CreateProduct')
    INSERT INTO Namespace (FullName) VALUES ('OrderManager.Application.Features.Products.Commands.CreateProduct');
IF NOT EXISTS (SELECT 1 FROM Namespace WHERE FullName='OrderManager.Application.Features.Products.Commands.DeleteProduct')
    INSERT INTO Namespace (FullName) VALUES ('OrderManager.Application.Features.Products.Commands.DeleteProduct');
IF NOT EXISTS (SELECT 1 FROM Namespace WHERE FullName='OrderManager.Application.Features.Products.Commands.UpdateProduct')
    INSERT INTO Namespace (FullName) VALUES ('OrderManager.Application.Features.Products.Commands.UpdateProduct');
IF NOT EXISTS (SELECT 1 FROM Namespace WHERE FullName='OrderManager.Application.Features.Products.DTOs')
    INSERT INTO Namespace (FullName) VALUES ('OrderManager.Application.Features.Products.DTOs');
IF NOT EXISTS (SELECT 1 FROM Namespace WHERE FullName='OrderManager.Application.Features.Products.Queries.GetAllProducts')
    INSERT INTO Namespace (FullName) VALUES ('OrderManager.Application.Features.Products.Queries.GetAllProducts');
IF NOT EXISTS (SELECT 1 FROM Namespace WHERE FullName='OrderManager.Application.Features.Products.Queries.GetProductById')
    INSERT INTO Namespace (FullName) VALUES ('OrderManager.Application.Features.Products.Queries.GetProductById');
-- Application Features - Roles
IF NOT EXISTS (SELECT 1 FROM Namespace WHERE FullName='OrderManager.Application.Features.Roles.Commands.CreateRole')
    INSERT INTO Namespace (FullName) VALUES ('OrderManager.Application.Features.Roles.Commands.CreateRole');
IF NOT EXISTS (SELECT 1 FROM Namespace WHERE FullName='OrderManager.Application.Features.Roles.Commands.DeleteRole')
    INSERT INTO Namespace (FullName) VALUES ('OrderManager.Application.Features.Roles.Commands.DeleteRole');
IF NOT EXISTS (SELECT 1 FROM Namespace WHERE FullName='OrderManager.Application.Features.Roles.Commands.UpdateRole')
    INSERT INTO Namespace (FullName) VALUES ('OrderManager.Application.Features.Roles.Commands.UpdateRole');
IF NOT EXISTS (SELECT 1 FROM Namespace WHERE FullName='OrderManager.Application.Features.Roles.DTOs')
    INSERT INTO Namespace (FullName) VALUES ('OrderManager.Application.Features.Roles.DTOs');
IF NOT EXISTS (SELECT 1 FROM Namespace WHERE FullName='OrderManager.Application.Features.Roles.Queries.GetAllRoles')
    INSERT INTO Namespace (FullName) VALUES ('OrderManager.Application.Features.Roles.Queries.GetAllRoles');
IF NOT EXISTS (SELECT 1 FROM Namespace WHERE FullName='OrderManager.Application.Features.Roles.Queries.GetRoleById')
    INSERT INTO Namespace (FullName) VALUES ('OrderManager.Application.Features.Roles.Queries.GetRoleById');
-- Application Features - StockMovements
IF NOT EXISTS (SELECT 1 FROM Namespace WHERE FullName='OrderManager.Application.Features.StockMovements.Commands.CreateStockMovement')
    INSERT INTO Namespace (FullName) VALUES ('OrderManager.Application.Features.StockMovements.Commands.CreateStockMovement');
IF NOT EXISTS (SELECT 1 FROM Namespace WHERE FullName='OrderManager.Application.Features.StockMovements.DTOs')
    INSERT INTO Namespace (FullName) VALUES ('OrderManager.Application.Features.StockMovements.DTOs');
IF NOT EXISTS (SELECT 1 FROM Namespace WHERE FullName='OrderManager.Application.Features.StockMovements.Queries.GetStockMovementsByProduct')
    INSERT INTO Namespace (FullName) VALUES ('OrderManager.Application.Features.StockMovements.Queries.GetStockMovementsByProduct');
-- Application Features - TabCheckouts
IF NOT EXISTS (SELECT 1 FROM Namespace WHERE FullName='OrderManager.Application.Features.TabCheckouts.Commands.CreateTabCheckout')
    INSERT INTO Namespace (FullName) VALUES ('OrderManager.Application.Features.TabCheckouts.Commands.CreateTabCheckout');
IF NOT EXISTS (SELECT 1 FROM Namespace WHERE FullName='OrderManager.Application.Features.TabCheckouts.DTOs')
    INSERT INTO Namespace (FullName) VALUES ('OrderManager.Application.Features.TabCheckouts.DTOs');
IF NOT EXISTS (SELECT 1 FROM Namespace WHERE FullName='OrderManager.Application.Features.TabCheckouts.Queries.GetTabCheckoutById')
    INSERT INTO Namespace (FullName) VALUES ('OrderManager.Application.Features.TabCheckouts.Queries.GetTabCheckoutById');
-- Application Features - TabPayments
IF NOT EXISTS (SELECT 1 FROM Namespace WHERE FullName='OrderManager.Application.Features.TabPayments.Commands.CreateTabPayment')
    INSERT INTO Namespace (FullName) VALUES ('OrderManager.Application.Features.TabPayments.Commands.CreateTabPayment');
IF NOT EXISTS (SELECT 1 FROM Namespace WHERE FullName='OrderManager.Application.Features.TabPayments.DTOs')
    INSERT INTO Namespace (FullName) VALUES ('OrderManager.Application.Features.TabPayments.DTOs');
IF NOT EXISTS (SELECT 1 FROM Namespace WHERE FullName='OrderManager.Application.Features.TabPayments.Queries.GetTabPaymentsByCheckout')
    INSERT INTO Namespace (FullName) VALUES ('OrderManager.Application.Features.TabPayments.Queries.GetTabPaymentsByCheckout');
-- Application Features - Tabs
IF NOT EXISTS (SELECT 1 FROM Namespace WHERE FullName='OrderManager.Application.Features.Tabs.Commands.CancelTab')
    INSERT INTO Namespace (FullName) VALUES ('OrderManager.Application.Features.Tabs.Commands.CancelTab');
IF NOT EXISTS (SELECT 1 FROM Namespace WHERE FullName='OrderManager.Application.Features.Tabs.Commands.CloseTab')
    INSERT INTO Namespace (FullName) VALUES ('OrderManager.Application.Features.Tabs.Commands.CloseTab');
IF NOT EXISTS (SELECT 1 FROM Namespace WHERE FullName='OrderManager.Application.Features.Tabs.Commands.CreateTab')
    INSERT INTO Namespace (FullName) VALUES ('OrderManager.Application.Features.Tabs.Commands.CreateTab');
IF NOT EXISTS (SELECT 1 FROM Namespace WHERE FullName='OrderManager.Application.Features.Tabs.DTOs')
    INSERT INTO Namespace (FullName) VALUES ('OrderManager.Application.Features.Tabs.DTOs');
IF NOT EXISTS (SELECT 1 FROM Namespace WHERE FullName='OrderManager.Application.Features.Tabs.Queries.GetAllTabs')
    INSERT INTO Namespace (FullName) VALUES ('OrderManager.Application.Features.Tabs.Queries.GetAllTabs');
IF NOT EXISTS (SELECT 1 FROM Namespace WHERE FullName='OrderManager.Application.Features.Tabs.Queries.GetTabById')
    INSERT INTO Namespace (FullName) VALUES ('OrderManager.Application.Features.Tabs.Queries.GetTabById');
-- Domain
IF NOT EXISTS (SELECT 1 FROM Namespace WHERE FullName='OrderManager.Domain.Common')
    INSERT INTO Namespace (FullName) VALUES ('OrderManager.Domain.Common');
IF NOT EXISTS (SELECT 1 FROM Namespace WHERE FullName='OrderManager.Domain.Entities')
    INSERT INTO Namespace (FullName) VALUES ('OrderManager.Domain.Entities');
IF NOT EXISTS (SELECT 1 FROM Namespace WHERE FullName='OrderManager.Domain.Enums')
    INSERT INTO Namespace (FullName) VALUES ('OrderManager.Domain.Enums');
IF NOT EXISTS (SELECT 1 FROM Namespace WHERE FullName='OrderManager.Domain.Events')
    INSERT INTO Namespace (FullName) VALUES ('OrderManager.Domain.Events');
IF NOT EXISTS (SELECT 1 FROM Namespace WHERE FullName='OrderManager.Domain.Interfaces')
    INSERT INTO Namespace (FullName) VALUES ('OrderManager.Domain.Interfaces');
IF NOT EXISTS (SELECT 1 FROM Namespace WHERE FullName='OrderManager.Domain.Interfaces.Repositories')
    INSERT INTO Namespace (FullName) VALUES ('OrderManager.Domain.Interfaces.Repositories');
-- Infrastructure
IF NOT EXISTS (SELECT 1 FROM Namespace WHERE FullName='OrderManager.Infrastructure.Persistence')
    INSERT INTO Namespace (FullName) VALUES ('OrderManager.Infrastructure.Persistence');
IF NOT EXISTS (SELECT 1 FROM Namespace WHERE FullName='OrderManager.Infrastructure.Persistence.Configurations')
    INSERT INTO Namespace (FullName) VALUES ('OrderManager.Infrastructure.Persistence.Configurations');
IF NOT EXISTS (SELECT 1 FROM Namespace WHERE FullName='OrderManager.Infrastructure.Repositories')
    INSERT INTO Namespace (FullName) VALUES ('OrderManager.Infrastructure.Repositories');
-- Tests
IF NOT EXISTS (SELECT 1 FROM Namespace WHERE FullName='OrderManager.UnitTests.Application.Features.Roles')
    INSERT INTO Namespace (FullName) VALUES ('OrderManager.UnitTests.Application.Features.Roles');
IF NOT EXISTS (SELECT 1 FROM Namespace WHERE FullName='OrderManager.UnitTests.Application.Features.Tabs')
    INSERT INTO Namespace (FullName) VALUES ('OrderManager.UnitTests.Application.Features.Tabs');
IF NOT EXISTS (SELECT 1 FROM Namespace WHERE FullName='OrderManager.UnitTests.Domain.Entities')
    INSERT INTO Namespace (FullName) VALUES ('OrderManager.UnitTests.Domain.Entities');
IF NOT EXISTS (SELECT 1 FROM Namespace WHERE FullName='OrderManager.BddTests.StepDefinitions')
    INSERT INTO Namespace (FullName) VALUES ('OrderManager.BddTests.StepDefinitions');

-- ── 4. DIRECTORIES ───────────────────────────────────────
IF NOT EXISTS (SELECT 1 FROM Directory WHERE Path='src\OrderManager.Api\Controllers')
    INSERT INTO Directory (Path) VALUES ('src\OrderManager.Api\Controllers');
IF NOT EXISTS (SELECT 1 FROM Directory WHERE Path='src\OrderManager.Api\Middleware')
    INSERT INTO Directory (Path) VALUES ('src\OrderManager.Api\Middleware');
IF NOT EXISTS (SELECT 1 FROM Directory WHERE Path='src\OrderManager.Application\Common\Behaviors')
    INSERT INTO Directory (Path) VALUES ('src\OrderManager.Application\Common\Behaviors');
IF NOT EXISTS (SELECT 1 FROM Directory WHERE Path='src\OrderManager.Application\Common\Exceptions')
    INSERT INTO Directory (Path) VALUES ('src\OrderManager.Application\Common\Exceptions');
IF NOT EXISTS (SELECT 1 FROM Directory WHERE Path='src\OrderManager.Application\Common\Models')
    INSERT INTO Directory (Path) VALUES ('src\OrderManager.Application\Common\Models');
IF NOT EXISTS (SELECT 1 FROM Directory WHERE Path='src\OrderManager.Application\Mappings')
    INSERT INTO Directory (Path) VALUES ('src\OrderManager.Application\Mappings');
IF NOT EXISTS (SELECT 1 FROM Directory WHERE Path='src\OrderManager.Application\Features\CashRegister\Commands\CloseCashRegister')
    INSERT INTO Directory (Path) VALUES ('src\OrderManager.Application\Features\CashRegister\Commands\CloseCashRegister');
IF NOT EXISTS (SELECT 1 FROM Directory WHERE Path='src\OrderManager.Application\Features\CashRegister\Commands\OpenCashRegister')
    INSERT INTO Directory (Path) VALUES ('src\OrderManager.Application\Features\CashRegister\Commands\OpenCashRegister');
IF NOT EXISTS (SELECT 1 FROM Directory WHERE Path='src\OrderManager.Application\Features\CashRegister\DTOs')
    INSERT INTO Directory (Path) VALUES ('src\OrderManager.Application\Features\CashRegister\DTOs');
IF NOT EXISTS (SELECT 1 FROM Directory WHERE Path='src\OrderManager.Application\Features\CashRegister\Queries\GetActiveCashRegister')
    INSERT INTO Directory (Path) VALUES ('src\OrderManager.Application\Features\CashRegister\Queries\GetActiveCashRegister');
IF NOT EXISTS (SELECT 1 FROM Directory WHERE Path='src\OrderManager.Application\Features\CashRegister\Queries\GetCashRegisterClosingById')
    INSERT INTO Directory (Path) VALUES ('src\OrderManager.Application\Features\CashRegister\Queries\GetCashRegisterClosingById');
IF NOT EXISTS (SELECT 1 FROM Directory WHERE Path='src\OrderManager.Application\Features\Employees\Commands\CreateEmployee')
    INSERT INTO Directory (Path) VALUES ('src\OrderManager.Application\Features\Employees\Commands\CreateEmployee');
IF NOT EXISTS (SELECT 1 FROM Directory WHERE Path='src\OrderManager.Application\Features\Employees\Commands\DeleteEmployee')
    INSERT INTO Directory (Path) VALUES ('src\OrderManager.Application\Features\Employees\Commands\DeleteEmployee');
IF NOT EXISTS (SELECT 1 FROM Directory WHERE Path='src\OrderManager.Application\Features\Employees\Commands\UpdateEmployee')
    INSERT INTO Directory (Path) VALUES ('src\OrderManager.Application\Features\Employees\Commands\UpdateEmployee');
IF NOT EXISTS (SELECT 1 FROM Directory WHERE Path='src\OrderManager.Application\Features\Employees\DTOs')
    INSERT INTO Directory (Path) VALUES ('src\OrderManager.Application\Features\Employees\DTOs');
IF NOT EXISTS (SELECT 1 FROM Directory WHERE Path='src\OrderManager.Application\Features\Employees\Queries\GetAllEmployees')
    INSERT INTO Directory (Path) VALUES ('src\OrderManager.Application\Features\Employees\Queries\GetAllEmployees');
IF NOT EXISTS (SELECT 1 FROM Directory WHERE Path='src\OrderManager.Application\Features\Employees\Queries\GetEmployeeById')
    INSERT INTO Directory (Path) VALUES ('src\OrderManager.Application\Features\Employees\Queries\GetEmployeeById');
IF NOT EXISTS (SELECT 1 FROM Directory WHERE Path='src\OrderManager.Application\Features\OrderItems\Commands\CancelOrderItem')
    INSERT INTO Directory (Path) VALUES ('src\OrderManager.Application\Features\OrderItems\Commands\CancelOrderItem');
IF NOT EXISTS (SELECT 1 FROM Directory WHERE Path='src\OrderManager.Application\Features\OrderItems\Commands\CreateOrderItem')
    INSERT INTO Directory (Path) VALUES ('src\OrderManager.Application\Features\OrderItems\Commands\CreateOrderItem');
IF NOT EXISTS (SELECT 1 FROM Directory WHERE Path='src\OrderManager.Application\Features\OrderItems\Queries\GetOrderItemById')
    INSERT INTO Directory (Path) VALUES ('src\OrderManager.Application\Features\OrderItems\Queries\GetOrderItemById');
IF NOT EXISTS (SELECT 1 FROM Directory WHERE Path='src\OrderManager.Application\Features\OrderItems\Queries\GetOrderItemsByOrder')
    INSERT INTO Directory (Path) VALUES ('src\OrderManager.Application\Features\OrderItems\Queries\GetOrderItemsByOrder');
IF NOT EXISTS (SELECT 1 FROM Directory WHERE Path='src\OrderManager.Application\Features\Orders\Commands\AdvanceOrderStatus')
    INSERT INTO Directory (Path) VALUES ('src\OrderManager.Application\Features\Orders\Commands\AdvanceOrderStatus');
IF NOT EXISTS (SELECT 1 FROM Directory WHERE Path='src\OrderManager.Application\Features\Orders\Commands\CancelOrder')
    INSERT INTO Directory (Path) VALUES ('src\OrderManager.Application\Features\Orders\Commands\CancelOrder');
IF NOT EXISTS (SELECT 1 FROM Directory WHERE Path='src\OrderManager.Application\Features\Orders\Commands\CreateOrder')
    INSERT INTO Directory (Path) VALUES ('src\OrderManager.Application\Features\Orders\Commands\CreateOrder');
IF NOT EXISTS (SELECT 1 FROM Directory WHERE Path='src\OrderManager.Application\Features\Orders\DTOs')
    INSERT INTO Directory (Path) VALUES ('src\OrderManager.Application\Features\Orders\DTOs');
IF NOT EXISTS (SELECT 1 FROM Directory WHERE Path='src\OrderManager.Application\Features\Orders\Queries\GetAllOrders')
    INSERT INTO Directory (Path) VALUES ('src\OrderManager.Application\Features\Orders\Queries\GetAllOrders');
IF NOT EXISTS (SELECT 1 FROM Directory WHERE Path='src\OrderManager.Application\Features\Orders\Queries\GetOrderById')
    INSERT INTO Directory (Path) VALUES ('src\OrderManager.Application\Features\Orders\Queries\GetOrderById');
IF NOT EXISTS (SELECT 1 FROM Directory WHERE Path='src\OrderManager.Application\Features\PaymentMethods\Commands\CreatePaymentMethod')
    INSERT INTO Directory (Path) VALUES ('src\OrderManager.Application\Features\PaymentMethods\Commands\CreatePaymentMethod');
IF NOT EXISTS (SELECT 1 FROM Directory WHERE Path='src\OrderManager.Application\Features\PaymentMethods\Commands\DeletePaymentMethod')
    INSERT INTO Directory (Path) VALUES ('src\OrderManager.Application\Features\PaymentMethods\Commands\DeletePaymentMethod');
IF NOT EXISTS (SELECT 1 FROM Directory WHERE Path='src\OrderManager.Application\Features\PaymentMethods\Commands\UpdatePaymentMethod')
    INSERT INTO Directory (Path) VALUES ('src\OrderManager.Application\Features\PaymentMethods\Commands\UpdatePaymentMethod');
IF NOT EXISTS (SELECT 1 FROM Directory WHERE Path='src\OrderManager.Application\Features\PaymentMethods\DTOs')
    INSERT INTO Directory (Path) VALUES ('src\OrderManager.Application\Features\PaymentMethods\DTOs');
IF NOT EXISTS (SELECT 1 FROM Directory WHERE Path='src\OrderManager.Application\Features\PaymentMethods\Queries\GetAllPaymentMethods')
    INSERT INTO Directory (Path) VALUES ('src\OrderManager.Application\Features\PaymentMethods\Queries\GetAllPaymentMethods');
IF NOT EXISTS (SELECT 1 FROM Directory WHERE Path='src\OrderManager.Application\Features\PaymentMethods\Queries\GetPaymentMethodById')
    INSERT INTO Directory (Path) VALUES ('src\OrderManager.Application\Features\PaymentMethods\Queries\GetPaymentMethodById');
IF NOT EXISTS (SELECT 1 FROM Directory WHERE Path='src\OrderManager.Application\Features\ProductCategories\Commands\CreateProductCategory')
    INSERT INTO Directory (Path) VALUES ('src\OrderManager.Application\Features\ProductCategories\Commands\CreateProductCategory');
IF NOT EXISTS (SELECT 1 FROM Directory WHERE Path='src\OrderManager.Application\Features\ProductCategories\Commands\DeleteProductCategory')
    INSERT INTO Directory (Path) VALUES ('src\OrderManager.Application\Features\ProductCategories\Commands\DeleteProductCategory');
IF NOT EXISTS (SELECT 1 FROM Directory WHERE Path='src\OrderManager.Application\Features\ProductCategories\Commands\UpdateProductCategory')
    INSERT INTO Directory (Path) VALUES ('src\OrderManager.Application\Features\ProductCategories\Commands\UpdateProductCategory');
IF NOT EXISTS (SELECT 1 FROM Directory WHERE Path='src\OrderManager.Application\Features\ProductCategories\DTOs')
    INSERT INTO Directory (Path) VALUES ('src\OrderManager.Application\Features\ProductCategories\DTOs');
IF NOT EXISTS (SELECT 1 FROM Directory WHERE Path='src\OrderManager.Application\Features\ProductCategories\Queries\GetAllProductCategories')
    INSERT INTO Directory (Path) VALUES ('src\OrderManager.Application\Features\ProductCategories\Queries\GetAllProductCategories');
IF NOT EXISTS (SELECT 1 FROM Directory WHERE Path='src\OrderManager.Application\Features\ProductCategories\Queries\GetProductCategoryById')
    INSERT INTO Directory (Path) VALUES ('src\OrderManager.Application\Features\ProductCategories\Queries\GetProductCategoryById');
IF NOT EXISTS (SELECT 1 FROM Directory WHERE Path='src\OrderManager.Application\Features\Products\Commands\CreateProduct')
    INSERT INTO Directory (Path) VALUES ('src\OrderManager.Application\Features\Products\Commands\CreateProduct');
IF NOT EXISTS (SELECT 1 FROM Directory WHERE Path='src\OrderManager.Application\Features\Products\Commands\DeleteProduct')
    INSERT INTO Directory (Path) VALUES ('src\OrderManager.Application\Features\Products\Commands\DeleteProduct');
IF NOT EXISTS (SELECT 1 FROM Directory WHERE Path='src\OrderManager.Application\Features\Products\Commands\UpdateProduct')
    INSERT INTO Directory (Path) VALUES ('src\OrderManager.Application\Features\Products\Commands\UpdateProduct');
IF NOT EXISTS (SELECT 1 FROM Directory WHERE Path='src\OrderManager.Application\Features\Products\DTOs')
    INSERT INTO Directory (Path) VALUES ('src\OrderManager.Application\Features\Products\DTOs');
IF NOT EXISTS (SELECT 1 FROM Directory WHERE Path='src\OrderManager.Application\Features\Products\Queries\GetAllProducts')
    INSERT INTO Directory (Path) VALUES ('src\OrderManager.Application\Features\Products\Queries\GetAllProducts');
IF NOT EXISTS (SELECT 1 FROM Directory WHERE Path='src\OrderManager.Application\Features\Products\Queries\GetProductById')
    INSERT INTO Directory (Path) VALUES ('src\OrderManager.Application\Features\Products\Queries\GetProductById');
IF NOT EXISTS (SELECT 1 FROM Directory WHERE Path='src\OrderManager.Application\Features\Roles\Commands\CreateRole')
    INSERT INTO Directory (Path) VALUES ('src\OrderManager.Application\Features\Roles\Commands\CreateRole');
IF NOT EXISTS (SELECT 1 FROM Directory WHERE Path='src\OrderManager.Application\Features\Roles\Commands\DeleteRole')
    INSERT INTO Directory (Path) VALUES ('src\OrderManager.Application\Features\Roles\Commands\DeleteRole');
IF NOT EXISTS (SELECT 1 FROM Directory WHERE Path='src\OrderManager.Application\Features\Roles\Commands\UpdateRole')
    INSERT INTO Directory (Path) VALUES ('src\OrderManager.Application\Features\Roles\Commands\UpdateRole');
IF NOT EXISTS (SELECT 1 FROM Directory WHERE Path='src\OrderManager.Application\Features\Roles\DTOs')
    INSERT INTO Directory (Path) VALUES ('src\OrderManager.Application\Features\Roles\DTOs');
IF NOT EXISTS (SELECT 1 FROM Directory WHERE Path='src\OrderManager.Application\Features\Roles\Queries\GetAllRoles')
    INSERT INTO Directory (Path) VALUES ('src\OrderManager.Application\Features\Roles\Queries\GetAllRoles');
IF NOT EXISTS (SELECT 1 FROM Directory WHERE Path='src\OrderManager.Application\Features\Roles\Queries\GetRoleById')
    INSERT INTO Directory (Path) VALUES ('src\OrderManager.Application\Features\Roles\Queries\GetRoleById');
IF NOT EXISTS (SELECT 1 FROM Directory WHERE Path='src\OrderManager.Application\Features\StockMovements\Commands\CreateStockMovement')
    INSERT INTO Directory (Path) VALUES ('src\OrderManager.Application\Features\StockMovements\Commands\CreateStockMovement');
IF NOT EXISTS (SELECT 1 FROM Directory WHERE Path='src\OrderManager.Application\Features\StockMovements\DTOs')
    INSERT INTO Directory (Path) VALUES ('src\OrderManager.Application\Features\StockMovements\DTOs');
IF NOT EXISTS (SELECT 1 FROM Directory WHERE Path='src\OrderManager.Application\Features\StockMovements\Queries\GetStockMovementsByProduct')
    INSERT INTO Directory (Path) VALUES ('src\OrderManager.Application\Features\StockMovements\Queries\GetStockMovementsByProduct');
IF NOT EXISTS (SELECT 1 FROM Directory WHERE Path='src\OrderManager.Application\Features\TabCheckouts\Commands\CreateTabCheckout')
    INSERT INTO Directory (Path) VALUES ('src\OrderManager.Application\Features\TabCheckouts\Commands\CreateTabCheckout');
IF NOT EXISTS (SELECT 1 FROM Directory WHERE Path='src\OrderManager.Application\Features\TabCheckouts\DTOs')
    INSERT INTO Directory (Path) VALUES ('src\OrderManager.Application\Features\TabCheckouts\DTOs');
IF NOT EXISTS (SELECT 1 FROM Directory WHERE Path='src\OrderManager.Application\Features\TabCheckouts\Queries\GetTabCheckoutById')
    INSERT INTO Directory (Path) VALUES ('src\OrderManager.Application\Features\TabCheckouts\Queries\GetTabCheckoutById');
IF NOT EXISTS (SELECT 1 FROM Directory WHERE Path='src\OrderManager.Application\Features\TabPayments\Commands\CreateTabPayment')
    INSERT INTO Directory (Path) VALUES ('src\OrderManager.Application\Features\TabPayments\Commands\CreateTabPayment');
IF NOT EXISTS (SELECT 1 FROM Directory WHERE Path='src\OrderManager.Application\Features\TabPayments\DTOs')
    INSERT INTO Directory (Path) VALUES ('src\OrderManager.Application\Features\TabPayments\DTOs');
IF NOT EXISTS (SELECT 1 FROM Directory WHERE Path='src\OrderManager.Application\Features\TabPayments\Queries\GetTabPaymentsByCheckout')
    INSERT INTO Directory (Path) VALUES ('src\OrderManager.Application\Features\TabPayments\Queries\GetTabPaymentsByCheckout');
IF NOT EXISTS (SELECT 1 FROM Directory WHERE Path='src\OrderManager.Application\Features\Tabs\Commands\CancelTab')
    INSERT INTO Directory (Path) VALUES ('src\OrderManager.Application\Features\Tabs\Commands\CancelTab');
IF NOT EXISTS (SELECT 1 FROM Directory WHERE Path='src\OrderManager.Application\Features\Tabs\Commands\CloseTab')
    INSERT INTO Directory (Path) VALUES ('src\OrderManager.Application\Features\Tabs\Commands\CloseTab');
IF NOT EXISTS (SELECT 1 FROM Directory WHERE Path='src\OrderManager.Application\Features\Tabs\Commands\CreateTab')
    INSERT INTO Directory (Path) VALUES ('src\OrderManager.Application\Features\Tabs\Commands\CreateTab');
IF NOT EXISTS (SELECT 1 FROM Directory WHERE Path='src\OrderManager.Application\Features\Tabs\DTOs')
    INSERT INTO Directory (Path) VALUES ('src\OrderManager.Application\Features\Tabs\DTOs');
IF NOT EXISTS (SELECT 1 FROM Directory WHERE Path='src\OrderManager.Application\Features\Tabs\Queries\GetAllTabs')
    INSERT INTO Directory (Path) VALUES ('src\OrderManager.Application\Features\Tabs\Queries\GetAllTabs');
IF NOT EXISTS (SELECT 1 FROM Directory WHERE Path='src\OrderManager.Application\Features\Tabs\Queries\GetTabById')
    INSERT INTO Directory (Path) VALUES ('src\OrderManager.Application\Features\Tabs\Queries\GetTabById');
-- Domain dirs
IF NOT EXISTS (SELECT 1 FROM Directory WHERE Path='src\OrderManager.Domain\Common')
    INSERT INTO Directory (Path) VALUES ('src\OrderManager.Domain\Common');
IF NOT EXISTS (SELECT 1 FROM Directory WHERE Path='src\OrderManager.Domain\Entities')
    INSERT INTO Directory (Path) VALUES ('src\OrderManager.Domain\Entities');
IF NOT EXISTS (SELECT 1 FROM Directory WHERE Path='src\OrderManager.Domain\Enums')
    INSERT INTO Directory (Path) VALUES ('src\OrderManager.Domain\Enums');
IF NOT EXISTS (SELECT 1 FROM Directory WHERE Path='src\OrderManager.Domain\Events')
    INSERT INTO Directory (Path) VALUES ('src\OrderManager.Domain\Events');
IF NOT EXISTS (SELECT 1 FROM Directory WHERE Path='src\OrderManager.Domain\Interfaces')
    INSERT INTO Directory (Path) VALUES ('src\OrderManager.Domain\Interfaces');
IF NOT EXISTS (SELECT 1 FROM Directory WHERE Path='src\OrderManager.Domain\Interfaces\Repositories')
    INSERT INTO Directory (Path) VALUES ('src\OrderManager.Domain\Interfaces\Repositories');
-- Infrastructure dirs
IF NOT EXISTS (SELECT 1 FROM Directory WHERE Path='src\OrderManager.Infrastructure\Persistence')
    INSERT INTO Directory (Path) VALUES ('src\OrderManager.Infrastructure\Persistence');
IF NOT EXISTS (SELECT 1 FROM Directory WHERE Path='src\OrderManager.Infrastructure\Persistence\Configurations')
    INSERT INTO Directory (Path) VALUES ('src\OrderManager.Infrastructure\Persistence\Configurations');
IF NOT EXISTS (SELECT 1 FROM Directory WHERE Path='src\OrderManager.Infrastructure\Repositories')
    INSERT INTO Directory (Path) VALUES ('src\OrderManager.Infrastructure\Repositories');
-- Test dirs
IF NOT EXISTS (SELECT 1 FROM Directory WHERE Path='tests\OrderManager.UnitTests\Application\Features\Roles')
    INSERT INTO Directory (Path) VALUES ('tests\OrderManager.UnitTests\Application\Features\Roles');
IF NOT EXISTS (SELECT 1 FROM Directory WHERE Path='tests\OrderManager.UnitTests\Application\Features\Tabs')
    INSERT INTO Directory (Path) VALUES ('tests\OrderManager.UnitTests\Application\Features\Tabs');
IF NOT EXISTS (SELECT 1 FROM Directory WHERE Path='tests\OrderManager.UnitTests\Domain\Entities')
    INSERT INTO Directory (Path) VALUES ('tests\OrderManager.UnitTests\Domain\Entities');
IF NOT EXISTS (SELECT 1 FROM Directory WHERE Path='tests\OrderManager.BddTests\StepDefinitions')
    INSERT INTO Directory (Path) VALUES ('tests\OrderManager.BddTests\StepDefinitions');

-- ── 5. CODE ELEMENTS ─────────────────────────────────────
-- Macro helper: resolucao de FK por Name/FullName/Path
-- Formato: INSERT INTO CodeElement (Name, ElementType, IsAbstract, IsSealed, LayerId, ProjectId, NamespaceId, DirectoryId)

-- == API - Controllers ==
IF NOT EXISTS (SELECT 1 FROM CodeElement WHERE Name='CashRegisterController')
  INSERT INTO CodeElement (Name,ElementType,IsAbstract,IsSealed,LayerId,ProjectId,NamespaceId,DirectoryId)
  VALUES ('CashRegisterController','Class',0,1,
    (SELECT Id FROM Layer WHERE Name='Api'),
    (SELECT Id FROM Project WHERE Name='OrderManager.Api'),
    (SELECT Id FROM Namespace WHERE FullName='OrderManager.Api.Controllers'),
    (SELECT Id FROM Directory WHERE Path='src\OrderManager.Api\Controllers'));

IF NOT EXISTS (SELECT 1 FROM CodeElement WHERE Name='EmployeesController')
  INSERT INTO CodeElement (Name,ElementType,IsAbstract,IsSealed,LayerId,ProjectId,NamespaceId,DirectoryId)
  VALUES ('EmployeesController','Class',0,1,
    (SELECT Id FROM Layer WHERE Name='Api'),
    (SELECT Id FROM Project WHERE Name='OrderManager.Api'),
    (SELECT Id FROM Namespace WHERE FullName='OrderManager.Api.Controllers'),
    (SELECT Id FROM Directory WHERE Path='src\OrderManager.Api\Controllers'));

IF NOT EXISTS (SELECT 1 FROM CodeElement WHERE Name='OrderItemsController')
  INSERT INTO CodeElement (Name,ElementType,IsAbstract,IsSealed,LayerId,ProjectId,NamespaceId,DirectoryId)
  VALUES ('OrderItemsController','Class',0,1,
    (SELECT Id FROM Layer WHERE Name='Api'),
    (SELECT Id FROM Project WHERE Name='OrderManager.Api'),
    (SELECT Id FROM Namespace WHERE FullName='OrderManager.Api.Controllers'),
    (SELECT Id FROM Directory WHERE Path='src\OrderManager.Api\Controllers'));

IF NOT EXISTS (SELECT 1 FROM CodeElement WHERE Name='OrdersController')
  INSERT INTO CodeElement (Name,ElementType,IsAbstract,IsSealed,LayerId,ProjectId,NamespaceId,DirectoryId)
  VALUES ('OrdersController','Class',0,1,
    (SELECT Id FROM Layer WHERE Name='Api'),
    (SELECT Id FROM Project WHERE Name='OrderManager.Api'),
    (SELECT Id FROM Namespace WHERE FullName='OrderManager.Api.Controllers'),
    (SELECT Id FROM Directory WHERE Path='src\OrderManager.Api\Controllers'));

IF NOT EXISTS (SELECT 1 FROM CodeElement WHERE Name='PaymentMethodsController')
  INSERT INTO CodeElement (Name,ElementType,IsAbstract,IsSealed,LayerId,ProjectId,NamespaceId,DirectoryId)
  VALUES ('PaymentMethodsController','Class',0,1,
    (SELECT Id FROM Layer WHERE Name='Api'),
    (SELECT Id FROM Project WHERE Name='OrderManager.Api'),
    (SELECT Id FROM Namespace WHERE FullName='OrderManager.Api.Controllers'),
    (SELECT Id FROM Directory WHERE Path='src\OrderManager.Api\Controllers'));

IF NOT EXISTS (SELECT 1 FROM CodeElement WHERE Name='ProductCategoriesController')
  INSERT INTO CodeElement (Name,ElementType,IsAbstract,IsSealed,LayerId,ProjectId,NamespaceId,DirectoryId)
  VALUES ('ProductCategoriesController','Class',0,1,
    (SELECT Id FROM Layer WHERE Name='Api'),
    (SELECT Id FROM Project WHERE Name='OrderManager.Api'),
    (SELECT Id FROM Namespace WHERE FullName='OrderManager.Api.Controllers'),
    (SELECT Id FROM Directory WHERE Path='src\OrderManager.Api\Controllers'));

IF NOT EXISTS (SELECT 1 FROM CodeElement WHERE Name='ProductsController')
  INSERT INTO CodeElement (Name,ElementType,IsAbstract,IsSealed,LayerId,ProjectId,NamespaceId,DirectoryId)
  VALUES ('ProductsController','Class',0,1,
    (SELECT Id FROM Layer WHERE Name='Api'),
    (SELECT Id FROM Project WHERE Name='OrderManager.Api'),
    (SELECT Id FROM Namespace WHERE FullName='OrderManager.Api.Controllers'),
    (SELECT Id FROM Directory WHERE Path='src\OrderManager.Api\Controllers'));

IF NOT EXISTS (SELECT 1 FROM CodeElement WHERE Name='RolesController')
  INSERT INTO CodeElement (Name,ElementType,IsAbstract,IsSealed,LayerId,ProjectId,NamespaceId,DirectoryId)
  VALUES ('RolesController','Class',0,1,
    (SELECT Id FROM Layer WHERE Name='Api'),
    (SELECT Id FROM Project WHERE Name='OrderManager.Api'),
    (SELECT Id FROM Namespace WHERE FullName='OrderManager.Api.Controllers'),
    (SELECT Id FROM Directory WHERE Path='src\OrderManager.Api\Controllers'));

IF NOT EXISTS (SELECT 1 FROM CodeElement WHERE Name='StockMovementsController')
  INSERT INTO CodeElement (Name,ElementType,IsAbstract,IsSealed,LayerId,ProjectId,NamespaceId,DirectoryId)
  VALUES ('StockMovementsController','Class',0,1,
    (SELECT Id FROM Layer WHERE Name='Api'),
    (SELECT Id FROM Project WHERE Name='OrderManager.Api'),
    (SELECT Id FROM Namespace WHERE FullName='OrderManager.Api.Controllers'),
    (SELECT Id FROM Directory WHERE Path='src\OrderManager.Api\Controllers'));

IF NOT EXISTS (SELECT 1 FROM CodeElement WHERE Name='TabCheckoutsController')
  INSERT INTO CodeElement (Name,ElementType,IsAbstract,IsSealed,LayerId,ProjectId,NamespaceId,DirectoryId)
  VALUES ('TabCheckoutsController','Class',0,1,
    (SELECT Id FROM Layer WHERE Name='Api'),
    (SELECT Id FROM Project WHERE Name='OrderManager.Api'),
    (SELECT Id FROM Namespace WHERE FullName='OrderManager.Api.Controllers'),
    (SELECT Id FROM Directory WHERE Path='src\OrderManager.Api\Controllers'));

IF NOT EXISTS (SELECT 1 FROM CodeElement WHERE Name='TabPaymentsController')
  INSERT INTO CodeElement (Name,ElementType,IsAbstract,IsSealed,LayerId,ProjectId,NamespaceId,DirectoryId)
  VALUES ('TabPaymentsController','Class',0,1,
    (SELECT Id FROM Layer WHERE Name='Api'),
    (SELECT Id FROM Project WHERE Name='OrderManager.Api'),
    (SELECT Id FROM Namespace WHERE FullName='OrderManager.Api.Controllers'),
    (SELECT Id FROM Directory WHERE Path='src\OrderManager.Api\Controllers'));

IF NOT EXISTS (SELECT 1 FROM CodeElement WHERE Name='TabsController')
  INSERT INTO CodeElement (Name,ElementType,IsAbstract,IsSealed,LayerId,ProjectId,NamespaceId,DirectoryId)
  VALUES ('TabsController','Class',0,1,
    (SELECT Id FROM Layer WHERE Name='Api'),
    (SELECT Id FROM Project WHERE Name='OrderManager.Api'),
    (SELECT Id FROM Namespace WHERE FullName='OrderManager.Api.Controllers'),
    (SELECT Id FROM Directory WHERE Path='src\OrderManager.Api\Controllers'));

IF NOT EXISTS (SELECT 1 FROM CodeElement WHERE Name='ErrorHandlingMiddleware')
  INSERT INTO CodeElement (Name,ElementType,IsAbstract,IsSealed,LayerId,ProjectId,NamespaceId,DirectoryId)
  VALUES ('ErrorHandlingMiddleware','Class',0,0,
    (SELECT Id FROM Layer WHERE Name='Api'),
    (SELECT Id FROM Project WHERE Name='OrderManager.Api'),
    (SELECT Id FROM Namespace WHERE FullName='OrderManager.Api.Middleware'),
    (SELECT Id FROM Directory WHERE Path='src\OrderManager.Api\Middleware'));

-- == APPLICATION - Common ==
IF NOT EXISTS (SELECT 1 FROM CodeElement WHERE Name='LoggingBehavior')
  INSERT INTO CodeElement (Name,ElementType,IsAbstract,IsSealed,LayerId,ProjectId,NamespaceId,DirectoryId)
  VALUES ('LoggingBehavior','Class',0,1,
    (SELECT Id FROM Layer WHERE Name='Application'),
    (SELECT Id FROM Project WHERE Name='OrderManager.Application'),
    (SELECT Id FROM Namespace WHERE FullName='OrderManager.Application.Common.Behaviors'),
    (SELECT Id FROM Directory WHERE Path='src\OrderManager.Application\Common\Behaviors'));

IF NOT EXISTS (SELECT 1 FROM CodeElement WHERE Name='ValidationBehavior')
  INSERT INTO CodeElement (Name,ElementType,IsAbstract,IsSealed,LayerId,ProjectId,NamespaceId,DirectoryId)
  VALUES ('ValidationBehavior','Class',0,1,
    (SELECT Id FROM Layer WHERE Name='Application'),
    (SELECT Id FROM Project WHERE Name='OrderManager.Application'),
    (SELECT Id FROM Namespace WHERE FullName='OrderManager.Application.Common.Behaviors'),
    (SELECT Id FROM Directory WHERE Path='src\OrderManager.Application\Common\Behaviors'));

IF NOT EXISTS (SELECT 1 FROM CodeElement WHERE Name='NotFoundException')
  INSERT INTO CodeElement (Name,ElementType,IsAbstract,IsSealed,LayerId,ProjectId,NamespaceId,DirectoryId)
  VALUES ('NotFoundException','Class',0,0,
    (SELECT Id FROM Layer WHERE Name='Application'),
    (SELECT Id FROM Project WHERE Name='OrderManager.Application'),
    (SELECT Id FROM Namespace WHERE FullName='OrderManager.Application.Common.Exceptions'),
    (SELECT Id FROM Directory WHERE Path='src\OrderManager.Application\Common\Exceptions'));

IF NOT EXISTS (SELECT 1 FROM CodeElement WHERE Name='ValidationException')
  INSERT INTO CodeElement (Name,ElementType,IsAbstract,IsSealed,LayerId,ProjectId,NamespaceId,DirectoryId)
  VALUES ('ValidationException','Class',0,0,
    (SELECT Id FROM Layer WHERE Name='Application'),
    (SELECT Id FROM Project WHERE Name='OrderManager.Application'),
    (SELECT Id FROM Namespace WHERE FullName='OrderManager.Application.Common.Exceptions'),
    (SELECT Id FROM Directory WHERE Path='src\OrderManager.Application\Common\Exceptions'));

IF NOT EXISTS (SELECT 1 FROM CodeElement WHERE Name='PagedResult')
  INSERT INTO CodeElement (Name,ElementType,IsAbstract,IsSealed,LayerId,ProjectId,NamespaceId,DirectoryId)
  VALUES ('PagedResult','Class',0,0,
    (SELECT Id FROM Layer WHERE Name='Application'),
    (SELECT Id FROM Project WHERE Name='OrderManager.Application'),
    (SELECT Id FROM Namespace WHERE FullName='OrderManager.Application.Common.Models'),
    (SELECT Id FROM Directory WHERE Path='src\OrderManager.Application\Common\Models'));

IF NOT EXISTS (SELECT 1 FROM CodeElement WHERE Name='MappingProfile')
  INSERT INTO CodeElement (Name,ElementType,IsAbstract,IsSealed,LayerId,ProjectId,NamespaceId,DirectoryId)
  VALUES ('MappingProfile','Class',0,0,
    (SELECT Id FROM Layer WHERE Name='Application'),
    (SELECT Id FROM Project WHERE Name='OrderManager.Application'),
    (SELECT Id FROM Namespace WHERE FullName='OrderManager.Application.Mappings'),
    (SELECT Id FROM Directory WHERE Path='src\OrderManager.Application\Mappings'));

-- == APPLICATION - CashRegister Commands ==
IF NOT EXISTS (SELECT 1 FROM CodeElement WHERE Name='CloseCashRegisterCommand')
  INSERT INTO CodeElement (Name,ElementType,IsAbstract,IsSealed,LayerId,ProjectId,NamespaceId,DirectoryId)
  VALUES ('CloseCashRegisterCommand','Record',0,0,
    (SELECT Id FROM Layer WHERE Name='Application'),
    (SELECT Id FROM Project WHERE Name='OrderManager.Application'),
    (SELECT Id FROM Namespace WHERE FullName='OrderManager.Application.Features.CashRegister.Commands.CloseCashRegister'),
    (SELECT Id FROM Directory WHERE Path='src\OrderManager.Application\Features\CashRegister\Commands\CloseCashRegister'));

IF NOT EXISTS (SELECT 1 FROM CodeElement WHERE Name='CloseCashRegisterCommandHandler')
  INSERT INTO CodeElement (Name,ElementType,IsAbstract,IsSealed,LayerId,ProjectId,NamespaceId,DirectoryId)
  VALUES ('CloseCashRegisterCommandHandler','Class',0,1,
    (SELECT Id FROM Layer WHERE Name='Application'),
    (SELECT Id FROM Project WHERE Name='OrderManager.Application'),
    (SELECT Id FROM Namespace WHERE FullName='OrderManager.Application.Features.CashRegister.Commands.CloseCashRegister'),
    (SELECT Id FROM Directory WHERE Path='src\OrderManager.Application\Features\CashRegister\Commands\CloseCashRegister'));

IF NOT EXISTS (SELECT 1 FROM CodeElement WHERE Name='CloseCashRegisterCommandValidator')
  INSERT INTO CodeElement (Name,ElementType,IsAbstract,IsSealed,LayerId,ProjectId,NamespaceId,DirectoryId)
  VALUES ('CloseCashRegisterCommandValidator','Class',0,1,
    (SELECT Id FROM Layer WHERE Name='Application'),
    (SELECT Id FROM Project WHERE Name='OrderManager.Application'),
    (SELECT Id FROM Namespace WHERE FullName='OrderManager.Application.Features.CashRegister.Commands.CloseCashRegister'),
    (SELECT Id FROM Directory WHERE Path='src\OrderManager.Application\Features\CashRegister\Commands\CloseCashRegister'));

IF NOT EXISTS (SELECT 1 FROM CodeElement WHERE Name='OpenCashRegisterCommand')
  INSERT INTO CodeElement (Name,ElementType,IsAbstract,IsSealed,LayerId,ProjectId,NamespaceId,DirectoryId)
  VALUES ('OpenCashRegisterCommand','Record',0,0,
    (SELECT Id FROM Layer WHERE Name='Application'),
    (SELECT Id FROM Project WHERE Name='OrderManager.Application'),
    (SELECT Id FROM Namespace WHERE FullName='OrderManager.Application.Features.CashRegister.Commands.OpenCashRegister'),
    (SELECT Id FROM Directory WHERE Path='src\OrderManager.Application\Features\CashRegister\Commands\OpenCashRegister'));

IF NOT EXISTS (SELECT 1 FROM CodeElement WHERE Name='OpenCashRegisterCommandHandler')
  INSERT INTO CodeElement (Name,ElementType,IsAbstract,IsSealed,LayerId,ProjectId,NamespaceId,DirectoryId)
  VALUES ('OpenCashRegisterCommandHandler','Class',0,1,
    (SELECT Id FROM Layer WHERE Name='Application'),
    (SELECT Id FROM Project WHERE Name='OrderManager.Application'),
    (SELECT Id FROM Namespace WHERE FullName='OrderManager.Application.Features.CashRegister.Commands.OpenCashRegister'),
    (SELECT Id FROM Directory WHERE Path='src\OrderManager.Application\Features\CashRegister\Commands\OpenCashRegister'));

IF NOT EXISTS (SELECT 1 FROM CodeElement WHERE Name='OpenCashRegisterCommandValidator')
  INSERT INTO CodeElement (Name,ElementType,IsAbstract,IsSealed,LayerId,ProjectId,NamespaceId,DirectoryId)
  VALUES ('OpenCashRegisterCommandValidator','Class',0,1,
    (SELECT Id FROM Layer WHERE Name='Application'),
    (SELECT Id FROM Project WHERE Name='OrderManager.Application'),
    (SELECT Id FROM Namespace WHERE FullName='OrderManager.Application.Features.CashRegister.Commands.OpenCashRegister'),
    (SELECT Id FROM Directory WHERE Path='src\OrderManager.Application\Features\CashRegister\Commands\OpenCashRegister'));

-- CashRegister DTOs
IF NOT EXISTS (SELECT 1 FROM CodeElement WHERE Name='CashRegisterClosingDto')
  INSERT INTO CodeElement (Name,ElementType,IsAbstract,IsSealed,LayerId,ProjectId,NamespaceId,DirectoryId)
  VALUES ('CashRegisterClosingDto','Record',0,0,
    (SELECT Id FROM Layer WHERE Name='Application'),
    (SELECT Id FROM Project WHERE Name='OrderManager.Application'),
    (SELECT Id FROM Namespace WHERE FullName='OrderManager.Application.Features.CashRegister.DTOs'),
    (SELECT Id FROM Directory WHERE Path='src\OrderManager.Application\Features\CashRegister\DTOs'));

IF NOT EXISTS (SELECT 1 FROM CodeElement WHERE Name='CashRegisterOpeningDto')
  INSERT INTO CodeElement (Name,ElementType,IsAbstract,IsSealed,LayerId,ProjectId,NamespaceId,DirectoryId)
  VALUES ('CashRegisterOpeningDto','Record',0,0,
    (SELECT Id FROM Layer WHERE Name='Application'),
    (SELECT Id FROM Project WHERE Name='OrderManager.Application'),
    (SELECT Id FROM Namespace WHERE FullName='OrderManager.Application.Features.CashRegister.DTOs'),
    (SELECT Id FROM Directory WHERE Path='src\OrderManager.Application\Features\CashRegister\DTOs'));

-- CashRegister Queries
IF NOT EXISTS (SELECT 1 FROM CodeElement WHERE Name='GetActiveCashRegisterQuery')
  INSERT INTO CodeElement (Name,ElementType,IsAbstract,IsSealed,LayerId,ProjectId,NamespaceId,DirectoryId)
  VALUES ('GetActiveCashRegisterQuery','Record',0,0,
    (SELECT Id FROM Layer WHERE Name='Application'),
    (SELECT Id FROM Project WHERE Name='OrderManager.Application'),
    (SELECT Id FROM Namespace WHERE FullName='OrderManager.Application.Features.CashRegister.Queries.GetActiveCashRegister'),
    (SELECT Id FROM Directory WHERE Path='src\OrderManager.Application\Features\CashRegister\Queries\GetActiveCashRegister'));

IF NOT EXISTS (SELECT 1 FROM CodeElement WHERE Name='GetActiveCashRegisterQueryHandler')
  INSERT INTO CodeElement (Name,ElementType,IsAbstract,IsSealed,LayerId,ProjectId,NamespaceId,DirectoryId)
  VALUES ('GetActiveCashRegisterQueryHandler','Class',0,1,
    (SELECT Id FROM Layer WHERE Name='Application'),
    (SELECT Id FROM Project WHERE Name='OrderManager.Application'),
    (SELECT Id FROM Namespace WHERE FullName='OrderManager.Application.Features.CashRegister.Queries.GetActiveCashRegister'),
    (SELECT Id FROM Directory WHERE Path='src\OrderManager.Application\Features\CashRegister\Queries\GetActiveCashRegister'));

IF NOT EXISTS (SELECT 1 FROM CodeElement WHERE Name='GetCashRegisterClosingByIdQuery')
  INSERT INTO CodeElement (Name,ElementType,IsAbstract,IsSealed,LayerId,ProjectId,NamespaceId,DirectoryId)
  VALUES ('GetCashRegisterClosingByIdQuery','Record',0,0,
    (SELECT Id FROM Layer WHERE Name='Application'),
    (SELECT Id FROM Project WHERE Name='OrderManager.Application'),
    (SELECT Id FROM Namespace WHERE FullName='OrderManager.Application.Features.CashRegister.Queries.GetCashRegisterClosingById'),
    (SELECT Id FROM Directory WHERE Path='src\OrderManager.Application\Features\CashRegister\Queries\GetCashRegisterClosingById'));

IF NOT EXISTS (SELECT 1 FROM CodeElement WHERE Name='GetCashRegisterClosingByIdQueryHandler')
  INSERT INTO CodeElement (Name,ElementType,IsAbstract,IsSealed,LayerId,ProjectId,NamespaceId,DirectoryId)
  VALUES ('GetCashRegisterClosingByIdQueryHandler','Class',0,1,
    (SELECT Id FROM Layer WHERE Name='Application'),
    (SELECT Id FROM Project WHERE Name='OrderManager.Application'),
    (SELECT Id FROM Namespace WHERE FullName='OrderManager.Application.Features.CashRegister.Queries.GetCashRegisterClosingById'),
    (SELECT Id FROM Directory WHERE Path='src\OrderManager.Application\Features\CashRegister\Queries\GetCashRegisterClosingById'));

-- == APPLICATION - Employees ==
IF NOT EXISTS (SELECT 1 FROM CodeElement WHERE Name='CreateEmployeeCommand')
  INSERT INTO CodeElement (Name,ElementType,IsAbstract,IsSealed,LayerId,ProjectId,NamespaceId,DirectoryId)
  VALUES ('CreateEmployeeCommand','Record',0,0,(SELECT Id FROM Layer WHERE Name='Application'),(SELECT Id FROM Project WHERE Name='OrderManager.Application'),(SELECT Id FROM Namespace WHERE FullName='OrderManager.Application.Features.Employees.Commands.CreateEmployee'),(SELECT Id FROM Directory WHERE Path='src\OrderManager.Application\Features\Employees\Commands\CreateEmployee'));
IF NOT EXISTS (SELECT 1 FROM CodeElement WHERE Name='CreateEmployeeCommandHandler')
  INSERT INTO CodeElement (Name,ElementType,IsAbstract,IsSealed,LayerId,ProjectId,NamespaceId,DirectoryId)
  VALUES ('CreateEmployeeCommandHandler','Class',0,1,(SELECT Id FROM Layer WHERE Name='Application'),(SELECT Id FROM Project WHERE Name='OrderManager.Application'),(SELECT Id FROM Namespace WHERE FullName='OrderManager.Application.Features.Employees.Commands.CreateEmployee'),(SELECT Id FROM Directory WHERE Path='src\OrderManager.Application\Features\Employees\Commands\CreateEmployee'));
IF NOT EXISTS (SELECT 1 FROM CodeElement WHERE Name='CreateEmployeeCommandValidator')
  INSERT INTO CodeElement (Name,ElementType,IsAbstract,IsSealed,LayerId,ProjectId,NamespaceId,DirectoryId)
  VALUES ('CreateEmployeeCommandValidator','Class',0,1,(SELECT Id FROM Layer WHERE Name='Application'),(SELECT Id FROM Project WHERE Name='OrderManager.Application'),(SELECT Id FROM Namespace WHERE FullName='OrderManager.Application.Features.Employees.Commands.CreateEmployee'),(SELECT Id FROM Directory WHERE Path='src\OrderManager.Application\Features\Employees\Commands\CreateEmployee'));
IF NOT EXISTS (SELECT 1 FROM CodeElement WHERE Name='DeleteEmployeeCommand')
  INSERT INTO CodeElement (Name,ElementType,IsAbstract,IsSealed,LayerId,ProjectId,NamespaceId,DirectoryId)
  VALUES ('DeleteEmployeeCommand','Record',0,0,(SELECT Id FROM Layer WHERE Name='Application'),(SELECT Id FROM Project WHERE Name='OrderManager.Application'),(SELECT Id FROM Namespace WHERE FullName='OrderManager.Application.Features.Employees.Commands.DeleteEmployee'),(SELECT Id FROM Directory WHERE Path='src\OrderManager.Application\Features\Employees\Commands\DeleteEmployee'));
IF NOT EXISTS (SELECT 1 FROM CodeElement WHERE Name='DeleteEmployeeCommandHandler')
  INSERT INTO CodeElement (Name,ElementType,IsAbstract,IsSealed,LayerId,ProjectId,NamespaceId,DirectoryId)
  VALUES ('DeleteEmployeeCommandHandler','Class',0,1,(SELECT Id FROM Layer WHERE Name='Application'),(SELECT Id FROM Project WHERE Name='OrderManager.Application'),(SELECT Id FROM Namespace WHERE FullName='OrderManager.Application.Features.Employees.Commands.DeleteEmployee'),(SELECT Id FROM Directory WHERE Path='src\OrderManager.Application\Features\Employees\Commands\DeleteEmployee'));
IF NOT EXISTS (SELECT 1 FROM CodeElement WHERE Name='UpdateEmployeeCommand')
  INSERT INTO CodeElement (Name,ElementType,IsAbstract,IsSealed,LayerId,ProjectId,NamespaceId,DirectoryId)
  VALUES ('UpdateEmployeeCommand','Record',0,0,(SELECT Id FROM Layer WHERE Name='Application'),(SELECT Id FROM Project WHERE Name='OrderManager.Application'),(SELECT Id FROM Namespace WHERE FullName='OrderManager.Application.Features.Employees.Commands.UpdateEmployee'),(SELECT Id FROM Directory WHERE Path='src\OrderManager.Application\Features\Employees\Commands\UpdateEmployee'));
IF NOT EXISTS (SELECT 1 FROM CodeElement WHERE Name='UpdateEmployeeCommandHandler')
  INSERT INTO CodeElement (Name,ElementType,IsAbstract,IsSealed,LayerId,ProjectId,NamespaceId,DirectoryId)
  VALUES ('UpdateEmployeeCommandHandler','Class',0,1,(SELECT Id FROM Layer WHERE Name='Application'),(SELECT Id FROM Project WHERE Name='OrderManager.Application'),(SELECT Id FROM Namespace WHERE FullName='OrderManager.Application.Features.Employees.Commands.UpdateEmployee'),(SELECT Id FROM Directory WHERE Path='src\OrderManager.Application\Features\Employees\Commands\UpdateEmployee'));
IF NOT EXISTS (SELECT 1 FROM CodeElement WHERE Name='UpdateEmployeeCommandValidator')
  INSERT INTO CodeElement (Name,ElementType,IsAbstract,IsSealed,LayerId,ProjectId,NamespaceId,DirectoryId)
  VALUES ('UpdateEmployeeCommandValidator','Class',0,1,(SELECT Id FROM Layer WHERE Name='Application'),(SELECT Id FROM Project WHERE Name='OrderManager.Application'),(SELECT Id FROM Namespace WHERE FullName='OrderManager.Application.Features.Employees.Commands.UpdateEmployee'),(SELECT Id FROM Directory WHERE Path='src\OrderManager.Application\Features\Employees\Commands\UpdateEmployee'));
IF NOT EXISTS (SELECT 1 FROM CodeElement WHERE Name='EmployeeDto')
  INSERT INTO CodeElement (Name,ElementType,IsAbstract,IsSealed,LayerId,ProjectId,NamespaceId,DirectoryId)
  VALUES ('EmployeeDto','Record',0,0,(SELECT Id FROM Layer WHERE Name='Application'),(SELECT Id FROM Project WHERE Name='OrderManager.Application'),(SELECT Id FROM Namespace WHERE FullName='OrderManager.Application.Features.Employees.DTOs'),(SELECT Id FROM Directory WHERE Path='src\OrderManager.Application\Features\Employees\DTOs'));
IF NOT EXISTS (SELECT 1 FROM CodeElement WHERE Name='GetAllEmployeesQuery')
  INSERT INTO CodeElement (Name,ElementType,IsAbstract,IsSealed,LayerId,ProjectId,NamespaceId,DirectoryId)
  VALUES ('GetAllEmployeesQuery','Record',0,0,(SELECT Id FROM Layer WHERE Name='Application'),(SELECT Id FROM Project WHERE Name='OrderManager.Application'),(SELECT Id FROM Namespace WHERE FullName='OrderManager.Application.Features.Employees.Queries.GetAllEmployees'),(SELECT Id FROM Directory WHERE Path='src\OrderManager.Application\Features\Employees\Queries\GetAllEmployees'));
IF NOT EXISTS (SELECT 1 FROM CodeElement WHERE Name='GetAllEmployeesQueryHandler')
  INSERT INTO CodeElement (Name,ElementType,IsAbstract,IsSealed,LayerId,ProjectId,NamespaceId,DirectoryId)
  VALUES ('GetAllEmployeesQueryHandler','Class',0,1,(SELECT Id FROM Layer WHERE Name='Application'),(SELECT Id FROM Project WHERE Name='OrderManager.Application'),(SELECT Id FROM Namespace WHERE FullName='OrderManager.Application.Features.Employees.Queries.GetAllEmployees'),(SELECT Id FROM Directory WHERE Path='src\OrderManager.Application\Features\Employees\Queries\GetAllEmployees'));
IF NOT EXISTS (SELECT 1 FROM CodeElement WHERE Name='GetEmployeeByIdQuery')
  INSERT INTO CodeElement (Name,ElementType,IsAbstract,IsSealed,LayerId,ProjectId,NamespaceId,DirectoryId)
  VALUES ('GetEmployeeByIdQuery','Record',0,0,(SELECT Id FROM Layer WHERE Name='Application'),(SELECT Id FROM Project WHERE Name='OrderManager.Application'),(SELECT Id FROM Namespace WHERE FullName='OrderManager.Application.Features.Employees.Queries.GetEmployeeById'),(SELECT Id FROM Directory WHERE Path='src\OrderManager.Application\Features\Employees\Queries\GetEmployeeById'));
IF NOT EXISTS (SELECT 1 FROM CodeElement WHERE Name='GetEmployeeByIdQueryHandler')
  INSERT INTO CodeElement (Name,ElementType,IsAbstract,IsSealed,LayerId,ProjectId,NamespaceId,DirectoryId)
  VALUES ('GetEmployeeByIdQueryHandler','Class',0,1,(SELECT Id FROM Layer WHERE Name='Application'),(SELECT Id FROM Project WHERE Name='OrderManager.Application'),(SELECT Id FROM Namespace WHERE FullName='OrderManager.Application.Features.Employees.Queries.GetEmployeeById'),(SELECT Id FROM Directory WHERE Path='src\OrderManager.Application\Features\Employees\Queries\GetEmployeeById'));

-- == APPLICATION - Orders ==
IF NOT EXISTS (SELECT 1 FROM CodeElement WHERE Name='AdvanceOrderStatusCommand')
  INSERT INTO CodeElement (Name,ElementType,IsAbstract,IsSealed,LayerId,ProjectId,NamespaceId,DirectoryId)
  VALUES ('AdvanceOrderStatusCommand','Record',0,0,(SELECT Id FROM Layer WHERE Name='Application'),(SELECT Id FROM Project WHERE Name='OrderManager.Application'),(SELECT Id FROM Namespace WHERE FullName='OrderManager.Application.Features.Orders.Commands.AdvanceOrderStatus'),(SELECT Id FROM Directory WHERE Path='src\OrderManager.Application\Features\Orders\Commands\AdvanceOrderStatus'));
IF NOT EXISTS (SELECT 1 FROM CodeElement WHERE Name='AdvanceOrderStatusCommandHandler')
  INSERT INTO CodeElement (Name,ElementType,IsAbstract,IsSealed,LayerId,ProjectId,NamespaceId,DirectoryId)
  VALUES ('AdvanceOrderStatusCommandHandler','Class',0,1,(SELECT Id FROM Layer WHERE Name='Application'),(SELECT Id FROM Project WHERE Name='OrderManager.Application'),(SELECT Id FROM Namespace WHERE FullName='OrderManager.Application.Features.Orders.Commands.AdvanceOrderStatus'),(SELECT Id FROM Directory WHERE Path='src\OrderManager.Application\Features\Orders\Commands\AdvanceOrderStatus'));
IF NOT EXISTS (SELECT 1 FROM CodeElement WHERE Name='AdvanceOrderStatusCommandValidator')
  INSERT INTO CodeElement (Name,ElementType,IsAbstract,IsSealed,LayerId,ProjectId,NamespaceId,DirectoryId)
  VALUES ('AdvanceOrderStatusCommandValidator','Class',0,1,(SELECT Id FROM Layer WHERE Name='Application'),(SELECT Id FROM Project WHERE Name='OrderManager.Application'),(SELECT Id FROM Namespace WHERE FullName='OrderManager.Application.Features.Orders.Commands.AdvanceOrderStatus'),(SELECT Id FROM Directory WHERE Path='src\OrderManager.Application\Features\Orders\Commands\AdvanceOrderStatus'));
IF NOT EXISTS (SELECT 1 FROM CodeElement WHERE Name='CancelOrderCommand')
  INSERT INTO CodeElement (Name,ElementType,IsAbstract,IsSealed,LayerId,ProjectId,NamespaceId,DirectoryId)
  VALUES ('CancelOrderCommand','Record',0,0,(SELECT Id FROM Layer WHERE Name='Application'),(SELECT Id FROM Project WHERE Name='OrderManager.Application'),(SELECT Id FROM Namespace WHERE FullName='OrderManager.Application.Features.Orders.Commands.CancelOrder'),(SELECT Id FROM Directory WHERE Path='src\OrderManager.Application\Features\Orders\Commands\CancelOrder'));
IF NOT EXISTS (SELECT 1 FROM CodeElement WHERE Name='CancelOrderCommandHandler')
  INSERT INTO CodeElement (Name,ElementType,IsAbstract,IsSealed,LayerId,ProjectId,NamespaceId,DirectoryId)
  VALUES ('CancelOrderCommandHandler','Class',0,1,(SELECT Id FROM Layer WHERE Name='Application'),(SELECT Id FROM Project WHERE Name='OrderManager.Application'),(SELECT Id FROM Namespace WHERE FullName='OrderManager.Application.Features.Orders.Commands.CancelOrder'),(SELECT Id FROM Directory WHERE Path='src\OrderManager.Application\Features\Orders\Commands\CancelOrder'));
IF NOT EXISTS (SELECT 1 FROM CodeElement WHERE Name='CancelOrderCommandValidator')
  INSERT INTO CodeElement (Name,ElementType,IsAbstract,IsSealed,LayerId,ProjectId,NamespaceId,DirectoryId)
  VALUES ('CancelOrderCommandValidator','Class',0,1,(SELECT Id FROM Layer WHERE Name='Application'),(SELECT Id FROM Project WHERE Name='OrderManager.Application'),(SELECT Id FROM Namespace WHERE FullName='OrderManager.Application.Features.Orders.Commands.CancelOrder'),(SELECT Id FROM Directory WHERE Path='src\OrderManager.Application\Features\Orders\Commands\CancelOrder'));
IF NOT EXISTS (SELECT 1 FROM CodeElement WHERE Name='CreateOrderCommand')
  INSERT INTO CodeElement (Name,ElementType,IsAbstract,IsSealed,LayerId,ProjectId,NamespaceId,DirectoryId)
  VALUES ('CreateOrderCommand','Record',0,0,(SELECT Id FROM Layer WHERE Name='Application'),(SELECT Id FROM Project WHERE Name='OrderManager.Application'),(SELECT Id FROM Namespace WHERE FullName='OrderManager.Application.Features.Orders.Commands.CreateOrder'),(SELECT Id FROM Directory WHERE Path='src\OrderManager.Application\Features\Orders\Commands\CreateOrder'));
IF NOT EXISTS (SELECT 1 FROM CodeElement WHERE Name='CreateOrderCommandHandler')
  INSERT INTO CodeElement (Name,ElementType,IsAbstract,IsSealed,LayerId,ProjectId,NamespaceId,DirectoryId)
  VALUES ('CreateOrderCommandHandler','Class',0,1,(SELECT Id FROM Layer WHERE Name='Application'),(SELECT Id FROM Project WHERE Name='OrderManager.Application'),(SELECT Id FROM Namespace WHERE FullName='OrderManager.Application.Features.Orders.Commands.CreateOrder'),(SELECT Id FROM Directory WHERE Path='src\OrderManager.Application\Features\Orders\Commands\CreateOrder'));
IF NOT EXISTS (SELECT 1 FROM CodeElement WHERE Name='CreateOrderCommandValidator')
  INSERT INTO CodeElement (Name,ElementType,IsAbstract,IsSealed,LayerId,ProjectId,NamespaceId,DirectoryId)
  VALUES ('CreateOrderCommandValidator','Class',0,1,(SELECT Id FROM Layer WHERE Name='Application'),(SELECT Id FROM Project WHERE Name='OrderManager.Application'),(SELECT Id FROM Namespace WHERE FullName='OrderManager.Application.Features.Orders.Commands.CreateOrder'),(SELECT Id FROM Directory WHERE Path='src\OrderManager.Application\Features\Orders\Commands\CreateOrder'));
IF NOT EXISTS (SELECT 1 FROM CodeElement WHERE Name='OrderDto')
  INSERT INTO CodeElement (Name,ElementType,IsAbstract,IsSealed,LayerId,ProjectId,NamespaceId,DirectoryId)
  VALUES ('OrderDto','Record',0,0,(SELECT Id FROM Layer WHERE Name='Application'),(SELECT Id FROM Project WHERE Name='OrderManager.Application'),(SELECT Id FROM Namespace WHERE FullName='OrderManager.Application.Features.Orders.DTOs'),(SELECT Id FROM Directory WHERE Path='src\OrderManager.Application\Features\Orders\DTOs'));
IF NOT EXISTS (SELECT 1 FROM CodeElement WHERE Name='GetAllOrdersQuery')
  INSERT INTO CodeElement (Name,ElementType,IsAbstract,IsSealed,LayerId,ProjectId,NamespaceId,DirectoryId)
  VALUES ('GetAllOrdersQuery','Record',0,0,(SELECT Id FROM Layer WHERE Name='Application'),(SELECT Id FROM Project WHERE Name='OrderManager.Application'),(SELECT Id FROM Namespace WHERE FullName='OrderManager.Application.Features.Orders.Queries.GetAllOrders'),(SELECT Id FROM Directory WHERE Path='src\OrderManager.Application\Features\Orders\Queries\GetAllOrders'));
IF NOT EXISTS (SELECT 1 FROM CodeElement WHERE Name='GetAllOrdersQueryHandler')
  INSERT INTO CodeElement (Name,ElementType,IsAbstract,IsSealed,LayerId,ProjectId,NamespaceId,DirectoryId)
  VALUES ('GetAllOrdersQueryHandler','Class',0,1,(SELECT Id FROM Layer WHERE Name='Application'),(SELECT Id FROM Project WHERE Name='OrderManager.Application'),(SELECT Id FROM Namespace WHERE FullName='OrderManager.Application.Features.Orders.Queries.GetAllOrders'),(SELECT Id FROM Directory WHERE Path='src\OrderManager.Application\Features\Orders\Queries\GetAllOrders'));
IF NOT EXISTS (SELECT 1 FROM CodeElement WHERE Name='GetOrderByIdQuery')
  INSERT INTO CodeElement (Name,ElementType,IsAbstract,IsSealed,LayerId,ProjectId,NamespaceId,DirectoryId)
  VALUES ('GetOrderByIdQuery','Record',0,0,(SELECT Id FROM Layer WHERE Name='Application'),(SELECT Id FROM Project WHERE Name='OrderManager.Application'),(SELECT Id FROM Namespace WHERE FullName='OrderManager.Application.Features.Orders.Queries.GetOrderById'),(SELECT Id FROM Directory WHERE Path='src\OrderManager.Application\Features\Orders\Queries\GetOrderById'));
IF NOT EXISTS (SELECT 1 FROM CodeElement WHERE Name='GetOrderByIdQueryHandler')
  INSERT INTO CodeElement (Name,ElementType,IsAbstract,IsSealed,LayerId,ProjectId,NamespaceId,DirectoryId)
  VALUES ('GetOrderByIdQueryHandler','Class',0,1,(SELECT Id FROM Layer WHERE Name='Application'),(SELECT Id FROM Project WHERE Name='OrderManager.Application'),(SELECT Id FROM Namespace WHERE FullName='OrderManager.Application.Features.Orders.Queries.GetOrderById'),(SELECT Id FROM Directory WHERE Path='src\OrderManager.Application\Features\Orders\Queries\GetOrderById'));

-- == APPLICATION - OrderItems ==
IF NOT EXISTS (SELECT 1 FROM CodeElement WHERE Name='CancelOrderItemCommand')
  INSERT INTO CodeElement (Name,ElementType,IsAbstract,IsSealed,LayerId,ProjectId,NamespaceId,DirectoryId)
  VALUES ('CancelOrderItemCommand','Record',0,0,(SELECT Id FROM Layer WHERE Name='Application'),(SELECT Id FROM Project WHERE Name='OrderManager.Application'),(SELECT Id FROM Namespace WHERE FullName='OrderManager.Application.Features.OrderItems.Commands.CancelOrderItem'),(SELECT Id FROM Directory WHERE Path='src\OrderManager.Application\Features\OrderItems\Commands\CancelOrderItem'));
IF NOT EXISTS (SELECT 1 FROM CodeElement WHERE Name='CancelOrderItemCommandHandler')
  INSERT INTO CodeElement (Name,ElementType,IsAbstract,IsSealed,LayerId,ProjectId,NamespaceId,DirectoryId)
  VALUES ('CancelOrderItemCommandHandler','Class',0,1,(SELECT Id FROM Layer WHERE Name='Application'),(SELECT Id FROM Project WHERE Name='OrderManager.Application'),(SELECT Id FROM Namespace WHERE FullName='OrderManager.Application.Features.OrderItems.Commands.CancelOrderItem'),(SELECT Id FROM Directory WHERE Path='src\OrderManager.Application\Features\OrderItems\Commands\CancelOrderItem'));
IF NOT EXISTS (SELECT 1 FROM CodeElement WHERE Name='CancelOrderItemCommandValidator')
  INSERT INTO CodeElement (Name,ElementType,IsAbstract,IsSealed,LayerId,ProjectId,NamespaceId,DirectoryId)
  VALUES ('CancelOrderItemCommandValidator','Class',0,1,(SELECT Id FROM Layer WHERE Name='Application'),(SELECT Id FROM Project WHERE Name='OrderManager.Application'),(SELECT Id FROM Namespace WHERE FullName='OrderManager.Application.Features.OrderItems.Commands.CancelOrderItem'),(SELECT Id FROM Directory WHERE Path='src\OrderManager.Application\Features\OrderItems\Commands\CancelOrderItem'));
IF NOT EXISTS (SELECT 1 FROM CodeElement WHERE Name='CreateOrderItemCommand')
  INSERT INTO CodeElement (Name,ElementType,IsAbstract,IsSealed,LayerId,ProjectId,NamespaceId,DirectoryId)
  VALUES ('CreateOrderItemCommand','Record',0,0,(SELECT Id FROM Layer WHERE Name='Application'),(SELECT Id FROM Project WHERE Name='OrderManager.Application'),(SELECT Id FROM Namespace WHERE FullName='OrderManager.Application.Features.OrderItems.Commands.CreateOrderItem'),(SELECT Id FROM Directory WHERE Path='src\OrderManager.Application\Features\OrderItems\Commands\CreateOrderItem'));
IF NOT EXISTS (SELECT 1 FROM CodeElement WHERE Name='CreateOrderItemCommandHandler')
  INSERT INTO CodeElement (Name,ElementType,IsAbstract,IsSealed,LayerId,ProjectId,NamespaceId,DirectoryId)
  VALUES ('CreateOrderItemCommandHandler','Class',0,1,(SELECT Id FROM Layer WHERE Name='Application'),(SELECT Id FROM Project WHERE Name='OrderManager.Application'),(SELECT Id FROM Namespace WHERE FullName='OrderManager.Application.Features.OrderItems.Commands.CreateOrderItem'),(SELECT Id FROM Directory WHERE Path='src\OrderManager.Application\Features\OrderItems\Commands\CreateOrderItem'));
IF NOT EXISTS (SELECT 1 FROM CodeElement WHERE Name='CreateOrderItemCommandValidator')
  INSERT INTO CodeElement (Name,ElementType,IsAbstract,IsSealed,LayerId,ProjectId,NamespaceId,DirectoryId)
  VALUES ('CreateOrderItemCommandValidator','Class',0,1,(SELECT Id FROM Layer WHERE Name='Application'),(SELECT Id FROM Project WHERE Name='OrderManager.Application'),(SELECT Id FROM Namespace WHERE FullName='OrderManager.Application.Features.OrderItems.Commands.CreateOrderItem'),(SELECT Id FROM Directory WHERE Path='src\OrderManager.Application\Features\OrderItems\Commands\CreateOrderItem'));
IF NOT EXISTS (SELECT 1 FROM CodeElement WHERE Name='GetOrderItemByIdQuery')
  INSERT INTO CodeElement (Name,ElementType,IsAbstract,IsSealed,LayerId,ProjectId,NamespaceId,DirectoryId)
  VALUES ('GetOrderItemByIdQuery','Record',0,0,(SELECT Id FROM Layer WHERE Name='Application'),(SELECT Id FROM Project WHERE Name='OrderManager.Application'),(SELECT Id FROM Namespace WHERE FullName='OrderManager.Application.Features.OrderItems.Queries.GetOrderItemById'),(SELECT Id FROM Directory WHERE Path='src\OrderManager.Application\Features\OrderItems\Queries\GetOrderItemById'));
IF NOT EXISTS (SELECT 1 FROM CodeElement WHERE Name='GetOrderItemByIdQueryHandler')
  INSERT INTO CodeElement (Name,ElementType,IsAbstract,IsSealed,LayerId,ProjectId,NamespaceId,DirectoryId)
  VALUES ('GetOrderItemByIdQueryHandler','Class',0,1,(SELECT Id FROM Layer WHERE Name='Application'),(SELECT Id FROM Project WHERE Name='OrderManager.Application'),(SELECT Id FROM Namespace WHERE FullName='OrderManager.Application.Features.OrderItems.Queries.GetOrderItemById'),(SELECT Id FROM Directory WHERE Path='src\OrderManager.Application\Features\OrderItems\Queries\GetOrderItemById'));
IF NOT EXISTS (SELECT 1 FROM CodeElement WHERE Name='GetOrderItemsByOrderQuery')
  INSERT INTO CodeElement (Name,ElementType,IsAbstract,IsSealed,LayerId,ProjectId,NamespaceId,DirectoryId)
  VALUES ('GetOrderItemsByOrderQuery','Record',0,0,(SELECT Id FROM Layer WHERE Name='Application'),(SELECT Id FROM Project WHERE Name='OrderManager.Application'),(SELECT Id FROM Namespace WHERE FullName='OrderManager.Application.Features.OrderItems.Queries.GetOrderItemsByOrder'),(SELECT Id FROM Directory WHERE Path='src\OrderManager.Application\Features\OrderItems\Queries\GetOrderItemsByOrder'));
IF NOT EXISTS (SELECT 1 FROM CodeElement WHERE Name='GetOrderItemsByOrderQueryHandler')
  INSERT INTO CodeElement (Name,ElementType,IsAbstract,IsSealed,LayerId,ProjectId,NamespaceId,DirectoryId)
  VALUES ('GetOrderItemsByOrderQueryHandler','Class',0,1,(SELECT Id FROM Layer WHERE Name='Application'),(SELECT Id FROM Project WHERE Name='OrderManager.Application'),(SELECT Id FROM Namespace WHERE FullName='OrderManager.Application.Features.OrderItems.Queries.GetOrderItemsByOrder'),(SELECT Id FROM Directory WHERE Path='src\OrderManager.Application\Features\OrderItems\Queries\GetOrderItemsByOrder'));

-- == APPLICATION - Tabs ==
IF NOT EXISTS (SELECT 1 FROM CodeElement WHERE Name='CancelTabCommand')
  INSERT INTO CodeElement (Name,ElementType,IsAbstract,IsSealed,LayerId,ProjectId,NamespaceId,DirectoryId)
  VALUES ('CancelTabCommand','Record',0,0,(SELECT Id FROM Layer WHERE Name='Application'),(SELECT Id FROM Project WHERE Name='OrderManager.Application'),(SELECT Id FROM Namespace WHERE FullName='OrderManager.Application.Features.Tabs.Commands.CancelTab'),(SELECT Id FROM Directory WHERE Path='src\OrderManager.Application\Features\Tabs\Commands\CancelTab'));
IF NOT EXISTS (SELECT 1 FROM CodeElement WHERE Name='CancelTabCommandHandler')
  INSERT INTO CodeElement (Name,ElementType,IsAbstract,IsSealed,LayerId,ProjectId,NamespaceId,DirectoryId)
  VALUES ('CancelTabCommandHandler','Class',0,1,(SELECT Id FROM Layer WHERE Name='Application'),(SELECT Id FROM Project WHERE Name='OrderManager.Application'),(SELECT Id FROM Namespace WHERE FullName='OrderManager.Application.Features.Tabs.Commands.CancelTab'),(SELECT Id FROM Directory WHERE Path='src\OrderManager.Application\Features\Tabs\Commands\CancelTab'));
IF NOT EXISTS (SELECT 1 FROM CodeElement WHERE Name='CancelTabCommandValidator')
  INSERT INTO CodeElement (Name,ElementType,IsAbstract,IsSealed,LayerId,ProjectId,NamespaceId,DirectoryId)
  VALUES ('CancelTabCommandValidator','Class',0,1,(SELECT Id FROM Layer WHERE Name='Application'),(SELECT Id FROM Project WHERE Name='OrderManager.Application'),(SELECT Id FROM Namespace WHERE FullName='OrderManager.Application.Features.Tabs.Commands.CancelTab'),(SELECT Id FROM Directory WHERE Path='src\OrderManager.Application\Features\Tabs\Commands\CancelTab'));
IF NOT EXISTS (SELECT 1 FROM CodeElement WHERE Name='CloseTabCommand')
  INSERT INTO CodeElement (Name,ElementType,IsAbstract,IsSealed,LayerId,ProjectId,NamespaceId,DirectoryId)
  VALUES ('CloseTabCommand','Record',0,0,(SELECT Id FROM Layer WHERE Name='Application'),(SELECT Id FROM Project WHERE Name='OrderManager.Application'),(SELECT Id FROM Namespace WHERE FullName='OrderManager.Application.Features.Tabs.Commands.CloseTab'),(SELECT Id FROM Directory WHERE Path='src\OrderManager.Application\Features\Tabs\Commands\CloseTab'));
IF NOT EXISTS (SELECT 1 FROM CodeElement WHERE Name='CloseTabCommandHandler')
  INSERT INTO CodeElement (Name,ElementType,IsAbstract,IsSealed,LayerId,ProjectId,NamespaceId,DirectoryId)
  VALUES ('CloseTabCommandHandler','Class',0,1,(SELECT Id FROM Layer WHERE Name='Application'),(SELECT Id FROM Project WHERE Name='OrderManager.Application'),(SELECT Id FROM Namespace WHERE FullName='OrderManager.Application.Features.Tabs.Commands.CloseTab'),(SELECT Id FROM Directory WHERE Path='src\OrderManager.Application\Features\Tabs\Commands\CloseTab'));
IF NOT EXISTS (SELECT 1 FROM CodeElement WHERE Name='CloseTabCommandValidator')
  INSERT INTO CodeElement (Name,ElementType,IsAbstract,IsSealed,LayerId,ProjectId,NamespaceId,DirectoryId)
  VALUES ('CloseTabCommandValidator','Class',0,1,(SELECT Id FROM Layer WHERE Name='Application'),(SELECT Id FROM Project WHERE Name='OrderManager.Application'),(SELECT Id FROM Namespace WHERE FullName='OrderManager.Application.Features.Tabs.Commands.CloseTab'),(SELECT Id FROM Directory WHERE Path='src\OrderManager.Application\Features\Tabs\Commands\CloseTab'));
IF NOT EXISTS (SELECT 1 FROM CodeElement WHERE Name='CreateTabCommand')
  INSERT INTO CodeElement (Name,ElementType,IsAbstract,IsSealed,LayerId,ProjectId,NamespaceId,DirectoryId)
  VALUES ('CreateTabCommand','Record',0,0,(SELECT Id FROM Layer WHERE Name='Application'),(SELECT Id FROM Project WHERE Name='OrderManager.Application'),(SELECT Id FROM Namespace WHERE FullName='OrderManager.Application.Features.Tabs.Commands.CreateTab'),(SELECT Id FROM Directory WHERE Path='src\OrderManager.Application\Features\Tabs\Commands\CreateTab'));
IF NOT EXISTS (SELECT 1 FROM CodeElement WHERE Name='CreateTabCommandHandler')
  INSERT INTO CodeElement (Name,ElementType,IsAbstract,IsSealed,LayerId,ProjectId,NamespaceId,DirectoryId)
  VALUES ('CreateTabCommandHandler','Class',0,1,(SELECT Id FROM Layer WHERE Name='Application'),(SELECT Id FROM Project WHERE Name='OrderManager.Application'),(SELECT Id FROM Namespace WHERE FullName='OrderManager.Application.Features.Tabs.Commands.CreateTab'),(SELECT Id FROM Directory WHERE Path='src\OrderManager.Application\Features\Tabs\Commands\CreateTab'));
IF NOT EXISTS (SELECT 1 FROM CodeElement WHERE Name='CreateTabCommandValidator')
  INSERT INTO CodeElement (Name,ElementType,IsAbstract,IsSealed,LayerId,ProjectId,NamespaceId,DirectoryId)
  VALUES ('CreateTabCommandValidator','Class',0,1,(SELECT Id FROM Layer WHERE Name='Application'),(SELECT Id FROM Project WHERE Name='OrderManager.Application'),(SELECT Id FROM Namespace WHERE FullName='OrderManager.Application.Features.Tabs.Commands.CreateTab'),(SELECT Id FROM Directory WHERE Path='src\OrderManager.Application\Features\Tabs\Commands\CreateTab'));
IF NOT EXISTS (SELECT 1 FROM CodeElement WHERE Name='TabDto')
  INSERT INTO CodeElement (Name,ElementType,IsAbstract,IsSealed,LayerId,ProjectId,NamespaceId,DirectoryId)
  VALUES ('TabDto','Record',0,0,(SELECT Id FROM Layer WHERE Name='Application'),(SELECT Id FROM Project WHERE Name='OrderManager.Application'),(SELECT Id FROM Namespace WHERE FullName='OrderManager.Application.Features.Tabs.DTOs'),(SELECT Id FROM Directory WHERE Path='src\OrderManager.Application\Features\Tabs\DTOs'));
IF NOT EXISTS (SELECT 1 FROM CodeElement WHERE Name='GetAllTabsQuery')
  INSERT INTO CodeElement (Name,ElementType,IsAbstract,IsSealed,LayerId,ProjectId,NamespaceId,DirectoryId)
  VALUES ('GetAllTabsQuery','Record',0,0,(SELECT Id FROM Layer WHERE Name='Application'),(SELECT Id FROM Project WHERE Name='OrderManager.Application'),(SELECT Id FROM Namespace WHERE FullName='OrderManager.Application.Features.Tabs.Queries.GetAllTabs'),(SELECT Id FROM Directory WHERE Path='src\OrderManager.Application\Features\Tabs\Queries\GetAllTabs'));
IF NOT EXISTS (SELECT 1 FROM CodeElement WHERE Name='GetAllTabsQueryHandler')
  INSERT INTO CodeElement (Name,ElementType,IsAbstract,IsSealed,LayerId,ProjectId,NamespaceId,DirectoryId)
  VALUES ('GetAllTabsQueryHandler','Class',0,1,(SELECT Id FROM Layer WHERE Name='Application'),(SELECT Id FROM Project WHERE Name='OrderManager.Application'),(SELECT Id FROM Namespace WHERE FullName='OrderManager.Application.Features.Tabs.Queries.GetAllTabs'),(SELECT Id FROM Directory WHERE Path='src\OrderManager.Application\Features\Tabs\Queries\GetAllTabs'));
IF NOT EXISTS (SELECT 1 FROM CodeElement WHERE Name='GetTabByIdQuery')
  INSERT INTO CodeElement (Name,ElementType,IsAbstract,IsSealed,LayerId,ProjectId,NamespaceId,DirectoryId)
  VALUES ('GetTabByIdQuery','Record',0,0,(SELECT Id FROM Layer WHERE Name='Application'),(SELECT Id FROM Project WHERE Name='OrderManager.Application'),(SELECT Id FROM Namespace WHERE FullName='OrderManager.Application.Features.Tabs.Queries.GetTabById'),(SELECT Id FROM Directory WHERE Path='src\OrderManager.Application\Features\Tabs\Queries\GetTabById'));
IF NOT EXISTS (SELECT 1 FROM CodeElement WHERE Name='GetTabByIdQueryHandler')
  INSERT INTO CodeElement (Name,ElementType,IsAbstract,IsSealed,LayerId,ProjectId,NamespaceId,DirectoryId)
  VALUES ('GetTabByIdQueryHandler','Class',0,1,(SELECT Id FROM Layer WHERE Name='Application'),(SELECT Id FROM Project WHERE Name='OrderManager.Application'),(SELECT Id FROM Namespace WHERE FullName='OrderManager.Application.Features.Tabs.Queries.GetTabById'),(SELECT Id FROM Directory WHERE Path='src\OrderManager.Application\Features\Tabs\Queries\GetTabById'));

-- == APPLICATION - Roles ==
IF NOT EXISTS (SELECT 1 FROM CodeElement WHERE Name='CreateRoleCommand')
  INSERT INTO CodeElement (Name,ElementType,IsAbstract,IsSealed,LayerId,ProjectId,NamespaceId,DirectoryId)
  VALUES ('CreateRoleCommand','Record',0,0,(SELECT Id FROM Layer WHERE Name='Application'),(SELECT Id FROM Project WHERE Name='OrderManager.Application'),(SELECT Id FROM Namespace WHERE FullName='OrderManager.Application.Features.Roles.Commands.CreateRole'),(SELECT Id FROM Directory WHERE Path='src\OrderManager.Application\Features\Roles\Commands\CreateRole'));
IF NOT EXISTS (SELECT 1 FROM CodeElement WHERE Name='CreateRoleCommandHandler')
  INSERT INTO CodeElement (Name,ElementType,IsAbstract,IsSealed,LayerId,ProjectId,NamespaceId,DirectoryId)
  VALUES ('CreateRoleCommandHandler','Class',0,1,(SELECT Id FROM Layer WHERE Name='Application'),(SELECT Id FROM Project WHERE Name='OrderManager.Application'),(SELECT Id FROM Namespace WHERE FullName='OrderManager.Application.Features.Roles.Commands.CreateRole'),(SELECT Id FROM Directory WHERE Path='src\OrderManager.Application\Features\Roles\Commands\CreateRole'));
IF NOT EXISTS (SELECT 1 FROM CodeElement WHERE Name='CreateRoleCommandValidator')
  INSERT INTO CodeElement (Name,ElementType,IsAbstract,IsSealed,LayerId,ProjectId,NamespaceId,DirectoryId)
  VALUES ('CreateRoleCommandValidator','Class',0,1,(SELECT Id FROM Layer WHERE Name='Application'),(SELECT Id FROM Project WHERE Name='OrderManager.Application'),(SELECT Id FROM Namespace WHERE FullName='OrderManager.Application.Features.Roles.Commands.CreateRole'),(SELECT Id FROM Directory WHERE Path='src\OrderManager.Application\Features\Roles\Commands\CreateRole'));
IF NOT EXISTS (SELECT 1 FROM CodeElement WHERE Name='DeleteRoleCommand')
  INSERT INTO CodeElement (Name,ElementType,IsAbstract,IsSealed,LayerId,ProjectId,NamespaceId,DirectoryId)
  VALUES ('DeleteRoleCommand','Record',0,0,(SELECT Id FROM Layer WHERE Name='Application'),(SELECT Id FROM Project WHERE Name='OrderManager.Application'),(SELECT Id FROM Namespace WHERE FullName='OrderManager.Application.Features.Roles.Commands.DeleteRole'),(SELECT Id FROM Directory WHERE Path='src\OrderManager.Application\Features\Roles\Commands\DeleteRole'));
IF NOT EXISTS (SELECT 1 FROM CodeElement WHERE Name='DeleteRoleCommandHandler')
  INSERT INTO CodeElement (Name,ElementType,IsAbstract,IsSealed,LayerId,ProjectId,NamespaceId,DirectoryId)
  VALUES ('DeleteRoleCommandHandler','Class',0,1,(SELECT Id FROM Layer WHERE Name='Application'),(SELECT Id FROM Project WHERE Name='OrderManager.Application'),(SELECT Id FROM Namespace WHERE FullName='OrderManager.Application.Features.Roles.Commands.DeleteRole'),(SELECT Id FROM Directory WHERE Path='src\OrderManager.Application\Features\Roles\Commands\DeleteRole'));
IF NOT EXISTS (SELECT 1 FROM CodeElement WHERE Name='UpdateRoleCommand')
  INSERT INTO CodeElement (Name,ElementType,IsAbstract,IsSealed,LayerId,ProjectId,NamespaceId,DirectoryId)
  VALUES ('UpdateRoleCommand','Record',0,0,(SELECT Id FROM Layer WHERE Name='Application'),(SELECT Id FROM Project WHERE Name='OrderManager.Application'),(SELECT Id FROM Namespace WHERE FullName='OrderManager.Application.Features.Roles.Commands.UpdateRole'),(SELECT Id FROM Directory WHERE Path='src\OrderManager.Application\Features\Roles\Commands\UpdateRole'));
IF NOT EXISTS (SELECT 1 FROM CodeElement WHERE Name='UpdateRoleCommandHandler')
  INSERT INTO CodeElement (Name,ElementType,IsAbstract,IsSealed,LayerId,ProjectId,NamespaceId,DirectoryId)
  VALUES ('UpdateRoleCommandHandler','Class',0,1,(SELECT Id FROM Layer WHERE Name='Application'),(SELECT Id FROM Project WHERE Name='OrderManager.Application'),(SELECT Id FROM Namespace WHERE FullName='OrderManager.Application.Features.Roles.Commands.UpdateRole'),(SELECT Id FROM Directory WHERE Path='src\OrderManager.Application\Features\Roles\Commands\UpdateRole'));
IF NOT EXISTS (SELECT 1 FROM CodeElement WHERE Name='UpdateRoleCommandValidator')
  INSERT INTO CodeElement (Name,ElementType,IsAbstract,IsSealed,LayerId,ProjectId,NamespaceId,DirectoryId)
  VALUES ('UpdateRoleCommandValidator','Class',0,1,(SELECT Id FROM Layer WHERE Name='Application'),(SELECT Id FROM Project WHERE Name='OrderManager.Application'),(SELECT Id FROM Namespace WHERE FullName='OrderManager.Application.Features.Roles.Commands.UpdateRole'),(SELECT Id FROM Directory WHERE Path='src\OrderManager.Application\Features\Roles\Commands\UpdateRole'));
IF NOT EXISTS (SELECT 1 FROM CodeElement WHERE Name='RoleDto')
  INSERT INTO CodeElement (Name,ElementType,IsAbstract,IsSealed,LayerId,ProjectId,NamespaceId,DirectoryId)
  VALUES ('RoleDto','Record',0,0,(SELECT Id FROM Layer WHERE Name='Application'),(SELECT Id FROM Project WHERE Name='OrderManager.Application'),(SELECT Id FROM Namespace WHERE FullName='OrderManager.Application.Features.Roles.DTOs'),(SELECT Id FROM Directory WHERE Path='src\OrderManager.Application\Features\Roles\DTOs'));
IF NOT EXISTS (SELECT 1 FROM CodeElement WHERE Name='GetAllRolesQuery')
  INSERT INTO CodeElement (Name,ElementType,IsAbstract,IsSealed,LayerId,ProjectId,NamespaceId,DirectoryId)
  VALUES ('GetAllRolesQuery','Record',0,0,(SELECT Id FROM Layer WHERE Name='Application'),(SELECT Id FROM Project WHERE Name='OrderManager.Application'),(SELECT Id FROM Namespace WHERE FullName='OrderManager.Application.Features.Roles.Queries.GetAllRoles'),(SELECT Id FROM Directory WHERE Path='src\OrderManager.Application\Features\Roles\Queries\GetAllRoles'));
IF NOT EXISTS (SELECT 1 FROM CodeElement WHERE Name='GetAllRolesQueryHandler')
  INSERT INTO CodeElement (Name,ElementType,IsAbstract,IsSealed,LayerId,ProjectId,NamespaceId,DirectoryId)
  VALUES ('GetAllRolesQueryHandler','Class',0,1,(SELECT Id FROM Layer WHERE Name='Application'),(SELECT Id FROM Project WHERE Name='OrderManager.Application'),(SELECT Id FROM Namespace WHERE FullName='OrderManager.Application.Features.Roles.Queries.GetAllRoles'),(SELECT Id FROM Directory WHERE Path='src\OrderManager.Application\Features\Roles\Queries\GetAllRoles'));
IF NOT EXISTS (SELECT 1 FROM CodeElement WHERE Name='GetRoleByIdQuery')
  INSERT INTO CodeElement (Name,ElementType,IsAbstract,IsSealed,LayerId,ProjectId,NamespaceId,DirectoryId)
  VALUES ('GetRoleByIdQuery','Record',0,0,(SELECT Id FROM Layer WHERE Name='Application'),(SELECT Id FROM Project WHERE Name='OrderManager.Application'),(SELECT Id FROM Namespace WHERE FullName='OrderManager.Application.Features.Roles.Queries.GetRoleById'),(SELECT Id FROM Directory WHERE Path='src\OrderManager.Application\Features\Roles\Queries\GetRoleById'));
IF NOT EXISTS (SELECT 1 FROM CodeElement WHERE Name='GetRoleByIdQueryHandler')
  INSERT INTO CodeElement (Name,ElementType,IsAbstract,IsSealed,LayerId,ProjectId,NamespaceId,DirectoryId)
  VALUES ('GetRoleByIdQueryHandler','Class',0,1,(SELECT Id FROM Layer WHERE Name='Application'),(SELECT Id FROM Project WHERE Name='OrderManager.Application'),(SELECT Id FROM Namespace WHERE FullName='OrderManager.Application.Features.Roles.Queries.GetRoleById'),(SELECT Id FROM Directory WHERE Path='src\OrderManager.Application\Features\Roles\Queries\GetRoleById'));

-- == APPLICATION - Products ==
IF NOT EXISTS (SELECT 1 FROM CodeElement WHERE Name='CreateProductCommand')
  INSERT INTO CodeElement (Name,ElementType,IsAbstract,IsSealed,LayerId,ProjectId,NamespaceId,DirectoryId)
  VALUES ('CreateProductCommand','Record',0,0,(SELECT Id FROM Layer WHERE Name='Application'),(SELECT Id FROM Project WHERE Name='OrderManager.Application'),(SELECT Id FROM Namespace WHERE FullName='OrderManager.Application.Features.Products.Commands.CreateProduct'),(SELECT Id FROM Directory WHERE Path='src\OrderManager.Application\Features\Products\Commands\CreateProduct'));
IF NOT EXISTS (SELECT 1 FROM CodeElement WHERE Name='CreateProductCommandHandler')
  INSERT INTO CodeElement (Name,ElementType,IsAbstract,IsSealed,LayerId,ProjectId,NamespaceId,DirectoryId)
  VALUES ('CreateProductCommandHandler','Class',0,1,(SELECT Id FROM Layer WHERE Name='Application'),(SELECT Id FROM Project WHERE Name='OrderManager.Application'),(SELECT Id FROM Namespace WHERE FullName='OrderManager.Application.Features.Products.Commands.CreateProduct'),(SELECT Id FROM Directory WHERE Path='src\OrderManager.Application\Features\Products\Commands\CreateProduct'));
IF NOT EXISTS (SELECT 1 FROM CodeElement WHERE Name='CreateProductCommandValidator')
  INSERT INTO CodeElement (Name,ElementType,IsAbstract,IsSealed,LayerId,ProjectId,NamespaceId,DirectoryId)
  VALUES ('CreateProductCommandValidator','Class',0,1,(SELECT Id FROM Layer WHERE Name='Application'),(SELECT Id FROM Project WHERE Name='OrderManager.Application'),(SELECT Id FROM Namespace WHERE FullName='OrderManager.Application.Features.Products.Commands.CreateProduct'),(SELECT Id FROM Directory WHERE Path='src\OrderManager.Application\Features\Products\Commands\CreateProduct'));
IF NOT EXISTS (SELECT 1 FROM CodeElement WHERE Name='DeleteProductCommand')
  INSERT INTO CodeElement (Name,ElementType,IsAbstract,IsSealed,LayerId,ProjectId,NamespaceId,DirectoryId)
  VALUES ('DeleteProductCommand','Record',0,0,(SELECT Id FROM Layer WHERE Name='Application'),(SELECT Id FROM Project WHERE Name='OrderManager.Application'),(SELECT Id FROM Namespace WHERE FullName='OrderManager.Application.Features.Products.Commands.DeleteProduct'),(SELECT Id FROM Directory WHERE Path='src\OrderManager.Application\Features\Products\Commands\DeleteProduct'));
IF NOT EXISTS (SELECT 1 FROM CodeElement WHERE Name='DeleteProductCommandHandler')
  INSERT INTO CodeElement (Name,ElementType,IsAbstract,IsSealed,LayerId,ProjectId,NamespaceId,DirectoryId)
  VALUES ('DeleteProductCommandHandler','Class',0,1,(SELECT Id FROM Layer WHERE Name='Application'),(SELECT Id FROM Project WHERE Name='OrderManager.Application'),(SELECT Id FROM Namespace WHERE FullName='OrderManager.Application.Features.Products.Commands.DeleteProduct'),(SELECT Id FROM Directory WHERE Path='src\OrderManager.Application\Features\Products\Commands\DeleteProduct'));
IF NOT EXISTS (SELECT 1 FROM CodeElement WHERE Name='UpdateProductCommand')
  INSERT INTO CodeElement (Name,ElementType,IsAbstract,IsSealed,LayerId,ProjectId,NamespaceId,DirectoryId)
  VALUES ('UpdateProductCommand','Record',0,0,(SELECT Id FROM Layer WHERE Name='Application'),(SELECT Id FROM Project WHERE Name='OrderManager.Application'),(SELECT Id FROM Namespace WHERE FullName='OrderManager.Application.Features.Products.Commands.UpdateProduct'),(SELECT Id FROM Directory WHERE Path='src\OrderManager.Application\Features\Products\Commands\UpdateProduct'));
IF NOT EXISTS (SELECT 1 FROM CodeElement WHERE Name='UpdateProductCommandHandler')
  INSERT INTO CodeElement (Name,ElementType,IsAbstract,IsSealed,LayerId,ProjectId,NamespaceId,DirectoryId)
  VALUES ('UpdateProductCommandHandler','Class',0,1,(SELECT Id FROM Layer WHERE Name='Application'),(SELECT Id FROM Project WHERE Name='OrderManager.Application'),(SELECT Id FROM Namespace WHERE FullName='OrderManager.Application.Features.Products.Commands.UpdateProduct'),(SELECT Id FROM Directory WHERE Path='src\OrderManager.Application\Features\Products\Commands\UpdateProduct'));
IF NOT EXISTS (SELECT 1 FROM CodeElement WHERE Name='UpdateProductCommandValidator')
  INSERT INTO CodeElement (Name,ElementType,IsAbstract,IsSealed,LayerId,ProjectId,NamespaceId,DirectoryId)
  VALUES ('UpdateProductCommandValidator','Class',0,1,(SELECT Id FROM Layer WHERE Name='Application'),(SELECT Id FROM Project WHERE Name='OrderManager.Application'),(SELECT Id FROM Namespace WHERE FullName='OrderManager.Application.Features.Products.Commands.UpdateProduct'),(SELECT Id FROM Directory WHERE Path='src\OrderManager.Application\Features\Products\Commands\UpdateProduct'));
IF NOT EXISTS (SELECT 1 FROM CodeElement WHERE Name='ProductDto')
  INSERT INTO CodeElement (Name,ElementType,IsAbstract,IsSealed,LayerId,ProjectId,NamespaceId,DirectoryId)
  VALUES ('ProductDto','Record',0,0,(SELECT Id FROM Layer WHERE Name='Application'),(SELECT Id FROM Project WHERE Name='OrderManager.Application'),(SELECT Id FROM Namespace WHERE FullName='OrderManager.Application.Features.Products.DTOs'),(SELECT Id FROM Directory WHERE Path='src\OrderManager.Application\Features\Products\DTOs'));
IF NOT EXISTS (SELECT 1 FROM CodeElement WHERE Name='GetAllProductsQuery')
  INSERT INTO CodeElement (Name,ElementType,IsAbstract,IsSealed,LayerId,ProjectId,NamespaceId,DirectoryId)
  VALUES ('GetAllProductsQuery','Record',0,0,(SELECT Id FROM Layer WHERE Name='Application'),(SELECT Id FROM Project WHERE Name='OrderManager.Application'),(SELECT Id FROM Namespace WHERE FullName='OrderManager.Application.Features.Products.Queries.GetAllProducts'),(SELECT Id FROM Directory WHERE Path='src\OrderManager.Application\Features\Products\Queries\GetAllProducts'));
IF NOT EXISTS (SELECT 1 FROM CodeElement WHERE Name='GetAllProductsQueryHandler')
  INSERT INTO CodeElement (Name,ElementType,IsAbstract,IsSealed,LayerId,ProjectId,NamespaceId,DirectoryId)
  VALUES ('GetAllProductsQueryHandler','Class',0,1,(SELECT Id FROM Layer WHERE Name='Application'),(SELECT Id FROM Project WHERE Name='OrderManager.Application'),(SELECT Id FROM Namespace WHERE FullName='OrderManager.Application.Features.Products.Queries.GetAllProducts'),(SELECT Id FROM Directory WHERE Path='src\OrderManager.Application\Features\Products\Queries\GetAllProducts'));
IF NOT EXISTS (SELECT 1 FROM CodeElement WHERE Name='GetProductByIdQuery')
  INSERT INTO CodeElement (Name,ElementType,IsAbstract,IsSealed,LayerId,ProjectId,NamespaceId,DirectoryId)
  VALUES ('GetProductByIdQuery','Record',0,0,(SELECT Id FROM Layer WHERE Name='Application'),(SELECT Id FROM Project WHERE Name='OrderManager.Application'),(SELECT Id FROM Namespace WHERE FullName='OrderManager.Application.Features.Products.Queries.GetProductById'),(SELECT Id FROM Directory WHERE Path='src\OrderManager.Application\Features\Products\Queries\GetProductById'));
IF NOT EXISTS (SELECT 1 FROM CodeElement WHERE Name='GetProductByIdQueryHandler')
  INSERT INTO CodeElement (Name,ElementType,IsAbstract,IsSealed,LayerId,ProjectId,NamespaceId,DirectoryId)
  VALUES ('GetProductByIdQueryHandler','Class',0,1,(SELECT Id FROM Layer WHERE Name='Application'),(SELECT Id FROM Project WHERE Name='OrderManager.Application'),(SELECT Id FROM Namespace WHERE FullName='OrderManager.Application.Features.Products.Queries.GetProductById'),(SELECT Id FROM Directory WHERE Path='src\OrderManager.Application\Features\Products\Queries\GetProductById'));

-- == APPLICATION - ProductCategories, PaymentMethods, StockMovements, TabCheckouts, TabPayments ==
IF NOT EXISTS (SELECT 1 FROM CodeElement WHERE Name='CreateProductCategoryCommand') INSERT INTO CodeElement (Name,ElementType,IsAbstract,IsSealed,LayerId,ProjectId,NamespaceId,DirectoryId) VALUES ('CreateProductCategoryCommand','Record',0,0,(SELECT Id FROM Layer WHERE Name='Application'),(SELECT Id FROM Project WHERE Name='OrderManager.Application'),(SELECT Id FROM Namespace WHERE FullName='OrderManager.Application.Features.ProductCategories.Commands.CreateProductCategory'),(SELECT Id FROM Directory WHERE Path='src\OrderManager.Application\Features\ProductCategories\Commands\CreateProductCategory'));
IF NOT EXISTS (SELECT 1 FROM CodeElement WHERE Name='CreateProductCategoryCommandHandler') INSERT INTO CodeElement (Name,ElementType,IsAbstract,IsSealed,LayerId,ProjectId,NamespaceId,DirectoryId) VALUES ('CreateProductCategoryCommandHandler','Class',0,1,(SELECT Id FROM Layer WHERE Name='Application'),(SELECT Id FROM Project WHERE Name='OrderManager.Application'),(SELECT Id FROM Namespace WHERE FullName='OrderManager.Application.Features.ProductCategories.Commands.CreateProductCategory'),(SELECT Id FROM Directory WHERE Path='src\OrderManager.Application\Features\ProductCategories\Commands\CreateProductCategory'));
IF NOT EXISTS (SELECT 1 FROM CodeElement WHERE Name='CreateProductCategoryCommandValidator') INSERT INTO CodeElement (Name,ElementType,IsAbstract,IsSealed,LayerId,ProjectId,NamespaceId,DirectoryId) VALUES ('CreateProductCategoryCommandValidator','Class',0,1,(SELECT Id FROM Layer WHERE Name='Application'),(SELECT Id FROM Project WHERE Name='OrderManager.Application'),(SELECT Id FROM Namespace WHERE FullName='OrderManager.Application.Features.ProductCategories.Commands.CreateProductCategory'),(SELECT Id FROM Directory WHERE Path='src\OrderManager.Application\Features\ProductCategories\Commands\CreateProductCategory'));
IF NOT EXISTS (SELECT 1 FROM CodeElement WHERE Name='DeleteProductCategoryCommand') INSERT INTO CodeElement (Name,ElementType,IsAbstract,IsSealed,LayerId,ProjectId,NamespaceId,DirectoryId) VALUES ('DeleteProductCategoryCommand','Record',0,0,(SELECT Id FROM Layer WHERE Name='Application'),(SELECT Id FROM Project WHERE Name='OrderManager.Application'),(SELECT Id FROM Namespace WHERE FullName='OrderManager.Application.Features.ProductCategories.Commands.DeleteProductCategory'),(SELECT Id FROM Directory WHERE Path='src\OrderManager.Application\Features\ProductCategories\Commands\DeleteProductCategory'));
IF NOT EXISTS (SELECT 1 FROM CodeElement WHERE Name='DeleteProductCategoryCommandHandler') INSERT INTO CodeElement (Name,ElementType,IsAbstract,IsSealed,LayerId,ProjectId,NamespaceId,DirectoryId) VALUES ('DeleteProductCategoryCommandHandler','Class',0,1,(SELECT Id FROM Layer WHERE Name='Application'),(SELECT Id FROM Project WHERE Name='OrderManager.Application'),(SELECT Id FROM Namespace WHERE FullName='OrderManager.Application.Features.ProductCategories.Commands.DeleteProductCategory'),(SELECT Id FROM Directory WHERE Path='src\OrderManager.Application\Features\ProductCategories\Commands\DeleteProductCategory'));
IF NOT EXISTS (SELECT 1 FROM CodeElement WHERE Name='UpdateProductCategoryCommand') INSERT INTO CodeElement (Name,ElementType,IsAbstract,IsSealed,LayerId,ProjectId,NamespaceId,DirectoryId) VALUES ('UpdateProductCategoryCommand','Record',0,0,(SELECT Id FROM Layer WHERE Name='Application'),(SELECT Id FROM Project WHERE Name='OrderManager.Application'),(SELECT Id FROM Namespace WHERE FullName='OrderManager.Application.Features.ProductCategories.Commands.UpdateProductCategory'),(SELECT Id FROM Directory WHERE Path='src\OrderManager.Application\Features\ProductCategories\Commands\UpdateProductCategory'));
IF NOT EXISTS (SELECT 1 FROM CodeElement WHERE Name='UpdateProductCategoryCommandHandler') INSERT INTO CodeElement (Name,ElementType,IsAbstract,IsSealed,LayerId,ProjectId,NamespaceId,DirectoryId) VALUES ('UpdateProductCategoryCommandHandler','Class',0,1,(SELECT Id FROM Layer WHERE Name='Application'),(SELECT Id FROM Project WHERE Name='OrderManager.Application'),(SELECT Id FROM Namespace WHERE FullName='OrderManager.Application.Features.ProductCategories.Commands.UpdateProductCategory'),(SELECT Id FROM Directory WHERE Path='src\OrderManager.Application\Features\ProductCategories\Commands\UpdateProductCategory'));
IF NOT EXISTS (SELECT 1 FROM CodeElement WHERE Name='UpdateProductCategoryCommandValidator') INSERT INTO CodeElement (Name,ElementType,IsAbstract,IsSealed,LayerId,ProjectId,NamespaceId,DirectoryId) VALUES ('UpdateProductCategoryCommandValidator','Class',0,1,(SELECT Id FROM Layer WHERE Name='Application'),(SELECT Id FROM Project WHERE Name='OrderManager.Application'),(SELECT Id FROM Namespace WHERE FullName='OrderManager.Application.Features.ProductCategories.Commands.UpdateProductCategory'),(SELECT Id FROM Directory WHERE Path='src\OrderManager.Application\Features\ProductCategories\Commands\UpdateProductCategory'));
IF NOT EXISTS (SELECT 1 FROM CodeElement WHERE Name='ProductCategoryDto') INSERT INTO CodeElement (Name,ElementType,IsAbstract,IsSealed,LayerId,ProjectId,NamespaceId,DirectoryId) VALUES ('ProductCategoryDto','Record',0,0,(SELECT Id FROM Layer WHERE Name='Application'),(SELECT Id FROM Project WHERE Name='OrderManager.Application'),(SELECT Id FROM Namespace WHERE FullName='OrderManager.Application.Features.ProductCategories.DTOs'),(SELECT Id FROM Directory WHERE Path='src\OrderManager.Application\Features\ProductCategories\DTOs'));
IF NOT EXISTS (SELECT 1 FROM CodeElement WHERE Name='GetAllProductCategoriesQuery') INSERT INTO CodeElement (Name,ElementType,IsAbstract,IsSealed,LayerId,ProjectId,NamespaceId,DirectoryId) VALUES ('GetAllProductCategoriesQuery','Record',0,0,(SELECT Id FROM Layer WHERE Name='Application'),(SELECT Id FROM Project WHERE Name='OrderManager.Application'),(SELECT Id FROM Namespace WHERE FullName='OrderManager.Application.Features.ProductCategories.Queries.GetAllProductCategories'),(SELECT Id FROM Directory WHERE Path='src\OrderManager.Application\Features\ProductCategories\Queries\GetAllProductCategories'));
IF NOT EXISTS (SELECT 1 FROM CodeElement WHERE Name='GetAllProductCategoriesQueryHandler') INSERT INTO CodeElement (Name,ElementType,IsAbstract,IsSealed,LayerId,ProjectId,NamespaceId,DirectoryId) VALUES ('GetAllProductCategoriesQueryHandler','Class',0,1,(SELECT Id FROM Layer WHERE Name='Application'),(SELECT Id FROM Project WHERE Name='OrderManager.Application'),(SELECT Id FROM Namespace WHERE FullName='OrderManager.Application.Features.ProductCategories.Queries.GetAllProductCategories'),(SELECT Id FROM Directory WHERE Path='src\OrderManager.Application\Features\ProductCategories\Queries\GetAllProductCategories'));
IF NOT EXISTS (SELECT 1 FROM CodeElement WHERE Name='GetProductCategoryByIdQuery') INSERT INTO CodeElement (Name,ElementType,IsAbstract,IsSealed,LayerId,ProjectId,NamespaceId,DirectoryId) VALUES ('GetProductCategoryByIdQuery','Record',0,0,(SELECT Id FROM Layer WHERE Name='Application'),(SELECT Id FROM Project WHERE Name='OrderManager.Application'),(SELECT Id FROM Namespace WHERE FullName='OrderManager.Application.Features.ProductCategories.Queries.GetProductCategoryById'),(SELECT Id FROM Directory WHERE Path='src\OrderManager.Application\Features\ProductCategories\Queries\GetProductCategoryById'));
IF NOT EXISTS (SELECT 1 FROM CodeElement WHERE Name='GetProductCategoryByIdQueryHandler') INSERT INTO CodeElement (Name,ElementType,IsAbstract,IsSealed,LayerId,ProjectId,NamespaceId,DirectoryId) VALUES ('GetProductCategoryByIdQueryHandler','Class',0,1,(SELECT Id FROM Layer WHERE Name='Application'),(SELECT Id FROM Project WHERE Name='OrderManager.Application'),(SELECT Id FROM Namespace WHERE FullName='OrderManager.Application.Features.ProductCategories.Queries.GetProductCategoryById'),(SELECT Id FROM Directory WHERE Path='src\OrderManager.Application\Features\ProductCategories\Queries\GetProductCategoryById'));
-- PaymentMethods
IF NOT EXISTS (SELECT 1 FROM CodeElement WHERE Name='CreatePaymentMethodCommand') INSERT INTO CodeElement (Name,ElementType,IsAbstract,IsSealed,LayerId,ProjectId,NamespaceId,DirectoryId) VALUES ('CreatePaymentMethodCommand','Record',0,0,(SELECT Id FROM Layer WHERE Name='Application'),(SELECT Id FROM Project WHERE Name='OrderManager.Application'),(SELECT Id FROM Namespace WHERE FullName='OrderManager.Application.Features.PaymentMethods.Commands.CreatePaymentMethod'),(SELECT Id FROM Directory WHERE Path='src\OrderManager.Application\Features\PaymentMethods\Commands\CreatePaymentMethod'));
IF NOT EXISTS (SELECT 1 FROM CodeElement WHERE Name='CreatePaymentMethodCommandHandler') INSERT INTO CodeElement (Name,ElementType,IsAbstract,IsSealed,LayerId,ProjectId,NamespaceId,DirectoryId) VALUES ('CreatePaymentMethodCommandHandler','Class',0,1,(SELECT Id FROM Layer WHERE Name='Application'),(SELECT Id FROM Project WHERE Name='OrderManager.Application'),(SELECT Id FROM Namespace WHERE FullName='OrderManager.Application.Features.PaymentMethods.Commands.CreatePaymentMethod'),(SELECT Id FROM Directory WHERE Path='src\OrderManager.Application\Features\PaymentMethods\Commands\CreatePaymentMethod'));
IF NOT EXISTS (SELECT 1 FROM CodeElement WHERE Name='CreatePaymentMethodCommandValidator') INSERT INTO CodeElement (Name,ElementType,IsAbstract,IsSealed,LayerId,ProjectId,NamespaceId,DirectoryId) VALUES ('CreatePaymentMethodCommandValidator','Class',0,1,(SELECT Id FROM Layer WHERE Name='Application'),(SELECT Id FROM Project WHERE Name='OrderManager.Application'),(SELECT Id FROM Namespace WHERE FullName='OrderManager.Application.Features.PaymentMethods.Commands.CreatePaymentMethod'),(SELECT Id FROM Directory WHERE Path='src\OrderManager.Application\Features\PaymentMethods\Commands\CreatePaymentMethod'));
IF NOT EXISTS (SELECT 1 FROM CodeElement WHERE Name='DeletePaymentMethodCommand') INSERT INTO CodeElement (Name,ElementType,IsAbstract,IsSealed,LayerId,ProjectId,NamespaceId,DirectoryId) VALUES ('DeletePaymentMethodCommand','Record',0,0,(SELECT Id FROM Layer WHERE Name='Application'),(SELECT Id FROM Project WHERE Name='OrderManager.Application'),(SELECT Id FROM Namespace WHERE FullName='OrderManager.Application.Features.PaymentMethods.Commands.DeletePaymentMethod'),(SELECT Id FROM Directory WHERE Path='src\OrderManager.Application\Features\PaymentMethods\Commands\DeletePaymentMethod'));
IF NOT EXISTS (SELECT 1 FROM CodeElement WHERE Name='DeletePaymentMethodCommandHandler') INSERT INTO CodeElement (Name,ElementType,IsAbstract,IsSealed,LayerId,ProjectId,NamespaceId,DirectoryId) VALUES ('DeletePaymentMethodCommandHandler','Class',0,1,(SELECT Id FROM Layer WHERE Name='Application'),(SELECT Id FROM Project WHERE Name='OrderManager.Application'),(SELECT Id FROM Namespace WHERE FullName='OrderManager.Application.Features.PaymentMethods.Commands.DeletePaymentMethod'),(SELECT Id FROM Directory WHERE Path='src\OrderManager.Application\Features\PaymentMethods\Commands\DeletePaymentMethod'));
IF NOT EXISTS (SELECT 1 FROM CodeElement WHERE Name='UpdatePaymentMethodCommand') INSERT INTO CodeElement (Name,ElementType,IsAbstract,IsSealed,LayerId,ProjectId,NamespaceId,DirectoryId) VALUES ('UpdatePaymentMethodCommand','Record',0,0,(SELECT Id FROM Layer WHERE Name='Application'),(SELECT Id FROM Project WHERE Name='OrderManager.Application'),(SELECT Id FROM Namespace WHERE FullName='OrderManager.Application.Features.PaymentMethods.Commands.UpdatePaymentMethod'),(SELECT Id FROM Directory WHERE Path='src\OrderManager.Application\Features\PaymentMethods\Commands\UpdatePaymentMethod'));
IF NOT EXISTS (SELECT 1 FROM CodeElement WHERE Name='UpdatePaymentMethodCommandHandler') INSERT INTO CodeElement (Name,ElementType,IsAbstract,IsSealed,LayerId,ProjectId,NamespaceId,DirectoryId) VALUES ('UpdatePaymentMethodCommandHandler','Class',0,1,(SELECT Id FROM Layer WHERE Name='Application'),(SELECT Id FROM Project WHERE Name='OrderManager.Application'),(SELECT Id FROM Namespace WHERE FullName='OrderManager.Application.Features.PaymentMethods.Commands.UpdatePaymentMethod'),(SELECT Id FROM Directory WHERE Path='src\OrderManager.Application\Features\PaymentMethods\Commands\UpdatePaymentMethod'));
IF NOT EXISTS (SELECT 1 FROM CodeElement WHERE Name='UpdatePaymentMethodCommandValidator') INSERT INTO CodeElement (Name,ElementType,IsAbstract,IsSealed,LayerId,ProjectId,NamespaceId,DirectoryId) VALUES ('UpdatePaymentMethodCommandValidator','Class',0,1,(SELECT Id FROM Layer WHERE Name='Application'),(SELECT Id FROM Project WHERE Name='OrderManager.Application'),(SELECT Id FROM Namespace WHERE FullName='OrderManager.Application.Features.PaymentMethods.Commands.UpdatePaymentMethod'),(SELECT Id FROM Directory WHERE Path='src\OrderManager.Application\Features\PaymentMethods\Commands\UpdatePaymentMethod'));
IF NOT EXISTS (SELECT 1 FROM CodeElement WHERE Name='PaymentMethodDto') INSERT INTO CodeElement (Name,ElementType,IsAbstract,IsSealed,LayerId,ProjectId,NamespaceId,DirectoryId) VALUES ('PaymentMethodDto','Record',0,0,(SELECT Id FROM Layer WHERE Name='Application'),(SELECT Id FROM Project WHERE Name='OrderManager.Application'),(SELECT Id FROM Namespace WHERE FullName='OrderManager.Application.Features.PaymentMethods.DTOs'),(SELECT Id FROM Directory WHERE Path='src\OrderManager.Application\Features\PaymentMethods\DTOs'));
IF NOT EXISTS (SELECT 1 FROM CodeElement WHERE Name='GetAllPaymentMethodsQuery') INSERT INTO CodeElement (Name,ElementType,IsAbstract,IsSealed,LayerId,ProjectId,NamespaceId,DirectoryId) VALUES ('GetAllPaymentMethodsQuery','Record',0,0,(SELECT Id FROM Layer WHERE Name='Application'),(SELECT Id FROM Project WHERE Name='OrderManager.Application'),(SELECT Id FROM Namespace WHERE FullName='OrderManager.Application.Features.PaymentMethods.Queries.GetAllPaymentMethods'),(SELECT Id FROM Directory WHERE Path='src\OrderManager.Application\Features\PaymentMethods\Queries\GetAllPaymentMethods'));
IF NOT EXISTS (SELECT 1 FROM CodeElement WHERE Name='GetAllPaymentMethodsQueryHandler') INSERT INTO CodeElement (Name,ElementType,IsAbstract,IsSealed,LayerId,ProjectId,NamespaceId,DirectoryId) VALUES ('GetAllPaymentMethodsQueryHandler','Class',0,1,(SELECT Id FROM Layer WHERE Name='Application'),(SELECT Id FROM Project WHERE Name='OrderManager.Application'),(SELECT Id FROM Namespace WHERE FullName='OrderManager.Application.Features.PaymentMethods.Queries.GetAllPaymentMethods'),(SELECT Id FROM Directory WHERE Path='src\OrderManager.Application\Features\PaymentMethods\Queries\GetAllPaymentMethods'));
IF NOT EXISTS (SELECT 1 FROM CodeElement WHERE Name='GetPaymentMethodByIdQuery') INSERT INTO CodeElement (Name,ElementType,IsAbstract,IsSealed,LayerId,ProjectId,NamespaceId,DirectoryId) VALUES ('GetPaymentMethodByIdQuery','Record',0,0,(SELECT Id FROM Layer WHERE Name='Application'),(SELECT Id FROM Project WHERE Name='OrderManager.Application'),(SELECT Id FROM Namespace WHERE FullName='OrderManager.Application.Features.PaymentMethods.Queries.GetPaymentMethodById'),(SELECT Id FROM Directory WHERE Path='src\OrderManager.Application\Features\PaymentMethods\Queries\GetPaymentMethodById'));
IF NOT EXISTS (SELECT 1 FROM CodeElement WHERE Name='GetPaymentMethodByIdQueryHandler') INSERT INTO CodeElement (Name,ElementType,IsAbstract,IsSealed,LayerId,ProjectId,NamespaceId,DirectoryId) VALUES ('GetPaymentMethodByIdQueryHandler','Class',0,1,(SELECT Id FROM Layer WHERE Name='Application'),(SELECT Id FROM Project WHERE Name='OrderManager.Application'),(SELECT Id FROM Namespace WHERE FullName='OrderManager.Application.Features.PaymentMethods.Queries.GetPaymentMethodById'),(SELECT Id FROM Directory WHERE Path='src\OrderManager.Application\Features\PaymentMethods\Queries\GetPaymentMethodById'));
-- StockMovements
IF NOT EXISTS (SELECT 1 FROM CodeElement WHERE Name='CreateStockMovementCommand') INSERT INTO CodeElement (Name,ElementType,IsAbstract,IsSealed,LayerId,ProjectId,NamespaceId,DirectoryId) VALUES ('CreateStockMovementCommand','Record',0,0,(SELECT Id FROM Layer WHERE Name='Application'),(SELECT Id FROM Project WHERE Name='OrderManager.Application'),(SELECT Id FROM Namespace WHERE FullName='OrderManager.Application.Features.StockMovements.Commands.CreateStockMovement'),(SELECT Id FROM Directory WHERE Path='src\OrderManager.Application\Features\StockMovements\Commands\CreateStockMovement'));
IF NOT EXISTS (SELECT 1 FROM CodeElement WHERE Name='CreateStockMovementCommandHandler') INSERT INTO CodeElement (Name,ElementType,IsAbstract,IsSealed,LayerId,ProjectId,NamespaceId,DirectoryId) VALUES ('CreateStockMovementCommandHandler','Class',0,1,(SELECT Id FROM Layer WHERE Name='Application'),(SELECT Id FROM Project WHERE Name='OrderManager.Application'),(SELECT Id FROM Namespace WHERE FullName='OrderManager.Application.Features.StockMovements.Commands.CreateStockMovement'),(SELECT Id FROM Directory WHERE Path='src\OrderManager.Application\Features\StockMovements\Commands\CreateStockMovement'));
IF NOT EXISTS (SELECT 1 FROM CodeElement WHERE Name='CreateStockMovementCommandValidator') INSERT INTO CodeElement (Name,ElementType,IsAbstract,IsSealed,LayerId,ProjectId,NamespaceId,DirectoryId) VALUES ('CreateStockMovementCommandValidator','Class',0,1,(SELECT Id FROM Layer WHERE Name='Application'),(SELECT Id FROM Project WHERE Name='OrderManager.Application'),(SELECT Id FROM Namespace WHERE FullName='OrderManager.Application.Features.StockMovements.Commands.CreateStockMovement'),(SELECT Id FROM Directory WHERE Path='src\OrderManager.Application\Features\StockMovements\Commands\CreateStockMovement'));
IF NOT EXISTS (SELECT 1 FROM CodeElement WHERE Name='StockMovementDto') INSERT INTO CodeElement (Name,ElementType,IsAbstract,IsSealed,LayerId,ProjectId,NamespaceId,DirectoryId) VALUES ('StockMovementDto','Record',0,0,(SELECT Id FROM Layer WHERE Name='Application'),(SELECT Id FROM Project WHERE Name='OrderManager.Application'),(SELECT Id FROM Namespace WHERE FullName='OrderManager.Application.Features.StockMovements.DTOs'),(SELECT Id FROM Directory WHERE Path='src\OrderManager.Application\Features\StockMovements\DTOs'));
IF NOT EXISTS (SELECT 1 FROM CodeElement WHERE Name='GetStockMovementsByProductQuery') INSERT INTO CodeElement (Name,ElementType,IsAbstract,IsSealed,LayerId,ProjectId,NamespaceId,DirectoryId) VALUES ('GetStockMovementsByProductQuery','Record',0,0,(SELECT Id FROM Layer WHERE Name='Application'),(SELECT Id FROM Project WHERE Name='OrderManager.Application'),(SELECT Id FROM Namespace WHERE FullName='OrderManager.Application.Features.StockMovements.Queries.GetStockMovementsByProduct'),(SELECT Id FROM Directory WHERE Path='src\OrderManager.Application\Features\StockMovements\Queries\GetStockMovementsByProduct'));
IF NOT EXISTS (SELECT 1 FROM CodeElement WHERE Name='GetStockMovementsByProductQueryHandler') INSERT INTO CodeElement (Name,ElementType,IsAbstract,IsSealed,LayerId,ProjectId,NamespaceId,DirectoryId) VALUES ('GetStockMovementsByProductQueryHandler','Class',0,1,(SELECT Id FROM Layer WHERE Name='Application'),(SELECT Id FROM Project WHERE Name='OrderManager.Application'),(SELECT Id FROM Namespace WHERE FullName='OrderManager.Application.Features.StockMovements.Queries.GetStockMovementsByProduct'),(SELECT Id FROM Directory WHERE Path='src\OrderManager.Application\Features\StockMovements\Queries\GetStockMovementsByProduct'));
-- TabCheckouts
IF NOT EXISTS (SELECT 1 FROM CodeElement WHERE Name='CreateTabCheckoutCommand') INSERT INTO CodeElement (Name,ElementType,IsAbstract,IsSealed,LayerId,ProjectId,NamespaceId,DirectoryId) VALUES ('CreateTabCheckoutCommand','Record',0,0,(SELECT Id FROM Layer WHERE Name='Application'),(SELECT Id FROM Project WHERE Name='OrderManager.Application'),(SELECT Id FROM Namespace WHERE FullName='OrderManager.Application.Features.TabCheckouts.Commands.CreateTabCheckout'),(SELECT Id FROM Directory WHERE Path='src\OrderManager.Application\Features\TabCheckouts\Commands\CreateTabCheckout'));
IF NOT EXISTS (SELECT 1 FROM CodeElement WHERE Name='CreateTabCheckoutCommandHandler') INSERT INTO CodeElement (Name,ElementType,IsAbstract,IsSealed,LayerId,ProjectId,NamespaceId,DirectoryId) VALUES ('CreateTabCheckoutCommandHandler','Class',0,1,(SELECT Id FROM Layer WHERE Name='Application'),(SELECT Id FROM Project WHERE Name='OrderManager.Application'),(SELECT Id FROM Namespace WHERE FullName='OrderManager.Application.Features.TabCheckouts.Commands.CreateTabCheckout'),(SELECT Id FROM Directory WHERE Path='src\OrderManager.Application\Features\TabCheckouts\Commands\CreateTabCheckout'));
IF NOT EXISTS (SELECT 1 FROM CodeElement WHERE Name='CreateTabCheckoutCommandValidator') INSERT INTO CodeElement (Name,ElementType,IsAbstract,IsSealed,LayerId,ProjectId,NamespaceId,DirectoryId) VALUES ('CreateTabCheckoutCommandValidator','Class',0,1,(SELECT Id FROM Layer WHERE Name='Application'),(SELECT Id FROM Project WHERE Name='OrderManager.Application'),(SELECT Id FROM Namespace WHERE FullName='OrderManager.Application.Features.TabCheckouts.Commands.CreateTabCheckout'),(SELECT Id FROM Directory WHERE Path='src\OrderManager.Application\Features\TabCheckouts\Commands\CreateTabCheckout'));
IF NOT EXISTS (SELECT 1 FROM CodeElement WHERE Name='TabCheckoutDto') INSERT INTO CodeElement (Name,ElementType,IsAbstract,IsSealed,LayerId,ProjectId,NamespaceId,DirectoryId) VALUES ('TabCheckoutDto','Record',0,0,(SELECT Id FROM Layer WHERE Name='Application'),(SELECT Id FROM Project WHERE Name='OrderManager.Application'),(SELECT Id FROM Namespace WHERE FullName='OrderManager.Application.Features.TabCheckouts.DTOs'),(SELECT Id FROM Directory WHERE Path='src\OrderManager.Application\Features\TabCheckouts\DTOs'));
IF NOT EXISTS (SELECT 1 FROM CodeElement WHERE Name='GetTabCheckoutByIdQuery') INSERT INTO CodeElement (Name,ElementType,IsAbstract,IsSealed,LayerId,ProjectId,NamespaceId,DirectoryId) VALUES ('GetTabCheckoutByIdQuery','Record',0,0,(SELECT Id FROM Layer WHERE Name='Application'),(SELECT Id FROM Project WHERE Name='OrderManager.Application'),(SELECT Id FROM Namespace WHERE FullName='OrderManager.Application.Features.TabCheckouts.Queries.GetTabCheckoutById'),(SELECT Id FROM Directory WHERE Path='src\OrderManager.Application\Features\TabCheckouts\Queries\GetTabCheckoutById'));
IF NOT EXISTS (SELECT 1 FROM CodeElement WHERE Name='GetTabCheckoutByIdQueryHandler') INSERT INTO CodeElement (Name,ElementType,IsAbstract,IsSealed,LayerId,ProjectId,NamespaceId,DirectoryId) VALUES ('GetTabCheckoutByIdQueryHandler','Class',0,1,(SELECT Id FROM Layer WHERE Name='Application'),(SELECT Id FROM Project WHERE Name='OrderManager.Application'),(SELECT Id FROM Namespace WHERE FullName='OrderManager.Application.Features.TabCheckouts.Queries.GetTabCheckoutById'),(SELECT Id FROM Directory WHERE Path='src\OrderManager.Application\Features\TabCheckouts\Queries\GetTabCheckoutById'));
-- TabPayments
IF NOT EXISTS (SELECT 1 FROM CodeElement WHERE Name='CreateTabPaymentCommand') INSERT INTO CodeElement (Name,ElementType,IsAbstract,IsSealed,LayerId,ProjectId,NamespaceId,DirectoryId) VALUES ('CreateTabPaymentCommand','Record',0,0,(SELECT Id FROM Layer WHERE Name='Application'),(SELECT Id FROM Project WHERE Name='OrderManager.Application'),(SELECT Id FROM Namespace WHERE FullName='OrderManager.Application.Features.TabPayments.Commands.CreateTabPayment'),(SELECT Id FROM Directory WHERE Path='src\OrderManager.Application\Features\TabPayments\Commands\CreateTabPayment'));
IF NOT EXISTS (SELECT 1 FROM CodeElement WHERE Name='CreateTabPaymentCommandHandler') INSERT INTO CodeElement (Name,ElementType,IsAbstract,IsSealed,LayerId,ProjectId,NamespaceId,DirectoryId) VALUES ('CreateTabPaymentCommandHandler','Class',0,1,(SELECT Id FROM Layer WHERE Name='Application'),(SELECT Id FROM Project WHERE Name='OrderManager.Application'),(SELECT Id FROM Namespace WHERE FullName='OrderManager.Application.Features.TabPayments.Commands.CreateTabPayment'),(SELECT Id FROM Directory WHERE Path='src\OrderManager.Application\Features\TabPayments\Commands\CreateTabPayment'));
IF NOT EXISTS (SELECT 1 FROM CodeElement WHERE Name='CreateTabPaymentCommandValidator') INSERT INTO CodeElement (Name,ElementType,IsAbstract,IsSealed,LayerId,ProjectId,NamespaceId,DirectoryId) VALUES ('CreateTabPaymentCommandValidator','Class',0,1,(SELECT Id FROM Layer WHERE Name='Application'),(SELECT Id FROM Project WHERE Name='OrderManager.Application'),(SELECT Id FROM Namespace WHERE FullName='OrderManager.Application.Features.TabPayments.Commands.CreateTabPayment'),(SELECT Id FROM Directory WHERE Path='src\OrderManager.Application\Features\TabPayments\Commands\CreateTabPayment'));
IF NOT EXISTS (SELECT 1 FROM CodeElement WHERE Name='TabPaymentDto') INSERT INTO CodeElement (Name,ElementType,IsAbstract,IsSealed,LayerId,ProjectId,NamespaceId,DirectoryId) VALUES ('TabPaymentDto','Record',0,0,(SELECT Id FROM Layer WHERE Name='Application'),(SELECT Id FROM Project WHERE Name='OrderManager.Application'),(SELECT Id FROM Namespace WHERE FullName='OrderManager.Application.Features.TabPayments.DTOs'),(SELECT Id FROM Directory WHERE Path='src\OrderManager.Application\Features\TabPayments\DTOs'));
IF NOT EXISTS (SELECT 1 FROM CodeElement WHERE Name='GetTabPaymentsByCheckoutQuery') INSERT INTO CodeElement (Name,ElementType,IsAbstract,IsSealed,LayerId,ProjectId,NamespaceId,DirectoryId) VALUES ('GetTabPaymentsByCheckoutQuery','Record',0,0,(SELECT Id FROM Layer WHERE Name='Application'),(SELECT Id FROM Project WHERE Name='OrderManager.Application'),(SELECT Id FROM Namespace WHERE FullName='OrderManager.Application.Features.TabPayments.Queries.GetTabPaymentsByCheckout'),(SELECT Id FROM Directory WHERE Path='src\OrderManager.Application\Features\TabPayments\Queries\GetTabPaymentsByCheckout'));
IF NOT EXISTS (SELECT 1 FROM CodeElement WHERE Name='GetTabPaymentsByCheckoutQueryHandler') INSERT INTO CodeElement (Name,ElementType,IsAbstract,IsSealed,LayerId,ProjectId,NamespaceId,DirectoryId) VALUES ('GetTabPaymentsByCheckoutQueryHandler','Class',0,1,(SELECT Id FROM Layer WHERE Name='Application'),(SELECT Id FROM Project WHERE Name='OrderManager.Application'),(SELECT Id FROM Namespace WHERE FullName='OrderManager.Application.Features.TabPayments.Queries.GetTabPaymentsByCheckout'),(SELECT Id FROM Directory WHERE Path='src\OrderManager.Application\Features\TabPayments\Queries\GetTabPaymentsByCheckout'));

-- == DOMAIN - Common ==
IF NOT EXISTS (SELECT 1 FROM CodeElement WHERE Name='Entity') INSERT INTO CodeElement (Name,ElementType,IsAbstract,IsSealed,LayerId,ProjectId,NamespaceId,DirectoryId) VALUES ('Entity','Class',1,0,(SELECT Id FROM Layer WHERE Name='Domain'),(SELECT Id FROM Project WHERE Name='OrderManager.Domain'),(SELECT Id FROM Namespace WHERE FullName='OrderManager.Domain.Common'),(SELECT Id FROM Directory WHERE Path='src\OrderManager.Domain\Common'));
IF NOT EXISTS (SELECT 1 FROM CodeElement WHERE Name='AggregateRoot') INSERT INTO CodeElement (Name,ElementType,IsAbstract,IsSealed,LayerId,ProjectId,NamespaceId,DirectoryId) VALUES ('AggregateRoot','Class',1,0,(SELECT Id FROM Layer WHERE Name='Domain'),(SELECT Id FROM Project WHERE Name='OrderManager.Domain'),(SELECT Id FROM Namespace WHERE FullName='OrderManager.Domain.Common'),(SELECT Id FROM Directory WHERE Path='src\OrderManager.Domain\Common'));
IF NOT EXISTS (SELECT 1 FROM CodeElement WHERE Name='IDomainEvent') INSERT INTO CodeElement (Name,ElementType,IsAbstract,IsSealed,LayerId,ProjectId,NamespaceId,DirectoryId) VALUES ('IDomainEvent','Interface',0,0,(SELECT Id FROM Layer WHERE Name='Domain'),(SELECT Id FROM Project WHERE Name='OrderManager.Domain'),(SELECT Id FROM Namespace WHERE FullName='OrderManager.Domain.Common'),(SELECT Id FROM Directory WHERE Path='src\OrderManager.Domain\Common'));
IF NOT EXISTS (SELECT 1 FROM CodeElement WHERE Name='Result') INSERT INTO CodeElement (Name,ElementType,IsAbstract,IsSealed,LayerId,ProjectId,NamespaceId,DirectoryId) VALUES ('Result','Class',0,0,(SELECT Id FROM Layer WHERE Name='Domain'),(SELECT Id FROM Project WHERE Name='OrderManager.Domain'),(SELECT Id FROM Namespace WHERE FullName='OrderManager.Domain.Common'),(SELECT Id FROM Directory WHERE Path='src\OrderManager.Domain\Common'));

-- == DOMAIN - Entities ==
IF NOT EXISTS (SELECT 1 FROM CodeElement WHERE Name='Role') INSERT INTO CodeElement (Name,ElementType,IsAbstract,IsSealed,LayerId,ProjectId,NamespaceId,DirectoryId) VALUES ('Role','Class',0,1,(SELECT Id FROM Layer WHERE Name='Domain'),(SELECT Id FROM Project WHERE Name='OrderManager.Domain'),(SELECT Id FROM Namespace WHERE FullName='OrderManager.Domain.Entities'),(SELECT Id FROM Directory WHERE Path='src\OrderManager.Domain\Entities'));
IF NOT EXISTS (SELECT 1 FROM CodeElement WHERE Name='Employee') INSERT INTO CodeElement (Name,ElementType,IsAbstract,IsSealed,LayerId,ProjectId,NamespaceId,DirectoryId) VALUES ('Employee','Class',0,1,(SELECT Id FROM Layer WHERE Name='Domain'),(SELECT Id FROM Project WHERE Name='OrderManager.Domain'),(SELECT Id FROM Namespace WHERE FullName='OrderManager.Domain.Entities'),(SELECT Id FROM Directory WHERE Path='src\OrderManager.Domain\Entities'));
IF NOT EXISTS (SELECT 1 FROM CodeElement WHERE Name='ProductCategory') INSERT INTO CodeElement (Name,ElementType,IsAbstract,IsSealed,LayerId,ProjectId,NamespaceId,DirectoryId) VALUES ('ProductCategory','Class',0,1,(SELECT Id FROM Layer WHERE Name='Domain'),(SELECT Id FROM Project WHERE Name='OrderManager.Domain'),(SELECT Id FROM Namespace WHERE FullName='OrderManager.Domain.Entities'),(SELECT Id FROM Directory WHERE Path='src\OrderManager.Domain\Entities'));
IF NOT EXISTS (SELECT 1 FROM CodeElement WHERE Name='Product') INSERT INTO CodeElement (Name,ElementType,IsAbstract,IsSealed,LayerId,ProjectId,NamespaceId,DirectoryId) VALUES ('Product','Class',0,1,(SELECT Id FROM Layer WHERE Name='Domain'),(SELECT Id FROM Project WHERE Name='OrderManager.Domain'),(SELECT Id FROM Namespace WHERE FullName='OrderManager.Domain.Entities'),(SELECT Id FROM Directory WHERE Path='src\OrderManager.Domain\Entities'));
IF NOT EXISTS (SELECT 1 FROM CodeElement WHERE Name='PaymentMethod') INSERT INTO CodeElement (Name,ElementType,IsAbstract,IsSealed,LayerId,ProjectId,NamespaceId,DirectoryId) VALUES ('PaymentMethod','Class',0,1,(SELECT Id FROM Layer WHERE Name='Domain'),(SELECT Id FROM Project WHERE Name='OrderManager.Domain'),(SELECT Id FROM Namespace WHERE FullName='OrderManager.Domain.Entities'),(SELECT Id FROM Directory WHERE Path='src\OrderManager.Domain\Entities'));
IF NOT EXISTS (SELECT 1 FROM CodeElement WHERE Name='Tab') INSERT INTO CodeElement (Name,ElementType,IsAbstract,IsSealed,LayerId,ProjectId,NamespaceId,DirectoryId) VALUES ('Tab','Class',0,1,(SELECT Id FROM Layer WHERE Name='Domain'),(SELECT Id FROM Project WHERE Name='OrderManager.Domain'),(SELECT Id FROM Namespace WHERE FullName='OrderManager.Domain.Entities'),(SELECT Id FROM Directory WHERE Path='src\OrderManager.Domain\Entities'));
IF NOT EXISTS (SELECT 1 FROM CodeElement WHERE Name='Order') INSERT INTO CodeElement (Name,ElementType,IsAbstract,IsSealed,LayerId,ProjectId,NamespaceId,DirectoryId) VALUES ('Order','Class',0,1,(SELECT Id FROM Layer WHERE Name='Domain'),(SELECT Id FROM Project WHERE Name='OrderManager.Domain'),(SELECT Id FROM Namespace WHERE FullName='OrderManager.Domain.Entities'),(SELECT Id FROM Directory WHERE Path='src\OrderManager.Domain\Entities'));
IF NOT EXISTS (SELECT 1 FROM CodeElement WHERE Name='OrderItem') INSERT INTO CodeElement (Name,ElementType,IsAbstract,IsSealed,LayerId,ProjectId,NamespaceId,DirectoryId) VALUES ('OrderItem','Class',0,1,(SELECT Id FROM Layer WHERE Name='Domain'),(SELECT Id FROM Project WHERE Name='OrderManager.Domain'),(SELECT Id FROM Namespace WHERE FullName='OrderManager.Domain.Entities'),(SELECT Id FROM Directory WHERE Path='src\OrderManager.Domain\Entities'));
IF NOT EXISTS (SELECT 1 FROM CodeElement WHERE Name='TabCheckout') INSERT INTO CodeElement (Name,ElementType,IsAbstract,IsSealed,LayerId,ProjectId,NamespaceId,DirectoryId) VALUES ('TabCheckout','Class',0,1,(SELECT Id FROM Layer WHERE Name='Domain'),(SELECT Id FROM Project WHERE Name='OrderManager.Domain'),(SELECT Id FROM Namespace WHERE FullName='OrderManager.Domain.Entities'),(SELECT Id FROM Directory WHERE Path='src\OrderManager.Domain\Entities'));
IF NOT EXISTS (SELECT 1 FROM CodeElement WHERE Name='TabPayment') INSERT INTO CodeElement (Name,ElementType,IsAbstract,IsSealed,LayerId,ProjectId,NamespaceId,DirectoryId) VALUES ('TabPayment','Class',0,1,(SELECT Id FROM Layer WHERE Name='Domain'),(SELECT Id FROM Project WHERE Name='OrderManager.Domain'),(SELECT Id FROM Namespace WHERE FullName='OrderManager.Domain.Entities'),(SELECT Id FROM Directory WHERE Path='src\OrderManager.Domain\Entities'));
IF NOT EXISTS (SELECT 1 FROM CodeElement WHERE Name='CashRegisterOpening') INSERT INTO CodeElement (Name,ElementType,IsAbstract,IsSealed,LayerId,ProjectId,NamespaceId,DirectoryId) VALUES ('CashRegisterOpening','Class',0,1,(SELECT Id FROM Layer WHERE Name='Domain'),(SELECT Id FROM Project WHERE Name='OrderManager.Domain'),(SELECT Id FROM Namespace WHERE FullName='OrderManager.Domain.Entities'),(SELECT Id FROM Directory WHERE Path='src\OrderManager.Domain\Entities'));
IF NOT EXISTS (SELECT 1 FROM CodeElement WHERE Name='CashRegisterClosing') INSERT INTO CodeElement (Name,ElementType,IsAbstract,IsSealed,LayerId,ProjectId,NamespaceId,DirectoryId) VALUES ('CashRegisterClosing','Class',0,1,(SELECT Id FROM Layer WHERE Name='Domain'),(SELECT Id FROM Project WHERE Name='OrderManager.Domain'),(SELECT Id FROM Namespace WHERE FullName='OrderManager.Domain.Entities'),(SELECT Id FROM Directory WHERE Path='src\OrderManager.Domain\Entities'));
IF NOT EXISTS (SELECT 1 FROM CodeElement WHERE Name='CashRegisterClosingDetail') INSERT INTO CodeElement (Name,ElementType,IsAbstract,IsSealed,LayerId,ProjectId,NamespaceId,DirectoryId) VALUES ('CashRegisterClosingDetail','Class',0,1,(SELECT Id FROM Layer WHERE Name='Domain'),(SELECT Id FROM Project WHERE Name='OrderManager.Domain'),(SELECT Id FROM Namespace WHERE FullName='OrderManager.Domain.Entities'),(SELECT Id FROM Directory WHERE Path='src\OrderManager.Domain\Entities'));
IF NOT EXISTS (SELECT 1 FROM CodeElement WHERE Name='StockMovement') INSERT INTO CodeElement (Name,ElementType,IsAbstract,IsSealed,LayerId,ProjectId,NamespaceId,DirectoryId) VALUES ('StockMovement','Class',0,1,(SELECT Id FROM Layer WHERE Name='Domain'),(SELECT Id FROM Project WHERE Name='OrderManager.Domain'),(SELECT Id FROM Namespace WHERE FullName='OrderManager.Domain.Entities'),(SELECT Id FROM Directory WHERE Path='src\OrderManager.Domain\Entities'));

-- == DOMAIN - Enums ==
IF NOT EXISTS (SELECT 1 FROM CodeElement WHERE Name='OrderStatus') INSERT INTO CodeElement (Name,ElementType,IsAbstract,IsSealed,LayerId,ProjectId,NamespaceId,DirectoryId) VALUES ('OrderStatus','Enum',0,0,(SELECT Id FROM Layer WHERE Name='Domain'),(SELECT Id FROM Project WHERE Name='OrderManager.Domain'),(SELECT Id FROM Namespace WHERE FullName='OrderManager.Domain.Enums'),(SELECT Id FROM Directory WHERE Path='src\OrderManager.Domain\Enums'));
IF NOT EXISTS (SELECT 1 FROM CodeElement WHERE Name='OrderItemStatus') INSERT INTO CodeElement (Name,ElementType,IsAbstract,IsSealed,LayerId,ProjectId,NamespaceId,DirectoryId) VALUES ('OrderItemStatus','Enum',0,0,(SELECT Id FROM Layer WHERE Name='Domain'),(SELECT Id FROM Project WHERE Name='OrderManager.Domain'),(SELECT Id FROM Namespace WHERE FullName='OrderManager.Domain.Enums'),(SELECT Id FROM Directory WHERE Path='src\OrderManager.Domain\Enums'));
IF NOT EXISTS (SELECT 1 FROM CodeElement WHERE Name='TabStatus') INSERT INTO CodeElement (Name,ElementType,IsAbstract,IsSealed,LayerId,ProjectId,NamespaceId,DirectoryId) VALUES ('TabStatus','Enum',0,0,(SELECT Id FROM Layer WHERE Name='Domain'),(SELECT Id FROM Project WHERE Name='OrderManager.Domain'),(SELECT Id FROM Namespace WHERE FullName='OrderManager.Domain.Enums'),(SELECT Id FROM Directory WHERE Path='src\OrderManager.Domain\Enums'));
IF NOT EXISTS (SELECT 1 FROM CodeElement WHERE Name='StockMovementType') INSERT INTO CodeElement (Name,ElementType,IsAbstract,IsSealed,LayerId,ProjectId,NamespaceId,DirectoryId) VALUES ('StockMovementType','Enum',0,0,(SELECT Id FROM Layer WHERE Name='Domain'),(SELECT Id FROM Project WHERE Name='OrderManager.Domain'),(SELECT Id FROM Namespace WHERE FullName='OrderManager.Domain.Enums'),(SELECT Id FROM Directory WHERE Path='src\OrderManager.Domain\Enums'));

-- == DOMAIN - Events ==
IF NOT EXISTS (SELECT 1 FROM CodeElement WHERE Name='OrderCreatedEvent') INSERT INTO CodeElement (Name,ElementType,IsAbstract,IsSealed,LayerId,ProjectId,NamespaceId,DirectoryId) VALUES ('OrderCreatedEvent','Record',0,0,(SELECT Id FROM Layer WHERE Name='Domain'),(SELECT Id FROM Project WHERE Name='OrderManager.Domain'),(SELECT Id FROM Namespace WHERE FullName='OrderManager.Domain.Events'),(SELECT Id FROM Directory WHERE Path='src\OrderManager.Domain\Events'));
IF NOT EXISTS (SELECT 1 FROM CodeElement WHERE Name='TabOpenedEvent') INSERT INTO CodeElement (Name,ElementType,IsAbstract,IsSealed,LayerId,ProjectId,NamespaceId,DirectoryId) VALUES ('TabOpenedEvent','Record',0,0,(SELECT Id FROM Layer WHERE Name='Domain'),(SELECT Id FROM Project WHERE Name='OrderManager.Domain'),(SELECT Id FROM Namespace WHERE FullName='OrderManager.Domain.Events'),(SELECT Id FROM Directory WHERE Path='src\OrderManager.Domain\Events'));
IF NOT EXISTS (SELECT 1 FROM CodeElement WHERE Name='TabClosedEvent') INSERT INTO CodeElement (Name,ElementType,IsAbstract,IsSealed,LayerId,ProjectId,NamespaceId,DirectoryId) VALUES ('TabClosedEvent','Record',0,0,(SELECT Id FROM Layer WHERE Name='Domain'),(SELECT Id FROM Project WHERE Name='OrderManager.Domain'),(SELECT Id FROM Namespace WHERE FullName='OrderManager.Domain.Events'),(SELECT Id FROM Directory WHERE Path='src\OrderManager.Domain\Events'));

-- == DOMAIN - Interfaces ==
IF NOT EXISTS (SELECT 1 FROM CodeElement WHERE Name='IRepository') INSERT INTO CodeElement (Name,ElementType,IsAbstract,IsSealed,LayerId,ProjectId,NamespaceId,DirectoryId) VALUES ('IRepository','Interface',0,0,(SELECT Id FROM Layer WHERE Name='Domain'),(SELECT Id FROM Project WHERE Name='OrderManager.Domain'),(SELECT Id FROM Namespace WHERE FullName='OrderManager.Domain.Interfaces'),(SELECT Id FROM Directory WHERE Path='src\OrderManager.Domain\Interfaces'));
IF NOT EXISTS (SELECT 1 FROM CodeElement WHERE Name='IUnitOfWork') INSERT INTO CodeElement (Name,ElementType,IsAbstract,IsSealed,LayerId,ProjectId,NamespaceId,DirectoryId) VALUES ('IUnitOfWork','Interface',0,0,(SELECT Id FROM Layer WHERE Name='Domain'),(SELECT Id FROM Project WHERE Name='OrderManager.Domain'),(SELECT Id FROM Namespace WHERE FullName='OrderManager.Domain.Interfaces'),(SELECT Id FROM Directory WHERE Path='src\OrderManager.Domain\Interfaces'));
IF NOT EXISTS (SELECT 1 FROM CodeElement WHERE Name='IRoleRepository') INSERT INTO CodeElement (Name,ElementType,IsAbstract,IsSealed,LayerId,ProjectId,NamespaceId,DirectoryId) VALUES ('IRoleRepository','Interface',0,0,(SELECT Id FROM Layer WHERE Name='Domain'),(SELECT Id FROM Project WHERE Name='OrderManager.Domain'),(SELECT Id FROM Namespace WHERE FullName='OrderManager.Domain.Interfaces.Repositories'),(SELECT Id FROM Directory WHERE Path='src\OrderManager.Domain\Interfaces\Repositories'));
IF NOT EXISTS (SELECT 1 FROM CodeElement WHERE Name='IEmployeeRepository') INSERT INTO CodeElement (Name,ElementType,IsAbstract,IsSealed,LayerId,ProjectId,NamespaceId,DirectoryId) VALUES ('IEmployeeRepository','Interface',0,0,(SELECT Id FROM Layer WHERE Name='Domain'),(SELECT Id FROM Project WHERE Name='OrderManager.Domain'),(SELECT Id FROM Namespace WHERE FullName='OrderManager.Domain.Interfaces.Repositories'),(SELECT Id FROM Directory WHERE Path='src\OrderManager.Domain\Interfaces\Repositories'));
IF NOT EXISTS (SELECT 1 FROM CodeElement WHERE Name='IProductCategoryRepository') INSERT INTO CodeElement (Name,ElementType,IsAbstract,IsSealed,LayerId,ProjectId,NamespaceId,DirectoryId) VALUES ('IProductCategoryRepository','Interface',0,0,(SELECT Id FROM Layer WHERE Name='Domain'),(SELECT Id FROM Project WHERE Name='OrderManager.Domain'),(SELECT Id FROM Namespace WHERE FullName='OrderManager.Domain.Interfaces.Repositories'),(SELECT Id FROM Directory WHERE Path='src\OrderManager.Domain\Interfaces\Repositories'));
IF NOT EXISTS (SELECT 1 FROM CodeElement WHERE Name='IProductRepository') INSERT INTO CodeElement (Name,ElementType,IsAbstract,IsSealed,LayerId,ProjectId,NamespaceId,DirectoryId) VALUES ('IProductRepository','Interface',0,0,(SELECT Id FROM Layer WHERE Name='Domain'),(SELECT Id FROM Project WHERE Name='OrderManager.Domain'),(SELECT Id FROM Namespace WHERE FullName='OrderManager.Domain.Interfaces.Repositories'),(SELECT Id FROM Directory WHERE Path='src\OrderManager.Domain\Interfaces\Repositories'));
IF NOT EXISTS (SELECT 1 FROM CodeElement WHERE Name='IPaymentMethodRepository') INSERT INTO CodeElement (Name,ElementType,IsAbstract,IsSealed,LayerId,ProjectId,NamespaceId,DirectoryId) VALUES ('IPaymentMethodRepository','Interface',0,0,(SELECT Id FROM Layer WHERE Name='Domain'),(SELECT Id FROM Project WHERE Name='OrderManager.Domain'),(SELECT Id FROM Namespace WHERE FullName='OrderManager.Domain.Interfaces.Repositories'),(SELECT Id FROM Directory WHERE Path='src\OrderManager.Domain\Interfaces\Repositories'));
IF NOT EXISTS (SELECT 1 FROM CodeElement WHERE Name='ITabRepository') INSERT INTO CodeElement (Name,ElementType,IsAbstract,IsSealed,LayerId,ProjectId,NamespaceId,DirectoryId) VALUES ('ITabRepository','Interface',0,0,(SELECT Id FROM Layer WHERE Name='Domain'),(SELECT Id FROM Project WHERE Name='OrderManager.Domain'),(SELECT Id FROM Namespace WHERE FullName='OrderManager.Domain.Interfaces.Repositories'),(SELECT Id FROM Directory WHERE Path='src\OrderManager.Domain\Interfaces\Repositories'));
IF NOT EXISTS (SELECT 1 FROM CodeElement WHERE Name='IOrderRepository') INSERT INTO CodeElement (Name,ElementType,IsAbstract,IsSealed,LayerId,ProjectId,NamespaceId,DirectoryId) VALUES ('IOrderRepository','Interface',0,0,(SELECT Id FROM Layer WHERE Name='Domain'),(SELECT Id FROM Project WHERE Name='OrderManager.Domain'),(SELECT Id FROM Namespace WHERE FullName='OrderManager.Domain.Interfaces.Repositories'),(SELECT Id FROM Directory WHERE Path='src\OrderManager.Domain\Interfaces\Repositories'));
IF NOT EXISTS (SELECT 1 FROM CodeElement WHERE Name='IOrderItemRepository') INSERT INTO CodeElement (Name,ElementType,IsAbstract,IsSealed,LayerId,ProjectId,NamespaceId,DirectoryId) VALUES ('IOrderItemRepository','Interface',0,0,(SELECT Id FROM Layer WHERE Name='Domain'),(SELECT Id FROM Project WHERE Name='OrderManager.Domain'),(SELECT Id FROM Namespace WHERE FullName='OrderManager.Domain.Interfaces.Repositories'),(SELECT Id FROM Directory WHERE Path='src\OrderManager.Domain\Interfaces\Repositories'));
IF NOT EXISTS (SELECT 1 FROM CodeElement WHERE Name='ITabCheckoutRepository') INSERT INTO CodeElement (Name,ElementType,IsAbstract,IsSealed,LayerId,ProjectId,NamespaceId,DirectoryId) VALUES ('ITabCheckoutRepository','Interface',0,0,(SELECT Id FROM Layer WHERE Name='Domain'),(SELECT Id FROM Project WHERE Name='OrderManager.Domain'),(SELECT Id FROM Namespace WHERE FullName='OrderManager.Domain.Interfaces.Repositories'),(SELECT Id FROM Directory WHERE Path='src\OrderManager.Domain\Interfaces\Repositories'));
IF NOT EXISTS (SELECT 1 FROM CodeElement WHERE Name='ITabPaymentRepository') INSERT INTO CodeElement (Name,ElementType,IsAbstract,IsSealed,LayerId,ProjectId,NamespaceId,DirectoryId) VALUES ('ITabPaymentRepository','Interface',0,0,(SELECT Id FROM Layer WHERE Name='Domain'),(SELECT Id FROM Project WHERE Name='OrderManager.Domain'),(SELECT Id FROM Namespace WHERE FullName='OrderManager.Domain.Interfaces.Repositories'),(SELECT Id FROM Directory WHERE Path='src\OrderManager.Domain\Interfaces\Repositories'));
IF NOT EXISTS (SELECT 1 FROM CodeElement WHERE Name='ICashRegisterOpeningRepository') INSERT INTO CodeElement (Name,ElementType,IsAbstract,IsSealed,LayerId,ProjectId,NamespaceId,DirectoryId) VALUES ('ICashRegisterOpeningRepository','Interface',0,0,(SELECT Id FROM Layer WHERE Name='Domain'),(SELECT Id FROM Project WHERE Name='OrderManager.Domain'),(SELECT Id FROM Namespace WHERE FullName='OrderManager.Domain.Interfaces.Repositories'),(SELECT Id FROM Directory WHERE Path='src\OrderManager.Domain\Interfaces\Repositories'));
IF NOT EXISTS (SELECT 1 FROM CodeElement WHERE Name='ICashRegisterClosingRepository') INSERT INTO CodeElement (Name,ElementType,IsAbstract,IsSealed,LayerId,ProjectId,NamespaceId,DirectoryId) VALUES ('ICashRegisterClosingRepository','Interface',0,0,(SELECT Id FROM Layer WHERE Name='Domain'),(SELECT Id FROM Project WHERE Name='OrderManager.Domain'),(SELECT Id FROM Namespace WHERE FullName='OrderManager.Domain.Interfaces.Repositories'),(SELECT Id FROM Directory WHERE Path='src\OrderManager.Domain\Interfaces\Repositories'));
IF NOT EXISTS (SELECT 1 FROM CodeElement WHERE Name='ICashRegisterClosingDetailRepository') INSERT INTO CodeElement (Name,ElementType,IsAbstract,IsSealed,LayerId,ProjectId,NamespaceId,DirectoryId) VALUES ('ICashRegisterClosingDetailRepository','Interface',0,0,(SELECT Id FROM Layer WHERE Name='Domain'),(SELECT Id FROM Project WHERE Name='OrderManager.Domain'),(SELECT Id FROM Namespace WHERE FullName='OrderManager.Domain.Interfaces.Repositories'),(SELECT Id FROM Directory WHERE Path='src\OrderManager.Domain\Interfaces\Repositories'));
IF NOT EXISTS (SELECT 1 FROM CodeElement WHERE Name='IStockMovementRepository') INSERT INTO CodeElement (Name,ElementType,IsAbstract,IsSealed,LayerId,ProjectId,NamespaceId,DirectoryId) VALUES ('IStockMovementRepository','Interface',0,0,(SELECT Id FROM Layer WHERE Name='Domain'),(SELECT Id FROM Project WHERE Name='OrderManager.Domain'),(SELECT Id FROM Namespace WHERE FullName='OrderManager.Domain.Interfaces.Repositories'),(SELECT Id FROM Directory WHERE Path='src\OrderManager.Domain\Interfaces\Repositories'));

-- == INFRASTRUCTURE ==
IF NOT EXISTS (SELECT 1 FROM CodeElement WHERE Name='AppDbContext') INSERT INTO CodeElement (Name,ElementType,IsAbstract,IsSealed,LayerId,ProjectId,NamespaceId,DirectoryId) VALUES ('AppDbContext','Class',0,1,(SELECT Id FROM Layer WHERE Name='Infrastructure'),(SELECT Id FROM Project WHERE Name='OrderManager.Infrastructure'),(SELECT Id FROM Namespace WHERE FullName='OrderManager.Infrastructure.Persistence'),(SELECT Id FROM Directory WHERE Path='src\OrderManager.Infrastructure\Persistence'));
IF NOT EXISTS (SELECT 1 FROM CodeElement WHERE Name='UnitOfWork') INSERT INTO CodeElement (Name,ElementType,IsAbstract,IsSealed,LayerId,ProjectId,NamespaceId,DirectoryId) VALUES ('UnitOfWork','Class',0,1,(SELECT Id FROM Layer WHERE Name='Infrastructure'),(SELECT Id FROM Project WHERE Name='OrderManager.Infrastructure'),(SELECT Id FROM Namespace WHERE FullName='OrderManager.Infrastructure.Persistence'),(SELECT Id FROM Directory WHERE Path='src\OrderManager.Infrastructure\Persistence'));
IF NOT EXISTS (SELECT 1 FROM CodeElement WHERE Name='GenericRepository') INSERT INTO CodeElement (Name,ElementType,IsAbstract,IsSealed,LayerId,ProjectId,NamespaceId,DirectoryId) VALUES ('GenericRepository','Class',0,0,(SELECT Id FROM Layer WHERE Name='Infrastructure'),(SELECT Id FROM Project WHERE Name='OrderManager.Infrastructure'),(SELECT Id FROM Namespace WHERE FullName='OrderManager.Infrastructure.Repositories'),(SELECT Id FROM Directory WHERE Path='src\OrderManager.Infrastructure\Repositories'));
IF NOT EXISTS (SELECT 1 FROM CodeElement WHERE Name='RoleRepository') INSERT INTO CodeElement (Name,ElementType,IsAbstract,IsSealed,LayerId,ProjectId,NamespaceId,DirectoryId) VALUES ('RoleRepository','Class',0,1,(SELECT Id FROM Layer WHERE Name='Infrastructure'),(SELECT Id FROM Project WHERE Name='OrderManager.Infrastructure'),(SELECT Id FROM Namespace WHERE FullName='OrderManager.Infrastructure.Repositories'),(SELECT Id FROM Directory WHERE Path='src\OrderManager.Infrastructure\Repositories'));
IF NOT EXISTS (SELECT 1 FROM CodeElement WHERE Name='EmployeeRepository') INSERT INTO CodeElement (Name,ElementType,IsAbstract,IsSealed,LayerId,ProjectId,NamespaceId,DirectoryId) VALUES ('EmployeeRepository','Class',0,1,(SELECT Id FROM Layer WHERE Name='Infrastructure'),(SELECT Id FROM Project WHERE Name='OrderManager.Infrastructure'),(SELECT Id FROM Namespace WHERE FullName='OrderManager.Infrastructure.Repositories'),(SELECT Id FROM Directory WHERE Path='src\OrderManager.Infrastructure\Repositories'));
IF NOT EXISTS (SELECT 1 FROM CodeElement WHERE Name='ProductCategoryRepository') INSERT INTO CodeElement (Name,ElementType,IsAbstract,IsSealed,LayerId,ProjectId,NamespaceId,DirectoryId) VALUES ('ProductCategoryRepository','Class',0,1,(SELECT Id FROM Layer WHERE Name='Infrastructure'),(SELECT Id FROM Project WHERE Name='OrderManager.Infrastructure'),(SELECT Id FROM Namespace WHERE FullName='OrderManager.Infrastructure.Repositories'),(SELECT Id FROM Directory WHERE Path='src\OrderManager.Infrastructure\Repositories'));
IF NOT EXISTS (SELECT 1 FROM CodeElement WHERE Name='ProductRepository') INSERT INTO CodeElement (Name,ElementType,IsAbstract,IsSealed,LayerId,ProjectId,NamespaceId,DirectoryId) VALUES ('ProductRepository','Class',0,1,(SELECT Id FROM Layer WHERE Name='Infrastructure'),(SELECT Id FROM Project WHERE Name='OrderManager.Infrastructure'),(SELECT Id FROM Namespace WHERE FullName='OrderManager.Infrastructure.Repositories'),(SELECT Id FROM Directory WHERE Path='src\OrderManager.Infrastructure\Repositories'));
IF NOT EXISTS (SELECT 1 FROM CodeElement WHERE Name='PaymentMethodRepository') INSERT INTO CodeElement (Name,ElementType,IsAbstract,IsSealed,LayerId,ProjectId,NamespaceId,DirectoryId) VALUES ('PaymentMethodRepository','Class',0,1,(SELECT Id FROM Layer WHERE Name='Infrastructure'),(SELECT Id FROM Project WHERE Name='OrderManager.Infrastructure'),(SELECT Id FROM Namespace WHERE FullName='OrderManager.Infrastructure.Repositories'),(SELECT Id FROM Directory WHERE Path='src\OrderManager.Infrastructure\Repositories'));
IF NOT EXISTS (SELECT 1 FROM CodeElement WHERE Name='TabRepository') INSERT INTO CodeElement (Name,ElementType,IsAbstract,IsSealed,LayerId,ProjectId,NamespaceId,DirectoryId) VALUES ('TabRepository','Class',0,1,(SELECT Id FROM Layer WHERE Name='Infrastructure'),(SELECT Id FROM Project WHERE Name='OrderManager.Infrastructure'),(SELECT Id FROM Namespace WHERE FullName='OrderManager.Infrastructure.Repositories'),(SELECT Id FROM Directory WHERE Path='src\OrderManager.Infrastructure\Repositories'));
IF NOT EXISTS (SELECT 1 FROM CodeElement WHERE Name='OrderRepository') INSERT INTO CodeElement (Name,ElementType,IsAbstract,IsSealed,LayerId,ProjectId,NamespaceId,DirectoryId) VALUES ('OrderRepository','Class',0,1,(SELECT Id FROM Layer WHERE Name='Infrastructure'),(SELECT Id FROM Project WHERE Name='OrderManager.Infrastructure'),(SELECT Id FROM Namespace WHERE FullName='OrderManager.Infrastructure.Repositories'),(SELECT Id FROM Directory WHERE Path='src\OrderManager.Infrastructure\Repositories'));
IF NOT EXISTS (SELECT 1 FROM CodeElement WHERE Name='OrderItemRepository') INSERT INTO CodeElement (Name,ElementType,IsAbstract,IsSealed,LayerId,ProjectId,NamespaceId,DirectoryId) VALUES ('OrderItemRepository','Class',0,1,(SELECT Id FROM Layer WHERE Name='Infrastructure'),(SELECT Id FROM Project WHERE Name='OrderManager.Infrastructure'),(SELECT Id FROM Namespace WHERE FullName='OrderManager.Infrastructure.Repositories'),(SELECT Id FROM Directory WHERE Path='src\OrderManager.Infrastructure\Repositories'));
IF NOT EXISTS (SELECT 1 FROM CodeElement WHERE Name='TabCheckoutRepository') INSERT INTO CodeElement (Name,ElementType,IsAbstract,IsSealed,LayerId,ProjectId,NamespaceId,DirectoryId) VALUES ('TabCheckoutRepository','Class',0,1,(SELECT Id FROM Layer WHERE Name='Infrastructure'),(SELECT Id FROM Project WHERE Name='OrderManager.Infrastructure'),(SELECT Id FROM Namespace WHERE FullName='OrderManager.Infrastructure.Repositories'),(SELECT Id FROM Directory WHERE Path='src\OrderManager.Infrastructure\Repositories'));
IF NOT EXISTS (SELECT 1 FROM CodeElement WHERE Name='TabPaymentRepository') INSERT INTO CodeElement (Name,ElementType,IsAbstract,IsSealed,LayerId,ProjectId,NamespaceId,DirectoryId) VALUES ('TabPaymentRepository','Class',0,1,(SELECT Id FROM Layer WHERE Name='Infrastructure'),(SELECT Id FROM Project WHERE Name='OrderManager.Infrastructure'),(SELECT Id FROM Namespace WHERE FullName='OrderManager.Infrastructure.Repositories'),(SELECT Id FROM Directory WHERE Path='src\OrderManager.Infrastructure\Repositories'));
IF NOT EXISTS (SELECT 1 FROM CodeElement WHERE Name='CashRegisterOpeningRepository') INSERT INTO CodeElement (Name,ElementType,IsAbstract,IsSealed,LayerId,ProjectId,NamespaceId,DirectoryId) VALUES ('CashRegisterOpeningRepository','Class',0,1,(SELECT Id FROM Layer WHERE Name='Infrastructure'),(SELECT Id FROM Project WHERE Name='OrderManager.Infrastructure'),(SELECT Id FROM Namespace WHERE FullName='OrderManager.Infrastructure.Repositories'),(SELECT Id FROM Directory WHERE Path='src\OrderManager.Infrastructure\Repositories'));
IF NOT EXISTS (SELECT 1 FROM CodeElement WHERE Name='CashRegisterClosingRepository') INSERT INTO CodeElement (Name,ElementType,IsAbstract,IsSealed,LayerId,ProjectId,NamespaceId,DirectoryId) VALUES ('CashRegisterClosingRepository','Class',0,1,(SELECT Id FROM Layer WHERE Name='Infrastructure'),(SELECT Id FROM Project WHERE Name='OrderManager.Infrastructure'),(SELECT Id FROM Namespace WHERE FullName='OrderManager.Infrastructure.Repositories'),(SELECT Id FROM Directory WHERE Path='src\OrderManager.Infrastructure\Repositories'));
IF NOT EXISTS (SELECT 1 FROM CodeElement WHERE Name='CashRegisterClosingDetailRepository') INSERT INTO CodeElement (Name,ElementType,IsAbstract,IsSealed,LayerId,ProjectId,NamespaceId,DirectoryId) VALUES ('CashRegisterClosingDetailRepository','Class',0,1,(SELECT Id FROM Layer WHERE Name='Infrastructure'),(SELECT Id FROM Project WHERE Name='OrderManager.Infrastructure'),(SELECT Id FROM Namespace WHERE FullName='OrderManager.Infrastructure.Repositories'),(SELECT Id FROM Directory WHERE Path='src\OrderManager.Infrastructure\Repositories'));
IF NOT EXISTS (SELECT 1 FROM CodeElement WHERE Name='StockMovementRepository') INSERT INTO CodeElement (Name,ElementType,IsAbstract,IsSealed,LayerId,ProjectId,NamespaceId,DirectoryId) VALUES ('StockMovementRepository','Class',0,1,(SELECT Id FROM Layer WHERE Name='Infrastructure'),(SELECT Id FROM Project WHERE Name='OrderManager.Infrastructure'),(SELECT Id FROM Namespace WHERE FullName='OrderManager.Infrastructure.Repositories'),(SELECT Id FROM Directory WHERE Path='src\OrderManager.Infrastructure\Repositories'));

-- == TESTS ==
IF NOT EXISTS (SELECT 1 FROM CodeElement WHERE Name='CreateRoleHandlerTests') INSERT INTO CodeElement (Name,ElementType,IsAbstract,IsSealed,LayerId,ProjectId,NamespaceId,DirectoryId) VALUES ('CreateRoleHandlerTests','Class',0,0,(SELECT Id FROM Layer WHERE Name='Test'),(SELECT Id FROM Project WHERE Name='OrderManager.UnitTests'),(SELECT Id FROM Namespace WHERE FullName='OrderManager.UnitTests.Application.Features.Roles'),(SELECT Id FROM Directory WHERE Path='tests\OrderManager.UnitTests\Application\Features\Roles'));
IF NOT EXISTS (SELECT 1 FROM CodeElement WHERE Name='CreateRoleValidatorTests') INSERT INTO CodeElement (Name,ElementType,IsAbstract,IsSealed,LayerId,ProjectId,NamespaceId,DirectoryId) VALUES ('CreateRoleValidatorTests','Class',0,0,(SELECT Id FROM Layer WHERE Name='Test'),(SELECT Id FROM Project WHERE Name='OrderManager.UnitTests'),(SELECT Id FROM Namespace WHERE FullName='OrderManager.UnitTests.Application.Features.Roles'),(SELECT Id FROM Directory WHERE Path='tests\OrderManager.UnitTests\Application\Features\Roles'));
IF NOT EXISTS (SELECT 1 FROM CodeElement WHERE Name='GetRoleByIdHandlerTests') INSERT INTO CodeElement (Name,ElementType,IsAbstract,IsSealed,LayerId,ProjectId,NamespaceId,DirectoryId) VALUES ('GetRoleByIdHandlerTests','Class',0,0,(SELECT Id FROM Layer WHERE Name='Test'),(SELECT Id FROM Project WHERE Name='OrderManager.UnitTests'),(SELECT Id FROM Namespace WHERE FullName='OrderManager.UnitTests.Application.Features.Roles'),(SELECT Id FROM Directory WHERE Path='tests\OrderManager.UnitTests\Application\Features\Roles'));
IF NOT EXISTS (SELECT 1 FROM CodeElement WHERE Name='CreateTabHandlerTests') INSERT INTO CodeElement (Name,ElementType,IsAbstract,IsSealed,LayerId,ProjectId,NamespaceId,DirectoryId) VALUES ('CreateTabHandlerTests','Class',0,0,(SELECT Id FROM Layer WHERE Name='Test'),(SELECT Id FROM Project WHERE Name='OrderManager.UnitTests'),(SELECT Id FROM Namespace WHERE FullName='OrderManager.UnitTests.Application.Features.Tabs'),(SELECT Id FROM Directory WHERE Path='tests\OrderManager.UnitTests\Application\Features\Tabs'));
IF NOT EXISTS (SELECT 1 FROM CodeElement WHERE Name='RoleTests') INSERT INTO CodeElement (Name,ElementType,IsAbstract,IsSealed,LayerId,ProjectId,NamespaceId,DirectoryId) VALUES ('RoleTests','Class',0,0,(SELECT Id FROM Layer WHERE Name='Test'),(SELECT Id FROM Project WHERE Name='OrderManager.UnitTests'),(SELECT Id FROM Namespace WHERE FullName='OrderManager.UnitTests.Domain.Entities'),(SELECT Id FROM Directory WHERE Path='tests\OrderManager.UnitTests\Domain\Entities'));
IF NOT EXISTS (SELECT 1 FROM CodeElement WHERE Name='OrderTests') INSERT INTO CodeElement (Name,ElementType,IsAbstract,IsSealed,LayerId,ProjectId,NamespaceId,DirectoryId) VALUES ('OrderTests','Class',0,0,(SELECT Id FROM Layer WHERE Name='Test'),(SELECT Id FROM Project WHERE Name='OrderManager.UnitTests'),(SELECT Id FROM Namespace WHERE FullName='OrderManager.UnitTests.Domain.Entities'),(SELECT Id FROM Directory WHERE Path='tests\OrderManager.UnitTests\Domain\Entities'));
IF NOT EXISTS (SELECT 1 FROM CodeElement WHERE Name='OrderItemTests') INSERT INTO CodeElement (Name,ElementType,IsAbstract,IsSealed,LayerId,ProjectId,NamespaceId,DirectoryId) VALUES ('OrderItemTests','Class',0,0,(SELECT Id FROM Layer WHERE Name='Test'),(SELECT Id FROM Project WHERE Name='OrderManager.UnitTests'),(SELECT Id FROM Namespace WHERE FullName='OrderManager.UnitTests.Domain.Entities'),(SELECT Id FROM Directory WHERE Path='tests\OrderManager.UnitTests\Domain\Entities'));
IF NOT EXISTS (SELECT 1 FROM CodeElement WHERE Name='ProductTests') INSERT INTO CodeElement (Name,ElementType,IsAbstract,IsSealed,LayerId,ProjectId,NamespaceId,DirectoryId) VALUES ('ProductTests','Class',0,0,(SELECT Id FROM Layer WHERE Name='Test'),(SELECT Id FROM Project WHERE Name='OrderManager.UnitTests'),(SELECT Id FROM Namespace WHERE FullName='OrderManager.UnitTests.Domain.Entities'),(SELECT Id FROM Directory WHERE Path='tests\OrderManager.UnitTests\Domain\Entities'));
IF NOT EXISTS (SELECT 1 FROM CodeElement WHERE Name='TabTests') INSERT INTO CodeElement (Name,ElementType,IsAbstract,IsSealed,LayerId,ProjectId,NamespaceId,DirectoryId) VALUES ('TabTests','Class',0,0,(SELECT Id FROM Layer WHERE Name='Test'),(SELECT Id FROM Project WHERE Name='OrderManager.UnitTests'),(SELECT Id FROM Namespace WHERE FullName='OrderManager.UnitTests.Domain.Entities'),(SELECT Id FROM Directory WHERE Path='tests\OrderManager.UnitTests\Domain\Entities'));
IF NOT EXISTS (SELECT 1 FROM CodeElement WHERE Name='TabCheckoutTests') INSERT INTO CodeElement (Name,ElementType,IsAbstract,IsSealed,LayerId,ProjectId,NamespaceId,DirectoryId) VALUES ('TabCheckoutTests','Class',0,0,(SELECT Id FROM Layer WHERE Name='Test'),(SELECT Id FROM Project WHERE Name='OrderManager.UnitTests'),(SELECT Id FROM Namespace WHERE FullName='OrderManager.UnitTests.Domain.Entities'),(SELECT Id FROM Directory WHERE Path='tests\OrderManager.UnitTests\Domain\Entities'));
IF NOT EXISTS (SELECT 1 FROM CodeElement WHERE Name='OrderFlowSteps') INSERT INTO CodeElement (Name,ElementType,IsAbstract,IsSealed,LayerId,ProjectId,NamespaceId,DirectoryId) VALUES ('OrderFlowSteps','Class',0,0,(SELECT Id FROM Layer WHERE Name='Test'),(SELECT Id FROM Project WHERE Name='OrderManager.BddTests'),(SELECT Id FROM Namespace WHERE FullName='OrderManager.BddTests.StepDefinitions'),(SELECT Id FROM Directory WHERE Path='tests\OrderManager.BddTests\StepDefinitions'));
IF NOT EXISTS (SELECT 1 FROM CodeElement WHERE Name='TabCheckoutSteps') INSERT INTO CodeElement (Name,ElementType,IsAbstract,IsSealed,LayerId,ProjectId,NamespaceId,DirectoryId) VALUES ('TabCheckoutSteps','Class',0,0,(SELECT Id FROM Layer WHERE Name='Test'),(SELECT Id FROM Project WHERE Name='OrderManager.BddTests'),(SELECT Id FROM Namespace WHERE FullName='OrderManager.BddTests.StepDefinitions'),(SELECT Id FROM Directory WHERE Path='tests\OrderManager.BddTests\StepDefinitions'));
IF NOT EXISTS (SELECT 1 FROM CodeElement WHERE Name='TabLifecycleSteps') INSERT INTO CodeElement (Name,ElementType,IsAbstract,IsSealed,LayerId,ProjectId,NamespaceId,DirectoryId) VALUES ('TabLifecycleSteps','Class',0,0,(SELECT Id FROM Layer WHERE Name='Test'),(SELECT Id FROM Project WHERE Name='OrderManager.BddTests'),(SELECT Id FROM Namespace WHERE FullName='OrderManager.BddTests.StepDefinitions'),(SELECT Id FROM Directory WHERE Path='tests\OrderManager.BddTests\StepDefinitions'));

-- ── 6. ELEMENT IMPLEMENTATIONS ───────────────────────────
-- Repositories implementam suas interfaces
IF NOT EXISTS (SELECT 1 FROM ElementImplementation WHERE ClassId=(SELECT Id FROM CodeElement WHERE Name='RoleRepository') AND InterfaceId=(SELECT Id FROM CodeElement WHERE Name='IRoleRepository'))
  INSERT INTO ElementImplementation (ClassId,InterfaceId) VALUES ((SELECT Id FROM CodeElement WHERE Name='RoleRepository'),(SELECT Id FROM CodeElement WHERE Name='IRoleRepository'));
IF NOT EXISTS (SELECT 1 FROM ElementImplementation WHERE ClassId=(SELECT Id FROM CodeElement WHERE Name='EmployeeRepository') AND InterfaceId=(SELECT Id FROM CodeElement WHERE Name='IEmployeeRepository'))
  INSERT INTO ElementImplementation (ClassId,InterfaceId) VALUES ((SELECT Id FROM CodeElement WHERE Name='EmployeeRepository'),(SELECT Id FROM CodeElement WHERE Name='IEmployeeRepository'));
IF NOT EXISTS (SELECT 1 FROM ElementImplementation WHERE ClassId=(SELECT Id FROM CodeElement WHERE Name='ProductCategoryRepository') AND InterfaceId=(SELECT Id FROM CodeElement WHERE Name='IProductCategoryRepository'))
  INSERT INTO ElementImplementation (ClassId,InterfaceId) VALUES ((SELECT Id FROM CodeElement WHERE Name='ProductCategoryRepository'),(SELECT Id FROM CodeElement WHERE Name='IProductCategoryRepository'));
IF NOT EXISTS (SELECT 1 FROM ElementImplementation WHERE ClassId=(SELECT Id FROM CodeElement WHERE Name='ProductRepository') AND InterfaceId=(SELECT Id FROM CodeElement WHERE Name='IProductRepository'))
  INSERT INTO ElementImplementation (ClassId,InterfaceId) VALUES ((SELECT Id FROM CodeElement WHERE Name='ProductRepository'),(SELECT Id FROM CodeElement WHERE Name='IProductRepository'));
IF NOT EXISTS (SELECT 1 FROM ElementImplementation WHERE ClassId=(SELECT Id FROM CodeElement WHERE Name='PaymentMethodRepository') AND InterfaceId=(SELECT Id FROM CodeElement WHERE Name='IPaymentMethodRepository'))
  INSERT INTO ElementImplementation (ClassId,InterfaceId) VALUES ((SELECT Id FROM CodeElement WHERE Name='PaymentMethodRepository'),(SELECT Id FROM CodeElement WHERE Name='IPaymentMethodRepository'));
IF NOT EXISTS (SELECT 1 FROM ElementImplementation WHERE ClassId=(SELECT Id FROM CodeElement WHERE Name='TabRepository') AND InterfaceId=(SELECT Id FROM CodeElement WHERE Name='ITabRepository'))
  INSERT INTO ElementImplementation (ClassId,InterfaceId) VALUES ((SELECT Id FROM CodeElement WHERE Name='TabRepository'),(SELECT Id FROM CodeElement WHERE Name='ITabRepository'));
IF NOT EXISTS (SELECT 1 FROM ElementImplementation WHERE ClassId=(SELECT Id FROM CodeElement WHERE Name='OrderRepository') AND InterfaceId=(SELECT Id FROM CodeElement WHERE Name='IOrderRepository'))
  INSERT INTO ElementImplementation (ClassId,InterfaceId) VALUES ((SELECT Id FROM CodeElement WHERE Name='OrderRepository'),(SELECT Id FROM CodeElement WHERE Name='IOrderRepository'));
IF NOT EXISTS (SELECT 1 FROM ElementImplementation WHERE ClassId=(SELECT Id FROM CodeElement WHERE Name='OrderItemRepository') AND InterfaceId=(SELECT Id FROM CodeElement WHERE Name='IOrderItemRepository'))
  INSERT INTO ElementImplementation (ClassId,InterfaceId) VALUES ((SELECT Id FROM CodeElement WHERE Name='OrderItemRepository'),(SELECT Id FROM CodeElement WHERE Name='IOrderItemRepository'));
IF NOT EXISTS (SELECT 1 FROM ElementImplementation WHERE ClassId=(SELECT Id FROM CodeElement WHERE Name='TabCheckoutRepository') AND InterfaceId=(SELECT Id FROM CodeElement WHERE Name='ITabCheckoutRepository'))
  INSERT INTO ElementImplementation (ClassId,InterfaceId) VALUES ((SELECT Id FROM CodeElement WHERE Name='TabCheckoutRepository'),(SELECT Id FROM CodeElement WHERE Name='ITabCheckoutRepository'));
IF NOT EXISTS (SELECT 1 FROM ElementImplementation WHERE ClassId=(SELECT Id FROM CodeElement WHERE Name='TabPaymentRepository') AND InterfaceId=(SELECT Id FROM CodeElement WHERE Name='ITabPaymentRepository'))
  INSERT INTO ElementImplementation (ClassId,InterfaceId) VALUES ((SELECT Id FROM CodeElement WHERE Name='TabPaymentRepository'),(SELECT Id FROM CodeElement WHERE Name='ITabPaymentRepository'));
IF NOT EXISTS (SELECT 1 FROM ElementImplementation WHERE ClassId=(SELECT Id FROM CodeElement WHERE Name='CashRegisterOpeningRepository') AND InterfaceId=(SELECT Id FROM CodeElement WHERE Name='ICashRegisterOpeningRepository'))
  INSERT INTO ElementImplementation (ClassId,InterfaceId) VALUES ((SELECT Id FROM CodeElement WHERE Name='CashRegisterOpeningRepository'),(SELECT Id FROM CodeElement WHERE Name='ICashRegisterOpeningRepository'));
IF NOT EXISTS (SELECT 1 FROM ElementImplementation WHERE ClassId=(SELECT Id FROM CodeElement WHERE Name='CashRegisterClosingRepository') AND InterfaceId=(SELECT Id FROM CodeElement WHERE Name='ICashRegisterClosingRepository'))
  INSERT INTO ElementImplementation (ClassId,InterfaceId) VALUES ((SELECT Id FROM CodeElement WHERE Name='CashRegisterClosingRepository'),(SELECT Id FROM CodeElement WHERE Name='ICashRegisterClosingRepository'));
IF NOT EXISTS (SELECT 1 FROM ElementImplementation WHERE ClassId=(SELECT Id FROM CodeElement WHERE Name='CashRegisterClosingDetailRepository') AND InterfaceId=(SELECT Id FROM CodeElement WHERE Name='ICashRegisterClosingDetailRepository'))
  INSERT INTO ElementImplementation (ClassId,InterfaceId) VALUES ((SELECT Id FROM CodeElement WHERE Name='CashRegisterClosingDetailRepository'),(SELECT Id FROM CodeElement WHERE Name='ICashRegisterClosingDetailRepository'));
IF NOT EXISTS (SELECT 1 FROM ElementImplementation WHERE ClassId=(SELECT Id FROM CodeElement WHERE Name='StockMovementRepository') AND InterfaceId=(SELECT Id FROM CodeElement WHERE Name='IStockMovementRepository'))
  INSERT INTO ElementImplementation (ClassId,InterfaceId) VALUES ((SELECT Id FROM CodeElement WHERE Name='StockMovementRepository'),(SELECT Id FROM CodeElement WHERE Name='IStockMovementRepository'));
IF NOT EXISTS (SELECT 1 FROM ElementImplementation WHERE ClassId=(SELECT Id FROM CodeElement WHERE Name='UnitOfWork') AND InterfaceId=(SELECT Id FROM CodeElement WHERE Name='IUnitOfWork'))
  INSERT INTO ElementImplementation (ClassId,InterfaceId) VALUES ((SELECT Id FROM CodeElement WHERE Name='UnitOfWork'),(SELECT Id FROM CodeElement WHERE Name='IUnitOfWork'));
-- Entities herdam AggregateRoot
IF NOT EXISTS (SELECT 1 FROM ElementImplementation WHERE ClassId=(SELECT Id FROM CodeElement WHERE Name='Role') AND InterfaceId=(SELECT Id FROM CodeElement WHERE Name='AggregateRoot'))
  INSERT INTO ElementImplementation (ClassId,InterfaceId) VALUES ((SELECT Id FROM CodeElement WHERE Name='Role'),(SELECT Id FROM CodeElement WHERE Name='AggregateRoot'));
IF NOT EXISTS (SELECT 1 FROM ElementImplementation WHERE ClassId=(SELECT Id FROM CodeElement WHERE Name='Employee') AND InterfaceId=(SELECT Id FROM CodeElement WHERE Name='AggregateRoot'))
  INSERT INTO ElementImplementation (ClassId,InterfaceId) VALUES ((SELECT Id FROM CodeElement WHERE Name='Employee'),(SELECT Id FROM CodeElement WHERE Name='AggregateRoot'));
IF NOT EXISTS (SELECT 1 FROM ElementImplementation WHERE ClassId=(SELECT Id FROM CodeElement WHERE Name='Product') AND InterfaceId=(SELECT Id FROM CodeElement WHERE Name='AggregateRoot'))
  INSERT INTO ElementImplementation (ClassId,InterfaceId) VALUES ((SELECT Id FROM CodeElement WHERE Name='Product'),(SELECT Id FROM CodeElement WHERE Name='AggregateRoot'));
IF NOT EXISTS (SELECT 1 FROM ElementImplementation WHERE ClassId=(SELECT Id FROM CodeElement WHERE Name='Tab') AND InterfaceId=(SELECT Id FROM CodeElement WHERE Name='AggregateRoot'))
  INSERT INTO ElementImplementation (ClassId,InterfaceId) VALUES ((SELECT Id FROM CodeElement WHERE Name='Tab'),(SELECT Id FROM CodeElement WHERE Name='AggregateRoot'));
IF NOT EXISTS (SELECT 1 FROM ElementImplementation WHERE ClassId=(SELECT Id FROM CodeElement WHERE Name='Order') AND InterfaceId=(SELECT Id FROM CodeElement WHERE Name='AggregateRoot'))
  INSERT INTO ElementImplementation (ClassId,InterfaceId) VALUES ((SELECT Id FROM CodeElement WHERE Name='Order'),(SELECT Id FROM CodeElement WHERE Name='AggregateRoot'));
IF NOT EXISTS (SELECT 1 FROM ElementImplementation WHERE ClassId=(SELECT Id FROM CodeElement WHERE Name='OrderItem') AND InterfaceId=(SELECT Id FROM CodeElement WHERE Name='AggregateRoot'))
  INSERT INTO ElementImplementation (ClassId,InterfaceId) VALUES ((SELECT Id FROM CodeElement WHERE Name='OrderItem'),(SELECT Id FROM CodeElement WHERE Name='AggregateRoot'));
IF NOT EXISTS (SELECT 1 FROM ElementImplementation WHERE ClassId=(SELECT Id FROM CodeElement WHERE Name='TabCheckout') AND InterfaceId=(SELECT Id FROM CodeElement WHERE Name='AggregateRoot'))
  INSERT INTO ElementImplementation (ClassId,InterfaceId) VALUES ((SELECT Id FROM CodeElement WHERE Name='TabCheckout'),(SELECT Id FROM CodeElement WHERE Name='AggregateRoot'));
IF NOT EXISTS (SELECT 1 FROM ElementImplementation WHERE ClassId=(SELECT Id FROM CodeElement WHERE Name='TabPayment') AND InterfaceId=(SELECT Id FROM CodeElement WHERE Name='AggregateRoot'))
  INSERT INTO ElementImplementation (ClassId,InterfaceId) VALUES ((SELECT Id FROM CodeElement WHERE Name='TabPayment'),(SELECT Id FROM CodeElement WHERE Name='AggregateRoot'));
IF NOT EXISTS (SELECT 1 FROM ElementImplementation WHERE ClassId=(SELECT Id FROM CodeElement WHERE Name='StockMovement') AND InterfaceId=(SELECT Id FROM CodeElement WHERE Name='AggregateRoot'))
  INSERT INTO ElementImplementation (ClassId,InterfaceId) VALUES ((SELECT Id FROM CodeElement WHERE Name='StockMovement'),(SELECT Id FROM CodeElement WHERE Name='AggregateRoot'));
IF NOT EXISTS (SELECT 1 FROM ElementImplementation WHERE ClassId=(SELECT Id FROM CodeElement WHERE Name='CashRegisterOpening') AND InterfaceId=(SELECT Id FROM CodeElement WHERE Name='AggregateRoot'))
  INSERT INTO ElementImplementation (ClassId,InterfaceId) VALUES ((SELECT Id FROM CodeElement WHERE Name='CashRegisterOpening'),(SELECT Id FROM CodeElement WHERE Name='AggregateRoot'));
IF NOT EXISTS (SELECT 1 FROM ElementImplementation WHERE ClassId=(SELECT Id FROM CodeElement WHERE Name='CashRegisterClosing') AND InterfaceId=(SELECT Id FROM CodeElement WHERE Name='AggregateRoot'))
  INSERT INTO ElementImplementation (ClassId,InterfaceId) VALUES ((SELECT Id FROM CodeElement WHERE Name='CashRegisterClosing'),(SELECT Id FROM CodeElement WHERE Name='AggregateRoot'));
-- Domain Events implementam IDomainEvent
IF NOT EXISTS (SELECT 1 FROM ElementImplementation WHERE ClassId=(SELECT Id FROM CodeElement WHERE Name='OrderCreatedEvent') AND InterfaceId=(SELECT Id FROM CodeElement WHERE Name='IDomainEvent'))
  INSERT INTO ElementImplementation (ClassId,InterfaceId) VALUES ((SELECT Id FROM CodeElement WHERE Name='OrderCreatedEvent'),(SELECT Id FROM CodeElement WHERE Name='IDomainEvent'));
IF NOT EXISTS (SELECT 1 FROM ElementImplementation WHERE ClassId=(SELECT Id FROM CodeElement WHERE Name='TabOpenedEvent') AND InterfaceId=(SELECT Id FROM CodeElement WHERE Name='IDomainEvent'))
  INSERT INTO ElementImplementation (ClassId,InterfaceId) VALUES ((SELECT Id FROM CodeElement WHERE Name='TabOpenedEvent'),(SELECT Id FROM CodeElement WHERE Name='IDomainEvent'));
IF NOT EXISTS (SELECT 1 FROM ElementImplementation WHERE ClassId=(SELECT Id FROM CodeElement WHERE Name='TabClosedEvent') AND InterfaceId=(SELECT Id FROM CodeElement WHERE Name='IDomainEvent'))
  INSERT INTO ElementImplementation (ClassId,InterfaceId) VALUES ((SELECT Id FROM CodeElement WHERE Name='TabClosedEvent'),(SELECT Id FROM CodeElement WHERE Name='IDomainEvent'));

-- ── 7. ELEMENT DEPENDENCIES (ConstructorInjection) ───────
-- Handlers -> Repositories + UnitOfWork + IMapper
-- CreateTabCommandHandler
IF NOT EXISTS (SELECT 1 FROM ElementDependency WHERE SourceElementId=(SELECT Id FROM CodeElement WHERE Name='CreateTabCommandHandler') AND TargetElementId=(SELECT Id FROM CodeElement WHERE Name='ITabRepository') AND DependencyType='ConstructorInjection')
  INSERT INTO ElementDependency (SourceElementId,TargetElementId,DependencyType,IsDirect) VALUES ((SELECT Id FROM CodeElement WHERE Name='CreateTabCommandHandler'),(SELECT Id FROM CodeElement WHERE Name='ITabRepository'),'ConstructorInjection',1);
IF NOT EXISTS (SELECT 1 FROM ElementDependency WHERE SourceElementId=(SELECT Id FROM CodeElement WHERE Name='CreateTabCommandHandler') AND TargetElementId=(SELECT Id FROM CodeElement WHERE Name='IUnitOfWork') AND DependencyType='ConstructorInjection')
  INSERT INTO ElementDependency (SourceElementId,TargetElementId,DependencyType,IsDirect) VALUES ((SELECT Id FROM CodeElement WHERE Name='CreateTabCommandHandler'),(SELECT Id FROM CodeElement WHERE Name='IUnitOfWork'),'ConstructorInjection',1);
-- CloseTabCommandHandler
IF NOT EXISTS (SELECT 1 FROM ElementDependency WHERE SourceElementId=(SELECT Id FROM CodeElement WHERE Name='CloseTabCommandHandler') AND TargetElementId=(SELECT Id FROM CodeElement WHERE Name='ITabRepository') AND DependencyType='ConstructorInjection')
  INSERT INTO ElementDependency (SourceElementId,TargetElementId,DependencyType,IsDirect) VALUES ((SELECT Id FROM CodeElement WHERE Name='CloseTabCommandHandler'),(SELECT Id FROM CodeElement WHERE Name='ITabRepository'),'ConstructorInjection',1);
IF NOT EXISTS (SELECT 1 FROM ElementDependency WHERE SourceElementId=(SELECT Id FROM CodeElement WHERE Name='CloseTabCommandHandler') AND TargetElementId=(SELECT Id FROM CodeElement WHERE Name='IUnitOfWork') AND DependencyType='ConstructorInjection')
  INSERT INTO ElementDependency (SourceElementId,TargetElementId,DependencyType,IsDirect) VALUES ((SELECT Id FROM CodeElement WHERE Name='CloseTabCommandHandler'),(SELECT Id FROM CodeElement WHERE Name='IUnitOfWork'),'ConstructorInjection',1);
-- CancelTabCommandHandler
IF NOT EXISTS (SELECT 1 FROM ElementDependency WHERE SourceElementId=(SELECT Id FROM CodeElement WHERE Name='CancelTabCommandHandler') AND TargetElementId=(SELECT Id FROM CodeElement WHERE Name='ITabRepository') AND DependencyType='ConstructorInjection')
  INSERT INTO ElementDependency (SourceElementId,TargetElementId,DependencyType,IsDirect) VALUES ((SELECT Id FROM CodeElement WHERE Name='CancelTabCommandHandler'),(SELECT Id FROM CodeElement WHERE Name='ITabRepository'),'ConstructorInjection',1);
IF NOT EXISTS (SELECT 1 FROM ElementDependency WHERE SourceElementId=(SELECT Id FROM CodeElement WHERE Name='CancelTabCommandHandler') AND TargetElementId=(SELECT Id FROM CodeElement WHERE Name='IUnitOfWork') AND DependencyType='ConstructorInjection')
  INSERT INTO ElementDependency (SourceElementId,TargetElementId,DependencyType,IsDirect) VALUES ((SELECT Id FROM CodeElement WHERE Name='CancelTabCommandHandler'),(SELECT Id FROM CodeElement WHERE Name='IUnitOfWork'),'ConstructorInjection',1);
-- CreateOrderCommandHandler
IF NOT EXISTS (SELECT 1 FROM ElementDependency WHERE SourceElementId=(SELECT Id FROM CodeElement WHERE Name='CreateOrderCommandHandler') AND TargetElementId=(SELECT Id FROM CodeElement WHERE Name='IOrderRepository') AND DependencyType='ConstructorInjection')
  INSERT INTO ElementDependency (SourceElementId,TargetElementId,DependencyType,IsDirect) VALUES ((SELECT Id FROM CodeElement WHERE Name='CreateOrderCommandHandler'),(SELECT Id FROM CodeElement WHERE Name='IOrderRepository'),'ConstructorInjection',1);
IF NOT EXISTS (SELECT 1 FROM ElementDependency WHERE SourceElementId=(SELECT Id FROM CodeElement WHERE Name='CreateOrderCommandHandler') AND TargetElementId=(SELECT Id FROM CodeElement WHERE Name='ITabRepository') AND DependencyType='ConstructorInjection')
  INSERT INTO ElementDependency (SourceElementId,TargetElementId,DependencyType,IsDirect) VALUES ((SELECT Id FROM CodeElement WHERE Name='CreateOrderCommandHandler'),(SELECT Id FROM CodeElement WHERE Name='ITabRepository'),'ConstructorInjection',1);
IF NOT EXISTS (SELECT 1 FROM ElementDependency WHERE SourceElementId=(SELECT Id FROM CodeElement WHERE Name='CreateOrderCommandHandler') AND TargetElementId=(SELECT Id FROM CodeElement WHERE Name='IUnitOfWork') AND DependencyType='ConstructorInjection')
  INSERT INTO ElementDependency (SourceElementId,TargetElementId,DependencyType,IsDirect) VALUES ((SELECT Id FROM CodeElement WHERE Name='CreateOrderCommandHandler'),(SELECT Id FROM CodeElement WHERE Name='IUnitOfWork'),'ConstructorInjection',1);
-- AdvanceOrderStatusCommandHandler
IF NOT EXISTS (SELECT 1 FROM ElementDependency WHERE SourceElementId=(SELECT Id FROM CodeElement WHERE Name='AdvanceOrderStatusCommandHandler') AND TargetElementId=(SELECT Id FROM CodeElement WHERE Name='IOrderRepository') AND DependencyType='ConstructorInjection')
  INSERT INTO ElementDependency (SourceElementId,TargetElementId,DependencyType,IsDirect) VALUES ((SELECT Id FROM CodeElement WHERE Name='AdvanceOrderStatusCommandHandler'),(SELECT Id FROM CodeElement WHERE Name='IOrderRepository'),'ConstructorInjection',1);
IF NOT EXISTS (SELECT 1 FROM ElementDependency WHERE SourceElementId=(SELECT Id FROM CodeElement WHERE Name='AdvanceOrderStatusCommandHandler') AND TargetElementId=(SELECT Id FROM CodeElement WHERE Name='IUnitOfWork') AND DependencyType='ConstructorInjection')
  INSERT INTO ElementDependency (SourceElementId,TargetElementId,DependencyType,IsDirect) VALUES ((SELECT Id FROM CodeElement WHERE Name='AdvanceOrderStatusCommandHandler'),(SELECT Id FROM CodeElement WHERE Name='IUnitOfWork'),'ConstructorInjection',1);
-- CancelOrderCommandHandler
IF NOT EXISTS (SELECT 1 FROM ElementDependency WHERE SourceElementId=(SELECT Id FROM CodeElement WHERE Name='CancelOrderCommandHandler') AND TargetElementId=(SELECT Id FROM CodeElement WHERE Name='IOrderRepository') AND DependencyType='ConstructorInjection')
  INSERT INTO ElementDependency (SourceElementId,TargetElementId,DependencyType,IsDirect) VALUES ((SELECT Id FROM CodeElement WHERE Name='CancelOrderCommandHandler'),(SELECT Id FROM CodeElement WHERE Name='IOrderRepository'),'ConstructorInjection',1);
IF NOT EXISTS (SELECT 1 FROM ElementDependency WHERE SourceElementId=(SELECT Id FROM CodeElement WHERE Name='CancelOrderCommandHandler') AND TargetElementId=(SELECT Id FROM CodeElement WHERE Name='IUnitOfWork') AND DependencyType='ConstructorInjection')
  INSERT INTO ElementDependency (SourceElementId,TargetElementId,DependencyType,IsDirect) VALUES ((SELECT Id FROM CodeElement WHERE Name='CancelOrderCommandHandler'),(SELECT Id FROM CodeElement WHERE Name='IUnitOfWork'),'ConstructorInjection',1);
-- CreateOrderItemCommandHandler
IF NOT EXISTS (SELECT 1 FROM ElementDependency WHERE SourceElementId=(SELECT Id FROM CodeElement WHERE Name='CreateOrderItemCommandHandler') AND TargetElementId=(SELECT Id FROM CodeElement WHERE Name='IOrderItemRepository') AND DependencyType='ConstructorInjection')
  INSERT INTO ElementDependency (SourceElementId,TargetElementId,DependencyType,IsDirect) VALUES ((SELECT Id FROM CodeElement WHERE Name='CreateOrderItemCommandHandler'),(SELECT Id FROM CodeElement WHERE Name='IOrderItemRepository'),'ConstructorInjection',1);
IF NOT EXISTS (SELECT 1 FROM ElementDependency WHERE SourceElementId=(SELECT Id FROM CodeElement WHERE Name='CreateOrderItemCommandHandler') AND TargetElementId=(SELECT Id FROM CodeElement WHERE Name='IOrderRepository') AND DependencyType='ConstructorInjection')
  INSERT INTO ElementDependency (SourceElementId,TargetElementId,DependencyType,IsDirect) VALUES ((SELECT Id FROM CodeElement WHERE Name='CreateOrderItemCommandHandler'),(SELECT Id FROM CodeElement WHERE Name='IOrderRepository'),'ConstructorInjection',1);
IF NOT EXISTS (SELECT 1 FROM ElementDependency WHERE SourceElementId=(SELECT Id FROM CodeElement WHERE Name='CreateOrderItemCommandHandler') AND TargetElementId=(SELECT Id FROM CodeElement WHERE Name='IProductRepository') AND DependencyType='ConstructorInjection')
  INSERT INTO ElementDependency (SourceElementId,TargetElementId,DependencyType,IsDirect) VALUES ((SELECT Id FROM CodeElement WHERE Name='CreateOrderItemCommandHandler'),(SELECT Id FROM CodeElement WHERE Name='IProductRepository'),'ConstructorInjection',1);
IF NOT EXISTS (SELECT 1 FROM ElementDependency WHERE SourceElementId=(SELECT Id FROM CodeElement WHERE Name='CreateOrderItemCommandHandler') AND TargetElementId=(SELECT Id FROM CodeElement WHERE Name='IUnitOfWork') AND DependencyType='ConstructorInjection')
  INSERT INTO ElementDependency (SourceElementId,TargetElementId,DependencyType,IsDirect) VALUES ((SELECT Id FROM CodeElement WHERE Name='CreateOrderItemCommandHandler'),(SELECT Id FROM CodeElement WHERE Name='IUnitOfWork'),'ConstructorInjection',1);
-- CancelOrderItemCommandHandler
IF NOT EXISTS (SELECT 1 FROM ElementDependency WHERE SourceElementId=(SELECT Id FROM CodeElement WHERE Name='CancelOrderItemCommandHandler') AND TargetElementId=(SELECT Id FROM CodeElement WHERE Name='IOrderItemRepository') AND DependencyType='ConstructorInjection')
  INSERT INTO ElementDependency (SourceElementId,TargetElementId,DependencyType,IsDirect) VALUES ((SELECT Id FROM CodeElement WHERE Name='CancelOrderItemCommandHandler'),(SELECT Id FROM CodeElement WHERE Name='IOrderItemRepository'),'ConstructorInjection',1);
IF NOT EXISTS (SELECT 1 FROM ElementDependency WHERE SourceElementId=(SELECT Id FROM CodeElement WHERE Name='CancelOrderItemCommandHandler') AND TargetElementId=(SELECT Id FROM CodeElement WHERE Name='IUnitOfWork') AND DependencyType='ConstructorInjection')
  INSERT INTO ElementDependency (SourceElementId,TargetElementId,DependencyType,IsDirect) VALUES ((SELECT Id FROM CodeElement WHERE Name='CancelOrderItemCommandHandler'),(SELECT Id FROM CodeElement WHERE Name='IUnitOfWork'),'ConstructorInjection',1);
-- CreateTabCheckoutCommandHandler
IF NOT EXISTS (SELECT 1 FROM ElementDependency WHERE SourceElementId=(SELECT Id FROM CodeElement WHERE Name='CreateTabCheckoutCommandHandler') AND TargetElementId=(SELECT Id FROM CodeElement WHERE Name='ITabCheckoutRepository') AND DependencyType='ConstructorInjection')
  INSERT INTO ElementDependency (SourceElementId,TargetElementId,DependencyType,IsDirect) VALUES ((SELECT Id FROM CodeElement WHERE Name='CreateTabCheckoutCommandHandler'),(SELECT Id FROM CodeElement WHERE Name='ITabCheckoutRepository'),'ConstructorInjection',1);
IF NOT EXISTS (SELECT 1 FROM ElementDependency WHERE SourceElementId=(SELECT Id FROM CodeElement WHERE Name='CreateTabCheckoutCommandHandler') AND TargetElementId=(SELECT Id FROM CodeElement WHERE Name='ITabRepository') AND DependencyType='ConstructorInjection')
  INSERT INTO ElementDependency (SourceElementId,TargetElementId,DependencyType,IsDirect) VALUES ((SELECT Id FROM CodeElement WHERE Name='CreateTabCheckoutCommandHandler'),(SELECT Id FROM CodeElement WHERE Name='ITabRepository'),'ConstructorInjection',1);
IF NOT EXISTS (SELECT 1 FROM ElementDependency WHERE SourceElementId=(SELECT Id FROM CodeElement WHERE Name='CreateTabCheckoutCommandHandler') AND TargetElementId=(SELECT Id FROM CodeElement WHERE Name='IUnitOfWork') AND DependencyType='ConstructorInjection')
  INSERT INTO ElementDependency (SourceElementId,TargetElementId,DependencyType,IsDirect) VALUES ((SELECT Id FROM CodeElement WHERE Name='CreateTabCheckoutCommandHandler'),(SELECT Id FROM CodeElement WHERE Name='IUnitOfWork'),'ConstructorInjection',1);
-- CreateTabPaymentCommandHandler
IF NOT EXISTS (SELECT 1 FROM ElementDependency WHERE SourceElementId=(SELECT Id FROM CodeElement WHERE Name='CreateTabPaymentCommandHandler') AND TargetElementId=(SELECT Id FROM CodeElement WHERE Name='ITabPaymentRepository') AND DependencyType='ConstructorInjection')
  INSERT INTO ElementDependency (SourceElementId,TargetElementId,DependencyType,IsDirect) VALUES ((SELECT Id FROM CodeElement WHERE Name='CreateTabPaymentCommandHandler'),(SELECT Id FROM CodeElement WHERE Name='ITabPaymentRepository'),'ConstructorInjection',1);
IF NOT EXISTS (SELECT 1 FROM ElementDependency WHERE SourceElementId=(SELECT Id FROM CodeElement WHERE Name='CreateTabPaymentCommandHandler') AND TargetElementId=(SELECT Id FROM CodeElement WHERE Name='ITabCheckoutRepository') AND DependencyType='ConstructorInjection')
  INSERT INTO ElementDependency (SourceElementId,TargetElementId,DependencyType,IsDirect) VALUES ((SELECT Id FROM CodeElement WHERE Name='CreateTabPaymentCommandHandler'),(SELECT Id FROM CodeElement WHERE Name='ITabCheckoutRepository'),'ConstructorInjection',1);
IF NOT EXISTS (SELECT 1 FROM ElementDependency WHERE SourceElementId=(SELECT Id FROM CodeElement WHERE Name='CreateTabPaymentCommandHandler') AND TargetElementId=(SELECT Id FROM CodeElement WHERE Name='IUnitOfWork') AND DependencyType='ConstructorInjection')
  INSERT INTO ElementDependency (SourceElementId,TargetElementId,DependencyType,IsDirect) VALUES ((SELECT Id FROM CodeElement WHERE Name='CreateTabPaymentCommandHandler'),(SELECT Id FROM CodeElement WHERE Name='IUnitOfWork'),'ConstructorInjection',1);
-- CreateRoleCommandHandler
IF NOT EXISTS (SELECT 1 FROM ElementDependency WHERE SourceElementId=(SELECT Id FROM CodeElement WHERE Name='CreateRoleCommandHandler') AND TargetElementId=(SELECT Id FROM CodeElement WHERE Name='IRoleRepository') AND DependencyType='ConstructorInjection')
  INSERT INTO ElementDependency (SourceElementId,TargetElementId,DependencyType,IsDirect) VALUES ((SELECT Id FROM CodeElement WHERE Name='CreateRoleCommandHandler'),(SELECT Id FROM CodeElement WHERE Name='IRoleRepository'),'ConstructorInjection',1);
IF NOT EXISTS (SELECT 1 FROM ElementDependency WHERE SourceElementId=(SELECT Id FROM CodeElement WHERE Name='CreateRoleCommandHandler') AND TargetElementId=(SELECT Id FROM CodeElement WHERE Name='IUnitOfWork') AND DependencyType='ConstructorInjection')
  INSERT INTO ElementDependency (SourceElementId,TargetElementId,DependencyType,IsDirect) VALUES ((SELECT Id FROM CodeElement WHERE Name='CreateRoleCommandHandler'),(SELECT Id FROM CodeElement WHERE Name='IUnitOfWork'),'ConstructorInjection',1);
-- CreateEmployeeCommandHandler
IF NOT EXISTS (SELECT 1 FROM ElementDependency WHERE SourceElementId=(SELECT Id FROM CodeElement WHERE Name='CreateEmployeeCommandHandler') AND TargetElementId=(SELECT Id FROM CodeElement WHERE Name='IEmployeeRepository') AND DependencyType='ConstructorInjection')
  INSERT INTO ElementDependency (SourceElementId,TargetElementId,DependencyType,IsDirect) VALUES ((SELECT Id FROM CodeElement WHERE Name='CreateEmployeeCommandHandler'),(SELECT Id FROM CodeElement WHERE Name='IEmployeeRepository'),'ConstructorInjection',1);
IF NOT EXISTS (SELECT 1 FROM ElementDependency WHERE SourceElementId=(SELECT Id FROM CodeElement WHERE Name='CreateEmployeeCommandHandler') AND TargetElementId=(SELECT Id FROM CodeElement WHERE Name='IRoleRepository') AND DependencyType='ConstructorInjection')
  INSERT INTO ElementDependency (SourceElementId,TargetElementId,DependencyType,IsDirect) VALUES ((SELECT Id FROM CodeElement WHERE Name='CreateEmployeeCommandHandler'),(SELECT Id FROM CodeElement WHERE Name='IRoleRepository'),'ConstructorInjection',1);
IF NOT EXISTS (SELECT 1 FROM ElementDependency WHERE SourceElementId=(SELECT Id FROM CodeElement WHERE Name='CreateEmployeeCommandHandler') AND TargetElementId=(SELECT Id FROM CodeElement WHERE Name='IUnitOfWork') AND DependencyType='ConstructorInjection')
  INSERT INTO ElementDependency (SourceElementId,TargetElementId,DependencyType,IsDirect) VALUES ((SELECT Id FROM CodeElement WHERE Name='CreateEmployeeCommandHandler'),(SELECT Id FROM CodeElement WHERE Name='IUnitOfWork'),'ConstructorInjection',1);
-- CreateProductCommandHandler
IF NOT EXISTS (SELECT 1 FROM ElementDependency WHERE SourceElementId=(SELECT Id FROM CodeElement WHERE Name='CreateProductCommandHandler') AND TargetElementId=(SELECT Id FROM CodeElement WHERE Name='IProductRepository') AND DependencyType='ConstructorInjection')
  INSERT INTO ElementDependency (SourceElementId,TargetElementId,DependencyType,IsDirect) VALUES ((SELECT Id FROM CodeElement WHERE Name='CreateProductCommandHandler'),(SELECT Id FROM CodeElement WHERE Name='IProductRepository'),'ConstructorInjection',1);
IF NOT EXISTS (SELECT 1 FROM ElementDependency WHERE SourceElementId=(SELECT Id FROM CodeElement WHERE Name='CreateProductCommandHandler') AND TargetElementId=(SELECT Id FROM CodeElement WHERE Name='IUnitOfWork') AND DependencyType='ConstructorInjection')
  INSERT INTO ElementDependency (SourceElementId,TargetElementId,DependencyType,IsDirect) VALUES ((SELECT Id FROM CodeElement WHERE Name='CreateProductCommandHandler'),(SELECT Id FROM CodeElement WHERE Name='IUnitOfWork'),'ConstructorInjection',1);
-- CreateStockMovementCommandHandler
IF NOT EXISTS (SELECT 1 FROM ElementDependency WHERE SourceElementId=(SELECT Id FROM CodeElement WHERE Name='CreateStockMovementCommandHandler') AND TargetElementId=(SELECT Id FROM CodeElement WHERE Name='IStockMovementRepository') AND DependencyType='ConstructorInjection')
  INSERT INTO ElementDependency (SourceElementId,TargetElementId,DependencyType,IsDirect) VALUES ((SELECT Id FROM CodeElement WHERE Name='CreateStockMovementCommandHandler'),(SELECT Id FROM CodeElement WHERE Name='IStockMovementRepository'),'ConstructorInjection',1);
IF NOT EXISTS (SELECT 1 FROM ElementDependency WHERE SourceElementId=(SELECT Id FROM CodeElement WHERE Name='CreateStockMovementCommandHandler') AND TargetElementId=(SELECT Id FROM CodeElement WHERE Name='IProductRepository') AND DependencyType='ConstructorInjection')
  INSERT INTO ElementDependency (SourceElementId,TargetElementId,DependencyType,IsDirect) VALUES ((SELECT Id FROM CodeElement WHERE Name='CreateStockMovementCommandHandler'),(SELECT Id FROM CodeElement WHERE Name='IProductRepository'),'ConstructorInjection',1);
IF NOT EXISTS (SELECT 1 FROM ElementDependency WHERE SourceElementId=(SELECT Id FROM CodeElement WHERE Name='CreateStockMovementCommandHandler') AND TargetElementId=(SELECT Id FROM CodeElement WHERE Name='IUnitOfWork') AND DependencyType='ConstructorInjection')
  INSERT INTO ElementDependency (SourceElementId,TargetElementId,DependencyType,IsDirect) VALUES ((SELECT Id FROM CodeElement WHERE Name='CreateStockMovementCommandHandler'),(SELECT Id FROM CodeElement WHERE Name='IUnitOfWork'),'ConstructorInjection',1);
-- OpenCashRegisterCommandHandler
IF NOT EXISTS (SELECT 1 FROM ElementDependency WHERE SourceElementId=(SELECT Id FROM CodeElement WHERE Name='OpenCashRegisterCommandHandler') AND TargetElementId=(SELECT Id FROM CodeElement WHERE Name='ICashRegisterOpeningRepository') AND DependencyType='ConstructorInjection')
  INSERT INTO ElementDependency (SourceElementId,TargetElementId,DependencyType,IsDirect) VALUES ((SELECT Id FROM CodeElement WHERE Name='OpenCashRegisterCommandHandler'),(SELECT Id FROM CodeElement WHERE Name='ICashRegisterOpeningRepository'),'ConstructorInjection',1);
IF NOT EXISTS (SELECT 1 FROM ElementDependency WHERE SourceElementId=(SELECT Id FROM CodeElement WHERE Name='OpenCashRegisterCommandHandler') AND TargetElementId=(SELECT Id FROM CodeElement WHERE Name='IUnitOfWork') AND DependencyType='ConstructorInjection')
  INSERT INTO ElementDependency (SourceElementId,TargetElementId,DependencyType,IsDirect) VALUES ((SELECT Id FROM CodeElement WHERE Name='OpenCashRegisterCommandHandler'),(SELECT Id FROM CodeElement WHERE Name='IUnitOfWork'),'ConstructorInjection',1);
-- CloseCashRegisterCommandHandler
IF NOT EXISTS (SELECT 1 FROM ElementDependency WHERE SourceElementId=(SELECT Id FROM CodeElement WHERE Name='CloseCashRegisterCommandHandler') AND TargetElementId=(SELECT Id FROM CodeElement WHERE Name='ICashRegisterClosingRepository') AND DependencyType='ConstructorInjection')
  INSERT INTO ElementDependency (SourceElementId,TargetElementId,DependencyType,IsDirect) VALUES ((SELECT Id FROM CodeElement WHERE Name='CloseCashRegisterCommandHandler'),(SELECT Id FROM CodeElement WHERE Name='ICashRegisterClosingRepository'),'ConstructorInjection',1);
IF NOT EXISTS (SELECT 1 FROM ElementDependency WHERE SourceElementId=(SELECT Id FROM CodeElement WHERE Name='CloseCashRegisterCommandHandler') AND TargetElementId=(SELECT Id FROM CodeElement WHERE Name='ICashRegisterOpeningRepository') AND DependencyType='ConstructorInjection')
  INSERT INTO ElementDependency (SourceElementId,TargetElementId,DependencyType,IsDirect) VALUES ((SELECT Id FROM CodeElement WHERE Name='CloseCashRegisterCommandHandler'),(SELECT Id FROM CodeElement WHERE Name='ICashRegisterOpeningRepository'),'ConstructorInjection',1);
IF NOT EXISTS (SELECT 1 FROM ElementDependency WHERE SourceElementId=(SELECT Id FROM CodeElement WHERE Name='CloseCashRegisterCommandHandler') AND TargetElementId=(SELECT Id FROM CodeElement WHERE Name='IUnitOfWork') AND DependencyType='ConstructorInjection')
  INSERT INTO ElementDependency (SourceElementId,TargetElementId,DependencyType,IsDirect) VALUES ((SELECT Id FROM CodeElement WHERE Name='CloseCashRegisterCommandHandler'),(SELECT Id FROM CodeElement WHERE Name='IUnitOfWork'),'ConstructorInjection',1);
-- Controllers -> IMediator (ModelParameter)
IF NOT EXISTS (SELECT 1 FROM ElementDependency WHERE SourceElementId=(SELECT Id FROM CodeElement WHERE Name='TabsController') AND TargetElementId=(SELECT Id FROM CodeElement WHERE Name='CreateTabCommand') AND DependencyType='MethodParameter')
  INSERT INTO ElementDependency (SourceElementId,TargetElementId,DependencyType,IsDirect) VALUES ((SELECT Id FROM CodeElement WHERE Name='TabsController'),(SELECT Id FROM CodeElement WHERE Name='CreateTabCommand'),'MethodParameter',1);
IF NOT EXISTS (SELECT 1 FROM ElementDependency WHERE SourceElementId=(SELECT Id FROM CodeElement WHERE Name='OrdersController') AND TargetElementId=(SELECT Id FROM CodeElement WHERE Name='CreateOrderCommand') AND DependencyType='MethodParameter')
  INSERT INTO ElementDependency (SourceElementId,TargetElementId,DependencyType,IsDirect) VALUES ((SELECT Id FROM CodeElement WHERE Name='OrdersController'),(SELECT Id FROM CodeElement WHERE Name='CreateOrderCommand'),'MethodParameter',1);

-- ── 8. HANDLER CONTRACTS ─────────────────────────────────
-- HandlerId, InputId, OutputId
IF NOT EXISTS (SELECT 1 FROM HandlerContract WHERE HandlerId=(SELECT Id FROM CodeElement WHERE Name='CreateTabCommandHandler'))
  INSERT INTO HandlerContract (HandlerId,InputId,OutputId) VALUES ((SELECT Id FROM CodeElement WHERE Name='CreateTabCommandHandler'),(SELECT Id FROM CodeElement WHERE Name='CreateTabCommand'),(SELECT Id FROM CodeElement WHERE Name='TabDto'));
IF NOT EXISTS (SELECT 1 FROM HandlerContract WHERE HandlerId=(SELECT Id FROM CodeElement WHERE Name='CloseTabCommandHandler'))
  INSERT INTO HandlerContract (HandlerId,InputId,OutputId) VALUES ((SELECT Id FROM CodeElement WHERE Name='CloseTabCommandHandler'),(SELECT Id FROM CodeElement WHERE Name='CloseTabCommand'),(SELECT Id FROM CodeElement WHERE Name='TabDto'));
IF NOT EXISTS (SELECT 1 FROM HandlerContract WHERE HandlerId=(SELECT Id FROM CodeElement WHERE Name='CancelTabCommandHandler'))
  INSERT INTO HandlerContract (HandlerId,InputId,OutputId) VALUES ((SELECT Id FROM CodeElement WHERE Name='CancelTabCommandHandler'),(SELECT Id FROM CodeElement WHERE Name='CancelTabCommand'),(SELECT Id FROM CodeElement WHERE Name='TabDto'));
IF NOT EXISTS (SELECT 1 FROM HandlerContract WHERE HandlerId=(SELECT Id FROM CodeElement WHERE Name='GetAllTabsQueryHandler'))
  INSERT INTO HandlerContract (HandlerId,InputId,OutputId) VALUES ((SELECT Id FROM CodeElement WHERE Name='GetAllTabsQueryHandler'),(SELECT Id FROM CodeElement WHERE Name='GetAllTabsQuery'),(SELECT Id FROM CodeElement WHERE Name='TabDto'));
IF NOT EXISTS (SELECT 1 FROM HandlerContract WHERE HandlerId=(SELECT Id FROM CodeElement WHERE Name='GetTabByIdQueryHandler'))
  INSERT INTO HandlerContract (HandlerId,InputId,OutputId) VALUES ((SELECT Id FROM CodeElement WHERE Name='GetTabByIdQueryHandler'),(SELECT Id FROM CodeElement WHERE Name='GetTabByIdQuery'),(SELECT Id FROM CodeElement WHERE Name='TabDto'));
IF NOT EXISTS (SELECT 1 FROM HandlerContract WHERE HandlerId=(SELECT Id FROM CodeElement WHERE Name='CreateOrderCommandHandler'))
  INSERT INTO HandlerContract (HandlerId,InputId,OutputId) VALUES ((SELECT Id FROM CodeElement WHERE Name='CreateOrderCommandHandler'),(SELECT Id FROM CodeElement WHERE Name='CreateOrderCommand'),(SELECT Id FROM CodeElement WHERE Name='OrderDto'));
IF NOT EXISTS (SELECT 1 FROM HandlerContract WHERE HandlerId=(SELECT Id FROM CodeElement WHERE Name='AdvanceOrderStatusCommandHandler'))
  INSERT INTO HandlerContract (HandlerId,InputId,OutputId) VALUES ((SELECT Id FROM CodeElement WHERE Name='AdvanceOrderStatusCommandHandler'),(SELECT Id FROM CodeElement WHERE Name='AdvanceOrderStatusCommand'),(SELECT Id FROM CodeElement WHERE Name='OrderDto'));
IF NOT EXISTS (SELECT 1 FROM HandlerContract WHERE HandlerId=(SELECT Id FROM CodeElement WHERE Name='CancelOrderCommandHandler'))
  INSERT INTO HandlerContract (HandlerId,InputId,OutputId) VALUES ((SELECT Id FROM CodeElement WHERE Name='CancelOrderCommandHandler'),(SELECT Id FROM CodeElement WHERE Name='CancelOrderCommand'),(SELECT Id FROM CodeElement WHERE Name='OrderDto'));
IF NOT EXISTS (SELECT 1 FROM HandlerContract WHERE HandlerId=(SELECT Id FROM CodeElement WHERE Name='GetAllOrdersQueryHandler'))
  INSERT INTO HandlerContract (HandlerId,InputId,OutputId) VALUES ((SELECT Id FROM CodeElement WHERE Name='GetAllOrdersQueryHandler'),(SELECT Id FROM CodeElement WHERE Name='GetAllOrdersQuery'),(SELECT Id FROM CodeElement WHERE Name='OrderDto'));
IF NOT EXISTS (SELECT 1 FROM HandlerContract WHERE HandlerId=(SELECT Id FROM CodeElement WHERE Name='GetOrderByIdQueryHandler'))
  INSERT INTO HandlerContract (HandlerId,InputId,OutputId) VALUES ((SELECT Id FROM CodeElement WHERE Name='GetOrderByIdQueryHandler'),(SELECT Id FROM CodeElement WHERE Name='GetOrderByIdQuery'),(SELECT Id FROM CodeElement WHERE Name='OrderDto'));
IF NOT EXISTS (SELECT 1 FROM HandlerContract WHERE HandlerId=(SELECT Id FROM CodeElement WHERE Name='CreateOrderItemCommandHandler'))
  INSERT INTO HandlerContract (HandlerId,InputId,OutputId) VALUES ((SELECT Id FROM CodeElement WHERE Name='CreateOrderItemCommandHandler'),(SELECT Id FROM CodeElement WHERE Name='CreateOrderItemCommand'),(SELECT Id FROM CodeElement WHERE Name='OrderDto'));
IF NOT EXISTS (SELECT 1 FROM HandlerContract WHERE HandlerId=(SELECT Id FROM CodeElement WHERE Name='CancelOrderItemCommandHandler'))
  INSERT INTO HandlerContract (HandlerId,InputId,OutputId) VALUES ((SELECT Id FROM CodeElement WHERE Name='CancelOrderItemCommandHandler'),(SELECT Id FROM CodeElement WHERE Name='CancelOrderItemCommand'),(SELECT Id FROM CodeElement WHERE Name='OrderDto'));
IF NOT EXISTS (SELECT 1 FROM HandlerContract WHERE HandlerId=(SELECT Id FROM CodeElement WHERE Name='CreateTabCheckoutCommandHandler'))
  INSERT INTO HandlerContract (HandlerId,InputId,OutputId) VALUES ((SELECT Id FROM CodeElement WHERE Name='CreateTabCheckoutCommandHandler'),(SELECT Id FROM CodeElement WHERE Name='CreateTabCheckoutCommand'),(SELECT Id FROM CodeElement WHERE Name='TabCheckoutDto'));
IF NOT EXISTS (SELECT 1 FROM HandlerContract WHERE HandlerId=(SELECT Id FROM CodeElement WHERE Name='GetTabCheckoutByIdQueryHandler'))
  INSERT INTO HandlerContract (HandlerId,InputId,OutputId) VALUES ((SELECT Id FROM CodeElement WHERE Name='GetTabCheckoutByIdQueryHandler'),(SELECT Id FROM CodeElement WHERE Name='GetTabCheckoutByIdQuery'),(SELECT Id FROM CodeElement WHERE Name='TabCheckoutDto'));
IF NOT EXISTS (SELECT 1 FROM HandlerContract WHERE HandlerId=(SELECT Id FROM CodeElement WHERE Name='CreateTabPaymentCommandHandler'))
  INSERT INTO HandlerContract (HandlerId,InputId,OutputId) VALUES ((SELECT Id FROM CodeElement WHERE Name='CreateTabPaymentCommandHandler'),(SELECT Id FROM CodeElement WHERE Name='CreateTabPaymentCommand'),(SELECT Id FROM CodeElement WHERE Name='TabPaymentDto'));
IF NOT EXISTS (SELECT 1 FROM HandlerContract WHERE HandlerId=(SELECT Id FROM CodeElement WHERE Name='GetTabPaymentsByCheckoutQueryHandler'))
  INSERT INTO HandlerContract (HandlerId,InputId,OutputId) VALUES ((SELECT Id FROM CodeElement WHERE Name='GetTabPaymentsByCheckoutQueryHandler'),(SELECT Id FROM CodeElement WHERE Name='GetTabPaymentsByCheckoutQuery'),(SELECT Id FROM CodeElement WHERE Name='TabPaymentDto'));
IF NOT EXISTS (SELECT 1 FROM HandlerContract WHERE HandlerId=(SELECT Id FROM CodeElement WHERE Name='CreateRoleCommandHandler'))
  INSERT INTO HandlerContract (HandlerId,InputId,OutputId) VALUES ((SELECT Id FROM CodeElement WHERE Name='CreateRoleCommandHandler'),(SELECT Id FROM CodeElement WHERE Name='CreateRoleCommand'),(SELECT Id FROM CodeElement WHERE Name='RoleDto'));
IF NOT EXISTS (SELECT 1 FROM HandlerContract WHERE HandlerId=(SELECT Id FROM CodeElement WHERE Name='GetAllRolesQueryHandler'))
  INSERT INTO HandlerContract (HandlerId,InputId,OutputId) VALUES ((SELECT Id FROM CodeElement WHERE Name='GetAllRolesQueryHandler'),(SELECT Id FROM CodeElement WHERE Name='GetAllRolesQuery'),(SELECT Id FROM CodeElement WHERE Name='RoleDto'));
IF NOT EXISTS (SELECT 1 FROM HandlerContract WHERE HandlerId=(SELECT Id FROM CodeElement WHERE Name='GetRoleByIdQueryHandler'))
  INSERT INTO HandlerContract (HandlerId,InputId,OutputId) VALUES ((SELECT Id FROM CodeElement WHERE Name='GetRoleByIdQueryHandler'),(SELECT Id FROM CodeElement WHERE Name='GetRoleByIdQuery'),(SELECT Id FROM CodeElement WHERE Name='RoleDto'));
IF NOT EXISTS (SELECT 1 FROM HandlerContract WHERE HandlerId=(SELECT Id FROM CodeElement WHERE Name='CreateEmployeeCommandHandler'))
  INSERT INTO HandlerContract (HandlerId,InputId,OutputId) VALUES ((SELECT Id FROM CodeElement WHERE Name='CreateEmployeeCommandHandler'),(SELECT Id FROM CodeElement WHERE Name='CreateEmployeeCommand'),(SELECT Id FROM CodeElement WHERE Name='EmployeeDto'));
IF NOT EXISTS (SELECT 1 FROM HandlerContract WHERE HandlerId=(SELECT Id FROM CodeElement WHERE Name='GetAllEmployeesQueryHandler'))
  INSERT INTO HandlerContract (HandlerId,InputId,OutputId) VALUES ((SELECT Id FROM CodeElement WHERE Name='GetAllEmployeesQueryHandler'),(SELECT Id FROM CodeElement WHERE Name='GetAllEmployeesQuery'),(SELECT Id FROM CodeElement WHERE Name='EmployeeDto'));
IF NOT EXISTS (SELECT 1 FROM HandlerContract WHERE HandlerId=(SELECT Id FROM CodeElement WHERE Name='GetEmployeeByIdQueryHandler'))
  INSERT INTO HandlerContract (HandlerId,InputId,OutputId) VALUES ((SELECT Id FROM CodeElement WHERE Name='GetEmployeeByIdQueryHandler'),(SELECT Id FROM CodeElement WHERE Name='GetEmployeeByIdQuery'),(SELECT Id FROM CodeElement WHERE Name='EmployeeDto'));
IF NOT EXISTS (SELECT 1 FROM HandlerContract WHERE HandlerId=(SELECT Id FROM CodeElement WHERE Name='CreateProductCommandHandler'))
  INSERT INTO HandlerContract (HandlerId,InputId,OutputId) VALUES ((SELECT Id FROM CodeElement WHERE Name='CreateProductCommandHandler'),(SELECT Id FROM CodeElement WHERE Name='CreateProductCommand'),(SELECT Id FROM CodeElement WHERE Name='ProductDto'));
IF NOT EXISTS (SELECT 1 FROM HandlerContract WHERE HandlerId=(SELECT Id FROM CodeElement WHERE Name='GetAllProductsQueryHandler'))
  INSERT INTO HandlerContract (HandlerId,InputId,OutputId) VALUES ((SELECT Id FROM CodeElement WHERE Name='GetAllProductsQueryHandler'),(SELECT Id FROM CodeElement WHERE Name='GetAllProductsQuery'),(SELECT Id FROM CodeElement WHERE Name='ProductDto'));
IF NOT EXISTS (SELECT 1 FROM HandlerContract WHERE HandlerId=(SELECT Id FROM CodeElement WHERE Name='GetProductByIdQueryHandler'))
  INSERT INTO HandlerContract (HandlerId,InputId,OutputId) VALUES ((SELECT Id FROM CodeElement WHERE Name='GetProductByIdQueryHandler'),(SELECT Id FROM CodeElement WHERE Name='GetProductByIdQuery'),(SELECT Id FROM CodeElement WHERE Name='ProductDto'));
IF NOT EXISTS (SELECT 1 FROM HandlerContract WHERE HandlerId=(SELECT Id FROM CodeElement WHERE Name='CreateProductCategoryCommandHandler'))
  INSERT INTO HandlerContract (HandlerId,InputId,OutputId) VALUES ((SELECT Id FROM CodeElement WHERE Name='CreateProductCategoryCommandHandler'),(SELECT Id FROM CodeElement WHERE Name='CreateProductCategoryCommand'),(SELECT Id FROM CodeElement WHERE Name='ProductCategoryDto'));
IF NOT EXISTS (SELECT 1 FROM HandlerContract WHERE HandlerId=(SELECT Id FROM CodeElement WHERE Name='GetAllProductCategoriesQueryHandler'))
  INSERT INTO HandlerContract (HandlerId,InputId,OutputId) VALUES ((SELECT Id FROM CodeElement WHERE Name='GetAllProductCategoriesQueryHandler'),(SELECT Id FROM CodeElement WHERE Name='GetAllProductCategoriesQuery'),(SELECT Id FROM CodeElement WHERE Name='ProductCategoryDto'));
IF NOT EXISTS (SELECT 1 FROM HandlerContract WHERE HandlerId=(SELECT Id FROM CodeElement WHERE Name='CreatePaymentMethodCommandHandler'))
  INSERT INTO HandlerContract (HandlerId,InputId,OutputId) VALUES ((SELECT Id FROM CodeElement WHERE Name='CreatePaymentMethodCommandHandler'),(SELECT Id FROM CodeElement WHERE Name='CreatePaymentMethodCommand'),(SELECT Id FROM CodeElement WHERE Name='PaymentMethodDto'));
IF NOT EXISTS (SELECT 1 FROM HandlerContract WHERE HandlerId=(SELECT Id FROM CodeElement WHERE Name='GetAllPaymentMethodsQueryHandler'))
  INSERT INTO HandlerContract (HandlerId,InputId,OutputId) VALUES ((SELECT Id FROM CodeElement WHERE Name='GetAllPaymentMethodsQueryHandler'),(SELECT Id FROM CodeElement WHERE Name='GetAllPaymentMethodsQuery'),(SELECT Id FROM CodeElement WHERE Name='PaymentMethodDto'));
IF NOT EXISTS (SELECT 1 FROM HandlerContract WHERE HandlerId=(SELECT Id FROM CodeElement WHERE Name='CreateStockMovementCommandHandler'))
  INSERT INTO HandlerContract (HandlerId,InputId,OutputId) VALUES ((SELECT Id FROM CodeElement WHERE Name='CreateStockMovementCommandHandler'),(SELECT Id FROM CodeElement WHERE Name='CreateStockMovementCommand'),(SELECT Id FROM CodeElement WHERE Name='StockMovementDto'));
IF NOT EXISTS (SELECT 1 FROM HandlerContract WHERE HandlerId=(SELECT Id FROM CodeElement WHERE Name='GetStockMovementsByProductQueryHandler'))
  INSERT INTO HandlerContract (HandlerId,InputId,OutputId) VALUES ((SELECT Id FROM CodeElement WHERE Name='GetStockMovementsByProductQueryHandler'),(SELECT Id FROM CodeElement WHERE Name='GetStockMovementsByProductQuery'),(SELECT Id FROM CodeElement WHERE Name='StockMovementDto'));
IF NOT EXISTS (SELECT 1 FROM HandlerContract WHERE HandlerId=(SELECT Id FROM CodeElement WHERE Name='OpenCashRegisterCommandHandler'))
  INSERT INTO HandlerContract (HandlerId,InputId,OutputId) VALUES ((SELECT Id FROM CodeElement WHERE Name='OpenCashRegisterCommandHandler'),(SELECT Id FROM CodeElement WHERE Name='OpenCashRegisterCommand'),(SELECT Id FROM CodeElement WHERE Name='CashRegisterOpeningDto'));
IF NOT EXISTS (SELECT 1 FROM HandlerContract WHERE HandlerId=(SELECT Id FROM CodeElement WHERE Name='GetActiveCashRegisterQueryHandler'))
  INSERT INTO HandlerContract (HandlerId,InputId,OutputId) VALUES ((SELECT Id FROM CodeElement WHERE Name='GetActiveCashRegisterQueryHandler'),(SELECT Id FROM CodeElement WHERE Name='GetActiveCashRegisterQuery'),(SELECT Id FROM CodeElement WHERE Name='CashRegisterOpeningDto'));
IF NOT EXISTS (SELECT 1 FROM HandlerContract WHERE HandlerId=(SELECT Id FROM CodeElement WHERE Name='CloseCashRegisterCommandHandler'))
  INSERT INTO HandlerContract (HandlerId,InputId,OutputId) VALUES ((SELECT Id FROM CodeElement WHERE Name='CloseCashRegisterCommandHandler'),(SELECT Id FROM CodeElement WHERE Name='CloseCashRegisterCommand'),(SELECT Id FROM CodeElement WHERE Name='CashRegisterClosingDto'));
IF NOT EXISTS (SELECT 1 FROM HandlerContract WHERE HandlerId=(SELECT Id FROM CodeElement WHERE Name='GetCashRegisterClosingByIdQueryHandler'))
  INSERT INTO HandlerContract (HandlerId,InputId,OutputId) VALUES ((SELECT Id FROM CodeElement WHERE Name='GetCashRegisterClosingByIdQueryHandler'),(SELECT Id FROM CodeElement WHERE Name='GetCashRegisterClosingByIdQuery'),(SELECT Id FROM CodeElement WHERE Name='CashRegisterClosingDto'));

-- ── 9. API ENDPOINTS ─────────────────────────────────────
-- TabsController
IF NOT EXISTS (SELECT 1 FROM ApiEndpoint WHERE ControllerId=(SELECT Id FROM CodeElement WHERE Name='TabsController') AND MethodName='GetAll' AND HttpVerb='GET')
  INSERT INTO ApiEndpoint (ControllerId,MethodName,HttpVerb,Route,InputId,OutputId,Roles) VALUES ((SELECT Id FROM CodeElement WHERE Name='TabsController'),'GetAll','GET','api/v1/tabs',NULL,(SELECT Id FROM CodeElement WHERE Name='TabDto'),NULL);
IF NOT EXISTS (SELECT 1 FROM ApiEndpoint WHERE ControllerId=(SELECT Id FROM CodeElement WHERE Name='TabsController') AND MethodName='GetTabById' AND HttpVerb='GET')
  INSERT INTO ApiEndpoint (ControllerId,MethodName,HttpVerb,Route,InputId,OutputId,Roles) VALUES ((SELECT Id FROM CodeElement WHERE Name='TabsController'),'GetTabById','GET','api/v1/tabs/{id}',NULL,(SELECT Id FROM CodeElement WHERE Name='TabDto'),NULL);
IF NOT EXISTS (SELECT 1 FROM ApiEndpoint WHERE ControllerId=(SELECT Id FROM CodeElement WHERE Name='TabsController') AND MethodName='Create' AND HttpVerb='POST')
  INSERT INTO ApiEndpoint (ControllerId,MethodName,HttpVerb,Route,InputId,OutputId,Roles) VALUES ((SELECT Id FROM CodeElement WHERE Name='TabsController'),'Create','POST','api/v1/tabs',(SELECT Id FROM CodeElement WHERE Name='CreateTabCommand'),(SELECT Id FROM CodeElement WHERE Name='TabDto'),NULL);
IF NOT EXISTS (SELECT 1 FROM ApiEndpoint WHERE ControllerId=(SELECT Id FROM CodeElement WHERE Name='TabsController') AND MethodName='Close' AND HttpVerb='POST')
  INSERT INTO ApiEndpoint (ControllerId,MethodName,HttpVerb,Route,InputId,OutputId,Roles) VALUES ((SELECT Id FROM CodeElement WHERE Name='TabsController'),'Close','POST','api/v1/tabs/{id}/close',(SELECT Id FROM CodeElement WHERE Name='CloseTabCommand'),(SELECT Id FROM CodeElement WHERE Name='TabDto'),NULL);
IF NOT EXISTS (SELECT 1 FROM ApiEndpoint WHERE ControllerId=(SELECT Id FROM CodeElement WHERE Name='TabsController') AND MethodName='Cancel' AND HttpVerb='POST')
  INSERT INTO ApiEndpoint (ControllerId,MethodName,HttpVerb,Route,InputId,OutputId,Roles) VALUES ((SELECT Id FROM CodeElement WHERE Name='TabsController'),'Cancel','POST','api/v1/tabs/{id}/cancel',(SELECT Id FROM CodeElement WHERE Name='CancelTabCommand'),(SELECT Id FROM CodeElement WHERE Name='TabDto'),NULL);
-- OrdersController
IF NOT EXISTS (SELECT 1 FROM ApiEndpoint WHERE ControllerId=(SELECT Id FROM CodeElement WHERE Name='OrdersController') AND MethodName='GetAll' AND HttpVerb='GET')
  INSERT INTO ApiEndpoint (ControllerId,MethodName,HttpVerb,Route,InputId,OutputId,Roles) VALUES ((SELECT Id FROM CodeElement WHERE Name='OrdersController'),'GetAll','GET','api/v1/orders',NULL,(SELECT Id FROM CodeElement WHERE Name='OrderDto'),NULL);
IF NOT EXISTS (SELECT 1 FROM ApiEndpoint WHERE ControllerId=(SELECT Id FROM CodeElement WHERE Name='OrdersController') AND MethodName='GetOrderById' AND HttpVerb='GET')
  INSERT INTO ApiEndpoint (ControllerId,MethodName,HttpVerb,Route,InputId,OutputId,Roles) VALUES ((SELECT Id FROM CodeElement WHERE Name='OrdersController'),'GetOrderById','GET','api/v1/orders/{id}',NULL,(SELECT Id FROM CodeElement WHERE Name='OrderDto'),NULL);
IF NOT EXISTS (SELECT 1 FROM ApiEndpoint WHERE ControllerId=(SELECT Id FROM CodeElement WHERE Name='OrdersController') AND MethodName='Create' AND HttpVerb='POST')
  INSERT INTO ApiEndpoint (ControllerId,MethodName,HttpVerb,Route,InputId,OutputId,Roles) VALUES ((SELECT Id FROM CodeElement WHERE Name='OrdersController'),'Create','POST','api/v1/orders',(SELECT Id FROM CodeElement WHERE Name='CreateOrderCommand'),(SELECT Id FROM CodeElement WHERE Name='OrderDto'),NULL);
IF NOT EXISTS (SELECT 1 FROM ApiEndpoint WHERE ControllerId=(SELECT Id FROM CodeElement WHERE Name='OrdersController') AND MethodName='AdvanceStatus' AND HttpVerb='POST')
  INSERT INTO ApiEndpoint (ControllerId,MethodName,HttpVerb,Route,InputId,OutputId,Roles) VALUES ((SELECT Id FROM CodeElement WHERE Name='OrdersController'),'AdvanceStatus','POST','api/v1/orders/{id}/advance-status',NULL,(SELECT Id FROM CodeElement WHERE Name='OrderDto'),NULL);
IF NOT EXISTS (SELECT 1 FROM ApiEndpoint WHERE ControllerId=(SELECT Id FROM CodeElement WHERE Name='OrdersController') AND MethodName='Cancel' AND HttpVerb='POST')
  INSERT INTO ApiEndpoint (ControllerId,MethodName,HttpVerb,Route,InputId,OutputId,Roles) VALUES ((SELECT Id FROM CodeElement WHERE Name='OrdersController'),'Cancel','POST','api/v1/orders/{id}/cancel',NULL,(SELECT Id FROM CodeElement WHERE Name='OrderDto'),NULL);
-- OrderItemsController
IF NOT EXISTS (SELECT 1 FROM ApiEndpoint WHERE ControllerId=(SELECT Id FROM CodeElement WHERE Name='OrderItemsController') AND MethodName='GetOrderItemById' AND HttpVerb='GET')
  INSERT INTO ApiEndpoint (ControllerId,MethodName,HttpVerb,Route,InputId,OutputId,Roles) VALUES ((SELECT Id FROM CodeElement WHERE Name='OrderItemsController'),'GetOrderItemById','GET','api/v1/orderitems/{id}',NULL,(SELECT Id FROM CodeElement WHERE Name='OrderDto'),NULL);
IF NOT EXISTS (SELECT 1 FROM ApiEndpoint WHERE ControllerId=(SELECT Id FROM CodeElement WHERE Name='OrderItemsController') AND MethodName='GetByOrder' AND HttpVerb='GET')
  INSERT INTO ApiEndpoint (ControllerId,MethodName,HttpVerb,Route,InputId,OutputId,Roles) VALUES ((SELECT Id FROM CodeElement WHERE Name='OrderItemsController'),'GetByOrder','GET','api/v1/orderitems',NULL,(SELECT Id FROM CodeElement WHERE Name='OrderDto'),NULL);
IF NOT EXISTS (SELECT 1 FROM ApiEndpoint WHERE ControllerId=(SELECT Id FROM CodeElement WHERE Name='OrderItemsController') AND MethodName='Create' AND HttpVerb='POST')
  INSERT INTO ApiEndpoint (ControllerId,MethodName,HttpVerb,Route,InputId,OutputId,Roles) VALUES ((SELECT Id FROM CodeElement WHERE Name='OrderItemsController'),'Create','POST','api/v1/orderitems',(SELECT Id FROM CodeElement WHERE Name='CreateOrderItemCommand'),(SELECT Id FROM CodeElement WHERE Name='OrderDto'),NULL);
IF NOT EXISTS (SELECT 1 FROM ApiEndpoint WHERE ControllerId=(SELECT Id FROM CodeElement WHERE Name='OrderItemsController') AND MethodName='Cancel' AND HttpVerb='POST')
  INSERT INTO ApiEndpoint (ControllerId,MethodName,HttpVerb,Route,InputId,OutputId,Roles) VALUES ((SELECT Id FROM CodeElement WHERE Name='OrderItemsController'),'Cancel','POST','api/v1/orderitems/{id}/cancel',(SELECT Id FROM CodeElement WHERE Name='CancelOrderItemCommand'),(SELECT Id FROM CodeElement WHERE Name='OrderDto'),NULL);
-- ProductsController
IF NOT EXISTS (SELECT 1 FROM ApiEndpoint WHERE ControllerId=(SELECT Id FROM CodeElement WHERE Name='ProductsController') AND MethodName='GetAll' AND HttpVerb='GET')
  INSERT INTO ApiEndpoint (ControllerId,MethodName,HttpVerb,Route,InputId,OutputId,Roles) VALUES ((SELECT Id FROM CodeElement WHERE Name='ProductsController'),'GetAll','GET','api/v1/products',NULL,(SELECT Id FROM CodeElement WHERE Name='ProductDto'),NULL);
IF NOT EXISTS (SELECT 1 FROM ApiEndpoint WHERE ControllerId=(SELECT Id FROM CodeElement WHERE Name='ProductsController') AND MethodName='GetById' AND HttpVerb='GET')
  INSERT INTO ApiEndpoint (ControllerId,MethodName,HttpVerb,Route,InputId,OutputId,Roles) VALUES ((SELECT Id FROM CodeElement WHERE Name='ProductsController'),'GetById','GET','api/v1/products/{id}',NULL,(SELECT Id FROM CodeElement WHERE Name='ProductDto'),NULL);
IF NOT EXISTS (SELECT 1 FROM ApiEndpoint WHERE ControllerId=(SELECT Id FROM CodeElement WHERE Name='ProductsController') AND MethodName='Create' AND HttpVerb='POST')
  INSERT INTO ApiEndpoint (ControllerId,MethodName,HttpVerb,Route,InputId,OutputId,Roles) VALUES ((SELECT Id FROM CodeElement WHERE Name='ProductsController'),'Create','POST','api/v1/products',(SELECT Id FROM CodeElement WHERE Name='CreateProductCommand'),(SELECT Id FROM CodeElement WHERE Name='ProductDto'),NULL);
IF NOT EXISTS (SELECT 1 FROM ApiEndpoint WHERE ControllerId=(SELECT Id FROM CodeElement WHERE Name='ProductsController') AND MethodName='Update' AND HttpVerb='PUT')
  INSERT INTO ApiEndpoint (ControllerId,MethodName,HttpVerb,Route,InputId,OutputId,Roles) VALUES ((SELECT Id FROM CodeElement WHERE Name='ProductsController'),'Update','PUT','api/v1/products/{id}',(SELECT Id FROM CodeElement WHERE Name='UpdateProductCommand'),(SELECT Id FROM CodeElement WHERE Name='ProductDto'),NULL);
IF NOT EXISTS (SELECT 1 FROM ApiEndpoint WHERE ControllerId=(SELECT Id FROM CodeElement WHERE Name='ProductsController') AND MethodName='Delete' AND HttpVerb='DELETE')
  INSERT INTO ApiEndpoint (ControllerId,MethodName,HttpVerb,Route,InputId,OutputId,Roles) VALUES ((SELECT Id FROM CodeElement WHERE Name='ProductsController'),'Delete','DELETE','api/v1/products/{id}',NULL,NULL,NULL);
-- RolesController
IF NOT EXISTS (SELECT 1 FROM ApiEndpoint WHERE ControllerId=(SELECT Id FROM CodeElement WHERE Name='RolesController') AND MethodName='GetAll' AND HttpVerb='GET')
  INSERT INTO ApiEndpoint (ControllerId,MethodName,HttpVerb,Route,InputId,OutputId,Roles) VALUES ((SELECT Id FROM CodeElement WHERE Name='RolesController'),'GetAll','GET','api/v1/roles',NULL,(SELECT Id FROM CodeElement WHERE Name='RoleDto'),NULL);
IF NOT EXISTS (SELECT 1 FROM ApiEndpoint WHERE ControllerId=(SELECT Id FROM CodeElement WHERE Name='RolesController') AND MethodName='GetById' AND HttpVerb='GET')
  INSERT INTO ApiEndpoint (ControllerId,MethodName,HttpVerb,Route,InputId,OutputId,Roles) VALUES ((SELECT Id FROM CodeElement WHERE Name='RolesController'),'GetById','GET','api/v1/roles/{id}',NULL,(SELECT Id FROM CodeElement WHERE Name='RoleDto'),NULL);
IF NOT EXISTS (SELECT 1 FROM ApiEndpoint WHERE ControllerId=(SELECT Id FROM CodeElement WHERE Name='RolesController') AND MethodName='Create' AND HttpVerb='POST')
  INSERT INTO ApiEndpoint (ControllerId,MethodName,HttpVerb,Route,InputId,OutputId,Roles) VALUES ((SELECT Id FROM CodeElement WHERE Name='RolesController'),'Create','POST','api/v1/roles',(SELECT Id FROM CodeElement WHERE Name='CreateRoleCommand'),(SELECT Id FROM CodeElement WHERE Name='RoleDto'),NULL);
IF NOT EXISTS (SELECT 1 FROM ApiEndpoint WHERE ControllerId=(SELECT Id FROM CodeElement WHERE Name='RolesController') AND MethodName='Update' AND HttpVerb='PUT')
  INSERT INTO ApiEndpoint (ControllerId,MethodName,HttpVerb,Route,InputId,OutputId,Roles) VALUES ((SELECT Id FROM CodeElement WHERE Name='RolesController'),'Update','PUT','api/v1/roles/{id}',(SELECT Id FROM CodeElement WHERE Name='UpdateRoleCommand'),(SELECT Id FROM CodeElement WHERE Name='RoleDto'),NULL);
IF NOT EXISTS (SELECT 1 FROM ApiEndpoint WHERE ControllerId=(SELECT Id FROM CodeElement WHERE Name='RolesController') AND MethodName='Delete' AND HttpVerb='DELETE')
  INSERT INTO ApiEndpoint (ControllerId,MethodName,HttpVerb,Route,InputId,OutputId,Roles) VALUES ((SELECT Id FROM CodeElement WHERE Name='RolesController'),'Delete','DELETE','api/v1/roles/{id}',NULL,NULL,NULL);
-- EmployeesController
IF NOT EXISTS (SELECT 1 FROM ApiEndpoint WHERE ControllerId=(SELECT Id FROM CodeElement WHERE Name='EmployeesController') AND MethodName='GetAll' AND HttpVerb='GET')
  INSERT INTO ApiEndpoint (ControllerId,MethodName,HttpVerb,Route,InputId,OutputId,Roles) VALUES ((SELECT Id FROM CodeElement WHERE Name='EmployeesController'),'GetAll','GET','api/v1/employees',NULL,(SELECT Id FROM CodeElement WHERE Name='EmployeeDto'),NULL);
IF NOT EXISTS (SELECT 1 FROM ApiEndpoint WHERE ControllerId=(SELECT Id FROM CodeElement WHERE Name='EmployeesController') AND MethodName='GetById' AND HttpVerb='GET')
  INSERT INTO ApiEndpoint (ControllerId,MethodName,HttpVerb,Route,InputId,OutputId,Roles) VALUES ((SELECT Id FROM CodeElement WHERE Name='EmployeesController'),'GetById','GET','api/v1/employees/{id}',NULL,(SELECT Id FROM CodeElement WHERE Name='EmployeeDto'),NULL);
IF NOT EXISTS (SELECT 1 FROM ApiEndpoint WHERE ControllerId=(SELECT Id FROM CodeElement WHERE Name='EmployeesController') AND MethodName='Create' AND HttpVerb='POST')
  INSERT INTO ApiEndpoint (ControllerId,MethodName,HttpVerb,Route,InputId,OutputId,Roles) VALUES ((SELECT Id FROM CodeElement WHERE Name='EmployeesController'),'Create','POST','api/v1/employees',(SELECT Id FROM CodeElement WHERE Name='CreateEmployeeCommand'),(SELECT Id FROM CodeElement WHERE Name='EmployeeDto'),NULL);
IF NOT EXISTS (SELECT 1 FROM ApiEndpoint WHERE ControllerId=(SELECT Id FROM CodeElement WHERE Name='EmployeesController') AND MethodName='Update' AND HttpVerb='PUT')
  INSERT INTO ApiEndpoint (ControllerId,MethodName,HttpVerb,Route,InputId,OutputId,Roles) VALUES ((SELECT Id FROM CodeElement WHERE Name='EmployeesController'),'Update','PUT','api/v1/employees/{id}',(SELECT Id FROM CodeElement WHERE Name='UpdateEmployeeCommand'),(SELECT Id FROM CodeElement WHERE Name='EmployeeDto'),NULL);
-- PaymentMethodsController
IF NOT EXISTS (SELECT 1 FROM ApiEndpoint WHERE ControllerId=(SELECT Id FROM CodeElement WHERE Name='PaymentMethodsController') AND MethodName='GetAll' AND HttpVerb='GET')
  INSERT INTO ApiEndpoint (ControllerId,MethodName,HttpVerb,Route,InputId,OutputId,Roles) VALUES ((SELECT Id FROM CodeElement WHERE Name='PaymentMethodsController'),'GetAll','GET','api/v1/paymentmethods',NULL,(SELECT Id FROM CodeElement WHERE Name='PaymentMethodDto'),NULL);
IF NOT EXISTS (SELECT 1 FROM ApiEndpoint WHERE ControllerId=(SELECT Id FROM CodeElement WHERE Name='PaymentMethodsController') AND MethodName='Create' AND HttpVerb='POST')
  INSERT INTO ApiEndpoint (ControllerId,MethodName,HttpVerb,Route,InputId,OutputId,Roles) VALUES ((SELECT Id FROM CodeElement WHERE Name='PaymentMethodsController'),'Create','POST','api/v1/paymentmethods',(SELECT Id FROM CodeElement WHERE Name='CreatePaymentMethodCommand'),(SELECT Id FROM CodeElement WHERE Name='PaymentMethodDto'),NULL);
-- TabCheckoutsController
IF NOT EXISTS (SELECT 1 FROM ApiEndpoint WHERE ControllerId=(SELECT Id FROM CodeElement WHERE Name='TabCheckoutsController') AND MethodName='GetById' AND HttpVerb='GET')
  INSERT INTO ApiEndpoint (ControllerId,MethodName,HttpVerb,Route,InputId,OutputId,Roles) VALUES ((SELECT Id FROM CodeElement WHERE Name='TabCheckoutsController'),'GetById','GET','api/v1/tabcheckouts/{id}',NULL,(SELECT Id FROM CodeElement WHERE Name='TabCheckoutDto'),NULL);
IF NOT EXISTS (SELECT 1 FROM ApiEndpoint WHERE ControllerId=(SELECT Id FROM CodeElement WHERE Name='TabCheckoutsController') AND MethodName='Create' AND HttpVerb='POST')
  INSERT INTO ApiEndpoint (ControllerId,MethodName,HttpVerb,Route,InputId,OutputId,Roles) VALUES ((SELECT Id FROM CodeElement WHERE Name='TabCheckoutsController'),'Create','POST','api/v1/tabcheckouts',(SELECT Id FROM CodeElement WHERE Name='CreateTabCheckoutCommand'),(SELECT Id FROM CodeElement WHERE Name='TabCheckoutDto'),NULL);
-- TabPaymentsController
IF NOT EXISTS (SELECT 1 FROM ApiEndpoint WHERE ControllerId=(SELECT Id FROM CodeElement WHERE Name='TabPaymentsController') AND MethodName='GetByCheckout' AND HttpVerb='GET')
  INSERT INTO ApiEndpoint (ControllerId,MethodName,HttpVerb,Route,InputId,OutputId,Roles) VALUES ((SELECT Id FROM CodeElement WHERE Name='TabPaymentsController'),'GetByCheckout','GET','api/v1/tabpayments',NULL,(SELECT Id FROM CodeElement WHERE Name='TabPaymentDto'),NULL);
IF NOT EXISTS (SELECT 1 FROM ApiEndpoint WHERE ControllerId=(SELECT Id FROM CodeElement WHERE Name='TabPaymentsController') AND MethodName='Create' AND HttpVerb='POST')
  INSERT INTO ApiEndpoint (ControllerId,MethodName,HttpVerb,Route,InputId,OutputId,Roles) VALUES ((SELECT Id FROM CodeElement WHERE Name='TabPaymentsController'),'Create','POST','api/v1/tabpayments',(SELECT Id FROM CodeElement WHERE Name='CreateTabPaymentCommand'),(SELECT Id FROM CodeElement WHERE Name='TabPaymentDto'),NULL);
-- ProductCategoriesController
IF NOT EXISTS (SELECT 1 FROM ApiEndpoint WHERE ControllerId=(SELECT Id FROM CodeElement WHERE Name='ProductCategoriesController') AND MethodName='GetAll' AND HttpVerb='GET')
  INSERT INTO ApiEndpoint (ControllerId,MethodName,HttpVerb,Route,InputId,OutputId,Roles) VALUES ((SELECT Id FROM CodeElement WHERE Name='ProductCategoriesController'),'GetAll','GET','api/v1/productcategories',NULL,(SELECT Id FROM CodeElement WHERE Name='ProductCategoryDto'),NULL);
IF NOT EXISTS (SELECT 1 FROM ApiEndpoint WHERE ControllerId=(SELECT Id FROM CodeElement WHERE Name='ProductCategoriesController') AND MethodName='Create' AND HttpVerb='POST')
  INSERT INTO ApiEndpoint (ControllerId,MethodName,HttpVerb,Route,InputId,OutputId,Roles) VALUES ((SELECT Id FROM CodeElement WHERE Name='ProductCategoriesController'),'Create','POST','api/v1/productcategories',(SELECT Id FROM CodeElement WHERE Name='CreateProductCategoryCommand'),(SELECT Id FROM CodeElement WHERE Name='ProductCategoryDto'),NULL);
-- StockMovementsController
IF NOT EXISTS (SELECT 1 FROM ApiEndpoint WHERE ControllerId=(SELECT Id FROM CodeElement WHERE Name='StockMovementsController') AND MethodName='GetByProduct' AND HttpVerb='GET')
  INSERT INTO ApiEndpoint (ControllerId,MethodName,HttpVerb,Route,InputId,OutputId,Roles) VALUES ((SELECT Id FROM CodeElement WHERE Name='StockMovementsController'),'GetByProduct','GET','api/v1/stockmovements',NULL,(SELECT Id FROM CodeElement WHERE Name='StockMovementDto'),NULL);
IF NOT EXISTS (SELECT 1 FROM ApiEndpoint WHERE ControllerId=(SELECT Id FROM CodeElement WHERE Name='StockMovementsController') AND MethodName='Create' AND HttpVerb='POST')
  INSERT INTO ApiEndpoint (ControllerId,MethodName,HttpVerb,Route,InputId,OutputId,Roles) VALUES ((SELECT Id FROM CodeElement WHERE Name='StockMovementsController'),'Create','POST','api/v1/stockmovements',(SELECT Id FROM CodeElement WHERE Name='CreateStockMovementCommand'),(SELECT Id FROM CodeElement WHERE Name='StockMovementDto'),NULL);
-- CashRegisterController
IF NOT EXISTS (SELECT 1 FROM ApiEndpoint WHERE ControllerId=(SELECT Id FROM CodeElement WHERE Name='CashRegisterController') AND MethodName='GetActive' AND HttpVerb='GET')
  INSERT INTO ApiEndpoint (ControllerId,MethodName,HttpVerb,Route,InputId,OutputId,Roles) VALUES ((SELECT Id FROM CodeElement WHERE Name='CashRegisterController'),'GetActive','GET','api/v1/cashregister/active',NULL,(SELECT Id FROM CodeElement WHERE Name='CashRegisterOpeningDto'),NULL);
IF NOT EXISTS (SELECT 1 FROM ApiEndpoint WHERE ControllerId=(SELECT Id FROM CodeElement WHERE Name='CashRegisterController') AND MethodName='Open' AND HttpVerb='POST')
  INSERT INTO ApiEndpoint (ControllerId,MethodName,HttpVerb,Route,InputId,OutputId,Roles) VALUES ((SELECT Id FROM CodeElement WHERE Name='CashRegisterController'),'Open','POST','api/v1/cashregister/open',(SELECT Id FROM CodeElement WHERE Name='OpenCashRegisterCommand'),(SELECT Id FROM CodeElement WHERE Name='CashRegisterOpeningDto'),NULL);
IF NOT EXISTS (SELECT 1 FROM ApiEndpoint WHERE ControllerId=(SELECT Id FROM CodeElement WHERE Name='CashRegisterController') AND MethodName='Close' AND HttpVerb='POST')
  INSERT INTO ApiEndpoint (ControllerId,MethodName,HttpVerb,Route,InputId,OutputId,Roles) VALUES ((SELECT Id FROM CodeElement WHERE Name='CashRegisterController'),'Close','POST','api/v1/cashregister/close',(SELECT Id FROM CodeElement WHERE Name='CloseCashRegisterCommand'),(SELECT Id FROM CodeElement WHERE Name='CashRegisterClosingDto'),NULL);
IF NOT EXISTS (SELECT 1 FROM ApiEndpoint WHERE ControllerId=(SELECT Id FROM CodeElement WHERE Name='CashRegisterController') AND MethodName='GetClosingById' AND HttpVerb='GET')
  INSERT INTO ApiEndpoint (ControllerId,MethodName,HttpVerb,Route,InputId,OutputId,Roles) VALUES ((SELECT Id FROM CodeElement WHERE Name='CashRegisterController'),'GetClosingById','GET','api/v1/cashregister/closing/{id}',NULL,(SELECT Id FROM CodeElement WHERE Name='CashRegisterClosingDto'),NULL);

-- ── FIM DO SCRIPT ────────────────────────────────────────
PRINT 'OrderManager inserido com sucesso no CodePropertyGraphDb!';
GO
