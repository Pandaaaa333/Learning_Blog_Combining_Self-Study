using backend_assignment_and_management_project.Application.DTOs.UserActivityLog;
using backend_assignment_and_management_project.Application.Interfaces;
using backend_assignment_and_management_project.Domain.Entities;
using backend_assignment_and_management_project.Infrastructure.Persistence;
using Microsoft.EntityFrameworkCore;

namespace backend_assignment_and_management_project.Infrastructure.Services
{
    public class UserActivityLogService : IUserActivityLogService
    {
        private readonly ApplicationDbContext _context;

        public UserActivityLogService(ApplicationDbContext context)
        {
            _context = context;
        }

        public async Task LogActionAsync(Guid userId, CreateUserActivityLogDto logDto)
        {
            var log = new UserActivityLog
            {
                UserId = userId,
                Action = logDto.Action,
                TargetEntity = logDto.TargetEntity,
                TargetId = logDto.TargetId,
                DataChange = logDto.DataChange,
                CreatedAt = DateTime.UtcNow
            };

            _context.UserActivityLogs.Add(log);
            await _context.SaveChangesAsync();
        }

        public async Task<IEnumerable<UserActivityLogDto>> GetLogsAsync(Guid? userId = null, int limit = 100)
        {
            var query = _context.UserActivityLogs
                .Include(l => l.User)
                .AsQueryable();

            if (userId.HasValue)
            {
                query = query.Where(l => l.UserId == userId.Value);
            }

            return await query
                .OrderByDescending(l => l.CreatedAt)
                .Take(limit)
                .Select(l => new UserActivityLogDto
                {
                    Id = l.Id,
                    Action = l.Action,
                    TargetEntity = l.TargetEntity,
                    TargetId = l.TargetId,
                    DataChange = l.DataChange,
                    CreatedAt = l.CreatedAt,
                    UserId = l.UserId,
                    Username = l.User.Name
                })
                .ToListAsync();
        }

        public async Task<IEnumerable<UserActivityLogStatisticsDto>> GetStatisticsAsync(DateTime startDate, DateTime endDate)
        {
            // Make sure to compare dates properly. Fetching data first or grouping in memory depending on provider support.
            // EF Core should be able to group by date part.
            var logs = await _context.UserActivityLogs
                .Where(l => l.CreatedAt >= startDate && l.CreatedAt <= endDate)
                .ToListAsync();

            var statistics = logs
                .GroupBy(l => l.CreatedAt.Date)
                .Select(g => new UserActivityLogStatisticsDto
                {
                    Date = g.Key,
                    TotalActions = g.Count(),
                    ActionCounts = g.GroupBy(x => x.Action)
                                    .Select(ag => new ActionCountDto
                                    {
                                        Action = ag.Key,
                                        Count = ag.Count()
                                    }).ToList()
                })
                .OrderBy(s => s.Date)
                .ToList();

            return statistics;
        }
    }
}
