using ERPCubes.Application.Features.Crm.Lead.Commands.DeleteBulkLeads;
using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Company.Commands.DeleteBulkCompany
{
    public class DeleteBulkCompanyCommand : IRequest
    {
        public string Id { get; set; }
        public int TenantId { get; set; }

        public List<CompanyIdsvm> Companies { get; set; }
    }
}
