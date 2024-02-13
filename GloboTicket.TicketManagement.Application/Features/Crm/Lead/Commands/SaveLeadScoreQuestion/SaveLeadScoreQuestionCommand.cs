using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Lead.Commands.SaveLeadScoreQuestion
{
    public class SaveLeadScoreQuestionCommand: IRequest
    {
        public int TenantId { get; set; }
        public string Id { get; set; } = string.Empty;
        public SaveLeadScoreQuestionDto Question { get; set;} = new SaveLeadScoreQuestionDto();
    }
}
