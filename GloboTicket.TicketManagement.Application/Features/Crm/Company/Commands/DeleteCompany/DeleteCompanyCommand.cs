using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Company.Commands.DeleteCompany
{
    public class DeleteCompanyCommand : IRequest
    {
        public int TenantId { get; set; }
        public string Id { get; set; } = string.Empty;
        public int CompanyId { get; set; }
        public string Name { get; set;} = string.Empty;
    }
}
