﻿using ERPCubes.Application.Models.Mail;
using System.Threading.Tasks;

namespace ERPCubes.Application.Contracts.Persistence.Infrastructure
{
    public interface IEmailService
    {
        Task<bool> SendEmail(Email email);
    }
}
