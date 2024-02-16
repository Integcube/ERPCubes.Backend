using ERPCubes.Application.Features.Notes.Queries.GetDeletedNotes;
using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Team.Queries.GetDeletedTeams
{
    public class GetDeletedTeamQuery : IRequest<List<GetDeletedTeamVm>>
    {
        public string Id { get; set; } = String.Empty;
        public int TenantId { get; set; }
    }
}
