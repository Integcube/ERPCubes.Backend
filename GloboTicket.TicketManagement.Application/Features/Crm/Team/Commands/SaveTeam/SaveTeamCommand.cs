using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Team.Commands.SaveTeam
{
    public class SaveTeamCommand : IRequest
    {
        public int TeamId { get; set; }
        public int TenantId { get; set; }
        public string TeamName { get; set; } = string.Empty;
        public string TeamLeader { get; set; } = string.Empty;
        public string UserId { get; set; } = string.Empty;
        public string TeamMembersId { get; set; } = string.Empty;
    }
}
