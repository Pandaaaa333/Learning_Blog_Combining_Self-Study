using backend_assignment_and_management_project.Application.DTOs.UserActivityLog;

namespace backend_assignment_and_management_project.Application.Interfaces
{
    public interface IUserActivityLogService
    {
        Task LogActionAsync(Guid userId, CreateUserActivityLogDto logDto);
        Task<IEnumerable<UserActivityLogDto>> GetLogsAsync(Guid? userId = null, int limit = 100);
        Task<IEnumerable<UserActivityLogStatisticsDto>> GetStatisticsAsync(DateTime startDate, DateTime endDate);
    }
}
