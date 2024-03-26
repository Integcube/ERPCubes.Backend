using ERPCubes.Application.Contracts.Persistence.Facebook;
using ERPCubes.Application.Exceptions;
using ERPCubes.Application.Features.Facebook.Commands.SaveFacebookUser;
using ERPCubes.Application.Features.Google.Commands.SaveAuth;
using ERPCubes.Application.Features.Google.Queries.GetAuthCode;
using ERPCubes.Identity;
using ERPCubes.Identity.Models;
using Microsoft.EntityFrameworkCore;

namespace ERPCubes.Persistence.Repositories
{
    public class SocialRepository : IAsyncSocialRepository
    {
        protected readonly ERPCubesIdentityDbContext _dbContextIdentity;
        public SocialRepository(ERPCubesIdentityDbContext dbContextIdentity)
        {
            _dbContextIdentity = dbContextIdentity;
        }


        public async Task<string> GetAuthCode(GetAuthCodeQuery request)
        {
            try
            {
                //SocialUsers? socialUser = await (from a in _dbContextIdentity.SocialUsers.Where(a => a.TenantId == request.TenantId && a.Provider == request.Provider)
                //                                 select a).FirstOrDefaultAsync();
                var auth = await (from a in _dbContextIdentity.SocialUserTokens.Where(a => a.TenantId == request.TenantId && a.Provider == request.Provider)
                                  select a).FirstOrDefaultAsync();
                return auth.AuthToken;

            }
            catch (Exception ex)
            {
                throw new BadRequestException(ex.Message);

            }


        }

        public async Task RegisterGoogleUser(SaveGoogleAuthUserCommand request)
        {
            try
            {

                var deleteSql1 = $"DELETE FROM \"SocialUsers\" WHERE \"TenantId\" = {request.TenantId}";
                var deleteSql2 = $"DELETE FROM \"SocialUserTokens\" WHERE \"TenantId\" = {request.TenantId}";

                _dbContextIdentity.Database.ExecuteSqlRaw(deleteSql1);
                _dbContextIdentity.Database.ExecuteSqlRaw(deleteSql2);

                SocialUsers users = new SocialUsers();
                    users.Id = request.User.Sub;
                    users.Provider = "GOOGLE";
                    users.FirstName = request.User.Given_Name;
                    users.Name = request.User.Name;
                    users.LastName = request.User.Family_Name;
                    users.PhotoUrl = request.User.Picture;
                    users.Email = request.User.Email;
                    users.CreatedBy = request.Id;
                    users.CreatedDate = DateTime.Now.ToUniversalTime();
                    users.TenantId = request.TenantId;
                    _dbContextIdentity.Add(users);
                    _dbContextIdentity.SaveChanges();
                    SocialUserTokens token = new SocialUserTokens();
                    token.AuthToken = request.AuthToken;
                    token.Provider = "GOOGLE";
                    token.AuthorizationCode = request.AuthCode;
                    token.IdToken = request.IdToken;
                    token.CreatedBy = request.Id;
                    token.CreatedDate = DateTime.Now.ToUniversalTime();
                    token.TenantId = request.TenantId;
                    token.SocialUserId = request.User.Sub;
                    _dbContextIdentity.Add(token);
                    _dbContextIdentity.SaveChanges();

            }
            catch (Exception ex)
            {
                throw new BadRequestException(ex.Message);
            }
        }

        public async Task RegisterUser(SaveFacebookUserCommand request)
        {
            try
            {
                var socialUser = await (from a in _dbContextIdentity.SocialUsers.Where(a => a.TenantId == request.TenantId && a.CreatedBy == request.Id && a.Provider == request.FbUser.Provider)
                                        select a).FirstOrDefaultAsync();

                if (socialUser == null)
                {
                    SocialUsers users = new SocialUsers();
                    users.Id = request.FbUser.Id;
                    users.Provider = request.FbUser.Provider;
                    users.FirstName = request.FbUser.FirstName;
                    users.Name = request.FbUser.Name;
                    users.LastName = request.FbUser.LastName;
                    users.PhotoUrl = request.FbUser.PhotoUrl;
                    users.Email = request.FbUser.Email;
                    users.CreatedBy = request.Id;
                    users.CreatedDate = DateTime.Now.ToUniversalTime();
                    users.TenantId = request.TenantId;
                    _dbContextIdentity.Add(users);
                    _dbContextIdentity.SaveChanges();
                    SocialUserTokens token = new SocialUserTokens();
                    token.AuthToken = request.FbUser.AuthToken;
                    token.Provider = request.FbUser.Provider;
                    token.AuthorizationCode = request.FbUser.AuthorizationCode;
                    token.IdToken = request.FbUser.IdToken;
                    token.CreatedBy = request.Id;
                    token.CreatedDate = DateTime.Now.ToUniversalTime();
                    token.TenantId = request.TenantId;
                    token.SocialUserId = users.Id;
                    _dbContextIdentity.Add(token);
                    _dbContextIdentity.SaveChanges();
                }
                else
                {
                    var socialUserToken = await (from a in _dbContextIdentity.SocialUserTokens.Where(a => a.TenantId == request.TenantId && a.CreatedBy == request.Id && a.Provider == request.FbUser.Provider && a.SocialUserId == socialUser.Id)
                                                 select a).FirstOrDefaultAsync();
                    if (socialUserToken != null)
                    {
                        socialUserToken.AuthToken = request.FbUser.AuthToken;
                        socialUserToken.Provider = request.FbUser.Provider;
                        socialUserToken.AuthorizationCode = request.FbUser.AuthorizationCode;
                        socialUserToken.IdToken = request.FbUser.IdToken;
                        socialUserToken.ModifiedBy = request.Id;
                        socialUserToken.ModifiedDate = DateTime.Now.ToUniversalTime();
                    }
                }
            }
            catch (Exception ex)
            {
                throw new BadRequestException(ex.Message);
            }
        }
    }
}
