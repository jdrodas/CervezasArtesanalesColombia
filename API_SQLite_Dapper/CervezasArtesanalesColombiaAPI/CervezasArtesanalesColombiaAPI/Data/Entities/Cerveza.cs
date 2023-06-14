namespace CervezasArtesanalesColombiaAPI.Data.Entities
{
    public class Cerveza
    {
        public int Id { get; set; }
        public string Nombre { get; set; } = null!;
        public string Estilo { get; set; } = null!;
        public string Cerveceria { get; set; } = null!;
        public float Ibu { get; set; } = 0;
        public string RangoIbu { get; set; } = null!;
        public float Abv { get; set; } = 0;
        public string RangoAbv { get; set; } = null!;
    }
}
