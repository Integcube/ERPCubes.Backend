using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Product.Queries.GetDeletedProductList
{
    public class GetDeletedProductVm
    {
        public int ProductId { get; set; }
        //public string Id { get; set; } = string.Empty;
        public string ProductName { get; set; } = string.Empty;
        public string DeletedBy { get; set; }
        public DateTime? DeletedDate { get; set; }
    }
}
