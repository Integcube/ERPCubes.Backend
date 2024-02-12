using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Lead.Commands.SaveLeadScoreQuestions
{
    public class SaveLeadScoreQuestionsCommand: IRequest
    {
        public int TenantId { get; set; }
        public string Id { get; set; } = string.Empty;
        public List<SaveLeadScoreQuestionsDto> Questions { get; set;} = new List<SaveLeadScoreQuestionsDto>();
    }
}
