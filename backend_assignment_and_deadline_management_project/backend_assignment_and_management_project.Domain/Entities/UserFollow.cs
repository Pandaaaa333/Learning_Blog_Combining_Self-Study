using System.ComponentModel.DataAnnotations.Schema;

namespace backend_assignment_and_management_project.Domain.Entities
{
    [Table("user_follows")]
    public class UserFollow
    {
        [Column("follower_id")]
        public Guid FollowerId { get; set; }

        [ForeignKey("FollowerId")]
        public User Follower { get; set; } = null!;

        [Column("following_id")]
        public Guid FollowingId { get; set; }

        [ForeignKey("FollowingId")]
        public User Following { get; set; } = null!;

        [Column("created_at")]
        public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
    }
}
