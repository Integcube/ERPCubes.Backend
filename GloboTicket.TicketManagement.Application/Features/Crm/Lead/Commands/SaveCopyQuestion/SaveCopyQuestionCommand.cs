using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Lead.Commands.SaveCopyQuestion
{
    public class SaveCopyQuestionCommand : IRequest
    {
        public int TenantId { get; set; }
        public string Id { get; set; } = string.Empty;
        public int ProductId { get; set; }
        public List<SaveCopyQuestionDto> Questions { get; set; } = new List<SaveCopyQuestionDto>();
    }
}
