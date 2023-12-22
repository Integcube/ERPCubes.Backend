using ERPCubes.Application.Features.Facebook.Commands.SaveFacebookUser;
using ERPCubes.Application.Models.Authentication;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Contracts.Facebook
{
    public interface IAsyncSocialRepository
    {
        Task RegisterUser(SaveFacebookUserCommand request);
    }
}
