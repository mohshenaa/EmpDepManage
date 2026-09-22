using CrystalDecisions.CrystalReports.Engine;
using EmpDepManage.Data;
using EmpDepManage.Models;
using Microsoft.Reporting.WebForms;
using System.Data.Entity;
using System.Linq;
using System.Web.Mvc;


namespace EmpDepManage.Controllers
{
    public class EmployeeController : Controller
    {
        private EmpDbContext db = new EmpDbContext();
        // GET: Employee
        public ActionResult Index()
        {
            var emp = db.Employees.Include(a => a.Department).ToList();
            return View(emp);
        }
        // GET: Employee
        public ActionResult Create()
        {
            var dep = db.Departments.ToList();
            ViewBag.department = new SelectList(dep, "DepId", "DepName");
            return View();
        }
        // Post: Employee
        [HttpPost]
        public ActionResult Create(Employee employee)
        {
            var dep = db.Departments.ToList();
            if (employee == null)
            {
                ViewBag.department = new SelectList(dep, "DepId", "DepName", employee.DepId);
                return View(employee);

            }
            if (!ModelState.IsValid)
            {

                ViewBag.department = new SelectList(dep, "DepId", "DepName", employee.DepId);
                return View(employee);
            }
            bool email = db.Employees.Any(a => a.Email == employee.Email);
            if (email)
            {
                ModelState.AddModelError("", "Email Already exists");
                ViewBag.department = new SelectList(dep, "DepId", "DepName", employee.DepId);

                return View(employee);
            }
            bool phone = db.Employees.Any(a => a.PhoneNumber == employee.PhoneNumber);
            if (phone)
            {
                ModelState.AddModelError("", "phone Number Already exists");
                ViewBag.department = new SelectList(dep, "DepId", "DepName", employee.DepId);
                return View(employee);
            }

            ViewBag.department = new SelectList(dep, "DepId", "DepName", employee.DepId);

            db.Employees.Add(employee);
            db.SaveChanges();
            return RedirectToAction("Index");
        }
        // GET: Employee
        public ActionResult Edit(int? id)
        {
            var emp = db.Employees.Find(id);
            if (emp == null)
            {
                return HttpNotFound();
            }
            var dep = db.Departments.ToList();
            ViewBag.department = new SelectList(dep, "DepId", "DepName", emp.DepId);
            return View(emp);
        }
        // Post: Employee
        [HttpPost]
        public ActionResult Edit(Employee employee)
        {
            var dep = db.Departments.ToList();

            if (employee == null)
            {
                return HttpNotFound();
            }
            if (!ModelState.IsValid)
            {
                ViewBag.department = new SelectList(dep, "DepId", "DepName", employee.DepId);
                return View(employee);
            }
            var emp = db.Employees.Find(employee.EmpId);

            if (emp == null)
            {
                return HttpNotFound();
            }
            if (employee.Salary < 0 || employee.Salary > 1000000)
            {
                ModelState.AddModelError("", "Salary must be greater than 0 and less than 10,00,000");
                ViewBag.department = new SelectList(dep, "DepId", "DepName", employee.DepId);
                return View(employee);
            }

            bool email = db.Employees.Any(a => a.Email == employee.Email && a.EmpId != employee.EmpId);
            if (email)
            {
                ModelState.AddModelError("", "Email Already exists");
                ViewBag.department = new SelectList(dep, "DepId", "DepName", employee.DepId);
                return View(employee);
            }
            bool phone = db.Employees.Any(a => a.PhoneNumber == employee.PhoneNumber && a.EmpId != employee.EmpId);
            if (phone)
            {
                ModelState.AddModelError("", "phone Number Already exists");
                ViewBag.department = new SelectList(dep, "DepId", "DepName", employee.DepId);
                return View(employee);
            }
            emp.EmpName = employee.EmpName;
            emp.PhoneNumber = employee.PhoneNumber;
            emp.Email = employee.Email;
            emp.Salary = employee.Salary;
            emp.DepId = employee.DepId;
            db.SaveChanges();
            return RedirectToAction("Index");
        }
        // GET: Employee
        public ActionResult Delete(int? id)
        {
            var emp = db.Employees.Include(a => a.Department).FirstOrDefault(a => a.EmpId == id);
            if (emp == null)
            {
                return HttpNotFound();
            }

            return View(emp);
        }
        // Post: Employee
        [HttpPost]
        public ActionResult DeleteConfirm(Employee employee)
        {
            var emp = db.Employees.Find(employee.EmpId);

            if (emp == null)
            {
                return HttpNotFound();
            }
            db.Employees.Remove(emp);
            db.SaveChanges();
            return RedirectToAction("Index");
        }
        //Get:Employee/Search
        public ActionResult Search(string search)
        {
            var exists = db.Employees.Include(a => a.Department).Where(a => a.Email.Contains(search) || a.EmpName.Contains(search)).ToList();
            if (exists.Count == 0)
            {
                ModelState.AddModelError("search", "No employee found");
            }
            return View(nameof(Index), exists);
        }
        public ActionResult EmployeeSalaryReport()
        {
            var reportData = db.Employees.Include(a => a.Department).Select(a => new
            {
                a.EmpId,
                a.EmpName,
                DepName = a.Department.DepName,
                a.Salary,
                AnnualSalary = a.Salary * 12
            }).ToList();
            LocalReport report = new LocalReport();  //to process this RDLC report locally

            report.ReportPath = Server.MapPath(
                "~/Reports/EmployeeSalaryReport.rdlc"
            );   //where the RDLC file is

            ReportDataSource dataSource = new ReportDataSource(
                "EmployeeSalaryReport",
                reportData
            );   //creates a report data source.

            report.DataSources.Add(dataSource);//gives the report its actual data

            string mimeType;
            string encoding;
            string fileNameExtension;

            Warning[] warnings;
            string[] streams;

            byte[] pdf = report.Render(
                "PDF",
                null,
                out mimeType,
                out encoding,
                out fileNameExtension,
                out streams,
                out warnings
            ); //This takes the report and renders it into PDF format

            return File(pdf, "application/pdf");  //sends that PDF to the browser
        }
        public ActionResult CrystalReport()
        {
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
            ReportDocument report = new ReportDocument();
            report.Load(Server.MapPath("~/Reports/EmployeeSalaryCrystalReport.rpt"));
            report.SetDataSource(ds);
            return View(report);
        }

    }
}