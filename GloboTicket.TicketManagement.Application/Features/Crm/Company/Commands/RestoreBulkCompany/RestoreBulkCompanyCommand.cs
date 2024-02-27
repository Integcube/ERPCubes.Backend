using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Company.Commands.RestoreBulkCompany
{
    public class RestoreBulkCompanyCommand : IRequest
    {
        public List<int> CompanyId { get; set; }
    }
}
