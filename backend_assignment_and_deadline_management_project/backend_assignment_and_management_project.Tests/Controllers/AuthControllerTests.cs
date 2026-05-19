using System.Net;
using System.Net.Http.Json;
using backend_assignment_and_management_project.Application.DTOs;
using Xunit;

namespace backend_assignment_and_management_project.Tests.Controllers
{
    public class AuthControllerTests : IClassFixture<CustomWebApplicationFactory<Program>>
    {
        private readonly HttpClient _client;
        private readonly CustomWebApplicationFactory<Program> _factory;

        public AuthControllerTests(CustomWebApplicationFactory<Program> factory)
        {
            _factory = factory;
            _client = factory.CreateClient();
        }

        [Fact]
        public async Task RegisterAndLogin_ShouldSucceed_AndReturnJwtToken()
        {
            // Arrange: Generate unique email to avoid collisions in DB
            var email = $"student_{Guid.NewGuid()}@example.com";
            var registerRequest = new RegisterRequest
            {
                Name = "John Doe",
                Email = email,
                Password = "Password123"
            };

            // Act 1: Register User
            var registerResponse = await _client.PostAsJsonAsync("/api/auth/register", registerRequest);
            
            // Assert 1: Registration succeeded
            Assert.Equal(HttpStatusCode.OK, registerResponse.StatusCode);
            
            var regResult = await registerResponse.Content.ReadFromJsonAsync<AuthResponse>();
            Assert.NotNull(regResult);
            Assert.NotNull(regResult.Token);
            Assert.Equal("John Doe", regResult.User.Name);
            Assert.Equal(email, regResult.User.Email);

            // Act 2: Login User
            var loginRequest = new LoginRequest
            {
                Email = email,
                Password = "Password123"
            };
            var loginResponse = await _client.PostAsJsonAsync("/api/auth/login", loginRequest);

            // Assert 2: Login succeeded and returned token
            Assert.Equal(HttpStatusCode.OK, loginResponse.StatusCode);
            
            var loginResult = await loginResponse.Content.ReadFromJsonAsync<AuthResponse>();
            Assert.NotNull(loginResult);
            Assert.NotEmpty(loginResult.Token);
            Assert.Equal("John Doe", loginResult.User.Name);
        }

        [Fact]
        public async Task Login_WithWrongPassword_ShouldReturnUnauthorized()
        {
            // Arrange
            var loginRequest = new LoginRequest
            {
                Email = "nonexistent@example.com",
                Password = "WrongPassword"
            };

            // Act
            var response = await _client.PostAsJsonAsync("/api/auth/login", loginRequest);

            // Assert
            Assert.Equal(HttpStatusCode.Unauthorized, response.StatusCode);
        }
    }
}
