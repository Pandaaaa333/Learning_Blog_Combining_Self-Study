using backend_assignment_and_management_project.Application.DTOs;
using backend_assignment_and_management_project.Application.Interfaces;
using backend_assignment_and_management_project.Domain.Entities;
using backend_assignment_and_management_project.Infrastructure.Persistence;
using Microsoft.EntityFrameworkCore;

namespace backend_assignment_and_management_project.Infrastructure.Services
{
    public class NotificationService : INotificationService
    {
        private readonly ApplicationDbContext _context;
        private readonly IStorageService _storageService;

        public NotificationService(ApplicationDbContext context, IStorageService storageService)
        {
            _context = context;
            _storageService = storageService;
        }

        public async Task CreateNotificationAsync(Guid userId, string title, string content, string type, Guid? targetId = null, Guid? actorId = null)
        {
            var notification = new Notification
            {
                UserId = userId,
                Title = title,
                Content = content,
                Type = type,
                TargetId = targetId,
                ActorId = actorId,
                CreatedAt = DateTime.UtcNow,
                IsRead = false
            };

            _context.Notifications.Add(notification);
            await _context.SaveChangesAsync();
        }

        public async Task<IEnumerable<NotificationDto>> GetUserNotificationsAsync(Guid userId)
        {
            var notifications = await _context.Notifications
                .Include(n => n.Actor)
                .Where(n => n.UserId == userId)
                .OrderByDescending(n => n.CreatedAt)
                .ToListAsync();

            var dtos = new List<NotificationDto>();
            foreach (var n in notifications)
            {
                dtos.Add(new NotificationDto
                {
                    Id = n.Id,
                    Title = n.Title,
                    Content = n.Content,
                    Type = n.Type,
                    TargetId = n.TargetId,
                    ActorId = n.ActorId,
                    ActorName = n.Actor?.Name,
                    ActorAvatar = !string.IsNullOrEmpty(n.Actor?.AvatarUrl) ? await _storageService.GetPresignedUrlAsync(n.Actor.AvatarUrl) : null,
                    IsRead = n.IsRead,
                    CreatedAt = n.CreatedAt
                });
            }
            return dtos;
        }

        public async Task MarkAsReadAsync(Guid notificationId)
        {
            var notification = await _context.Notifications.FindAsync(notificationId);
            if (notification != null)
            {
                notification.IsRead = true;
                await _context.SaveChangesAsync();
            }
        }

        public async Task MarkAllAsReadAsync(Guid userId)
        {
            var notifications = await _context.Notifications
                .Where(n => n.UserId == userId && !n.IsRead)
                .ToListAsync();

            foreach (var n in notifications)
            {
                n.IsRead = true;
            }

            await _context.SaveChangesAsync();
        }
    }
}
