using ERPCubes.Application.Features.Crm.Company.Commands.DeleteBulkCompany;
using ERPCubes.Application.Features.Crm.Lead.Commands.DeleteBulkLeads;
using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Company.Commands.BulkAssignCompany
{
    public class BulkAssignCompanyCommand : IRequest
    {
        public int TenantId { get; set; }
        public string userId { get; set; }
        public string CompanyOwner { get; set; }
        public List<CompanyIdsvm> Companies { get; set; }
    }
}
