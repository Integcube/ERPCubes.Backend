using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Notes.Queries.GetNoteList
{
    public class GetNoteListQuery : IRequest<List<GetNoteListVm>>
    {
        public string Id { get; set; } = "-1";
        public int TenantId { get; set; }
        public int LeadId { get; set; } = -1;
        public int CompanyId { get; set; } = -1;
        public int OpportunityId { get; set; } = -1;
    }
}
