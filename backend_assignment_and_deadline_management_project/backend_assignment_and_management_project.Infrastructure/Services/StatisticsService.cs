using backend_assignment_and_management_project.Application.DTOs.Statistics;
using backend_assignment_and_management_project.Application.Interfaces;
using backend_assignment_and_management_project.Infrastructure.Persistence;
using Microsoft.EntityFrameworkCore;

namespace backend_assignment_and_management_project.Infrastructure.Services
{
    public class StatisticsService : IStatisticsService
    {
        private readonly ApplicationDbContext _context;

        public StatisticsService(ApplicationDbContext context)
        {
            _context = context;
        }

        public async Task<DashboardStatisticsDto> GetDashboardStatisticsAsync()
        {
            var totalStudents = await _context.Users
                .Include(u => u.Role)
                .CountAsync(u => u.Role.Name == "User");

            var activeDeadlines = await _context.TodoTasks
                .CountAsync(t => !t.IsCompleted);

            var totalPosts = await _context.Posts.CountAsync();

            var pendingReports = await _context.Reports
                .CountAsync(r => !r.IsResolved);

            var totalTasks = await _context.TodoTasks.CountAsync();
            var completedTasks = await _context.TodoTasks.CountAsync(t => t.IsCompleted);
            
            double completionRate = 0;
            if (totalTasks > 0)
            {
                completionRate = Math.Round((double)completedTasks / totalTasks * 100, 2);
            }

            return new DashboardStatisticsDto
            {
                TotalStudents = totalStudents,
                ActiveDeadlines = activeDeadlines,
                TotalPosts = totalPosts,
                PendingReports = pendingReports,
                DeadlineCompletionRate = completionRate
            };
        }
    }
}
