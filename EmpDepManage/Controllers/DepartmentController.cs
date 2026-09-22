using EmpDepManage.Data;
using EmpDepManage.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace EmpDepManage.Controllers
{
    public class DepartmentController : Controller
    {
        private EmpDbContext db= new EmpDbContext();
        // GET: Department
        public ActionResult Index()
        {
            var dep = db.Departments.ToList();
            return View(dep);
        }
        // GET: Department
        public ActionResult Create()
        {
            return View();
        }
        // Post: Department
        [HttpPost]
        public ActionResult Create(Department department)
        {if (!ModelState.IsValid)
            {
                return View(department);
            }
            bool exists= db.Departments.Any(a=>a.DepName==department.DepName);
            if (exists)
            {
                ModelState.AddModelError("", "Department already exists.");
                return View(department);
            }
            db.Departments.Add(department);
            db.SaveChanges();
            return RedirectToAction("Index");
        }
        // GET: Department
        public ActionResult Edit(int? id)
        {
            var dep = db.Departments.Find(id);
            if (dep == null)
            {
                return HttpNotFound();
            }
            return View(dep);
        }
        // Post: Department
        [HttpPost]
        public ActionResult Edit(Department department)
        {
            if (!ModelState.IsValid)
            {
                return View(department);
            }
            var dep=db.Departments.FirstOrDefault(a=>a.DepId==department.DepId);
          
            bool exists= db.Departments.Any(a=>a.DepName==department.DepName && a.DepId!=department.DepId);
            if (exists)
            {
                ModelState.AddModelError("", "Department already exists.");
                return View(department);
            }
            dep.DepId = department.DepId;
            dep.DepName = department.DepName;
            db.SaveChanges();
            return RedirectToAction("Index");
        }
        // GET: Department
        public ActionResult Delete(int? id)
        {
            var dep = db.Departments.Find(id);
            if (dep == null)
            {
                return HttpNotFound();
            }

            return View(dep);
        }
        // Post: Department
        [HttpPost]
        public ActionResult DeleteConfirm(Department department)
        {
            var dep = db.Departments.Find(department.DepId);
            if (dep == null)
            {
                return HttpNotFound();
            }
            bool hasEmployee = db.Employees.Any(e => e.DepId == department.DepId);

            if (hasEmployee)
            {
                ModelState.AddModelError("", "Cannot delete this department because employees are assigned to it.");
                return View("delete",department);
            }
            db.Departments.Remove(dep);
            db.SaveChanges();
            return RedirectToAction("Index");
        }
    }
}