<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="EmployeeWebForm.aspx.cs" Inherits="EmpDepManage.EmployeeWebForm" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
       <h2>Employee Management</h2>
        <asp:Label ID="lblName" runat="server" Text="Employee Name"></asp:Label>
        <br />
        <asp:TextBox ID="txtName" runat="server"></asp:TextBox>
        <br /><br />
        <asp:Label ID="lblDepartment" runat="server" Text="Department"></asp:Label>
        <br />
        <asp:DropDownList ID="ddlDepartment" runat="server"></asp:DropDownList>
        <br />
        <asp:Label ID="lblEmail" runat="server" Text="Email"></asp:Label>
        <br />
        <asp:TextBox ID="txtEmail" runat="server"></asp:TextBox>
        <br />
        <asp:Label ID="lblSalary" runat="server" Text="Salary"></asp:Label>
        <br />
        <asp:TextBox ID="txtSalary" runat="server" ></asp:TextBox>        <br />
        <asp:Label ID="lblPhone" runat="server" Text="Phone Number"></asp:Label>
        <br />
        <asp:TextBox ID="txtPhone" runat="server"></asp:TextBox>
        <br /><br />
        <asp:Button ID="btnSave"
            runat="server" Text="Save" OnClick="btnSave_Click" />
        <br /><br />
        <asp:Label ID="lblMessage" runat="server"></asp:Label>
        <asp:GridView ID="gvEmployees" runat="server" AutoGenerateColumns="False"
            AutoGenerateEditButton="true"
DataKeyNames="EmpId"
            OnRowEditing="gvEmployees_RowEditing"
            OnRowCancelingEdit="gvEmployees_RowCancelingEdit"
            OnRowUpdating="gvEmployees_RowUpodating"
            OnRowDeleting="gvEmployees_RowDeleting">
            <Columns>
                <asp:BoundField DataField="EmpId" HeaderText="ID" ReadOnly="true" />
                <asp:BoundField DataField="EmpName" HeaderText="Name" />
                <asp:BoundField DataField="Email" HeaderText="Email" />
                <asp:BoundField DataField="PhoneNumber" HeaderText="Phone" />
                <asp:BoundField DataField="Salary" HeaderText="Salary" />
                <asp:BoundField DataField="DepId" HeaderText="Department ID" />
                <asp:CommandField ShowDeleteButton="true" />
            </Columns>
        </asp:GridView>
    </form>

</body>
</html>
