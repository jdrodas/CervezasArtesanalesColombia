using Dapper;
using CervezasArtesanalesColombiaAPI.Data.DbContexts;
using CervezasArtesanalesColombiaAPI.Data.Entities;
using CervezasArtesanalesColombiaAPI.Interfaces;
using System.Data;

namespace CervezasArtesanalesColombiaAPI.Repositories
{
    public class CerveceriaRepository: ICerveceriaRepository
    {
        private readonly SQLiteDbContext contextoDB;

        public CerveceriaRepository(SQLiteDbContext unContexto)
        {
            contextoDB = unContexto;
        }

        public async Task<List<Cerveceria>> GetAllAsync()
        {
            using (contextoDB.Conexion)
            {
                string sentenciaSQL = "SELECT DISTINCT " +
                    "c.id, " +
                    "c.nombre, " +
                    "(u.municipio || ', ' || u.departamento) ubicacion, " +
                    "c.sitioWeb, " +
                    "c.instagram " +
                    "FROM cervecerias c JOIN ubicaciones u ON c.ubicacionId = u.id " +
                    "ORDER BY c.nombre;";

                var resultadoCervecerias = await contextoDB.Conexion.QueryAsync<Cerveceria>(sentenciaSQL, new DynamicParameters());

                return resultadoCervecerias.AsList();
            }
        }

        public async Task<Cerveceria> GetAsync(int id)
        {
            Cerveceria unaCerveceria = new Cerveceria();

            using (contextoDB.Conexion)
            {
                DynamicParameters parametrosSentencia = new DynamicParameters();
                parametrosSentencia.Add("@id_cerveceria", id,
                    DbType.Int32, ParameterDirection.Input);

                string sentenciaSQL = "SELECT DISTINCT " +
                    "c.id, " +
                    "c.nombre, " +
                    "(u.municipio || ', ' || u.departamento) ubicacion, " +
                    "c.sitioWeb, " +
                    "c.instagram " +
                    "FROM cervecerias c JOIN ubicaciones u ON c.ubicacionId = u.id " +
                    "WHERE c.id = @id_cerveceria " +
                    "ORDER BY c.nombre;";

                var resultado = await contextoDB.Conexion.QueryAsync<Cerveceria>(sentenciaSQL, parametrosSentencia);

                if (resultado.ToArray().Length > 0)
                    unaCerveceria = resultado.First();
            }

            return unaCerveceria;
        }

        public async Task<List<Cerveza>> GetAllCervezasAsync(int id)
        {
            using (contextoDB.Conexion)
            {
                DynamicParameters parametrosSentencia = new DynamicParameters();
                parametrosSentencia.Add("@id_cerveceria", id,
                    DbType.Int32, ParameterDirection.Input);

                string sentenciaSQL = "SELECT DISTINCT " +
                    "cv.nombre, " +
                    "cr.nombre cerveceria, " +
                    "e.nombre estilo, " +
                    "cv.ibu, " +
                    "ri.nombre rangoIbu, " +
                    "cv.abv, " +
                    "ra.nombre rangoAbv " +
                    "FROM cervezas cv JOIN cervecerias cr ON cv.cerveceriaId = cr.id " +
                    "JOIN estilos e on cv.estiloId = e.id " +
                    "JOIN rangosIbu ri on cv.rangoIbuId = ri.id " +
                    "JOIN rangosAbv ra on cv.rangoAbvId = ra.id " +
                    "WHERE cv.cerveceriaId = @id_cerveceria " +
                    "ORDER BY cv.nombre";

                var resultadoCervezas = await contextoDB.Conexion.QueryAsync<Cerveza>(sentenciaSQL, parametrosSentencia);

                return resultadoCervezas.AsList();
            }
        }
    }
}