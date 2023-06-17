namespace CervezasArtesanalesColombiaAPI.Data.Entities
{
    public class Ingrediente
    {
        public int Id { get; set; }

        public string Nombre { get; set; } = null!;
        public string TipoIngrediente { get; set; } = null!;
    }
}
