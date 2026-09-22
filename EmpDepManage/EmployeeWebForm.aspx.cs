using EmpDepManage.Data;
using EmpDepManage.Models;
using System;
using System.Data.Entity.Validation;
using System.Linq;
using System.Web.UI.WebControls;

namespace EmpDepManage
{
    public partial class EmployeeWebForm : System.Web.UI.Page
    {
        private EmpDbContext db = new EmpDbContext();
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadDepartments();
                LoadEmployees();
            }
        }
        private void LoadDepartments()
        {
            ddlDepartment.DataSource = db.Departments.ToList();
            ddlDepartment.DataTextField = "DepName";
            ddlDepartment.DataValueField = "DepId";
            ddlDepartment.DataBind();
            ddlDepartment.Items.Insert(0, new ListItem("--Select Department--", "0"));
        }
        private void LoadEmployees()
        {
            gvEmployees.DataSource = db.Employees.ToList();
            gvEmployees.DataBind();
        }
        protected void btnSave_Click(object sender, EventArgs e)
        {
            Employee employee = new Employee();
            employee.EmpName = txtName.Text;
            employee.Email = txtEmail.Text;
            employee.PhoneNumber = txtPhone.Text;

            decimal salary;
            if(!decimal.TryParse(txtSalary.Text,out salary))
            {
                lblMessage.Text = "Please input a valid salary!";
                return;
            }
            employee.Salary = salary;
            employee.DepId = Convert.ToInt32(ddlDepartment.SelectedValue);
            db.Employees.Add(employee);
            db.SaveChanges();
            lblMessage.Text = "Employee Saved successfully.";
            LoadEmployees();
        }
        protected void gvEmployees_RowEditing(object sender, GridViewEditEventArgs e)
        {
            gvEmployees.EditIndex = e.NewEditIndex;
            LoadEmployees();
        }
        protected void gvEmployees_RowCancelingEdit(object sender,GridViewCancelEditEventArgs e)
        {
            gvEmployees.EditIndex = -1;
            LoadEmployees();
        }
        protected void gvEmployees_RowUpodating(object sender,GridViewUpdateEventArgs e)
        {
            int empId = Convert.ToInt32(gvEmployees.DataKeys[e.RowIndex].Value);
            Employee employee=db.Employees.Find(empId);
            employee.EmpName = ((TextBox)gvEmployees.Rows[e.RowIndex].Cells[2].Controls[0]).Text;
            employee.Email = ((TextBox)gvEmployees.Rows[e.RowIndex].Cells[3].Controls[0]).Text;
            employee.PhoneNumber = ((TextBox)gvEmployees.Rows[e.RowIndex].Cells[4].Controls[0]).Text;
            employee.Salary = Convert.ToDecimal(((TextBox)gvEmployees.Rows[e.RowIndex].Cells[5].Controls[0]).Text);
            db.SaveChanges();
            gvEmployees.EditIndex = -1;
            LoadEmployees();
            lblMessage.Text = "EMployee Updated Successfully.";

        }protected void gvEmployees_RowDeleting(object sender,GridViewDeleteEventArgs e)
        {
            int EmpId = Convert.ToInt32(gvEmployees.DataKeys[e.RowIndex].Value);
            Employee employee= db.Employees.Find(EmpId);
            if (employee != null)
            {
                db.Employees.Remove(employee);
                db.SaveChanges() ;
            }
            LoadEmployees() ;
            lblMessage.Text = "Employee deleted successfully.";
        }
    }
}