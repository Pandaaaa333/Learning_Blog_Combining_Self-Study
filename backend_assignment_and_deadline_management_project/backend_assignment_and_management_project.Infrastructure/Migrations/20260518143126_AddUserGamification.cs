using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace backend_assignment_and_management_project.Infrastructure.Migrations
{
    /// <inheritdoc />
    public partial class AddUserGamification : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<int>(
                name: "level",
                table: "users",
                type: "integer",
                nullable: false,
                defaultValue: 1);

            migrationBuilder.AddColumn<int>(
                name: "points",
                table: "users",
                type: "integer",
                nullable: false,
                defaultValue: 0);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "level",
                table: "users");

            migrationBuilder.DropColumn(
                name: "points",
                table: "users");
        }
    }
}
