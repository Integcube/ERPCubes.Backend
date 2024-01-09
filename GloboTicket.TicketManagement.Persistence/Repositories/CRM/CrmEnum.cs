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
            Opportunity = 4,
        }

        public enum TaskEnum
        {
            Completed = 1,
            InProgress = 2,
            Pending = 3,
            Overdue = 4,
        }
    }
}
