using System.ComponentModel.DataAnnotations;

namespace backend_assignment_and_management_project.Application.DTOs.UserActivityLog
{
    public class CreateUserActivityLogDto
    {
        [Required]
        public string Action { get; set; } = string.Empty;

        public string? TargetEntity { get; set; }

        public Guid? TargetId { get; set; }

        public string? DataChange { get; set; }
    }
}
