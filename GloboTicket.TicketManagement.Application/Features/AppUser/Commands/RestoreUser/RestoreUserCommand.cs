﻿using ERPCubes.Application.Features.Notes.Commands.SaveNote;
using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.AppUser.Commands.RestoreUser
{
    public class RestoreUserCommand : IRequest
    {
        public string Id { get; set; }
        public RestoreUserDto? User { get; set; }


    }
}
