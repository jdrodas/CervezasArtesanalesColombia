using CervezasArtesanalesColombiaAPI.Data.Entities;
using CervezasArtesanalesColombiaAPI.Services;
using Microsoft.AspNetCore.Mvc;

namespace CervezasArtesanalesColombiaAPI.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class IngredientesController : Controller
    {
        private readonly IngredienteService _ingredienteService;

        public IngredientesController(IngredienteService ingredienteService)
        {
            _ingredienteService = ingredienteService;
        }

        [HttpGet]
        public async Task<List<Ingrediente>> GetAllIngredientes()
        {
            var losIngredientes = await _ingredienteService
                .GetAllIngredientesAsync();

            return losIngredientes;
        }

        [HttpGet("{id:int}")]
        public async Task<ActionResult<Ingrediente>> GetIngrediente(int id)
        {
            var unIngrediente = await _ingredienteService
                .GetIngredienteAsync(id);

            if (unIngrediente is null)
                return NotFound();

            return unIngrediente;
        }
    }
}
