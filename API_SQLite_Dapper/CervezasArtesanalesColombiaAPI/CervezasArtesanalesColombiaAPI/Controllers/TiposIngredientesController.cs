using CervezasArtesanalesColombiaAPI.Data.Entities;
using CervezasArtesanalesColombiaAPI.Services;
using Microsoft.AspNetCore.Mvc;

namespace CervezasArtesanalesColombiaAPI.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class TiposIngredientesController : Controller
    {
        private readonly IngredienteService _ingredienteService;

        public TiposIngredientesController(IngredienteService ingredienteService)
        {
            _ingredienteService = ingredienteService;
        }

        [HttpGet]
        public async Task<List<TipoIngrediente>> GetAllTipoIngredientes()
        {
            var losTiposIngredientes = await _ingredienteService
                .GetAllTipoIngredientesAsync();

            return losTiposIngredientes;
        }

        [HttpGet("{id:int}")]
        public async Task<ActionResult<TipoIngrediente>> GetTipoIngrediente(int id)
        {
            var unTipoIngrediente = await _ingredienteService
                .GetTipoIngredienteAsync(id);

            if (unTipoIngrediente is null)
                return NotFound();

            return unTipoIngrediente;
        }

        [HttpGet("{id:int}/Ingredientes")]
        public async Task<List<Ingrediente>> GetAllIngredientesPorTipo(int id)
        {
            var losIngredientes = await _ingredienteService
                .GetAllIngredientesPorTipoAsync(id);

            return losIngredientes;
        }
    }
}
