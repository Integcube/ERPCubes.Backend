using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Call.Commands.SaveCall
{
    public class SaveCallCommand : IRequest
    {
        public int CallId { get; set; }
        public string Subject { get; set; } = String.Empty;
        public string Response { get; set; }
        public string Id { get; set; } = string.Empty;
        public DateTime StartTime { get; set; }
        public DateTime EndTime { get; set; }
        public int TenantId { get; set; }
        public int ReasonId { get; set; }
        //For auto task createing
        public DateTime? DueDate { get; set; }
        public int TaskId { get; set; }
        public int IsTask { get; set; }
        public int ContactTypeId { get; set; }
        public int ContactId { get; set; }
        public DateTime CallDate { get; set; }
        
    }
}
