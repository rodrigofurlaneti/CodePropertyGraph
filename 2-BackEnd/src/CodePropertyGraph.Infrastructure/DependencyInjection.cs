using CodePropertyGraph.Domain.Interfaces;
using CodePropertyGraph.Infrastructure.Data;
using CodePropertyGraph.Infrastructure.Repositories;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;

namespace CodePropertyGraph.Infrastructure;

public static class DependencyInjection
{
    public static IServiceCollection AddInfrastructure(this IServiceCollection services, IConfiguration configuration)
    {
        services.AddDbContext<AppDbContext>(options =>
            options.UseSqlServer(
                configuration.GetConnectionString("DefaultConnection"),
                b => b.MigrationsAssembly(typeof(AppDbContext).Assembly.FullName)));

        // Repositories
        services.AddScoped<ILayerRepository, LayerRepository>();
        services.AddScoped<IProjectRepository, ProjectRepository>();
        services.AddScoped<INamespaceRepository, NamespaceRepository>();
        services.AddScoped<IDirectoryRepository, DirectoryRepository>();
        services.AddScoped<ICodeElementRepository, CodeElementRepository>();
        services.AddScoped<IElementImplementationRepository, ElementImplementationRepository>();
        services.AddScoped<IElementDependencyRepository, ElementDependencyRepository>();
        services.AddScoped<IApiEndpointRepository, ApiEndpointRepository>();
        services.AddScoped<IHandlerContractRepository, HandlerContractRepository>();

        return services;
    }
}
