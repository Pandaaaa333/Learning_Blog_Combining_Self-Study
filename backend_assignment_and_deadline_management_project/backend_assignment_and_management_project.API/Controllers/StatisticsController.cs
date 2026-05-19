using backend_assignment_and_management_project.Application.Interfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace backend_assignment_and_management_project.API.Controllers
{
    [Route("api/statistics")]
    [ApiController]
    [Authorize] // Maybe require Admin role in the future
    public class StatisticsController : ControllerBase
    {
        private readonly IStatisticsService _statisticsService;

        public StatisticsController(IStatisticsService statisticsService)
        {
            _statisticsService = statisticsService;
        }

        [HttpGet("dashboard")]
        public async Task<IActionResult> GetDashboardStatistics()
        {
            var stats = await _statisticsService.GetDashboardStatisticsAsync();
            return Ok(stats);
        }
    }
}
