using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Task.Commands.SaveTask
{
    public class SaveTaskCommand:IRequest
    {
        public string Id { get; set; } = string.Empty;
        public int TenantId { get; set; }
        public SaveTaskDto? Task { get; set; }
    }
}