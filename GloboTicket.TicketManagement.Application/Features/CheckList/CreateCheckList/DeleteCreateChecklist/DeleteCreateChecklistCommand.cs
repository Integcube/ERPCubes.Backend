using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.CheckList.CreateCheckList.DeleteCreateChecklist
{
    public class DeleteCreateChecklistCommand : IRequest
    {
        public int CLId { get; set; }
        public string Id { get; set; }
    }
}
