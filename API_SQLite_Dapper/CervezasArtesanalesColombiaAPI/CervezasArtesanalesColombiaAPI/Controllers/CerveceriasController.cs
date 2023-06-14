using CervezasArtesanalesColombiaAPI.Data.Entities;
using CervezasArtesanalesColombiaAPI.Services;
using Microsoft.AspNetCore.Mvc;

namespace CervezasArtesanalesColombiaAPI.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class CerveceriasController : Controller
    {
        private readonly CerveceriaService _cerveceriaService;

        public CerveceriasController(CerveceriaService cerveceriaService)
        {
            _cerveceriaService = cerveceriaService;
        }

        [HttpGet]
        public async Task<List<Cerveceria>> GetCervecerias()
        {
            var lasCervecerias = await _cerveceriaService
                .GetAllAsync();

            return lasCervecerias;
        }

        [HttpGet("{id:int}")]
        public async Task<ActionResult<Cerveceria>> Get(int id)
        {
            var unaCerveceria = await _cerveceriaService
                .GetAsync(id);

            if (unaCerveceria is null)
                return NotFound();

            return unaCerveceria;
        }

        [HttpGet("{id:int}/Cervezas")]
        public async Task<List<Cerveza>> GetCervezasDeCerveceria(int id)
        {
            var lasCervezas = await _cerveceriaService
                .GetAllCervezasAsync(id);

            return lasCervezas;
        }
    }
}
