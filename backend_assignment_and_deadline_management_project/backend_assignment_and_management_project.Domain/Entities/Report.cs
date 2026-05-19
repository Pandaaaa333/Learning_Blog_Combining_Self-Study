using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace backend_assignment_and_management_project.Domain.Entities
{
    [Table("reports")]
    public class Report
    {
        [Key]
        [Column("id")]
        public Guid Id { get; set; } = Guid.NewGuid();

        [Required]
        [Column("reporter_id")]
        public Guid ReporterId { get; set; }

        [ForeignKey("ReporterId")]
        public User Reporter { get; set; } = null!;

        [Required]
        [Column("target_entity")]
        [MaxLength(100)]
        public string TargetEntity { get; set; } = string.Empty; // e.g., "Post", "Comment", "User"

        [Required]
        [Column("target_id")]
        public Guid TargetId { get; set; }

        [Required]
        [Column("reason")]
        [MaxLength(500)]
        public string Reason { get; set; } = string.Empty;

        [Column("is_resolved")]
        public bool IsResolved { get; set; } = false;

        [Column("created_at")]
        public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
    }
}
