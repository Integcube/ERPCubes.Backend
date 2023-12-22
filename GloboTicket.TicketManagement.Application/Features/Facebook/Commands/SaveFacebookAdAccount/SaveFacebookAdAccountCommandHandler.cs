using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Facebook.Commands.SaveFacebookAdAccount
{
    public class SaveFacebookAdAccountCommandHandler : IRequestHandler<SaveFacebookAdAccountCommand>
    {
        public Task<Unit> Handle(SaveFacebookAdAccountCommand request, CancellationToken cancellationToken)
        {
            throw new NotImplementedException();
        }
    }
}
