<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="CrystalReportViewer.aspx.cs" Inherits="EmpDepManage.Views.Employee.CrystalReportViewer" %>
<%@ Register Assembly="CrystalDecisions.Web"
    NameSpace="CrystalDecisions.Web"
    TagPreFix="CR"%>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
       <CR:CrystalReportViewer
           ID="CrystalReportViewer1"
           runat="server"
           AutoDataBind="true"
           width="100%"
           height="800px" />
        </form>
</body>
</html>
