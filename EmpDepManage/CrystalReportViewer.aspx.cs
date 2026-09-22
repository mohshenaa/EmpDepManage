using CrystalDecisions.CrystalReports.Engine;
using EmpDepManage.Data;
using EmpDepManage.Models;
using System;
using System.Linq;
using System.Data.Entity;
using System.Web.UI.WebControls;

namespace EmpDepManage.Views.Employee
{
    public partial class CrystalReportViewer : System.Web.UI.Page
    {
        private EmpDbContext db = new EmpDbContext();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                ReportDocument report = new ReportDocument();
                report.Load(Server.MapPath("~/Reports/EmployeeSalaryCrystalReport.rpt")
                    );
                var emp = db.Employees.Include(a => a.Department).Select(a => new
                {
                    a.EmpId,
                    a.EmpName,
                    DepName = a.Department.DepName,
                    a.Salary,
                    AnnualSalary = a.Salary * 12
                }).ToList();
                EmployeeReportDataSet ds = new EmployeeReportDataSet();
                foreach (var employee in emp)
                {
                    var row = ds.EmployeeSalaryReport.NewEmployeeSalaryReportRow();
                    row.EmpId = employee.EmpId;
                    row.EmpName = employee.EmpName;
                    row.DepName = employee.DepName;
                    row.Salary = employee.Salary;
                    row.AnnualSalary = employee.AnnualSalary;
                    ds.EmployeeSalaryReport.AddEmployeeSalaryReportRow(row);
                }
                report.SetDataSource(ds);
                CrystalReportViewer1.ReportSource = report;

            }
        }
    }
}