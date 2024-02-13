using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Lead.Commands.DeleteLeadScoreQuestion
{
    public class DeleteLeadScoreQuestionCommand: IRequest
    {
        public int TenantId {  get; set; }
        public string Id { get; set; } = string.Empty;
        public int QuestionId { get; set; }
    }
}
