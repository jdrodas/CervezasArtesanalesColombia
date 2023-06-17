using CervezasArtesanalesColombiaAPI.Data.Entities;

namespace CervezasArtesanalesColombiaAPI.Interfaces
{
    public interface IIngredienteRepository
    {
        public Task<List<Ingrediente>> GetAllIngredientesAsync();

        public Task<List<Ingrediente>> GetAllIngredientesPorTipoAsync(int id);

        public Task<List<TipoIngrediente>> GetAllTipoIngredientesAsync();

        public Task<Ingrediente> GetIngredienteAsync(int id);

        public Task<TipoIngrediente> GetTipoIngredienteAsync(int id);
    }
}