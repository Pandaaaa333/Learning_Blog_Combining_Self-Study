namespace backend_assignment_and_management_project.Application.DTOs.UserActivityLog
{
    public class UserActivityLogDto
    {
        public Guid Id { get; set; }
        public string Action { get; set; } = string.Empty;
        public string? TargetEntity { get; set; }
        public Guid? TargetId { get; set; }
        public string? DataChange { get; set; }
        public DateTime CreatedAt { get; set; }
        public Guid UserId { get; set; }
        public string? Username { get; set; } // Optional: Can join with User table to return username
    }
}
