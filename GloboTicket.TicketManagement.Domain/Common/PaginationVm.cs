using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Domain.Common
{
    public class PaginationVm
    {
        public int Length { get; set; }
        public int Size { get; set; }
        public int Page { get; set; }
        public int LastPage { get; set; }
        public int StartIndex { get; set; }
        public int EndIndex { get; set; }
    }
}
