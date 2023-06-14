using System.Data;
using Microsoft.Data.Sqlite;

namespace CervezasArtesanalesColombiaAPI.Data.DbContexts
{
    public class SQLiteDbContext
    {
        private IDbConnection conexionDB;


        public SQLiteDbContext(IConfiguration unaConfiguracion)
        {
            conexionDB = new SqliteConnection(
                    unaConfiguracion.GetConnectionString("SQLite")
                );
        }

        public IDbConnection Conexion => conexionDB;
    }
}