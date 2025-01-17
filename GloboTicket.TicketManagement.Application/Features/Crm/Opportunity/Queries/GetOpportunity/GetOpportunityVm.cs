﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Opportunity.Queries.GetOpportunity
{
    public class GetOpportunityVm
    {
        public int OpportunityId { get; set; }
        public string FirstName { get; set; } = string.Empty;
        public string LastName { get; set; } = string.Empty;
        public string Email { get; set; } = string.Empty;
        public int StatusId { get; set; }
        public string StatusTitle { get; set; } = string.Empty;
        public string OpportunityOwner { get; set; } = String.Empty;
        public string Mobile { get; set; } = string.Empty;
        public string Work { get; set; } = string.Empty;
        public string Address { get; set; } = string.Empty;
        public string Street { get; set; } = string.Empty;
        public string City { get; set; } = string.Empty;
        public string Zip { get; set; } = string.Empty;
        public string State { get; set; } = string.Empty;
        public string Country { get; set; } = string.Empty;
        public int SourceId { get; set; }
        public string SourceTitle { get; set; } = string.Empty;
        public int IndustryId { get; set; }
        public string IndustryTitle { get; set; } = string.Empty;
        public int ProductId { get; set; }
        public string ProductTitle { get; set; } = string.Empty;
        public DateTime CreatedDate { get; set; }
        public DateTime? ModifiedDate { get; set; }
    }
}
