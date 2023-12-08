using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Notes.Queries.GetNotesWithTasks
{
    public class GetNotesTagsDto
    {
        public int TagId { get; set; }
        public string TagTitle { get; set; } = string.Empty;
    }
}
