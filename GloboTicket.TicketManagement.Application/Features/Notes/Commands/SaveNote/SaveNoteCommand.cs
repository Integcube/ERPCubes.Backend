﻿using ERPCubes.Application.Features.Crm.Task.Commands.SaveTask;
using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace ERPCubes.Application.Features.Notes.Commands.SaveNote
{
    public class SaveNoteCommand : IRequest
    {
        public string Id { get; set; } = String.Empty;
        public int TenantId { get; set; }
        public int CompanyId { get; set; }
        public int LeadId { get; set; }
        public int OpportunityId { get; set; }
        public SaveNoteDto? Note { get; set; }
    }
}