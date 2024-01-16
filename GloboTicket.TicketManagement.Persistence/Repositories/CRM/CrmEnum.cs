using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Persistence.Repositories.CRM
{
    public class CrmEnum
    {
        public enum ContactEnum
        {
            Lead = 1,
            Company = 2,
            Opportunity = 3,
        }

        public enum TaskEnum
        {
            Completed = 1,
            InProgress = 2,
            Pending = 3,
            Overdue = 4,
        }

        public enum UserActivityEnum
        {
            Call = 1,
            Email = 2,
            Meeting = 3,
            Note = 4,
            Task = 5,
        }


    }
}
