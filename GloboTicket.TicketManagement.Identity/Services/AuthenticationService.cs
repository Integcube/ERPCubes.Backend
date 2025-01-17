﻿using ERPCubes.Application.Contracts.Persistence.Identity;
using ERPCubes.Application.Exceptions;
using ERPCubes.Application.Features.Crm.Tenant.Commands.SaveTenant;
using ERPCubes.Application.Models.Authentication;
using ERPCubes.Application.Models.Mail;
using ERPCubes.Identity.Models;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Options;
using Microsoft.IdentityModel.Tokens;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;

namespace ERPCubes.Identity.Services
{
    public class AuthenticationService: IAuthenticationService
    {
        private readonly UserManager<ApplicationUser> _userManager;
        private readonly SignInManager<ApplicationUser> _signInManager;
        private readonly JwtSettings _jwtSettings;
        private readonly ERPCubesIdentityDbContext _dbContext;
        public AuthenticationService(UserManager<ApplicationUser> userManager,
            IOptions<JwtSettings> jwtSettings,
            SignInManager<ApplicationUser> signInManager,
        ERPCubesIdentityDbContext dbContext)
        {
            _userManager = userManager;
            _jwtSettings = jwtSettings.Value;
            _signInManager = signInManager;
            _dbContext = dbContext;
        }

        public async Task<AuthenticationResponse> AuthenticateAsync(AuthenticationRequest request)
        {
            var user = await (
                       from u in _userManager.Users
                       where (u.UserName == request.Email|| u.Email.ToLower() == request.Email.ToLower()) && u.IsActive == 0
                       join t in _dbContext.Tenant on u.TenantId equals t.TenantId
                       where t.Subdomain == request.Subdomain
                      select new { User = u, Tenant = t }).FirstOrDefaultAsync();

            if (user == null)
            {
                throw new Exception($"User with {request.Email} not found.");
            }

            var result = await _signInManager.PasswordSignInAsync(user.User.UserName, request.Password, false, lockoutOnFailure: false);

            if (!result.Succeeded)
            {
                throw new Exception($"Credentials for '{request.Email} aren't valid'.");
            }

            JwtSecurityToken jwtSecurityToken = await GenerateToken(user.User);

            AuthenticationResponse response = new AuthenticationResponse
            {
                Id = user.User.Id,
                Token = new JwtSecurityTokenHandler().WriteToken(jwtSecurityToken),
                Email = user.User.Email,
                UserName = user.User.UserName,
                Name = user.User.FirstName + " " + user.User.LastName,
                TenantId = user.User.TenantId,
                TenantGuid= user.Tenant.TenantGuid,
                IsDocumentAcces = user.Tenant.IsDocumentAcces
            };
            
            return response;
        }

        public async Task<RegistrationResponse> RegisterAsync(RegistrationRequest request)
        {
            var existingUser = await _userManager.Users.SingleOrDefaultAsync(u => u.UserName == request.UserName && u.TenantId == request.TenantId);

            if (existingUser != null)
            {
                throw new Exception($"Username '{request.UserName}' already exists.");
            }

            var user = new ApplicationUser
            {
                Email = request.Email,
                FirstName = request.FirstName,
                LastName = request.LastName,
                UserName = request.UserName,
                PhoneNumber = request.PhoneNumber,
                EmailConfirmed = true,
                TenantId = request.TenantId,
                CreatedOn= DateTime.UtcNow,

            };

            var existingEmail = await _userManager.Users.SingleOrDefaultAsync(u => u.Email == request.Email && u.TenantId == request.TenantId);

            if (existingEmail == null)
            {
                var result = await _userManager.CreateAsync(user, request.Password);

                if (result.Succeeded)
                {
                    return new RegistrationResponse() { UserId = user.Id };
                }
                else
                {

                    var errors = string.Join(", ", result.Errors.Select(e => e.Description));
                    throw new Exception($"{errors}");
                }
            }
            else
            {
                throw new Exception($"Email {request.Email } already exists.");
            }
        }

        public async Task<RegistrationResponse> UpdateUserAsync(RegistrationRequest request)
        {
            try
            {
                DateTime TodayDate = DateTime.Now.ToUniversalTime();
                // Find the existing user by user ID
                var existingUser = await _userManager.FindByIdAsync(request.UserId);

                if (existingUser == null)
                {
                    throw new Exception($"User with ID '{request.UserId}' not found.");
                }

                // Update user properties
                existingUser.Email = request.Email;
                existingUser.FirstName = request.FirstName;
                existingUser.LastName = request.LastName;
                existingUser.UserName = request.UserName;
                existingUser.PhoneNumber = request.LastName;
                existingUser.ModifiedBy = request.UserId;
                existingUser.ModifiedOn = TodayDate;

                // Check if the email is being changed
                if (!string.Equals(existingUser.NormalizedEmail, request.Email, StringComparison.OrdinalIgnoreCase) && existingUser.TenantId == request.TenantId)
                {
                    var existingEmail = await _userManager.Users.SingleOrDefaultAsync(u => u.Email == request.Email && u.TenantId == request.TenantId);

                    if (existingEmail != null && existingEmail.Id != existingUser.Id)
                    {
                        throw new Exception($"Email '{request.Email}' is already associated with another user.");
                    }
                }

                // Update the password if provided
                if (!string.IsNullOrWhiteSpace(request.Password))
                {
                    var token = await _userManager.GeneratePasswordResetTokenAsync(existingUser);
                    var result = await _userManager.ResetPasswordAsync(existingUser, token, request.Password);

                    if (!result.Succeeded)
                    {
                        // Handle password update failure
                        var errors = string.Join(", ", result.Errors.Select(e => e.Description));
                  

                        throw new Exception($"{errors}");
                    }
                }

                // Update the user
                var resultUpdate = await _userManager.UpdateAsync(existingUser);

                if (resultUpdate.Succeeded)
                {
                    return new RegistrationResponse() { UserId = existingUser.Id };
                }
                else
                {
                    // Handle user update failure
                    var errors = string.Join(", ", resultUpdate.Errors.Select(e => e.Description));


                    throw new Exception($"{errors}");
                }
            }
            catch (Exception ex)
            {
                // Log the exception for internal investigation
                // logger.LogError(ex, "Error occurred while updating user.");
                throw; // Rethrow the exception for the calling code to handle
            }
        }



        public async  Task<bool> SaveTenant(SaveTenantCommand obj)
        {
            using (var transaction = await _dbContext.Database.BeginTransactionAsync())
            {
                try
                {
                    Tenant NewObj = new Tenant();

                    NewObj.Name = obj.Company;
                    NewObj.Subdomain = obj.Domain;
                    NewObj.IsDocumentAcces = 1;
                    NewObj.IsDeleted = 0;
                    NewObj.Owner = obj.FirstName;
                    NewObj.CreatedBy = obj.FirstName;
                    NewObj.CreatedDate = DateTime.UtcNow;
                    NewObj.TenantGuid = Guid.NewGuid();

                    _dbContext.Add(NewObj);
                    _dbContext.SaveChanges();
                    _userManager.UserValidators.Clear();

                    ApplicationUser user = new ApplicationUser();                 
                    user.FirstName = obj.FirstName;
                    user.LastName = obj.LastName;
                    user.UserName = obj.FirstName.ToLower() + "01";
                    user.PhoneNumber = "";
                    user.EmailConfirmed = true;
                    user.TenantId = NewObj.TenantId;
                    user.CreatedOn = DateTime.UtcNow;
                    user.Createdby = "-1";
                    user.Email = obj.Email;
                    var result = await _userManager.CreateAsync(user, obj.Password);
                    var ob = await _dbContext.Tenant.FirstOrDefaultAsync(a => a.TenantId == NewObj.TenantId);
                    ob.Owner = user.Id;
                   
                    _dbContext.SaveChanges();
                    await transaction.CommitAsync();

                    return true;
                }

                catch (Exception e)
                {
                    await transaction.RollbackAsync();
                    throw new BadRequestException(e.Message);

                }
            }
        }


        private async Task<JwtSecurityToken> GenerateToken(ApplicationUser user)
        {
            var userClaims = await _userManager.GetClaimsAsync(user);
            var roles = await _userManager.GetRolesAsync(user);

            var roleClaims = new List<Claim>();

            for (int i = 0; i < roles.Count; i++)
            {
                roleClaims.Add(new Claim("roles", roles[i]));
            }

            var claims = new[]
            {
                new Claim(JwtRegisteredClaimNames.Sub, user.UserName),
                new Claim(JwtRegisteredClaimNames.Jti, Guid.NewGuid().ToString()),
                new Claim(JwtRegisteredClaimNames.Email, user.Email),
                new Claim("uid", user.Id),
                //new Claim("tenantId", user.TenantId.ToString()) 

            }
            .Union(userClaims)
            .Union(roleClaims);

            var symmetricSecurityKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(_jwtSettings.Key));
            var signingCredentials = new SigningCredentials(symmetricSecurityKey, SecurityAlgorithms.HmacSha256);

            var jwtSecurityToken = new JwtSecurityToken(
                issuer: _jwtSettings.Issuer,
                audience: _jwtSettings.Audience,
                claims: claims,
                expires: DateTime.UtcNow.AddMinutes(_jwtSettings.DurationInMinutes),
                signingCredentials: signingCredentials);
            return jwtSecurityToken;
        }
    }
}
