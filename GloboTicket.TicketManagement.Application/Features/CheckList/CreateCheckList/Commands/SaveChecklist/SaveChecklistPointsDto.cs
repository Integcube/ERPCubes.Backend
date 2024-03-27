using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Checklist.Command.SaveChecklist
{
    public class SaveChecklistPointsDto
    {
        public string Title { get; set; } = String.Empty;
        public int DueDays { get; set; }
        public int Priority { get; set; }
        public int IsRequired { get; set; }

        //public bool IsCompleted { get; set; }
    }
}
