using backend_assignment_and_management_project.Application.DTOs.Statistics;

namespace backend_assignment_and_management_project.Application.Interfaces
{
    public interface IStatisticsService
    {
        Task<DashboardStatisticsDto> GetDashboardStatisticsAsync();
    }
}
