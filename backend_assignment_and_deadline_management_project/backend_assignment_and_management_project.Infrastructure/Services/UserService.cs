using backend_assignment_and_management_project.Application.DTOs;
using backend_assignment_and_management_project.Application.Interfaces;
using backend_assignment_and_management_project.Domain.Entities;
using backend_assignment_and_management_project.Infrastructure.Persistence;
using Microsoft.EntityFrameworkCore;
using BC = BCrypt.Net.BCrypt;

namespace backend_assignment_and_management_project.Infrastructure.Services
{
    public class UserService : IUserService
    {
        private readonly ApplicationDbContext _context;
        private readonly IStorageService _storageService;
        private readonly INotificationService _notificationService;

        public UserService(ApplicationDbContext context, IStorageService storageService, INotificationService notificationService)
        {
            _context = context;
            _storageService = storageService;
            _notificationService = notificationService;
        }

        public async Task<IEnumerable<UserResponse>> GetAllAsync()
        {
            var users = await _context.Users
                .Include(u => u.Role)
                .ToListAsync();

            var userResponses = new List<UserResponse>();
            foreach (var u in users)
            {
                userResponses.Add(new UserResponse
                {
                    Id = u.Id,
                    Name = u.Name,
                    Email = u.Email,
                    AvatarUrl = !string.IsNullOrEmpty(u.AvatarUrl) ? await _storageService.GetPresignedUrlAsync(u.AvatarUrl) : null,
                    Role = u.Role.Name,
                    Points = u.Points,
                    Level = u.Level
                });
            }
            return userResponses;
        }

        public async Task<UserResponse> GetByIdAsync(Guid id)
        {
            var user = await _context.Users
                .Include(u => u.Role)
                .FirstOrDefaultAsync(u => u.Id == id);

            if (user == null) return null!;

            return new UserResponse
            {
                Id = user.Id,
                Name = user.Name,
                Email = user.Email,
                AvatarUrl = !string.IsNullOrEmpty(user.AvatarUrl) ? await _storageService.GetPresignedUrlAsync(user.AvatarUrl) : null,
                Role = user.Role.Name,
                Points = user.Points,
                Level = user.Level
            };
        }

        public async Task<UserResponse> CreateAsync(CreateUserRequest request)
        {
            if (await _context.Users.AnyAsync(u => u.Email == request.Email))
            {
                throw new Exception("Email already exists.");
            }

            var role = await _context.Roles.FirstOrDefaultAsync(r => r.Name == request.Role);
            if (role == null)
            {
                role = new Role { Name = request.Role };
                _context.Roles.Add(role);
                await _context.SaveChangesAsync();
            }

            var user = new User
            {
                Name = request.Name,
                Email = request.Email,
                Password = BC.HashPassword(request.Password),
                RoleId = role.Id
            };

            _context.Users.Add(user);
            await _context.SaveChangesAsync();

            return new UserResponse
            {
                Id = user.Id,
                Name = user.Name,
                Email = user.Email,
                Role = role.Name,
                Points = user.Points,
                Level = user.Level
            };
        }

        public async Task<UserResponse> UpdateAsync(Guid id, UpdateUserRequest request)
        {
            var user = await _context.Users
                .Include(u => u.Role)
                .FirstOrDefaultAsync(u => u.Id == id);

            if (user == null) throw new Exception("User not found.");

            if (!string.IsNullOrEmpty(request.Name)) user.Name = request.Name;
            if (!string.IsNullOrEmpty(request.Email)) user.Email = request.Email;
            if (!string.IsNullOrEmpty(request.NewPassword)) user.Password = BC.HashPassword(request.NewPassword);
            if (!string.IsNullOrEmpty(request.AvatarUrl)) user.AvatarUrl = request.AvatarUrl;

            if (!string.IsNullOrEmpty(request.Role))
            {
                var role = await _context.Roles.FirstOrDefaultAsync(r => r.Name == request.Role);
                if (role == null)
                {
                    role = new Role { Name = request.Role };
                    _context.Roles.Add(role);
                    await _context.SaveChangesAsync();
                }
                user.RoleId = role.Id;
            }

            _context.Users.Update(user);
            await _context.SaveChangesAsync();

            return new UserResponse
            {
                Id = user.Id,
                Name = user.Name,
                Email = user.Email,
                AvatarUrl = !string.IsNullOrEmpty(user.AvatarUrl) ? await _storageService.GetPresignedUrlAsync(user.AvatarUrl) : null,
                Role = user.Role.Name,
                Points = user.Points,
                Level = user.Level
            };
        }

        public async Task<bool> DeleteAsync(Guid id)
        {
            var user = await _context.Users.FindAsync(id);
            if (user == null) return false;

            _context.Users.Remove(user);
            await _context.SaveChangesAsync();
            return true;
        }

        public async Task<UserResponse> ChangeRoleAsync(Guid userId, string roleName)
        {
            var user = await _context.Users
                .Include(u => u.Role)
                .FirstOrDefaultAsync(u => u.Id == userId);

            if (user == null) throw new Exception("User not found.");

            var role = await _context.Roles.FirstOrDefaultAsync(r => r.Name == roleName);
            if (role == null)
            {
                role = new Role { Name = roleName };
                _context.Roles.Add(role);
                await _context.SaveChangesAsync();
            }

            user.RoleId = role.Id;
            _context.Users.Update(user);
            await _context.SaveChangesAsync();

            return new UserResponse
            {
                Id = user.Id,
                Name = user.Name,
                Email = user.Email,
                AvatarUrl = !string.IsNullOrEmpty(user.AvatarUrl) ? await _storageService.GetPresignedUrlAsync(user.AvatarUrl) : null,
                Role = role.Name,
                Points = user.Points,
                Level = user.Level
            };
        }

        public async Task<UserResponse> UpdateProfileAsync(Guid userId, UpdateProfileRequest request)
        {
            var user = await _context.Users
                .Include(u => u.Role)
                .FirstOrDefaultAsync(u => u.Id == userId);

            if (user == null)
            {
                throw new Exception("User not found.");
            }

            if (!string.IsNullOrEmpty(request.Name))
            {
                user.Name = request.Name;
            }

            if (!string.IsNullOrEmpty(request.NewPassword))
            {
                user.Password = BC.HashPassword(request.NewPassword);
            }

            if (!string.IsNullOrEmpty(request.AvatarUrl))
            {
                user.AvatarUrl = request.AvatarUrl;
            }

            _context.Users.Update(user);
            await _context.SaveChangesAsync();

            return new UserResponse
            {
                Id = user.Id,
                Name = user.Name,
                Email = user.Email,
                AvatarUrl = !string.IsNullOrEmpty(user.AvatarUrl) ? await _storageService.GetPresignedUrlAsync(user.AvatarUrl) : null,
                Role = user.Role.Name,
                Points = user.Points,
                Level = user.Level
            };
        }

        public async Task<bool> FollowUserAsync(Guid followerId, Guid followingId)
        {
            if (followerId == followingId) return false;

            if (await _context.UserFollows.AnyAsync(f => f.FollowerId == followerId && f.FollowingId == followingId))
                return true;

            var follow = new UserFollow
            {
                FollowerId = followerId,
                FollowingId = followingId,
                CreatedAt = DateTime.UtcNow
            };

            _context.UserFollows.Add(follow);
            await _context.SaveChangesAsync();

            // Notify the user being followed
            var follower = await _context.Users.FindAsync(followerId);
            await _notificationService.CreateNotificationAsync(
                followingId,
                "Người theo dõi mới",
                $"{follower?.Name ?? "Ai đó"} đã bắt đầu theo dõi bạn.",
                "Follow",
                followerId,
                followerId
            );

            return true;
        }

        public async Task<bool> UnfollowUserAsync(Guid followerId, Guid followingId)
        {
            var follow = await _context.UserFollows.FindAsync(followerId, followingId);
            if (follow == null) return true;

            _context.UserFollows.Remove(follow);
            await _context.SaveChangesAsync();
            return true;
        }

        public async Task<IEnumerable<UserResponse>> GetFollowersAsync(Guid userId)
        {
            var followers = await _context.UserFollows
                .Where(f => f.FollowingId == userId)
                .Include(f => f.Follower)
                .ThenInclude(u => u.Role)
                .Select(f => f.Follower)
                .ToListAsync();

            var responses = new List<UserResponse>();
            foreach (var u in followers)
            {
                responses.Add(new UserResponse
                {
                    Id = u.Id,
                    Name = u.Name,
                    AvatarUrl = !string.IsNullOrEmpty(u.AvatarUrl) ? await _storageService.GetPresignedUrlAsync(u.AvatarUrl) : null,
                    Role = u.Role.Name,
                    Points = u.Points,
                    Level = u.Level
                });
            }
            return responses;
        }

        public async Task<IEnumerable<UserResponse>> GetFollowingAsync(Guid userId)
        {
            var following = await _context.UserFollows
                .Where(f => f.FollowerId == userId)
                .Include(f => f.Following)
                .ThenInclude(u => u.Role)
                .Select(f => f.Following)
                .ToListAsync();

            var responses = new List<UserResponse>();
            foreach (var u in following)
            {
                responses.Add(new UserResponse
                {
                    Id = u.Id,
                    Name = u.Name,
                    AvatarUrl = !string.IsNullOrEmpty(u.AvatarUrl) ? await _storageService.GetPresignedUrlAsync(u.AvatarUrl) : null,
                    Role = u.Role.Name,
                    Points = u.Points,
                    Level = u.Level
                });
            }
            return responses;
        }

        public async Task<bool> IsFollowingAsync(Guid followerId, Guid followingId)
        {
            return await _context.UserFollows.AnyAsync(f => f.FollowerId == followerId && f.FollowingId == followingId);
        }

        public async Task<IEnumerable<UserResponse>> GetLeaderboardAsync(int limit)
        {
            var users = await _context.Users
                .Include(u => u.Role)
                .OrderByDescending(u => u.Points)
                .Take(limit)
                .ToListAsync();

            var responses = new List<UserResponse>();
            foreach (var u in users)
            {
                responses.Add(new UserResponse
                {
                    Id = u.Id,
                    Name = u.Name,
                    Email = u.Email,
                    AvatarUrl = !string.IsNullOrEmpty(u.AvatarUrl) ? await _storageService.GetPresignedUrlAsync(u.AvatarUrl) : null,
                    Role = u.Role.Name,
                    Points = u.Points,
                    Level = u.Level
                });
            }
            return responses;
        }
    }
}
