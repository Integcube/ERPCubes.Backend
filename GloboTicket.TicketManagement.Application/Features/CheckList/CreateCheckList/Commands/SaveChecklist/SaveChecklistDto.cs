using ERPCubes.Application.Features.Notes.Commands.SaveNote;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Checklist.Command.SaveChecklist
{
    public class SaveChecklistDto
    {
        public int CLId { get; set; }
        public string Title { get; set; } 
        public string Description { get; set; } 
        public List<SaveChecklistPointsDto>? Checkpoints { get; set; }

    }
}
