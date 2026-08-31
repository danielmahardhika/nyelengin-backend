using System.ComponentModel.DataAnnotations;

namespace UserService.DTOs;

public record LoginRequest(
    [Required, EmailAddress] string Email,
    [Required] string Password
);
