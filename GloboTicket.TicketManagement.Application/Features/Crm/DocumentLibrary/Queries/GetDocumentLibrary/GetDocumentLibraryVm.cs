using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.DocumentLibrary.Queries.GetDocumentLibrary
{
    public class GetDocumentLibraryVm
    {
        public int FileId { get; set; }
        public string FileName { get; set; }
        public string Description { get; set; }
        public string Type { get; set; }
        public string Path { get; set; }
        public int ParentId { get; set; }
    }
}
