using ERPCubes.Application.Contracts.Persistence.CRM;
using ERPCubes.Application.Exceptions;
using ERPCubes.Application.Features.AppUser.Queries.GetUserList;
using ERPCubes.Application.Features.Crm.Team.Commands.DeleteTeam;
using ERPCubes.Application.Features.Crm.Team.Commands.RestoreBulkTeam;
using ERPCubes.Application.Features.Crm.Team.Commands.RestoreTeam;
using ERPCubes.Application.Features.Crm.Team.Commands.SaveTeam;
using ERPCubes.Application.Features.Crm.Team.Queries.GetDeletedTeams;
using ERPCubes.Application.Features.Crm.Team.Queries.GetTeams;
using ERPCubes.Application.Features.Notes.Queries.GetDeletedNotes;
using ERPCubes.Domain.Entities;
using ERPCubes.Identity;
using MediatR;
using Microsoft.EntityFrameworkCore;

namespace ERPCubes.Persistence.Repositories.CRM
{
    public class TeamRepository : BaseRepository<CrmTeam>, IAsyncTeamRepository
    {
        public TeamRepository(ERPCubesDbContext dbContext, ERPCubesIdentityDbContext dbContextIdentity)
            : base(dbContext, dbContextIdentity) { }

        public async Task<List<GetTeamsVm>> GetTeamsAsync(GetTeamsQuery request)
        {
            try
            {
                var teamsList = await (
                    from a in _dbContext.CrmTeam.Where(a => a.TenantId == request.TenantId && a.IsDeleted == 0)
                    join b in _dbContext.CrmTeamMember on a.TeamId equals b.TeamId into teamGroup
                    from c in teamGroup.DefaultIfEmpty()
                    select new
                    {
                        TeamId = a.TeamId,
                        Name = a.Name,
                        TeamLeader = a.TeamLeader,
                        TeamMembers = c.UserId
                    }).ToListAsync();

                var usernames = await (
                    from a in _dbContextIdentity.ApplicationUsers.Where(a => a.TenantId == request.TenantId)
                    select new
                    {
                        Id = a.Id,
                        Name = a.FirstName + " " + a.LastName
                    }).ToListAsync();

                var finalTeamsList = teamsList
                    .GroupBy(a => a.TeamId)
                    .Select(team => new GetTeamsVm
                    {
                        TeamId = team.Key,
                        TeamName = team.FirstOrDefault().Name,
                        TeamLeader = team.FirstOrDefault().TeamLeader,
                        TeamLeaderName = usernames.FirstOrDefault(u => u.Id == team.FirstOrDefault().TeamLeader)?.Name,
                        TeamMembersId = String.Join(",", team.Select(u => u.TeamMembers)),
                        TeamMembersName = String.Join(",", usernames.Where(u => team.Select(t => t.TeamMembers).Contains(u.Id)).Select(u => u.Name)),

                        //TeamMemberNames = usernames.SelectMany(u => u.Id == team.Select(u => u.TeamMembers)))
                    }).ToList();

                return finalTeamsList;
            }
            catch(Exception ex)
            {
                throw new Exception(ex.Message);
            }
        }


        public async Task<Unit> SaveTeamAsync(SaveTeamCommand request)
        {
            try
            {
                DateTime localDateTime = DateTime.Now;
                if (request.TeamId == -1)
                {
                    CrmTeam obj = new CrmTeam();

                    obj.TenantId = request.TenantId;
                    obj.Name = request.TeamName;
                    obj.TeamLeader = request.TeamLeader;
                    obj.CreatedBy = request.UserId;
                    obj.CreatedDate = localDateTime.ToUniversalTime();
                    _dbContext.Add(obj);
                    _dbContext.SaveChanges();

                    // Parse the string of user IDs and insert team members into CrmTeamMember table.
                    var TeamMemberIds = request.TeamMembersId.Split(',').ToList();
                    foreach (var TeamMemberId in TeamMemberIds)
                    {
                        var NewTeamMember = new CrmTeamMember
                        {
                            TeamId = obj.TeamId,
                            UserId = TeamMemberId,
                            TenantId = request.TenantId,
                            CreatedBy = request.UserId,
                            CreatedDate = localDateTime.ToUniversalTime(),
                        };

                        _dbContext.CrmTeamMember.Add(NewTeamMember);
                        _dbContext.SaveChanges();
                    }
                    _dbContext.SaveChanges();

                    return Unit.Value;
                }
                else
                {
                    var obj = await (
                        from a in _dbContext.CrmTeam.Where(a => a.TeamId == request.TeamId && a.TenantId == request.TenantId)
                        select a).FirstOrDefaultAsync();

                    obj.Name = request.TeamName;
                    obj.TeamLeader = request.TeamLeader;
                    obj.LastModifiedBy = request.UserId;
                    obj.LastModifiedDate = localDateTime.ToUniversalTime();

                    var UpdatedTeamMembers = request.TeamMembersId.Split(',').ToList();

                    var StoredTeamMembers = await (
                        from b in _dbContext.CrmTeamMember.Where(b => b.TenantId == request.TenantId && b.TeamId == request.TeamId)
                        select b).ToListAsync();

                    foreach (var StoredTeamMember in StoredTeamMembers)
                    {
                        if (!UpdatedTeamMembers.Contains(StoredTeamMember.UserId)) // Tag stored in CrmTaskTags against TaskId is not in UpdatedTagIds
                        {
                            _dbContext.CrmTeamMember.Remove(StoredTeamMember);   // Delete stored tag from CrmTaskTag

                        }
                        else   // Tag stored in CrmTaskTags against TaskId is in UpdatedTagIds
                        {
                            StoredTeamMember.LastModifiedBy = request.UserId;
                            StoredTeamMember.LastModifiedDate = DateTime.UtcNow;
                            UpdatedTeamMembers.Remove(StoredTeamMember.UserId);
                        }
                    }

                    foreach (var TeamMemberId in UpdatedTeamMembers)   // iterating through TagIds and creating new entries in CrmTaskTags table
                    {
                        var NewTeamMember = new CrmTeamMember
                        {
                            TeamId = request.TeamId,
                            UserId = TeamMemberId,
                            TenantId = request.TenantId,
                            CreatedBy = request.UserId,
                        };

                        _dbContext.CrmTeamMember.Add(NewTeamMember);
                    }

                    _dbContext.SaveChanges();

                    return Unit.Value;
                }
            }
            catch(Exception ex)
            {
                throw new Exception(ex.Message);
            }
        }


        public async Task<List<GetDeletedTeamVm>> GetDeletedTeams(int TenantId, string Id)
        {
            try
            {
                List<GetDeletedTeamVm> teamDetail = await(from a in _dbContext.CrmTeam.Where(a => a.TenantId == TenantId && a.IsDeleted == 1)
                                                          join user in _dbContext.AppUser on a.DeletedBy equals user.Id
                                                          select new GetDeletedTeamVm
                                                          {
                                                              Id = a.TeamId,
                                                              Title = a.Name,
                                                              DeletedBy = user.FirstName + " " + user.LastName,
                                                              DeletedDate = a.DeletedDate,
                                                          }).OrderBy(a => a.Title).ToListAsync();
                return teamDetail;
            }
            catch (Exception ex)
            {
                throw new BadRequestException(ex.Message);
            }
        }

        public async Task DeleteTeamAsync(DeleteTeamCommand team)
        {
            try
            {
                var deleteTeam = await(from a in _dbContext.CrmTeam.Where(a => a.TeamId == team.TeamId)
                                          select a).FirstOrDefaultAsync();
                if (deleteTeam == null)
                {
                    throw new NotFoundException("team", team);
                }
                else
                {
                    deleteTeam.IsDeleted = 1;
                    deleteTeam.DeletedBy = team.Id;
                    deleteTeam.DeletedDate = DateTime.Now.ToUniversalTime();
                    await _dbContext.SaveChangesAsync();
                }
            }
            catch (Exception ex)
            {
                throw new BadRequestException(ex.Message);
            }
        }

        public async Task RestoreTeam(RestoreTeamCommand team)
        {
            try
            {
                var restoreteam = await(from a in _dbContext.CrmTeam.Where(a => a.TeamId == team.TeamId)
                                          select a).FirstOrDefaultAsync();
                if (restoreteam == null)
                {
                    throw new NotFoundException("team", team);
                }
                else
                {
                    restoreteam.IsDeleted = 0;
                    await _dbContext.SaveChangesAsync();
                }
            }
            catch (Exception ex)
            {
                throw new BadRequestException(ex.Message);
            }
        }

        public async Task RestoreBulkTeam(RestoreBulkTeamCommand team)
        {
            try
            {
                foreach (var teamId in team.TeamId)
                {
                    var noteDetail = await _dbContext.CrmTeam
                        .Where(p => p.TeamId == teamId && p.IsDeleted == 1)
                        .FirstOrDefaultAsync();

                    if (noteDetail == null)
                    {
                        throw new NotFoundException(nameof(teamId), teamId);
                    }

                    noteDetail.IsDeleted = 0;
                }

                await _dbContext.SaveChangesAsync();
            }
            catch (Exception ex)
            {
                throw new BadRequestException(ex.Message);
            }
        }
    }
}
