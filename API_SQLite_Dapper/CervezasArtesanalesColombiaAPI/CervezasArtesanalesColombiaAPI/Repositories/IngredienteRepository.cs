using Dapper;
using CervezasArtesanalesColombiaAPI.Data.DbContexts;
using CervezasArtesanalesColombiaAPI.Data.Entities;
using CervezasArtesanalesColombiaAPI.Interfaces;
using System.Data;

namespace CervezasArtesanalesColombiaAPI.Repositories
{
    public class IngredienteRepository : IIngredienteRepository
    {
        private readonly SQLiteDbContext contextoDB;

        public IngredienteRepository(SQLiteDbContext unContexto)
        {
            contextoDB = unContexto;
        }

        public async Task<List<Ingrediente>> GetAllIngredientesAsync()
        {
            using (contextoDB.Conexion)
            {
                string sentenciaSQL = "SELECT DISTINCT " +
                    "ig.id, " +
                    "ig.nombre, " +
                    "ti.nombre tipoIngrediente " +
                    "FROM ingredientes ig JOIN tiposIngredientes ti ON ig.tipoIngredienteId = ti.id " +
                    "ORDER BY ig.nombre";

                var resultadoIngredientes = await contextoDB.Conexion.QueryAsync<Ingrediente>(sentenciaSQL, new DynamicParameters());

                return resultadoIngredientes.AsList();
            }
        }

        public async Task<List<Ingrediente>> GetAllIngredientesPorTipoAsync(int id)
        {
            using (contextoDB.Conexion)
            {
                DynamicParameters parametrosSentencia = new DynamicParameters();
                parametrosSentencia.Add("@id_tipoIngrediente", id,
                    DbType.Int32, ParameterDirection.Input);

                string sentenciaSQL = "SELECT DISTINCT " +
                    "ig.id, " +
                    "ig.nombre, " +
                    "ti.nombre tipoIngrediente " +
                    "FROM ingredientes ig JOIN tiposIngredientes ti ON ig.tipoIngredienteId = ti.id " +
                    "WHERE ti.id = @id_tipoIngrediente " +
                    "ORDER BY ig.nombre";

                var resultadoIngredientes = await contextoDB.Conexion.QueryAsync<Ingrediente>(sentenciaSQL, parametrosSentencia);

                return resultadoIngredientes.AsList();
            }
        }

        public async Task<List<TipoIngrediente>> GetAllTipoIngredientesAsync()
        {
            using (contextoDB.Conexion)
            {
                string sentenciaSQL = "SELECT DISTINCT " +
                    "id, " +
                    "nombre " +
                    "FROM tiposIngredientes " +
                    "ORDER BY nombre";

                var resultadoTipoIngredientes = await contextoDB.Conexion.QueryAsync<TipoIngrediente>(sentenciaSQL, new DynamicParameters());

                return resultadoTipoIngredientes.AsList();
            }
        }

        public async Task<Ingrediente> GetIngredienteAsync(int id)
        {
            Ingrediente unIngrediente = new Ingrediente();

            using (contextoDB.Conexion)
            {
                DynamicParameters parametrosSentencia = new DynamicParameters();
                parametrosSentencia.Add("@id_ingrediente", id,
                    DbType.Int32, ParameterDirection.Input);

                string sentenciaSQL = "SELECT DISTINCT " +
                    "ig.id, " +
                    "ig.nombre, " +
                    "ti.nombre tipoIngrediente " +
                    "FROM ingredientes ig JOIN tiposIngredientes ti ON ig.tipoIngredienteId = ti.id " +
                    "WHERE ig.id = @id_ingrediente " +
                    "ORDER BY ig.nombre";

                var resultado = await contextoDB.Conexion.QueryAsync<Ingrediente>(sentenciaSQL, parametrosSentencia);

                if (resultado.ToArray().Length > 0)
                    unIngrediente = resultado.First();
            }

            return unIngrediente;
        }

        public async Task<TipoIngrediente> GetTipoIngredienteAsync(int id)
        {
            TipoIngrediente unTipoIngrediente = new TipoIngrediente();

            using (contextoDB.Conexion)
            {
                DynamicParameters parametrosSentencia = new DynamicParameters();
                parametrosSentencia.Add("@id_tipoIngrediente", id,
                    DbType.Int32, ParameterDirection.Input);

                string sentenciaSQL = "SELECT DISTINCT " +
                    "id, " +
                    "nombre " +
                    "FROM tiposIngredientes " +
                    "WHERE id = @id_tipoIngrediente " +
                    "ORDER BY nombre";

                var resultado = await contextoDB.Conexion.QueryAsync<TipoIngrediente>(sentenciaSQL, parametrosSentencia);


                if (resultado.ToArray().Length > 0)
                    unTipoIngrediente = resultado.First();
            }

            return unTipoIngrediente;
        }
    }
}
