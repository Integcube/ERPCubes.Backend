using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Lead.Queries.GetLeadAttachments
{
    public class GetLeadAttachmentsVm
    {
        public int FileId { get; set; }
        public decimal Size { get; set; }
        public string Path { get; set; } = string.Empty;
        public string FileName { get; set; } = string.Empty;
        public string Description {  get; set; } = string.Empty;
        public string Type { get; set; } = string.Empty;
    }
}
