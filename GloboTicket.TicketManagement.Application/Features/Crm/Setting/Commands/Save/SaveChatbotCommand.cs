using ERPCubes.Application.Features.Product.Queries.GetProductList;
using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Setting.Commands.Save
{
    public class SaveChatbotCommand : IRequest
    {
        public int Id { get; set; }
        public string Title { get; set; }
        public string PrimaryColor { get; set; }
        public string UserId { get; set; } 
        public int TenantId { get; set; }
    }
}
