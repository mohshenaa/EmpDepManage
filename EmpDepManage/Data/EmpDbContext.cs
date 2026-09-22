using EmpDepManage.Models;
using System.Data.Entity;

namespace EmpDepManage.Data
{
    public class EmpDbContext : DbContext
    {
        public EmpDbContext() : base("default") { }

        public DbSet<Employee> Employees { get; set; }
        public DbSet<Department> Departments { get; set; }

    }
}