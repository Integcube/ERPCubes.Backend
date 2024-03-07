using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Domain.Common
{
    public class Pagination
    {
        public int Page { get; set; }
        public int Size { get; set; }
        public string Sort { get; set; }
        public string Order { get; set; }
        public string Search { get; set; }
    }
}
