﻿using ERPCubes.Domain.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.AppUser.Queries.LazyGetUserList
{
    public class LazyGetUserListVm
    {
        public List<LazyGetUserList> UserList { get; set; }
        public PaginationVm PaginationVm { get; set; }
    }


    public class LazyGetUserList
    {
        public string Id { get; set; } = string.Empty;
        public string FirstName { get; set; } = string.Empty;
        public string LastName { get; set; } = string.Empty;
        public string UserName { get; set; } = string.Empty;
        public string Email { get; set; } = string.Empty;
        public string PhoneNumber { get; set; } = string.Empty;
        public string Name { get; set; } = string.Empty;
        public int IsActive { get; set; }


    }

}