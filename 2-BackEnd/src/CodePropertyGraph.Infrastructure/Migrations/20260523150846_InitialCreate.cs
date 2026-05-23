using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace CodePropertyGraph.Infrastructure.Migrations
{
    /// <inheritdoc />
    public partial class InitialCreate : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "Directory",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Path = table.Column<string>(type: "nvarchar(1000)", maxLength: 1000, nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Directory", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "Layer",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Name = table.Column<string>(type: "nvarchar(100)", maxLength: 100, nullable: false),
                    Description = table.Column<string>(type: "nvarchar(255)", maxLength: 255, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Layer", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "Namespace",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    FullName = table.Column<string>(type: "nvarchar(500)", maxLength: 500, nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Namespace", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "Project",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Name = table.Column<string>(type: "nvarchar(200)", maxLength: 200, nullable: false),
                    ProjectType = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Project", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "CodeElement",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Name = table.Column<string>(type: "nvarchar(200)", maxLength: 200, nullable: false),
                    ElementType = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: false),
                    IsAbstract = table.Column<bool>(type: "bit", nullable: false, defaultValue: false),
                    IsSealed = table.Column<bool>(type: "bit", nullable: false, defaultValue: false),
                    LayerId = table.Column<int>(type: "int", nullable: false),
                    ProjectId = table.Column<int>(type: "int", nullable: false),
                    NamespaceId = table.Column<int>(type: "int", nullable: false),
                    DirectoryId = table.Column<int>(type: "int", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_CodeElement", x => x.Id);
                    table.ForeignKey(
                        name: "FK_CodeElement_Directory_DirectoryId",
                        column: x => x.DirectoryId,
                        principalTable: "Directory",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_CodeElement_Layer_LayerId",
                        column: x => x.LayerId,
                        principalTable: "Layer",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_CodeElement_Namespace_NamespaceId",
                        column: x => x.NamespaceId,
                        principalTable: "Namespace",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_CodeElement_Project_ProjectId",
                        column: x => x.ProjectId,
                        principalTable: "Project",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.CreateTable(
                name: "ElementDependency",
                columns: table => new
                {
                    SourceElementId = table.Column<int>(type: "int", nullable: false),
                    TargetElementId = table.Column<int>(type: "int", nullable: false),
                    DependencyType = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: false),
                    IsDirect = table.Column<bool>(type: "bit", nullable: false, defaultValue: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_ElementDependency", x => new { x.SourceElementId, x.TargetElementId, x.DependencyType });
                    table.ForeignKey(
                        name: "FK_ElementDependency_CodeElement_SourceElementId",
                        column: x => x.SourceElementId,
                        principalTable: "CodeElement",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_ElementDependency_CodeElement_TargetElementId",
                        column: x => x.TargetElementId,
                        principalTable: "CodeElement",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.CreateTable(
                name: "ElementImplementation",
                columns: table => new
                {
                    ClassId = table.Column<int>(type: "int", nullable: false),
                    InterfaceId = table.Column<int>(type: "int", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_ElementImplementation", x => new { x.ClassId, x.InterfaceId });
                    table.ForeignKey(
                        name: "FK_ElementImplementation_CodeElement_ClassId",
                        column: x => x.ClassId,
                        principalTable: "CodeElement",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_ElementImplementation_CodeElement_InterfaceId",
                        column: x => x.InterfaceId,
                        principalTable: "CodeElement",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.CreateIndex(
                name: "IX_CodeElement_DirectoryId",
                table: "CodeElement",
                column: "DirectoryId");

            migrationBuilder.CreateIndex(
                name: "IX_CodeElement_LayerId",
                table: "CodeElement",
                column: "LayerId");

            migrationBuilder.CreateIndex(
                name: "IX_CodeElement_NamespaceId",
                table: "CodeElement",
                column: "NamespaceId");

            migrationBuilder.CreateIndex(
                name: "IX_CodeElement_ProjectId",
                table: "CodeElement",
                column: "ProjectId");

            migrationBuilder.CreateIndex(
                name: "IX_Directory_Path",
                table: "Directory",
                column: "Path",
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_ElementDependency_TargetElementId",
                table: "ElementDependency",
                column: "TargetElementId");

            migrationBuilder.CreateIndex(
                name: "IX_ElementImplementation_InterfaceId",
                table: "ElementImplementation",
                column: "InterfaceId");

            migrationBuilder.CreateIndex(
                name: "IX_Layer_Name",
                table: "Layer",
                column: "Name",
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_Namespace_FullName",
                table: "Namespace",
                column: "FullName",
                unique: true);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "ElementDependency");

            migrationBuilder.DropTable(
                name: "ElementImplementation");

            migrationBuilder.DropTable(
                name: "CodeElement");

            migrationBuilder.DropTable(
                name: "Directory");

            migrationBuilder.DropTable(
                name: "Layer");

            migrationBuilder.DropTable(
                name: "Namespace");

            migrationBuilder.DropTable(
                name: "Project");
        }
    }
}
