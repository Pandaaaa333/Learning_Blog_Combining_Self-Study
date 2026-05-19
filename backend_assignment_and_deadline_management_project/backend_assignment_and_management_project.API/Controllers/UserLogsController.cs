using backend_assignment_and_management_project.Application.DTOs.UserActivityLog;
using backend_assignment_and_management_project.Application.Interfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System.Security.Claims;

namespace backend_assignment_and_management_project.API.Controllers
{
    [Route("api/user-logs")]
    [ApiController]
    [Authorize]
    public class UserLogsController : ControllerBase
    {
        private readonly IUserActivityLogService _logService;

        public UserLogsController(IUserActivityLogService logService)
        {
            _logService = logService;
        }

        [HttpPost]
        public async Task<IActionResult> LogAction([FromBody] CreateUserActivityLogDto dto)
        {
            var userIdStr = User.FindFirstValue(ClaimTypes.NameIdentifier);
            if (string.IsNullOrEmpty(userIdStr) || !Guid.TryParse(userIdStr, out var userId))
            {
                return Unauthorized();
            }

            await _logService.LogActionAsync(userId, dto);
            return Ok(new { message = "Log saved successfully" });
        }

        [HttpGet]
        public async Task<IActionResult> GetLogs([FromQuery] Guid? userId, [FromQuery] int limit = 100)
        {
            var logs = await _logService.GetLogsAsync(userId, limit);
            return Ok(logs);
        }

        [HttpGet("statistics")]
        public async Task<IActionResult> GetStatistics([FromQuery] DateTime? startDate, [FromQuery] DateTime? endDate)
        {
            // Default to last 30 days if not provided
            var start = startDate ?? DateTime.UtcNow.AddDays(-30);
            var end = endDate ?? DateTime.UtcNow;

            var stats = await _logService.GetStatisticsAsync(start, end);
            return Ok(stats);
        }
    }
}
