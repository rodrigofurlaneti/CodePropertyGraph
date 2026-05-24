using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace CodePropertyGraph.Infrastructure.Migrations
{
    /// <inheritdoc />
    public partial class AddApiEndpointAndHandlerContract : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "ApiEndpoint",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    ControllerId = table.Column<int>(type: "int", nullable: false),
                    MethodName = table.Column<string>(type: "nvarchar(100)", maxLength: 100, nullable: false),
                    HttpVerb = table.Column<string>(type: "nvarchar(10)", maxLength: 10, nullable: false),
                    Route = table.Column<string>(type: "nvarchar(300)", maxLength: 300, nullable: false),
                    InputId = table.Column<int>(type: "int", nullable: true),
                    OutputId = table.Column<int>(type: "int", nullable: true),
                    Roles = table.Column<string>(type: "nvarchar(200)", maxLength: 200, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_ApiEndpoint", x => x.Id);
                    table.ForeignKey(
                        name: "FK_ApiEndpoint_CodeElement_ControllerId",
                        column: x => x.ControllerId,
                        principalTable: "CodeElement",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_ApiEndpoint_CodeElement_InputId",
                        column: x => x.InputId,
                        principalTable: "CodeElement",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_ApiEndpoint_CodeElement_OutputId",
                        column: x => x.OutputId,
                        principalTable: "CodeElement",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.CreateTable(
                name: "HandlerContract",
                columns: table => new
                {
                    HandlerId = table.Column<int>(type: "int", nullable: false),
                    InputId = table.Column<int>(type: "int", nullable: false),
                    OutputId = table.Column<int>(type: "int", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_HandlerContract", x => x.HandlerId);
                    table.ForeignKey(
                        name: "FK_HandlerContract_CodeElement_HandlerId",
                        column: x => x.HandlerId,
                        principalTable: "CodeElement",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_HandlerContract_CodeElement_InputId",
                        column: x => x.InputId,
                        principalTable: "CodeElement",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_HandlerContract_CodeElement_OutputId",
                        column: x => x.OutputId,
                        principalTable: "CodeElement",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.CreateIndex(
                name: "IX_ApiEndpoint_ControllerId",
                table: "ApiEndpoint",
                column: "ControllerId");

            migrationBuilder.CreateIndex(
                name: "IX_ApiEndpoint_InputId",
                table: "ApiEndpoint",
                column: "InputId");

            migrationBuilder.CreateIndex(
                name: "IX_ApiEndpoint_OutputId",
                table: "ApiEndpoint",
                column: "OutputId");

            migrationBuilder.CreateIndex(
                name: "IX_HandlerContract_InputId",
                table: "HandlerContract",
                column: "InputId");

            migrationBuilder.CreateIndex(
                name: "IX_HandlerContract_OutputId",
                table: "HandlerContract",
                column: "OutputId");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "ApiEndpoint");

            migrationBuilder.DropTable(
                name: "HandlerContract");
        }
    }
}
