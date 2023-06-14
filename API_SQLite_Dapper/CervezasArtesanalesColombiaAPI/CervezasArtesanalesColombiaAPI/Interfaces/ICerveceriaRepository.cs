using CervezasArtesanalesColombiaAPI.Data.Entities;

namespace CervezasArtesanalesColombiaAPI.Interfaces
{
    public interface ICerveceriaRepository
    {
        public Task<List<Cerveceria>> GetAllAsync();
        public Task<Cerveceria> GetAsync(int id);
        public Task<List<Cerveza>> GetAllCervezasAsync(int id);
    }
}
