using ERPCubes.Application.Features.Crm.Lead.Commands.BulkSaveLead;
using ERPCubes.Application.Features.Crm.Product.Commands.SaveProductBulk;
using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Product.Commands.SaveProductBulk
{
    public class SaveProductBulkCommand:IRequest
    {
        public int TenantId { get; set; }
        public string Id { get; set; } = String.Empty;
        public List<SaveProductBulkDto> Products { get; set; } = new List<SaveProductBulkDto>();
    }
}
