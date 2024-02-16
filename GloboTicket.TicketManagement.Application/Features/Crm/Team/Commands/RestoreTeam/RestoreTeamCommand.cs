using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Team.Commands.RestoreTeam
{
    public class RestoreTeamCommand : IRequest
    {
        public int TeamId { get; set; }
    }
}
