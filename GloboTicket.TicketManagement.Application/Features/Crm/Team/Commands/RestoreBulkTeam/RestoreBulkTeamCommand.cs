using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Team.Commands.RestoreBulkTeam
{
    public class RestoreBulkTeamCommand : IRequest
    {
        public List<int> TeamId { get; set; }
    }
}
