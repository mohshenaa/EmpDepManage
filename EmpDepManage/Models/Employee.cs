using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace EmpDepManage.Models
{
    public class Employee
    {
        [Key]
        public int EmpId { get; set; }
        [Required]
        public string EmpName { get; set; }
        [EmailAddress]
        [Required]
        public string Email { get; set; }
        [Required]
        [Phone]
        public string PhoneNumber { get; set; }
        [Required]
        [Range(1, 1000000, ErrorMessage = "Salary must be greater than 0 and less than 10,00,000")]
        public decimal Salary { get; set; }

        [ForeignKey("Department")]
        public int DepId { get; set; }
        public Department Department { get; set; }
    }
}