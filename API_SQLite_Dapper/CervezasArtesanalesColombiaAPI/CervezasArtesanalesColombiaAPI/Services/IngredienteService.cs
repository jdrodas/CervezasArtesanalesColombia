using CervezasArtesanalesColombiaAPI.Data.Entities;
using CervezasArtesanalesColombiaAPI.Interfaces;
using CervezasArtesanalesColombiaAPI.Repositories;

namespace CervezasArtesanalesColombiaAPI.Services
{
    public class IngredienteService
    {
        private readonly IIngredienteRepository _ingredienteRepository;

        public IngredienteService(IIngredienteRepository ingredienteRepository)
        {
            _ingredienteRepository = ingredienteRepository;
        }

        public async Task<List<Ingrediente>> GetAllIngredientesAsync()
        {
            return await _ingredienteRepository.GetAllIngredientesAsync();
        }

        public async Task<List<Ingrediente>> GetAllIngredientesPorTipoAsync(int id)
        {
            return await _ingredienteRepository.GetAllIngredientesPorTipoAsync(id);
        }

        public async Task<List<TipoIngrediente>> GetAllTipoIngredientesAsync()
        {
            return await _ingredienteRepository.GetAllTipoIngredientesAsync();
        }

        public async Task<Ingrediente> GetIngredienteAsync(int id)
        {
            return await _ingredienteRepository.GetIngredienteAsync(id);
        }

        public async Task<TipoIngrediente> GetTipoIngredienteAsync(int id)
        {
            return await _ingredienteRepository.GetTipoIngredienteAsync(id);
        }
    }
}
