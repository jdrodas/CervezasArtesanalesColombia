namespace CervezasArtesanalesColombiaAPI.Data.Entities
{
    public class Cerveceria
    {
        public int Id { get; set; }

        public string Nombre { get; set; } = null!;

        public string Ubicacion { get; set; } = null!;

        public string SitioWeb { get; set; } = null!;

        public string Instagram { get; set; } = null!;
    }
}
