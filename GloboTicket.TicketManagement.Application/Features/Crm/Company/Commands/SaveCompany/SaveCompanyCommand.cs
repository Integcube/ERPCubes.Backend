using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Company.Commands.SaveCompany
{
    public class SaveCompanyCommand : IRequest
    {
        public string Id { get; set; } = String.Empty;
        public int TenantId { get; set; }
        public SaveCompanyDto company { get; set; } = new SaveCompanyDto();
    }
}
