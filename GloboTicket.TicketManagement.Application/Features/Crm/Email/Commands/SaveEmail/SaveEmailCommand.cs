using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Email.Commands.SaveEmail
{
    public class SaveEmailCommand: IRequest
    {
        public int EmailId { get; set; }
        public string Subject { get; set; } = String.Empty;
        public string Description { get; set; } = String.Empty;
        public string Id { get; set; } = String.Empty;
        public int ContactTypeId { get; set; }
        public int ContactId { get; set; }
        public int TenantId { get; set; }

    }
}
