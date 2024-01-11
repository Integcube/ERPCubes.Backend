using AutoMapper;
using ERPCubes.Application.Contracts.Facebook;
using ERPCubes.Application.Contracts.Persistence;
using ERPCubes.Application.Exceptions;
using ERPCubes.Application.Features.AppUser.Queries.GetUserList;
using ERPCubes.Application.Features.Crm.Team.Queries.GetTeams;
using MediatR;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Google.Queries.GetAuthCode
{
    public class GetUserAuthQueryHandler : IRequestHandler<GetAuthCodeQuery, string>
    {
        
        private readonly IAsyncSocialRepository _socialRepository;
        private readonly ILogger<GetUserAuthQueryHandler> _logger;

        public GetUserAuthQueryHandler(IAsyncSocialRepository userRepository)
        {
            _socialRepository = userRepository;
        }
        public async Task<string> Handle(GetAuthCodeQuery request, CancellationToken cancellationToken)
        {
            try
            {

                var accessToken = await _socialRepository.GetAuthCode(request);
                return accessToken;
            }
            catch (Exception ex)
            {
                _logger.LogError($"Getting Teams List failed due to an error : {ex.Message}");
                throw new BadRequestException(ex.Message);
            }
        }
    }
}
