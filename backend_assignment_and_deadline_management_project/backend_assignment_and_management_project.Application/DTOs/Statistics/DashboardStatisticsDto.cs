namespace backend_assignment_and_management_project.Application.DTOs.Statistics
{
    public class DashboardStatisticsDto
    {
        public int TotalStudents { get; set; }
        public int ActiveDeadlines { get; set; }
        public int TotalPosts { get; set; }
        public int PendingReports { get; set; }
        public double DeadlineCompletionRate { get; set; }
    }
}
