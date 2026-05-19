using System;
using System.Security.Claims;
using System.Threading.Tasks;
using backend_assignment_and_management_project.Domain.Entities;
using backend_assignment_and_management_project.Infrastructure.Persistence;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace backend_assignment_and_management_project.API.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    [Authorize]
    public class ReportsController : ControllerBase
    {
        private readonly ApplicationDbContext _context;

        public ReportsController(ApplicationDbContext context)
        {
            _context = context;
        }

        private Guid GetCurrentUserId()
        {
            var userIdClaim = User.FindFirst(ClaimTypes.NameIdentifier);
            if (userIdClaim == null) throw new UnauthorizedAccessException();
            return Guid.Parse(userIdClaim.Value);
        }

        [HttpPost]
        public async Task<IActionResult> CreateReport([FromBody] CreateReportDto dto)
        {
            try
            {
                var reporterId = GetCurrentUserId();

                if (string.IsNullOrWhiteSpace(dto.TargetEntity))
                {
                    return BadRequest(new { message = "Target entity is required." });
                }

                if (dto.TargetId == Guid.Empty)
                {
                    return BadRequest(new { message = "Target ID is required." });
                }

                if (string.IsNullOrWhiteSpace(dto.Reason))
                {
                    return BadRequest(new { message = "Reason is required." });
                }

                var report = new Report
                {
                    ReporterId = reporterId,
                    TargetEntity = dto.TargetEntity,
                    TargetId = dto.TargetId,
                    Reason = dto.Reason,
                    IsResolved = false,
                    CreatedAt = DateTime.UtcNow
                };

                _context.Reports.Add(report);
                await _context.SaveChangesAsync();

                return Ok(new { message = "Report submitted successfully." });
            }
            catch (UnauthorizedAccessException)
            {
                return Unauthorized();
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { message = "An error occurred while submitting the report.", details = ex.Message });
            }
        }
    }

    public class CreateReportDto
    {
        public string TargetEntity { get; set; } = "Post";
        public Guid TargetId { get; set; }
        public string Reason { get; set; } = string.Empty;
    }
}
