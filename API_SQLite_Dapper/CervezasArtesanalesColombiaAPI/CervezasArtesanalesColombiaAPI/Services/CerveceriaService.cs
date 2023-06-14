using CervezasArtesanalesColombiaAPI.Data.Entities;
using CervezasArtesanalesColombiaAPI.Interfaces;

namespace CervezasArtesanalesColombiaAPI.Services
{
    public class CerveceriaService
    {
        private readonly ICerveceriaRepository _cerveceriaRepository;

        public CerveceriaService(ICerveceriaRepository cerveceriaRepository)
        {
            _cerveceriaRepository = cerveceriaRepository;
        }

        public async Task<List<Cerveceria>> GetAllAsync()
        {
            return await _cerveceriaRepository.GetAllAsync();
        }

        public async Task<Cerveceria> GetAsync(int id)
        {
            return await _cerveceriaRepository.GetAsync(id);
        }

        public async Task<List<Cerveza>> GetAllCervezasAsync(int id)
        {
            return await _cerveceriaRepository.GetAllCervezasAsync(id);
        }
    }
}
