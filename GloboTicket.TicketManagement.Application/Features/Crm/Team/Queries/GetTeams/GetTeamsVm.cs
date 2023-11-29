namespace ERPCubes.Application.Features.Crm.Team.Queries.GetTeams
{
    public class GetTeamsVm
    {
        public int TeamId { get; set; }
        public string TeamName { get; set; } = string.Empty;
        public string TeamLeader { get; set; } = string.Empty;
        public string TeamLeaderName { get; set; } = string.Empty;
        public string TeamMembersId { get; set; } = string.Empty;
        public string TeamMembersName { get; set; } = string.Empty;
    }
}
