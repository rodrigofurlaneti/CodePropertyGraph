using CodePropertyGraph.Application.Common;
using CodePropertyGraph.Infrastructure;

var builder = WebApplication.CreateBuilder(args);

// Layers
builder.Services.AddApplication();
builder.Services.AddInfrastructure(builder.Configuration);

builder.Services.AddControllers();
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen(c =>
{
    c.SwaggerDoc("v1", new()
    {
        Title = "CodePropertyGraph API",
        Version = "v1",
        Description = "API para análise e visualização de arquiteturas de código como Knowledge Graph"
    });
});

// CORS para o frontend React
builder.Services.AddCors(options =>
{
    options.AddPolicy("AllowFrontend", policy =>
        policy.WithOrigins("http://localhost:5173", "http://localhost:3000")
              .AllowAnyHeader()
              .AllowAnyMethod());
});

var app = builder.Build();

if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI(c => c.SwaggerEndpoint("/swagger/v1/swagger.json", "CodePropertyGraph API v1"));
}

// Em desenvolvimento o proxy do Vite aponta para HTTP (localhost:5000).
// UseHttpsRedirection redirecionaria para HTTPS antes da resposta chegar,
// quebrando a comunicação proxy → API. Só habilita em produção.
if (!app.Environment.IsDevelopment())
    app.UseHttpsRedirection();

app.UseCors("AllowFrontend");
app.UseAuthorization();
app.MapControllers();

app.Run();
