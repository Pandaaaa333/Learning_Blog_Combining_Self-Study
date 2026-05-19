namespace backend_assignment_and_management_project.Application.DTOs.UserActivityLog
{
    public class UserActivityLogStatisticsDto
    {
        public DateTime Date { get; set; }
        public int TotalActions { get; set; }
        public List<ActionCountDto> ActionCounts { get; set; } = new List<ActionCountDto>();
    }

    public class ActionCountDto
    {
        public string Action { get; set; } = string.Empty;
        public int Count { get; set; }
    }
}
