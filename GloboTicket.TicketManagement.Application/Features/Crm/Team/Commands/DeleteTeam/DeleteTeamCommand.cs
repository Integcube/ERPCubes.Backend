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
        public string Id { get; set; } = string.Empty;
        public string DeletedBy { get; set; }
        public DateTime? DeletedDate { get; set; }
    }
}