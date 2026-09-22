namespace EmpDepManage.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class Init : DbMigration
    {
        public override void Up()
        {
            CreateTable(
                "dbo.Departments",
                c => new
                    {
                        DepId = c.Int(nullable: false, identity: true),
                        DepName = c.String(nullable: false),
                    })
                .PrimaryKey(t => t.DepId);
            
            CreateTable(
                "dbo.Employees",
                c => new
                    {
                        EmpId = c.Int(nullable: false, identity: true),
                        EmpName = c.String(nullable: false),
                        Email = c.String(nullable: false),
                        PhoneNumber = c.String(nullable: false),
                        Salary = c.Decimal(nullable: false, precision: 18, scale: 2),
                        DepId = c.Int(nullable: false),
                    })
                .PrimaryKey(t => t.EmpId)
                .ForeignKey("dbo.Departments", t => t.DepId, cascadeDelete: true)
                .Index(t => t.DepId);
            
        }
        
        public override void Down()
        {
            DropForeignKey("dbo.Employees", "DepId", "dbo.Departments");
            DropIndex("dbo.Employees", new[] { "DepId" });
            DropTable("dbo.Employees");
            DropTable("dbo.Departments");
        }
    }
}
