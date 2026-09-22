using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace EmpDepManage.Models
{
    public class Department
    {
        [Key]
        public int DepId { get; set; }
        [Required]
        public string DepName { get; set; }
        public ICollection<Employee> Employee { get; set; } = new List<Employee>();
    }
}