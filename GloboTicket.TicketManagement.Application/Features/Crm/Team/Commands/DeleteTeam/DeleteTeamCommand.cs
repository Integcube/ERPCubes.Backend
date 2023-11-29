using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Team.Commands.DeleteTeam
{
    public class DeleteTeamCommand : IRequest
    {
        public int TeamId { get; set; }
        public int TeamName { get; set; }
        public int TenantId { get; set; }
        public string Id { get; set; } = string.Empty;
    }
}