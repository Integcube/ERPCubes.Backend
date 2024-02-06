using ERPCubes.Application.Features.Facebook.Commands.SaveFacebookUser;
using ERPCubes.Application.Features.Google.Commands.SaveAuth;
using ERPCubes.Application.Features.Google.Queries.GetAuthCode;
using ERPCubes.Application.Models.Authentication;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Contracts.Persistence.Facebook
{
    public interface IAsyncSocialRepository
    {
        Task RegisterUser(SaveFacebookUserCommand request);
        Task RegisterGoogleUser(SaveGoogleAuthUserCommand request);
        Task<string> GetAuthCode(GetAuthCodeQuery request);
    }
}
