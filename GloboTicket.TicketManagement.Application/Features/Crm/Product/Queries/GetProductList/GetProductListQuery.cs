using MediatR;

namespace ERPCubes.Application.Features.Product.Queries.GetProductList
{
    public class GetProductListQuery : IRequest<List<GetProductVm>>
    {

        public string Id { get; set; }=String.Empty;
        public int TenantId { get; set; }
    }
}
