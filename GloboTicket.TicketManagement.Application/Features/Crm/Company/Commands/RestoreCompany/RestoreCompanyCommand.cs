using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Company.Commands.RestoreCompany
{
    public class RestoreCompanyCommand : IRequest
    {
        public int CompanyId { get; set; }
    }
}
