using CervezasArtesanalesColombiaAPI.Data.DbContexts;
using CervezasArtesanalesColombiaAPI.Interfaces;
using CervezasArtesanalesColombiaAPI.Repositories;
using CervezasArtesanalesColombiaAPI.Services;

var builder = WebApplication.CreateBuilder(args);

//Aqui agregamos los servicios requeridos

//El DBContext a utilizar
builder.Services.AddSingleton<SQLiteDbContext>();

//Los repositorios
builder.Services.AddScoped<ICerveceriaRepository, CerveceriaRepository>();

//Aqui agregamos los servicios asociados para cada EndPoint
builder.Services.AddScoped<CerveceriaService>();

// Agregamos Servicios al Controlador, especificando las opciones para el manejo de Json
builder.Services.AddControllers()
    .AddJsonOptions(
        options => options.JsonSerializerOptions.PropertyNamingPolicy = null);

var app = builder.Build();

// Configure the HTTP request pipeline.

app.UseHttpsRedirection();

app.UseAuthorization();

app.MapControllers();

app.Run();